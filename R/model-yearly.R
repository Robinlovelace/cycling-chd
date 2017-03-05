# Aim: run model for each year
# Run after process-minap (which results minap obj)

# Libraries
library(plyr)
library(data.table)
library(INLA)

load("data/pop_03_13.RData")
yearly_results_m <- yearly_results_f <- vector(mode = "list", 11)
res_df <- data.frame(y = 2003:2013, cl = NA, cu = NA)

la_2001 <- read.csv("data/2001_exposure_25_74.csv")

y = 2003
for(y in 2003:2013){
  i = y - 2003 # counter
  j = i + 1

  source("R/process-per-year.R") # output: msoa_exp_obs and la_exp_obs - from which we can run model



  la_exp_obs <- la_exp_obs[la_exp_obs$year == y] # Subset year
  la_exp_obs_11 <- la_exp_obs[grepl(pattern = "0-9|67-76|77-86|87+", x = la_exp_obs),] # Subset age bands for 2011 Analysis
  la_exp_obs <- la_exp_obs[grepl(pattern = "0-9|10-19|77-86|87+", x = la_exp_obs),] # Subset age bands for 2001 Analysis

  dt <- data.table(la_exp_obs) # Aggregate counts
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

  res_df$cl[j] = yearly_results_f[[1]]$`0.025quant`
  res_df$ul[j] = yearly_results_f[[1]]$`0.975quant`


}

res_df$cl[1:9] = sapply(yearly_results_f, function(x) x$`0.025quant`[3])
plot(res_df$y, res_df$cl)

