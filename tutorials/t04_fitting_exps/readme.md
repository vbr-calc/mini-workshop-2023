# Tutorial 04: fitting experiments

This tutorials works through fitting experimental data with a new anelastic method.

## tasks

1. add a new anelastic method
2. call the new anelastic method
3. vary the method model parameters
4. improve the anelastic method (burgers model)
5. run some experiments (fabricate some fake "data")...
6. fit some model parameters to the experimental "data" (recover the parameter
   values we used in generating the fake data)



## 1. adding a new method

Go to `vbr` directory and if working from git,

```
git checkout -b tasty_burgers
```

If working from a zip download, just edit it (but remember that you did...)

### add the method to the vbrc core
https://vbr-calc.github.io/vbr/contrib/newmethod/
1. add to vbr/vbrCore/params/Params_Anelastic.m (function name!!)
2. add the new function (normally in `vbr/vbrCore/functions`,
   but technically anywhere in your matlab path)
3. (optional) add dependencies to `vbr/vbrCore/functions/checkInput.m`

## 2. calling the new method

```
% put VBR in the path
path_to_top_level_vbr=getenv('vbrdir');
addpath(path_to_top_level_vbr)
vbr_init
```
the following should display your new method:
```
vbrListMethods()
```
see `ex_01_calling_your_method.m`

## 3. vary your model parameters

see `ex_02_varying_method_params.m`

* Add a new anelastic method to the VBRc:
* Fit the method parameters with experimental "data"

## 4. adding a new extended burgers model

Equations in the [presentation](https://docs.google.com/presentation/d/1Ib9DKGV-VrDD5U0tIBfH7r6pxUNYSfyThW8y947--Sw/edit?usp=sharing) (or https://bit.ly/vbrcburgers).
