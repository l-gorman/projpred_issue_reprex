# ProjPred Reprex

A repository to illustrate an issue occuring in ProjPred 2.6.0.
Relating to an analysis discussed [here](https://discourse.mc-stan.org/t/projpred-fixing-group-effects-in-search-terms-and-tips-for-speed/31678/5) and [here](https://discourse.mc-stan.org/t/cv-varsel-error-infinite-or-missing-values-in-x/31703).

# Usage

I have included a sample dataset in `data/example_dataset.csv`. The reference model is created
in the `create_model.R` file. Projpred  can be run on the model using the `run_projpred.R` script (although
takes a while to run!). This mimics the HPC run. 