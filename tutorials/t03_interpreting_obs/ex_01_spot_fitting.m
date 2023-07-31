%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Pick a spot in the western U.S., find possible temperature, melt fraction
% ranges constrained by Vs, Q measurements
%
% FIRST: run ex_00_fetch_some_data

% initialize vbr
clear; close all;
vbr_path=getenv('vbrdir');
addpath(vbr_path)
vbr_init

% going to use some helper functions in bayesian_fitting example
addpath(genpath([vbr_path, '/Projects/bayesian_fitting']))

% inspect the data
filenames.Q = './data/Q_models/Dalton_Ekstrom_2008.mat';
filenames.Vs = './data/vel_models/Shen_Ritzwoller_2016.mat';

sr = load(filenames.Vs);
Vs_Model = sr.Vs_Model;

size(Vs_Model.Depth)
size(Vs_Model.Latitude)
size(Vs_Model.Longitude)
size(Vs_Model.Vs)

pcolor(Vs_Model.Vs(:,:,50))
colorbar()

de = load(filenames.Q);
Q_Model = de.Q_Model;
size(Q_Model.Qinv)
size(Q_Model.Depth)
pcolor(Q_Model.Longitude, Q_Model.Latitude, Q_Model.Qinv(:,:,10))
colorbar()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract some spot measurements and look at some Vs, Q distributions
%

% extract a spot measurement for lat/lon point and a depth range
help process_SeismicModels  % note: plotting arg may be funky, longitude should be 0 to 360

% what is the probability distribution of Vs, Q for this spot ? plot them!
% use the probability_distributions function with a normal distribution

help probability_distributions

% in case the varargin descprtion is confusing, your calls should look like:
% P = probability_distributions('normal', test_values_array, observed_value, std_of_observed)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% using the VBRc, conduct a grid search to find the T and phi that explain the
% observed values for all of the anelastic methods.
%
% steps:
%
% 1. build a lookup table (LUT) of VBRc values for parameter range of interest
% 2. find the best fit T, phi using a chi-squared misfit
%    (https://en.wikipedia.org/wiki/Reduced_chi-squared_statistic)
%
% hints/simplifications:
%
% pick sensible values for other state variables.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set 1D range for the state variables we want to search for (T, phi)

% build a grid of (T, phi)

% initialie the VBRc structure (set state variables)

% what method to use? lets do them all
% VBR.in.elastic.methods_list={'anharmonic';'anh_poro';};
% VBR.in.anelastic.methods_list={'eburgers_psp';'andrade_psp';'xfit_mxw'; 'xfit_premelt'};

% call the VBRc
% VBR = VBR_spine(VBR);

% plot the look up table (LUT).
% contour plots of V, Q vs T and phi for a method of your choice, single frequency


% for a single method, calculate the chi-squared misfit for Q and V separately
% and together for a single anelastic method

% plot 3 contours of chi-squared misfit:
% Vs misfit vs T and phi
% Q misfit vs T and phi
% joint misfit vs T and phi


% extract the best fitting values of T, phi for each anelastic method

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% say that you have some prior information from some xenoliths that the
% temperature range is close to 1350... and there might be some melt...
%
% use a pure bayesian inference to incorporate these prior constraints and plot a
% posterior distribtuion showing the likely T and phi ranges for a single method
%
% For a bayes intro, see the intro in the following:
% https://github.com/vbr-calc/pyVBRc/blob/main/examples/ex_003_vbr_bayes_intro.ipynb
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. build prior model distributions of T, phi and plot them
%
% use a uniform distribtuion for phi and a normal distribution for T. You can
% again use the probability_distributions function.
%
% pick your preferred range of phi and your preferred mean and standard deviation
% for T.
%
% plot both distributions
%
% do this for both the 1D distributions defining the range of phi, T that went into
% the VBRc LUT as well as the 2D matrices used in the VBRc calculations (VBR.in.SV.T_K,
% VBR.in.SV.phi).

% calcualte distributions with 1D phi, T ranges using probability_distributions

% plot them

% recalculate priors as matrices using the T and phi inputs to the VBRc LUT

% plot them!



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. calculate the likelihood of observing the Vs and Q in your VBRc LUT for
% a single anelastic method.
% use the normal_likelihood function in this directory (or write your own)
%
% make contour plots of the independent and joint likelihoods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. calculate and plot the final posterior distribution

% how does the inferred temperature differ from the straight chi-squared misfit?

%%%%%%%%%%%%%%%%%%
% 4. still going?
%
% you love all anelastic methods equally... so calculate the ensemble mean
% distribution over all anelastic methods
% (ensemble mean is a weighted sum of distribtuions... equal love = equal weights)
