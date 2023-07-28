% initialize vbr
vbr_path=getenv('vbrdir');
addpath(vbr_path)
vbr_init

addpath(genpath([vbr_path, '/Projects/bayesian_fitting']))

% fetch some data
fetch_data(pwd)

% build some output folders (sorry)
mkdir('plots')
mkdir('plots/output_plots/')
mkdir('plots/output_plots/gsLogNormal_1cm')
mkdir('plots/output_plots/gsLogNormal_1mm')
mkdir('plots/output_plots/gsLogUniform')
