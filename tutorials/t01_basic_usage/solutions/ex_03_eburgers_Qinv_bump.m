%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dissipation peaks with eburgers_psp!
%
% using the eburgers_psp method, calculate attenuation vs temperature for the
% following case:
%     - high temperature background only (bg_only)
%     - high temperature background + dissipation peak
%     - high temperature background + SUPER dissipation peak centered in the
%       given temperature range (not physical, just for fun, learning VBRc)
%
%
% Use the following experimental-ish conditions:
%   1 Hz frequency
%   temperature range 600 to 1300 C
%   10 micron grain size
%   .2 GPa pressure
%   3300 kg/m3 density
%   melt fraction of 0
%
% hints:
%
% You will need to call VBR_spine multiple times, varying the `eBurgerFit`
% parameter: https://vbr-calc.github.io/vbr/vbrmethods/anel/eburgerspsp/
% has a section.
%

% initialize VBRc
clear; close all;
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init

% write method list
VBR.in.elastic.methods_list={'anharmonic'};
VBR.in.anelastic.methods_list={'eburgers_psp';};

% turn on the dissipation peak
VBR.in.anelastic.eburgers_psp=Params_Anelastic('eburgers_psp');
VBR.in.anelastic.eburgers_psp.eBurgerFit='bg_peak';

% define the Thermodynamic State

% frequencies to calculate at
VBR.in.SV.f = [1]; % [Hz]

% remaining state variables
VBR.in.SV.T_K=transpose(linspace(600,1300, 50) + 273); % temperature
sz=size(VBR.in.SV.T_K);
VBR.in.SV.P_GPa = 0.2 * ones(sz); % pressure [GPa]
VBR.in.SV.dg_um = 10 * ones(sz); % grain size [um]
VBR.in.SV.rho = 3300 * ones(sz); % density [kg m^-3]
VBR.in.SV.sig_MPa = 10 * ones(sz); % differential stress [MPa]
VBR.in.SV.phi = 0.0 * ones(sz); % melt fraction

% call VBR_spine
[VBR] = VBR_spine(VBR) ;

% create a super peak (increase strength, narrow the peak, move the maxwell time)
% default settings
VBR.in.anelastic.eburgers_psp.bg_peak.DeltaP % the peak strength
VBR.in.anelastic.eburgers_psp.bg_peak.sig % the peak spread (too narrow causes numerical issues...)
VBR.in.anelastic.eburgers_psp.bg_peak.Tau_PR % the reference peak centered maxwell time

% modify above paratmers, call VBR_spine again (without overwriting your initial)
VBR.in.anelastic.eburgers_psp.bg_peak.DeltaP= 100;
VBR.in.anelastic.eburgers_psp.bg_peak.sig= 2;
VBR.in.anelastic.eburgers_psp.bg_peak.Tau_PR = 1e4;
[VBR_super_peak] = VBR_spine(VBR) ;

% set to no peak, calculate again
VBR.in.anelastic.eburgers_psp.eBurgerFit='bg_only';
[VBR_no_peak] = VBR_spine(VBR) ;

%  plot Qinv vs temperature for the 3 cases: default peak, no peak, super peak
Qinv_w_peak = VBR.out.anelastic.eburgers_psp.Qinv(:,1);
Qinv_no_peak = VBR_no_peak.out.anelastic.eburgers_psp.Qinv(:, 1);
Qinv_super_peak = VBR_super_peak.out.anelastic.eburgers_psp.Qinv(:, 1);
figure()
semilogy(VBR.in.SV.T_K, Qinv_w_peak,'k', 'displayname', 'JF10 peak')
hold on
semilogy(VBR.in.SV.T_K, Qinv_no_peak, 'r', 'displayname', 'bg only')
semilogy(VBR.in.SV.T_K, Qinv_super_peak, 'b', 'displayname', 'SUPER PEAK')
legend('location','NorthEast')
xlabel('temperature [K]')
ylabel('Q^{-1}')
