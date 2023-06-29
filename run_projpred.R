# sbatch run-projpred.sh
library(readr)

library(brms)
library(projpred)
library(cmdstanr)
# library(optimx)
# library(optparse)

options(mc.cores = 4,  brms.backend = "cmdstanr")


# option_list = list(
#   make_option(c("-j", "--index"), type='character',
#               help="Index for project to model")
# )
# 
# opt_parser = OptionParser(option_list=option_list);
# opt = parse_args(opt_parser);
# 
# opt$index <- as.numeric(opt$index)



loadRData <- function(fileName){
  #loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}


ref_model <- loadRData("./outputs/ref_model.rda")
ref_model <- get_refmodel(ref_model)

get_search_terms <- function(fixed_terms, other_predictors, max_terms) {
  
  if (max_terms > length(other_predictors)){
    stop("Cannot have max terms more than predictors")
  }
  
  search_terms <- unlist(lapply(1:max_terms, function(m_predictors) {
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
  'log_livestock_tlu'
  # 'log_land_cultivated',
  # 
  # # Practices
  # 'off_farm_any',
  # 'till_not_by_hand',
  # 'external_labour',
  # 'pesticide',
  # 'debts_have',
  # 'aidreceived',
  # 'livestock_inputs_any',
  # 'land_irrigated_any',
  # 
  # #------------------
  # # Village Level
  # 'norm_growing_period',
  # 'log_min_travel_time',
  # 'log_pop_dens',
  # #------------------
  # #County Level
  # 'norm_gdl_country_shdi'
)

group_effects <-"(1 | iso_country_code) + (1 | iso_country_code:village)"


# Basing this off of discussion on stan forum:
# https://discourse.mc-stan.org/t/projpred-fixing-group-effects-in-search-terms-and-tips-for-speed/31678/4
search_terms <- get_search_terms(group_effects,auxilliary_variables, max_terms=3) 
# Basing from this: https://discourse.mc-stan.org/t/advice-on-using-search-terms-in-projpred/22846/3


cv_varsel_res <- cv_varsel(ref_model,
                          method = 'forward', 
                          cv_method = 'kfold', 
                          K = 2,
                          verbose = TRUE, 
                          seed = 1,
                          search_terms=search_terms,
                          nterms_max=3)
save(cv_varsel_res,file="./outputs/cv_varsel_res_test_1.rda")



# if (opt$index==2){
# search_terms <- get_search_terms(group_effects,auxilliary_variables, max_terms=16) 
# 
# cv_varsel_res <- cv_varsel(ref_model,
#                            method = 'forward', 
#                            cv_method = 'kfold', 
#                            K = 2,
#                            verbose = TRUE, 
#                            seed = 1,
#                            search_terms=search_terms,
#                            nterms_max=12)
# 
# save(cv_varsel_res,file="./outputs/cv_varsel_res_test_2.rda")
# }
