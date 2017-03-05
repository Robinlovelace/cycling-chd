# Aim: run model for each year
# Run after process-minap (which results minap obj)

# Libraries
library(plyr)
library(data.table)
library(INLA)

load("data/pop_03_13.RData")
yearly_results_m <- yearly_results_f <- vector(mode = "list", 11)
res_f <- data.frame(y = 2003:2013, mean = NA, cl = NA, cu = NA) # Store results females
res_m <- data.frame(y = 2003:2013, mean = NA, cl = NA, cu = NA) # Store results males
lkup <- readr::read_csv("data/la_msoa_lkup.csv") # Load LA to MSOA lookup
la_2001 <- read.csv("data/2001_exposure_25_74.csv")

## 2001 Exposure ##
y = 2003
for(y in 2003:2013){
  i = y - 2003 # counter
  j = i + 1

  source("R/process-per-year.R") # output: msoa_exp_obs and la_exp_obs - from which we can run model

  la_exp_obs_yr <- la_exp_obs[la_exp_obs$year == y,] # Subset year
  la_exp_obs_01 <- la_exp_obs_yr[grepl(pattern = "0-9|10-19|77-86|87+", x = la_exp_obs_yr$age_band),] # Subset age bands for 2001 Analysis

  dt <- data.table(la_exp_obs_01) # Aggregate counts
  la_sex <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE)),
               by = c("sex", "la_code")]

  la_sex <- join(la_sex, la_2001, by = "la_code", type = "left", match = "all") # Join on exposure (2001 cycling)

  la_males <- la_sex[la_sex$sex=="Male"]
  la_females <- la_sex[la_sex$sex=="Female"]

  # Males (unadjusted)
  formula <- admissions ~ 1 + m_walk_25_74 + m_cycle_25_74
  model_m1 <- inla(formula, family = "nbinomial", data = la_males, offset = log(expt_adms), control.compute=list(dic=T))

  # Females (unadjusted)
  formula <- admissions ~ 1 + f_walk_25_74 + f_cycle_25_74
  model_f1 <- inla(formula, family = "nbinomial", data = la_females, offset = log(expt_adms), control.compute=list(dic=T))

  # Store results
  yearly_results_m[[j]] = exp(model_m1$summary.fixed)
  yearly_results_f[[j]] = exp(model_f1$summary.fixed)

  # res_f$mean[j] = yearly_results_f[[1]]$`mean`
  # res_f$cl[j] = yearly_results_f[[1]]$`0.025quant`
  # res_f$ul[j] = yearly_results_f[[1]]$`0.975quant`
  #
  # res_m$mean[j] = yearly_results_m[[1]]$`mean`
  # res_m$cl[j] = yearly_results_m[[1]]$`0.025quant`
  # res_m$ul[j] = yearly_results_m[[1]]$`0.975quant`

  print(y)

}

saveRDS(yearly_results_f, "la_results/yearly_results_f.Rds")
saveRDS(yearly_results_m, "la_results/yearly_results_m.Rds")

res_df <- data.frame(year = 2003:2013, mean_m = NA, mean_f = NA)
res_df$mean_m_cycle = sapply(yearly_results_m, function(x) x$`mean`[3])
res_df$mean_f_cycle = sapply(yearly_results_f, function(x) x$`mean`[3])

plot(res_df$year, res_df$mean_f_cycle, ylim = c(0, 1.1), type = "l") # make grey area with ggplot2
lines(res_df$year, res_df$mean_m_cycle)


## 2011 Exposure ##

yearly_results_munadj <- yearly_results_funadj <- vector(mode = "list", 11)
yearly_results_madj <- yearly_results_fadj <- vector(mode = "list", 11)

la_2011 <- read.csv("data/2011_exposure_25_74.csv")
la_confs <- readr::read_csv("data/phe_la_data.csv") # Confounders

y = 2011
for(y in 2011:2013){
  i = y - 2011 # counter
  j = i + 1

  source("R/process-per-year.R") # output: msoa_exp_obs and la_exp_obs - from which we can run model

  la_exp_obs_yr <- la_exp_obs[la_exp_obs$year == y,] # Subset year
  la_exp_obs_11 <- la_exp_obs_yr[grepl(pattern = "0-9|67-76|77-86|87+", x = la_exp_obs_yr$age_band),] # Subset age bands for 2001 Analysis

  dt <- data.table(la_exp_obs_11) # Aggregate counts
  la_sex <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE)),
               by = c("sex", "la_code")]

  temp <- join(la_sex, la_2011, by = "la_code", type = "left", match = "all") # Join on exposure (2011 mode transport)
  la_sex <- join(la_sex, la_confs, by = "la_code", type = "left", match = "all") # Join on confounders


  la_males <- la_sex[la_sex$sex=="Male"]
  la_females <- la_sex[la_sex$sex=="Female"]

  # Males (unadjusted)
  formula <- admissions ~ 1 + pcm_walk_25_74 + pcm_cycle_27_74 # it is 25-74 not 27-74 spelling error!
  model_m1 <- inla(formula, family = "nbinomial", data = la_males, offset = log(expt_adms), control.compute=list(dic=T))

  # Males (adjusted)
  formula <- admissions ~ 1 + pcm_walk_25_74 + pcm_cycle_27_74 + imd_2015 + pc_smoke12 + pc_pa_12 + excess_wt_12_14 + dm_10_11
  model_m2 <- inla(formula, family = "nbinomial", data = la_males, offset = log(expt_adms), control.compute=list(dic=T))

  # Females (unadjusted)
  formula <- admissions ~ 1 + pcf_walk_25_74 + pcf_cycle_27_74
  model_f1 <- inla(formula, family = "nbinomial", data = la_females, offset = log(expt_adms), control.compute=list(dic=T))

  # Females (adjusted)
  formula <- admissions ~ 1 + pcf_walk_25_74 + pcf_cycle_27_74 + imd_2015 + pc_smoke12 + pc_pa_12 + excess_wt_12_14 + dm_10_11
  model_f2 <- inla(formula, family = "nbinomial", data = la_females, offset = log(expt_adms), control.compute=list(dic=T))

  # Store results
  yearly_results_munadj[[j]] = exp(model_m1$summary.fixed)
  yearly_results_funadj[[j]] = exp(model_f1$summary.fixed)

  yearly_results_madj[[j]] = exp(model_m2$summary.fixed)
  yearly_results_fadj[[j]] = exp(model_f2$summary.fixed)

  print(y)

}
