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
figure()
for ifreq = 1:numel(SV.f)
  subplot(1,2,1)
  hold all
  semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.M(:,ifreq),...
           'displayname', num2str(SV.f(ifreq)))

  subplot(1,2,2)
  hold all
  semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.Q(:,ifreq))

end

subplot(1,2,1)
xlabel(['T in ', VBR.in.SV.units.T_K])
ylabel(['M in ', VBR.out.anelastic.tasty_burgers.units.M])
legend('Location','SouthWest')
title('default parameters')
subplot(1,2,2)
xlabel(['T in ', VBR.in.SV.units.T_K])
ylabel(['Q ', VBR.out.anelastic.tasty_burgers.units.Q])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how does decreasing or increasing activation energy in steady
% state viscosity change the plots?
%
VBR = struct();
VBR.in.SV = SV;

% methods list
VBR.in.elastic.methods_list = {'anharmonic'};
VBR.in.anelastic.methods_list = {'tasty_burgers'};
VBR.in.anelastic.tasty_burgers = Params_Anelastic('tasty_burgers');
VBR.in.anelastic.tasty_burgers.FLP.Q = 1000*1e3;
% call it
VBR = VBR_spine(VBR);

figure()
for ifreq = 1:numel(SV.f)
  subplot(1,2,1)
  hold all
  semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.M(:,ifreq),...
           'displayname', num2str(SV.f(ifreq)))

  subplot(1,2,2)
  hold all
  semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.Q(:,ifreq))

end

subplot(1,2,1)
xlabel(['T in ', VBR.in.SV.units.T_K])
ylabel(['M in ', VBR.out.anelastic.tasty_burgers.units.M])
legend('Location','SouthWest')
title('adjusted activation energy')
subplot(1,2,2)
xlabel(['T in ', VBR.in.SV.units.T_K])
ylabel(['Q ', VBR.out.anelastic.tasty_burgers.units.Q])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how does decreasing or increasing relaxation strength change the plots?

VBR = struct();
VBR.in.SV = SV;

% methods list
VBR.in.elastic.methods_list = {'anharmonic'};
VBR.in.anelastic.methods_list = {'tasty_burgers'};
VBR.in.anelastic.tasty_burgers = Params_Anelastic('tasty_burgers');
VBR.in.anelastic.tasty_burgers.delta= 0;
% call it
VBR = VBR_spine(VBR);

figure()
for ifreq = 1:numel(SV.f)
  subplot(1,2,1)
  hold all
  semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.M(:,ifreq),...
           'displayname', num2str(SV.f(ifreq)))

  subplot(1,2,2)
  hold all
  semilogy(VBR.in.SV.T_K, VBR.out.anelastic.tasty_burgers.Q(:,ifreq))

end

subplot(1,2,1)
xlabel(['T in ', VBR.in.SV.units.T_K])
ylabel(['M in ', VBR.out.anelastic.tasty_burgers.units.M])
legend('Location','SouthWest')
title('adjusted relaxation strength')
subplot(1,2,2)
xlabel(['T in ', VBR.in.SV.units.T_K])
ylabel(['Q ', VBR.out.anelastic.tasty_burgers.units.Q])
