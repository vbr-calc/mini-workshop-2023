% initialize vbr
vbr_path=getenv('vbrdir');
addpath(vbr_path)
vbr_init

% going to use some helper functions in bayesian_fitting example
addpath(genpath([vbr_path, '/Projects/bayesian_fitting']))

% fetch some data
fetch_data(pwd)
