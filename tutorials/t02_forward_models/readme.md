# Tutorial 02 : forward modeling


Overview:

using the VBRc within a forward modeling framework:

Goal: geodynamics to geophysical observable

post-processing output from geodynamic forward model

1. Run the forward model
2. Get the output into form for the VBRc
3. call the VBRc, plot it up

also:
1. embedding the VBRc within a geodynamic calculation


## Step 1:

* copy the starting project to a new directory (work outside of the VBRc repository)

```
cd somewhere
cp -r ~/src/vbr/vbr/forwardModels/ThermalEvolution_1d ./
```
