clear; close all
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init

% thermodynamic state
SV.T_K = transpose(linspace(800,1400,10)+273);;
sz = size(SV.T_K);
SV.dg_um = 10 * ones(sz);
SV.sig_MPa = 1 * ones(sz);
SV.rho = 3300 * ones(sz);  % only needed so anharmonic doesnt error
SV.P_GPa = 0.1 * ones(sz);
SV.f  = [.01, .1, 1];
VBR = struct();
VBR.in.SV = SV;

% methods list
VBR.in.elastic.methods_list = {'anharmonic'};
VBR.in.anelastic.methods_list = {'tasty_burgers'};

% call it
VBR = VBR_spine(VBR);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot M, Q vs T for all frequencies


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how does decreasing or increasing activation energy in steady
% state viscosity change the plots?



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how does decreasing or increasing relaxation strength change the plots?
