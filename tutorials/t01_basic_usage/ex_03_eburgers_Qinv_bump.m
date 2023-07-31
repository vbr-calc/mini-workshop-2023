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

% call VBR_spine

% create a super peak (increase strength, narrow the peak, move the maxwell time)
% check default settings:
VBR.in.anelastic.eburgers_psp.bg_peak.DeltaP % the peak strength
VBR.in.anelastic.eburgers_psp.bg_peak.sig % the peak spread (too narrow causes numerical issues...)
VBR.in.anelastic.eburgers_psp.bg_peak.Tau_PR % the peak centered maxwell time

% modify above paratmers, call VBR_spine again (without overwriting your initial)

% set to no peak, call VBR_spine again (without overwriting your initial)

% plot Qinv vs temperature for the 3 cases: default peak, no peak, super peak
