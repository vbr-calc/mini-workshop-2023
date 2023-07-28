% initialize vbr
vbr_path=getenv('vbrdir');
addpath(vbr_path)
vbr_init

addpath(genpath([vbr_path, '/Projects/bayesian_fitting']))

% fetch some data
fetch_data(pwd)

% inspect some data
filenames.Q = './data/Q_models/Dalton_Ekstrom_2008.mat';
filenames.Vs = './data/vel_models/Shen_Ritzwoller_2016.mat';

sr = load(filenames.Vs);
Vs_Model = sr.Vs_model;

size(Vs_Model.Depth)
size(Vs_Model.Latitude)
size(Vs_Model.Longitude)
size(Vs_Model.Vs)

pcolor(Vs_Model.Vs(:,:,50))
colorbar()

de = load(filenames.Q);
Q_Model = de.Q_Model;
size(Q_model.Qinv)
size(Q_model.Depth)
pcolor(Q_model.Longitude, Q_model.Latitude, Q_model.Qinv(:,:,10))
colorbar()

% extract a spot measurement
help process_SeismicModels

% b_and_r = [40.7, -117.5];
location.lat = 40.7;
location.lon = 360-117.5;
location.z_min = 75;
location.z_max = 105;
location.smooth_rad = 0.5;

[obs_Vs, sigma_Vs] = process_SeismicModels('Vs', location, filenames.Vs, 0);

obs_Vs
sigma_Vs

vs_range = linspace(obs_Vs-4*sigma_Vs,obs_Vs+4*sigma_Vs,50);
P_obs_Vs = probability_distributions('normal', vs_range, obs_Vs, sigma_Vs);
plot(vs_range, P_obs_Vs)
trapz(vs_range, P_obs_Vs)  % close to 1 :D

[obs_Q, sigma_Q] = process_SeismicModels('Q', location, filenames.Q, 0);
Q_range = linspace(obs_Q-4*sigma_Q,obs_Q+4*sigma_Q,50);
P_obs_Q = probability_distributions('normal', Q_range, obs_Q, sigma_Q);
plot(Q_range, P_obs_Q)
trapz(Q_range, P_obs_Q)  % close to 1 :D

% what T, phi to get these Vs, Q???

% set ranges for the state variables we want to search for
test_T = linspace(1000,1500,100)+273;
test_phi = linspace(0, 0.05, 50);

% build a grid
[T, phi] = meshgrid(test_T, test_phi);

% prep for VBRc
VBR = struct();
VBR.in.SV.T_K = T;
VBR.in.SV.phi = phi;

% make remainder of vars same shape
sz = size(T);
VBR.in.SV.P_GPa = 2 * ones(sz); % pressure [GPa]
VBR.in.SV.sig_MPa = .1 * ones(sz); % differential stress [MPa]
VBR.in.SV.dg_um = 0.01 * 1e6 * ones(sz); % grain size [um]
VBR.in.SV.Tsolidus_K = 1200 * ones(sz);
rho = san_carlos_density_from_pressure(VBR.in.SV.P_GPa);
rho = Density_Thermal_Expansion(rho, VBR.in.SV.T_K, 0.9);

VBR.in.SV.rho = rho; % density [kg m^-3]

% pick a frequency
VBR.in.SV.f = [0.01, 0.1];

% what method to use? lets do them all
VBR.in.elastic.methods_list={'anharmonic';'anh_poro';};
VBR.in.anelastic.methods_list={'eburgers_psp';'andrade_psp';'xfit_mxw'; 'xfit_premelt'};

% lets do itttt
VBR = VBR_spine(VBR);


contourf(test_T, test_phi, VBR.out.anelastic.eburgers_psp.V(:,:,1))
contourf(test_T, test_phi, VBR.out.anelastic.eburgers_psp.Q(:,:,1))

% whats the beest fit?
method_name = 'eburgers_psp'; % andrade v eburger
% straight minimization
V = VBR.out.anelastic.(method_name).V(:,:,1)/1e3;
chi_sq_V = ((V-obs_Vs)/sigma_Vs).^2;
Q = VBR.out.anelastic.(method_name).Q(:,:,1);
chi_sq_Q = ((Q-obs_Q)/sigma_Q).^2;

contourf(test_T-273, test_phi, log10(chi_sq_V))
colorbar()

contourf(test_T-273, test_phi, log10(chi_sq_Q))
colorbar()

figure; contourf(test_T-273, test_phi, log10(chi_sq_Q+chi_sq_V))
colorbar()


% but what abbbout bbbbbayyyyyes
% BAYES BREAK  https://github.com/vbr-calc/pyVBRc
% OK, back

% lets build those priors : lets just do T, phi
min_phi = 0;
max_phi = 0.05;
phi_dist = probability_distributions('uniform', test_phi, min_phi, max_phi);
plot(test_phi, phi_dist)

meanT = 1200+273;
T_std = 50;
T_dist = probability_distributions('normal', test_T, meanT, T_std);
plot(test_T,T_dist)

% likelihood
PV = normal_likelihood_(V, obs_Vs, sigma_Vs);
PQ = normal_likelihood_(Q, obs_Q, sigma_Q);
joint_likeli = PV .* PQ;
contourf(test_T-273, test_phi, joint_likeli)

% priors as matrices
prior_phi = probability_distributions('uniform', phi, min_phi, max_phi);
prior_T = probability_distributions('normal', T, meanT, T_std);
contourf(test_T-273, test_phi, prior_T.*prior_phi)

Pjoint = joint_likeli .* prior_T .* prior_phi;
contourf(test_T-273, test_phi, Pjoint)

% try changing the melt to normal dist
