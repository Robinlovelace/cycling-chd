#################################################
###### Myocardial Infarction Cycling Paper ######
#################################################

# Libraries
library(plyr)
library(data.table)
library(sp)

# Load data
sample_data <- readRDS("data/minap-sample.Rds")

# Subset data to variables required
names(sample_data)
vars <- c("year", "age", "sex", "easting", "northing") # Will need to add more later
minap = sample_data[vars]
rm(sample_data)
rm(vars)

# Keep only years interested in [need to make a decision on this - I have picked 2010-2013 for now]
minap <- minap[minap$year>2009,]
# Remove observations with no location
minap = minap[!is.na(minap$easting) & !is.na(minap$easting),]

## Attach MSOA codes here ##
library(sp)
summary(minap$easting)
coords = cbind(minap$easting * 100, minap$northing * 100)
minap_sp = SpatialPointsDataFrame(coords = coords, data = minap)
rm(coords)

bbox(minap_sp)
proj4string(minap_sp) = CRS("+init=epsg:27700")
minap_sp = spTransform(x = minap_sp, CRSobj = CRS("+init=epsg:4326"))
bbox(minap_sp)

las = readRDS("data/las-geo-mode.Rds")
names(las)

# msoas = readRDS("../pct-bigdata/ukmsoas-scenarios.Rds")
# names(msoas)
# msoas@data = msoas@data[1:13]
# saveRDS(msoas, "data/msoas.Rds")

msoas = readRDS("data/msoas.Rds")
names(msoas)
plot(las, lwd = 3)
plot(msoas, add = T) # just english msoas for now
plot(minap_sp, col = "red", add = T)
o = over(minap_sp, msoas)

names(o)
minap = cbind(minap, o[c("geo_code", "All", "Car", "Bicycle", "foot")])
rm(minap_sp)
rm(msoas)
rm(las)
rm(o)

# Save MSOA cycling data seperately
library(dplyr)
hold <- minap[c("geo_code", "All", "Car", "Bicycle", "foot")] # Subset
transport_msoa <- hold %>% distinct(geo_code) # Drop duplicate MSOAs
saveRDS(transport_msoa, "data/msoas_transport_data.Rds")
rm(transport_msoa)
rm(hold)

# Create age bands
minap$age_band <- cut(minap[, "age"], c(-1, 15.5, 24.5, 34.5, 44.5, 54.5, 64.5, 74.5, 121),
                            labels=c("0-15","16-24","25-34","35-44","45-54","55-64","65-74","75+"))

# Aggregate counts to MSOAs
minap$msoa_code <- minap$geo_code # Rename variable
dt <- data.table(minap) # Convert to data table
msoas_age_sex_yr <- dt[, list(admissions=.N), by = c("sex", "age_band", "year", "msoa_code")] # Aggregate up
msoas_age_sex_yr <- as.data.frame(msoas_age_sex_yr)
rm(minap)
rm(dt)



## Join on population data in same format here based on MSOA data

# Load population data
load("data/Population Data/Processed Data/pop_10_13.Rdata") # Loads object 'pop_10_13'

# Join together population data to MINAP
msoas_join <- join(msoas_age_sex_yr, pop_10_13, by = c("age_band", "sex", "year", "msoa_code"), type = "full", match = "all")
rm(msoas_age_sex_yr)
rm(pop_10_13)



### Create expected counts ###


# Aggregate counts by age and sex to calcuate the 'standard population'
hold <- data.table(msoas_join)
std_pop <- hold[, list(admissions = sum(admissions, na.rm = TRUE), population = sum(population, na.rm = TRUE)),
                by = c("sex", "age_band")]
rm(hold)


# Calculate age- and sex-specific rates
std_pop <- as.data.frame(std_pop)
std_pop$adm_rate <- std_pop$admissions / std_pop$population

std_pop <- std_pop[is.finite(std_pop$adm_rate),] # Get rid of missing data
std_pop

std_pop$population <- NULL # Delete unnceessary variables
std_pop$admissions <- NULL

# Join the age- and sex-specific rates onto the data
msoa_exp_obs <- join(msoas_join, std_pop, by = c("sex", "age_band"), type = "left", match = "all")
rm(msoas_join)
rm(std_pop)

# Calcuate expected rate
msoa_exp_obs$expt_adms <- msoa_exp_obs$adm_rate * msoa_exp_obs$population
msoa_exp_obs$adm_rate <- NULL

# Save data
saveRDS(msoa_exp_obs, "data/msoas_observed_expected_counts.Rds")
rm(msoa_exp_obs)
gc()

## What are left with is a file for MSOAs disaggregated by sex and age-bands with counts of
## admissions, population and the expected count of admissions. We can later aggregate by sex (or for total
## persons) the counts but better to keep disaggregated for now
