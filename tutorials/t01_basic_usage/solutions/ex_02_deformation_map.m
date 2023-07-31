%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create some deformation mechanism maps for steady state viscosity using
% HZK2011 viscosity method at the following experimental conditions:
%
% differential stress: .1 to 1e4 MPa
% grain size: 1 to 1e4 micromenters (um)
%
% temperature: 1673 K
% pressure: 3 GPa
% melt fraction: 0.0
%
% Hints:
%
% Deformation mechanism maps: plots that show contribution of strain rate by
% the deformation mechanism (diffusion creep, dislocation creep, etc.)
%
% method doc: https://vbr-calc.github.io/vbr/vbrmethods/visc/hzk2011/
%
% use the meshgrid function to create a grid of stress, grain size
%
% viscous methods store both total strain rate and strain rate by
% deformation mechanism. Check out the VBR.out.viscous. fields after
% calculating.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize VBRc
clear; close all;
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init

% populate methods list
VBR.in.viscous.methods_list={'HZK2011'};

% setup experimental conditions
sigma_1d = logspace(-1, 4, 100); % MPa
grain_size_1d = logspace(0, 4, 98); % um

[grain, sigma] = meshgrid(grain_size_1d, sigma_1d);

VBR.in.SV.dg_um = grain;
VBR.in.SV.sig_MPa = sigma;
sz = size(sigma);
VBR.in.SV.P_GPa = 3 * ones(sz); % pressure [GPa]
VBR.in.SV.T_K = 1673 * ones(sz); % temperature [K]
VBR.in.SV.phi = zeros(sz); % melt fraction / porosity


% call VBR_spine
[VBR] = VBR_spine(VBR) ;

%%%%%%%%%%%%%%%%%%%
% make some plots %
%%%%%%%%%%%%%%%%%%%

% PLOT 1: contourf plot of total strain rate
figure()
contourf(log10(grain_size_1d), log10(sigma_1d), log10(VBR.out.viscous.HZK2011.sr_tot))
xlabel('log10(grain size [um])')
ylabel('log10(differential stress [MPa])')
h = colorbar();
set(h, 'title', 'log10(strain rate)')

% PLOT 2: subplots for each mechanism showing relative contribution to total strain rate.
visc = VBR.out.viscous.HZK2011; % just for convenience
flds = {'diff'; 'disl'; 'gbs';};
figure()
for ifield = 1:numel(flds)
  current_field = flds{ifield};
  subplot(1,numel(flds), ifield)
  sr_f = visc.(current_field).sr ./ visc.sr_tot;
  contourf(log10(grain_size_1d), log10(sigma_1d), sr_f, 25, 'linecolor', 'None')
  colorbar()
  xlabel('log10(grain size [um])')
  ylabel('log10(differential stress [MPa])')
  title(current_field)
end

% PLOTS 3,4: make some plots that delineate strain rate by mechanism

% step 1: build an integer mask with a different integer for each dominant mechanism
visc = VBR.out.viscous.HZK2011; % just for convenience
flds = {'diff'; 'disl'; 'gbs';};
mech_mask = zeros(size(grain));  % integer deformation mechanism mask
for ifield = 1:numel(flds)
    current_field = flds{ifield};
    sr = visc.(current_field).sr;
    mech_mask_i = ones(size(grain));
    for other_field_i = 1:numel(flds)
      if ifield ~= other_field_i
        other_field = flds{other_field_i};
        mech_mask_i = mech_mask_i .* (sr > visc.(other_field).sr);
      end
    end
    mech_mask = ifield * mech_mask_i + mech_mask;
end

% step 2: plot that integer mask
figure()
subplot(1,2,1)
contourf(log10(grain_size_1d), log10(sigma_1d), log10(VBR.out.viscous.HZK2011.sr_tot))
xlabel('log10(grain size [um])')
ylabel('log10(differential stress [MPa])')
h = colorbar();
set(h, 'title', 'log10(strain rate)')

subplot(1,2,2)
contourf(log10(grain_size_1d), log10(sigma_1d), mech_mask)
xlabel('log10(grain size [um])')
ylabel('log10(differential stress [MPa])')
colorbar()

figure()
contourf(log10(grain_size_1d), log10(sigma_1d), log10(VBR.out.viscous.HZK2011.sr_tot), '--k')
hold on
contour(log10(grain_size_1d), log10(sigma_1d), mech_mask, [1, 2, 3], 'k', 'linewidth', 2)
h = colorbar();
set(h, 'title', 'log10(strain rate)')
xlabel('log10(grain size [um])')
ylabel('log10(differential stress [MPa])')
