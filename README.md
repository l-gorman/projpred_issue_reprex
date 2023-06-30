# ProjPred Reprex

A repository to illustrate an issue occuring in ProjPred 2.6.0.

This issues discussed [here](https://discourse.mc-stan.org/t/projpred-fixing-group-effects-in-search-terms-and-tips-for-speed/31678/5) and [here](https://discourse.mc-stan.org/t/cv-varsel-error-infinite-or-missing-values-in-x/31703) have been resolved.

This repository is now being used to resolve the issue discussed [here](https://discourse.mc-stan.org/t/projpred-non-convergence-of-predictive-performance-with-reference-model/31916)

# Usage

I have included a sample dataset in `data/example_dataset.csv`. The reference model is created
in the `create_model.R` file. Projpred can be run on the model using the `run_projpred.R` script (although
takes a while to run!).

To create larger/small reference models, change the value for `N` found in the `create_model.R`.




# Notes

Error:

```
Failed with error:  ‘there is no package called ‘optimx’’
Error in getOptfun(optimizer) : 
  'optimx' package must be installed order to use 'optimizer="optimx"'
```
