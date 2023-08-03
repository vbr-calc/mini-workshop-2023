## tasks

1. add a new anelastic method
2. call the new anelastic method
3. vary the method model parameters
4. improve the anelastic method (burgers model)
5. run some experiments (fabricate some fake "data")...
6. fit some model parameters to the experimental "data" (recover the parameter
   values we used in generating the fake data)

# initial state

### vbr: clean on main

`git checkout -b tasty_burgers`

### this directory

# adding a new anelastic method

go open the relevant params file in vbrc

adjust the possible_methods line:

```
params.possible_methods={'eburgers_psp';'andrade_psp';...
                         'xfit_mxw';'xfit_premelt'; ...
                         'tasty_burgers'};
```                         

add an entry for the new method:

```
if strcmp(method, 'tasty_burgers')
    params.func_name='Q_undercooked_burgers'; % the name of your new matlab function    

    % any parameters you want to set
    params.n = 1;
    params.Delta = 0.01;
    params.whatever = 2;

    % just avoid the following variable names:
    % .melt_alpha, .phi_c, .x_phi_c, .possible_methods
  end
```  

note that `Q_undercooked_burgers` normally would go in `vbr/vbrCore/functions/`,
but we can **actually** put it anywhere in the matlab path, so we'll add it to
our current workshop directory.

## checking that it worked:

in a shell:
```
% put VBR in the path
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init

vbrListMethods
```

## calling it

run `ex_01_calling_your_method`

### tasks
run `ex_02_varying_method_params`, make a plot varying parameters

modify `Q_undercooked_burgers` to use the unrelaxed modulus from the `anharmonic`
calculation. adjust `ex_02_varying_method_params` to provide additional state
variables.

# cooking a better burger

modify the parameters file to use `Q_tasty_burgers` and add some parameters:

```
params.func_name='Q_tasty_burgers'; % the name of your new matlab function

% some steady state flow law parameters (FLP) -- could instead write a new
% viscous method. going to embed in the Q function though...
params.FLP = struct(); % steady state flow law parameters
params.FLP.A = 1e6; % pre-exponential
params.FLP.Q = 400*1e3; % activation energy
params.FLP.n = 1; % stress exponent
params.FLP.p = 3; % grain size exponent

% high temp background parameters
params.alpha = .3 ; % high temp background tau exponent
params.delta = 10.0 ; % relaxation strength
params.tau_low_factor = 1e-3 ; % Relaxation time lower limit factor
params.tau_high_factor = 1e3 ; % Relaxation time higher limit factor
```


look through `Q_tasty_burgers`, compare to eqs in slides

## varying burger parameters
`ex_03_tasty_burgers` tasks:

1. plot M, Q for all freqs
2. how does decreasing or increasing activation energy in steady state viscosity change the plots?
3. how does decreasing or increasing relaxation strength change the plots?

# fitting

## running some experiments

```
addpath('helper_funcs')
experi = create_fake_data(1);

```

look through `experi` structure

let's treat this data as experimental data and do a simplified fit to the
extended burgers model: What are the `alpha` and `delta` values that explain
this data?

## the fitting function

open up a blank `ex_04_fitting_func.m` : most of a brute force grid search minimization

1. fill out the blanks!
* reading in the experimental data
* call_VBRc
* misfit calculations

2. the final tasks in the file
