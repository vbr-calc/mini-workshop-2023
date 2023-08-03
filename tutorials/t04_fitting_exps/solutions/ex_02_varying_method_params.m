% put VBR in the path
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init('quiet',1)

% set the state variables
VBR = struct();
SV.T_K = linspace(800,1300,30)+273;
sz = size(SV.T_K);
SV.sig_MPa = 1 * ones(sz);
SV.dg_um = 0.01 * 1e6 * ones(sz);
SV.rho = 3300 * ones(sz);
SV.P_GPa = 0.1 * ones(sz);

SV.f  = [.01, .1, 1, 10];
VBR.in.SV = SV;
% set the methods to use
VBR.in.elastic.methods_list = {'anharmonic'};
VBR.in.anelastic.methods_list = {'tasty_burgers'};

% load in the default params
VBR.in.anelastic.tasty_burgers = Params_Anelastic('tasty_burgers');
disp(VBR.in.anelastic.tasty_burgers)

% vary one parameter
VBR.in.anelastic.tasty_burgers.n = 2;

% run the calculations
VBR = VBR_spine(VBR);

% plot a thing
figure()
semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.Q(1,:,1))
xlabel('T [K]')
ylabel('Q (sort of but not really)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vary the model parameters
%
% create a loop to co-vary the n and Delta parameters, plotting Q curves for each
%
% (remember: this is not a real equation... yet...)

figure()

n_range = linspace(1, 5, 3);
d_range = linspace(1, 10, 3);
for i_n = 1:numel(n_range)
  for i_d = 1:numel(d_range)
      VBR.in.anelastic.tasty_burgers.n = n_range(i_n);
      VBR.in.anelastic.tasty_burgers.Delta = d_range(i_d);
      % run the calculations
      VBR = VBR_spine(VBR);
      dispn = [num2str(VBR.in.anelastic.tasty_burgers.n), ',', ...
               num2str(VBR.in.anelastic.tasty_burgers.Delta)]
      semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.Q(1,:,1), 'displayname', dispn)
      hold all
  end
end
legend()
