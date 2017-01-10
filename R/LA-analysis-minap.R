##########################################
######## Local Authority Analyses ########
##########################################


# Libraries
library(plyr)
library(data.table)
library(INLA)

# Load data
la_minap <- readRDS("data/las_observed_expected_counts.Rds") # Minap data
la_transport <- readr::read_csv("data/la_transport.csv") # Exposures (totals)
la_transp_sex_age <- readr::read_csv("data/la_commuting_data_age_sex_2011.csv") # Exposures (by age and sex)
la_confs <- readr::read_csv("data/phe_la_data.csv") # Confounders

# Join into single file
hold <- join(la_minap, la_transport, by = "la_code", type = "left", match = "all")
hold2 <- join(hold, la_transp_sex_age, by = "la_code", type = "left", match = "all")
la_data <- join(hold2, la_confs, by = "la_code", type = "left", match = "all")
rm(hold, hold2, la_minap, la_transport, la_transp_sex_age, la_confs)
gc()

# Variables that are not obvious:
# expt_adms <- expected number of admissions
# pcwalk_11 <- percent who walk total all persons from 2011 Census (plus other variables with similar names but vary by mode of transport)
# pcp_16p_walk <- series of variables identified by three parts to name: (1) "pcp" is 'percent persons' - can be m (male) or f (female), (2) "16p" indicates age group so this is
# 16 plus, then there are 5 year age bands so 1619 is 16-19, (3) "walk" - mode of transport (obvious!)
# imd_15 <- IMD average score
# dm_10_11 <- Prevalence of diabetes (2010-11)
# pcsmoke_12 <- Percentage of adults who smoke (number is year - 2012 here)
# excess_wt_12_14 <- Percentage of adults with excess body weight (overweight or obese) (2012-14)
# pc_pa_12 <- Percentage of physicaly active adults
# dm_10_11 <- diabetes prevalence (2010/11)


### Analysing total admissions ###

# Aggregate data
dt <- data.table(la_data)
la_persons <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE),
                        pccycle_11 = max(pccycle_11, na.rm = TRUE), pcwalk_11 = max(pcwalk_11, na.rm = TRUE),
                        imd_15 = max(imd_2015, na.rm = TRUE), pcsmoke_12 = max(pcsmoke_12, na.rm = TRUE), pc_pa_12 = max(pc_pa_12, na.rm = TRUE),
                        excess_wt_12_14 = max(excess_wt_12_14, na.rm = TRUE), dm_10_11 = max(dm_10_11, na.rm = TRUE)),
                   by = c("la_code")] # NB I have used max for covariates since are all same values - just need to select one!
la_persons$imd_15[is.infinite(la_persons$imd_15)] <- NA # Set 'infinite' values as missing
la_persons$pcsmoke_12[is.infinite(la_persons$pcsmoke_12)] <- NA
la_persons$pc_pa_12[is.infinite(la_persons$pc_pa_12)] <- NA
la_persons$excess_wt_12_14[is.infinite(la_persons$excess_wt_12_14)] <- NA
la_persons$dm_10_11[is.infinite(la_persons$dm_10_11)] <- NA

# Regression
formula <- admissions ~ 1 + pccycle_11 + pcwalk_11 + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_p <- inla(formula, family = "poisson", data = la_persons, offset = log(expt_adms), control.compute=list(dic=T))
summary(model_p) # For IRRs take exponential of median and CIs - have to do manually as inla cannot :(

# generate summary table
ff_res = exp(model_p$summary.fixed)
ff_res_cywalk = ff_res[2:3, c("mean", "0.025quant", "0.975quant")]
dir.create("la_results")
write.csv(ff_res, "la_results/ff_res.csv")
write.csv(ff_res_cywalk, "la_results/ff_res_cywalk.csv")

(ff_res - 1) * 100
rm(la_persons)
names(la_data)


### Analysing admissions by sex ###

# Aggregate data
dt <- data.table(la_data)
la_sex <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE),
                        pccycle_fm_11 = max(pcf_16p_cycle, na.rm = TRUE), pcwalk_fm_11 = max(pcf_16p_walk, na.rm = TRUE),
                        pccycle_ma_11 = max(pcm_16p_cycle, na.rm = TRUE), pcwalk_ma_11 = max(pcm_16p_walk, na.rm = TRUE),
                        imd_15 = max(imd_2015, na.rm = TRUE), pcsmoke_12 = max(pcsmoke_12, na.rm = TRUE), pc_pa_12 = max(pc_pa_12, na.rm = TRUE),
                        excess_wt_12_14 = max(excess_wt_12_14, na.rm = TRUE), dm_10_11 = max(dm_10_11, na.rm = TRUE)),
                 by = c("sex", "la_code")] # NB I have used max for covariates since are all same values - just need to select one!
la_sex$imd_15[is.infinite(la_sex$imd_15)] <- NA # Set 'infinite' values as missing
la_sex$pcsmoke_12[is.infinite(la_sex$pcsmoke_12)] <- NA
la_sex$pc_pa_12[is.infinite(la_sex$pc_pa_12)] <- NA
la_sex$excess_wt_12_14[is.infinite(la_sex$excess_wt_12_14)] <- NA
la_sex$dm_10_11[is.infinite(la_sex$dm_10_11)] <- NA
la_sex$pccycle_fm_11[is.infinite(la_sex$pccycle_fm_11)] <- NA
la_sex$pcwalk_fm_11[is.infinite(la_sex$pcwalk_fm_11)] <- NA
la_sex$pccycle_ma_11[is.infinite(la_sex$pccycle_ma_11)] <- NA
la_sex$pcwalk_ma_11[is.infinite(la_sex$pcwalk_ma_11)] <- NA

la_males <- la_sex[la_sex$sex=="Male"]
la_females <- la_sex[la_sex$sex=="Female"]
rm(la_sex)
gc()

# Regression
formula <- admissions ~ 1 + pccycle_ma_11 + pcwalk_ma_11 + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12 # Males
model_m <- inla(formula, family = "poisson", data = la_males, offset = log(expt_adms), control.compute=list(dic=T))
summary(model_m)

formula <- admissions ~ 1 + pccycle_fm_11 + pcwalk_fm_11 + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12 # Females
model_f <- inla(formula, family = "poisson", data = la_females, offset = log(expt_adms), control.compute=list(dic=T))
summary(model_f)

rm(la_males, la_females, dt)
gc()



### Analysing admissions by age and sex ###


# Aggregate data
dt <- data.table(la_data)
la_sex <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE),
                    pcf_1624_walk = max(pcf_1624_walk, na.rm = TRUE), pcf_1624_cycle = max(pcf_1624_cycle, na.rm = TRUE),
                    pcf_2534_walk = max(pcf_2534_walk, na.rm = TRUE), pcf_2534_cycle = max(pcf_2534_cycle, na.rm = TRUE),
                    pcf_3544_walk = max(pcf_3544_walk, na.rm = TRUE), pcf_3544_cycle = max(pcf_3544_cycle, na.rm = TRUE),
                    pcf_4554_walk = max(pcf_4554_walk, na.rm = TRUE), pcf_4554_cycle = max(pcf_4554_cycle, na.rm = TRUE),
                    pcf_5564_walk = max(pcf_5564_walk, na.rm = TRUE), pcf_5564_cycle = max(pcf_5564_cycle, na.rm = TRUE),
                    pcf_65p_walk = max(pcf_65p_walk, na.rm = TRUE), pcf_65p_cycle = max(pcf_65p_cycle, na.rm = TRUE),
                    pcm_1624_walk = max(pcm_1624_walk, na.rm = TRUE), pcm_1624_cycle = max(pcm_1624_cycle, na.rm = TRUE),
                    pcm_2534_walk = max(pcm_2534_walk, na.rm = TRUE), pcm_2534_cycle = max(pcm_2534_cycle, na.rm = TRUE),
                    pcm_3544_walk = max(pcm_3544_walk, na.rm = TRUE), pcm_3544_cycle = max(pcm_3544_cycle, na.rm = TRUE),
                    pcm_4554_walk = max(pcm_4554_walk, na.rm = TRUE), pcm_4554_cycle = max(pcm_4554_cycle, na.rm = TRUE),
                    pcm_5564_walk = max(pcm_5564_walk, na.rm = TRUE), pcm_5564_cycle = max(pcm_5564_cycle, na.rm = TRUE),
                    imd_15 = max(imd_2015, na.rm = TRUE), pcsmoke_12 = max(pcsmoke_12, na.rm = TRUE), pc_pa_12 = max(pc_pa_12, na.rm = TRUE),
                    excess_wt_12_14 = max(excess_wt_12_14, na.rm = TRUE), dm_10_11 = max(dm_10_11, na.rm = TRUE)),
             by = c("la_code", "sex", "age_band")] # NB I have used max for covariates since are all same values - just need to select one!

invisible(lapply(names(la_sex),function(.name) set(la_sex, which(is.infinite(la_sex[[.name]])), j = .name,value =NA))) # Set 'infinite' values as missing

la_males <- la_sex[la_sex$sex=="Male"]
la_females <- la_sex[la_sex$sex=="Female"]
rm(la_sex)
gc()

age_results = data.frame(matrix(nrow = 10, ncol = 8))
names(age_results) = c("Age band", "Explanatory variable", "IRR",	"Lower CI",	"Upper CI",	"IRR",	"Lower CI",	"Upper CI")
age_results$`Age band` = rep(c("16-24", "25-34", "35-44", "45-54", "55-64"), each = 2)

age_results$`Explanatory variable` = rep(c("% Cycle", "% Walk"), length.out = nrow(age_results))

# Males #
hold <- la_males[la_males$age_band == "16-24"]
formula <- admissions ~ 1 + pcm_1624_cycle + pcm_1624_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[1:2, 3:5] = exp(model_m$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "25-34"]
formula <- admissions ~ 1 + pcm_2534_cycle + pcm_2534_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[3:4, 3:5] = exp(model_m$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "35-44"]
formula <- admissions ~ 1 + pcm_3544_cycle + pcm_3544_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[5:6, 3:5] = exp(model_m$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "45-54"]
formula <- admissions ~ 1 + pcm_4554_cycle + pcm_4554_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[7:8, 3:5] = exp(model_m$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "55-64"]
formula <- admissions ~ 1 + pcm_5564_cycle + pcm_5564_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[9:10, 3:5] = exp(model_m$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

rm(model_m)

# Females #
hold <- la_females[la_females$age_band == "16-24"]
formula <- admissions ~ 1 + pcf_1624_cycle + pcf_1624_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[1:2, 6:8] = exp(model_f$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "25-34"]
formula <- admissions ~ 1 + pcf_2534_cycle + pcf_2534_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[3:4, 6:8] = exp(model_f$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "35-44"]
formula <- admissions ~ 1 + pcf_3544_cycle + pcf_3544_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[5:6, 6:8] = exp(model_f$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "45-54"]
formula <- admissions ~ 1 + pcf_4554_cycle + pcf_4554_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[7:8, 6:8] = exp(model_f$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "55-64"]
formula <- admissions ~ 1 + pcf_5564_cycle + pcf_5564_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[9:10, 6:8] = exp(model_f$summary.fixed[2:3, c("mean", "0.025quant", "0.975quant")])

write.csv(age_results, "la_results/age_results.csv")

rm(model_f)


### Lag effect analysis ###


# Add lag effect data
la_2001 <- readRDS("data/las_exposures_2001.Rds")

age_results = data.frame(matrix(nrow = 16, ncol = 8))
names(age_results) = c("Age band", "Explanatory variable", "IRR",  "Lower CI",	"Upper CI",	"IRR",	"Lower CI",	"Upper CI")
age_results$`Age band` = rep(c("25-34", "35-44", "45-54", "55-64"), each = 4)

age_results$`Explanatory variable` = rep(c("% Cycle lag", "% Walk lag", "% Cycle 11", "% Walk 11"), length.out = nrow(age_results))

# Males #
hold <- la_males[la_males$age_band == "25-34"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcm01_1624_cycle + pcm01_1624_walk + pcm_2534_cycle + pcm_2534_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[1:4, 3:5] = exp(model_m$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "35-44"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcm_3544_cycle + pcm_3544_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[5:8, 3:5] = exp(model_m$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "45-54"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcm_4554_cycle + pcm_4554_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[9:12, 3:5] = exp(model_m$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

hold <- la_males[la_males$age_band == "55-64"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcm_5564_cycle + pcm_5564_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_m)
age_results[13:16, 3:5] = exp(model_m$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

rm(model_m)

# Females #
hold <- la_females[la_females$age_band == "25-34"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcf01_1624_cycle + pcf01_1624_walk + pcf_2534_cycle + pcf_2534_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[1:4, 6:8] = exp(model_f$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "35-44"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcf01_2534_cycle + pcf01_2534_walk + pcf_3544_cycle + pcf_3544_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[5:8, 6:8] = exp(model_f$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "45-54"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcf01_3544_cycle + pcf01_3544_walk + pcf_4554_cycle + pcf_4554_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[9:12, 6:8] = exp(model_f$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

hold <- la_females[la_females$age_band == "55-64"]
hold <- join(hold, la_2001, by = "la_code", type = "left", match = "all")
formula <- admissions ~ 1 + pcf01_4554_cycle + pcf01_4554_walk + pcf_5564_cycle + pcf_5564_walk + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_f <- inla(formula, family = "poisson", data = hold, control.compute=list(dic=T))
summary(model_f)
age_results[13:16, 6:8] = exp(model_f$summary.fixed[2:5, c("mean", "0.025quant", "0.975quant")])

write.csv(age_results, "la_results/age_results_lag.csv")

rm(model_f)

