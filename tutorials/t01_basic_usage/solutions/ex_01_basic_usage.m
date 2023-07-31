% 1. initialize the VBRc
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init

% 2. initialize the VBR structure
%    - set thermodynamic state variable arrays  (T, phi)
%    - set the properties and methods

VBR.in.elastic.methods_list={'anharmonic';'anh_poro';};
VBR.in.viscous.methods_list={'HK2003';'HZK2011'};
VBR.in.anelastic.methods_list={'eburgers_psp';'andrade_psp';'xfit_mxw'};

%  frequencies to calculate at
VBR.in.SV.f = logspace(-2.2,-1.3,4); % [Hz]

%  size of the state variable arrays. arrays can be any shape
%  but all arays must be the same shape.
VBR.in.SV.T_K = linspace(600, 1600, 100)+273; % temperature [K]
sz = size(VBR.in.SV.T_K);
VBR.in.SV.P_GPa = 2 * ones(sz); % pressure [GPa]
VBR.in.SV.T_K = 1473 * ones(sz);
VBR.in.SV.rho = 3300 * ones(sz); % density [kg m^-3]
VBR.in.SV.sig_MPa = 10 * ones(sz); % differential stress [MPa]
VBR.in.SV.phi = 0.0 * ones(sz); % melt fraction
VBR.in.SV.dg_um = 0.01 * 1e6 * ones(sz); % grain size [um]

% what SVs are required? check docs!
% https://vbr-calc.github.io/vbr/vbrmethods/viscous/
% https://vbr-calc.github.io/vbr/vbrmethods/elastic/
% https://vbr-calc.github.io/vbr/vbrmethods/anelastic/


% 3. call the VBRc
VBR = VBR_spine(VBR);

% 4. inspect output
% shape of arrays (frequency dependence)
% iterating over methods
disp(fieldnames(VBR.out))
disp(fieldnames(VBR.out.anelastic))
disp(fieldnames(VBR.out.anelastic.eburgers_psp))

% 5. method citations
VBR.in.anelastic.andrade_psp.citations
%ans =
%{
%  [1,1] = Jackson and Faul, 2010, Phys. Earth Planet. Inter., https://doi.org/10.1016/j.pepi.2010.09.005
%}
