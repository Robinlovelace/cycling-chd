##########################################
######## Local Authority Analyses ########
##########################################


# Libraries
library(plyr)
library(data.table)
library(INLA)

# Load data
la_minap <- readRDS("data/las_observed_expected_counts.Rds") # Minap data
la_transport <- readr::read_csv("data/la_transport.csv") # Exposures
la_confs <- readr::read_csv("data/phe_la_data.csv") # Confounders

# Join into single file
hold <- join(la_minap, la_transport, by = "la_code", type = "left", match = "all")
la_data <- join(hold, la_confs, by = "la_code", type = "left", match = "all")
rm(hold, la_minap, la_transport, la_confs)
gc()

# Keep only years of focus
la_data <- la_data[la_data$year >= 2010]

### Analysing total admissions ###

# Aggregate data
dt <- data.table(la_data)
la_persons <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE), pccar_11 = max(pccar_11, na.rm = TRUE),
                        pccycle_11 = max(pccycle_11, na.rm = TRUE), pcwalk_11 = max(pcwalk_11, na.rm = TRUE), pcactive_11 = max(pcactive_11, na.rm = TRUE),
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
summary(model_p)


### Analysing admissions by sex ###

# Aggregate data
dt <- data.table(la_data)
la_sex <- dt[, list(admissions = sum(admissions, na.rm = TRUE), expt_adms = sum(expt_adms, na.rm = TRUE), pccar_11 = max(pccar_11, na.rm = TRUE),
                        pccycle_11 = max(pccycle_11, na.rm = TRUE), pcwalk_11 = max(pcwalk_11, na.rm = TRUE), pcactive_11 = max(pcactive_11, na.rm = TRUE),
                        imd_15 = max(imd_2015, na.rm = TRUE), pcsmoke_12 = max(pcsmoke_12, na.rm = TRUE), pc_pa_12 = max(pc_pa_12, na.rm = TRUE),
                        excess_wt_12_14 = max(excess_wt_12_14, na.rm = TRUE), dm_10_11 = max(dm_10_11, na.rm = TRUE)),
                 by = c("sex", "la_code")] # NB I have used max for covariates since are all same values - just need to select one!
la_sex$imd_15[is.infinite(la_sex$imd_15)] <- NA # Set 'infinite' values as missing
la_sex$pcsmoke_12[is.infinite(la_sex$pcsmoke_12)] <- NA
la_sex$pc_pa_12[is.infinite(la_sex$pc_pa_12)] <- NA
la_sex$excess_wt_12_14[is.infinite(la_sex$excess_wt_12_14)] <- NA
la_sex$dm_10_11[is.infinite(la_sex$dm_10_11)] <- NA

la_males <- la_sex[la_sex$sex=="Male"]
la_females <- la_sex[la_sex$sex=="Female"]
rm(la_sex)
gc()

# Regression
formula <- admissions ~ 1 + pccycle_11 + pcwalk_11 + imd_15 + pcsmoke_12 + excess_wt_12_14 + pc_pa_12
model_m <- inla(formula, family = "poisson", data = la_males, offset = log(expt_adms), control.compute=list(dic=T))
model_f <- inla(formula, family = "poisson", data = la_females, offset = log(expt_adms), control.compute=list(dic=T))
summary(model_m)
summary(model_f)





