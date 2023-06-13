# sbatch run-projpred.sh
library(readr)

library(brms)
library(projpred)
library(cmdstanr)
library(optimx)

options(mc.cores = 4,  brms.backend = "cmdstanr")


loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}


ref_model <- loadRData("./outputs/ref_model.rda")
ref_model <- get_refmodel(ref_model)

get_search_terms <- function(fixed_terms, other_predictors) {
  search_terms <- unlist(lapply(1:length(other_predictors), function(m_predictors) {
    lapply(combn(other_predictors, m = m_predictors, simplify = FALSE),
           function(idxs_predictors) {
             paste0(idxs_predictors, collapse = " + ")
           })
  }))
  search_terms <- c(fixed_terms, paste(fixed_terms, "+", search_terms))
  return(search_terms)
}


auxilliary_variables <- c(
  "log_hh_size",
  'education_cleaned',
  
  #Assets
  'log_livestock_tlu',
  'log_land_cultivated',
  
  # Practices
  'off_farm_any',
  'till_not_by_hand',
  'external_labour',
  'pesticide',
  'debts_have',
  'aidreceived',
  'livestock_inputs_any',
  'land_irrigated_any',
  
  #------------------
  # Village Level
  'norm_growing_period',
  'log_min_travel_time',
  'log_pop_dens',
  #------------------
  #County Level
  'norm_gdl_country_shdi'
)



group_effects <-"(1 | iso_country_code) + (1 | iso_country_code:village)"
search_terms <- get_search_terms(group_effects,auxilliary_variables) 

cv_varsel_res <- cv_varsel(ref_model,
                          method = 'forward', 
                          cv_method = 'kfold', 
                          K = 2,
                          verbose = TRUE, 
                          seed = 1,
                          search_terms=search_terms)

save(cv_varsel_res,file="./outputs/cv_varsel_res.rda")

