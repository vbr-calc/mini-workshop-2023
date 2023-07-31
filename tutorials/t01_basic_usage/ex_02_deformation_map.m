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

% setup experimental conditions

% call VBR_spine

%%%%%%%%%%%%%%%%%%%
% make some plots %
%%%%%%%%%%%%%%%%%%%

% PLOT 1: contourf plot of total strain rate

% PLOT 2: subplots for each mechanism showing relative contribution to total strain rate.

% PLOTS 3,4: make some plots that delineate strain rate by mechanism

% step 1: build an integer mask with a different integer for each dominant mechanism

% step 2: plot that integer mask
