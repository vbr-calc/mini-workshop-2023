% put VBR in the path
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init('quiet',1)

% set the state variables
VBR = struct();
VBR.in.SV.T_K = linspace(800,1300,30)+273;
VBR.in.SV.f  = [.01, .1, 1, 10];

% set the methods to use
VBR.in.anelastic.methods_list = {'tasty_burgers'};

% run the calculations
VBR = VBR_spine(VBR);

% plot a thing
semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.Q(1,:,1))
xlabel('T [K]')
ylabel('Q (sort of but not really)')
