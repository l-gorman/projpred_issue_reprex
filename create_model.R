library(readr)

library(brms)
library(projpred)
library(cmdstanr)

options(mc.cores = 4, brms.backend = "cmdstanr") # allows threading


indicator_data <- readr::read_csv("./data/example_dataset.csv")

set.seed(123)

indicator_data <- indicator_data[sample(c(1:nrow(indicator_data)),400),]

ref_model <- brm(
  formula=bf(log_tva ~ 1 +
               
               #------------------
             #Household Level
             # Demographics
             log_hh_size +
               education_cleaned +
               
               #Assets
               log_livestock_tlu +
               log_land_cultivated +
               
               # Practices
               off_farm_any+
               till_not_by_hand+
               external_labour+
               pesticide+
               debts_have+
               aidreceived+
               livestock_inputs_any+
               land_irrigated_any+
               
               #------------------
             # Village Level
             norm_growing_period +
               log_min_travel_time +
               log_pop_dens +
               #------------------
             #County Level
             norm_gdl_country_shdi+
               
               # Levels
               (1 | iso_country_code) +
               (1 | iso_country_code:village)),
  data=indicator_data,
  prior = c(
    set_prior('normal(0, 1)', class = 'b'),
    set_prior('normal(0, 1)', class = 'sd'),
    set_prior('normal(0, 1)', class = 'sigma'),
    set_prior('normal(0, 1)', class = 'Intercept')
  ),
  cores = 4,
  iter = 2000,
  warmup = 1000,
  family=gaussian() 
  
)


save(ref_model,file="outputs/ref_model.rda")


