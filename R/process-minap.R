#################################################
###### Myocardial Infarction Cycling Paper ######
#################################################

# Libraries
library(plyr)
library(data.table)

# Set working directory
# setwd("M:/GitHub/cycling-chd") # Mark

# Load data
sample_data <- read.csv("./data/testdat.csv")

# Subset data to variables required
vars <- c("year", "age", "sex", "easting", "northing") # Will need to add more later
subset_data<- sample_data[,vars]

# Keep only years interested in [need to make a decision on this]
subset_data <- subset_data[subset_data$year>2009,]

## Robin - need to attach M/LSOA codes here ##

# Create age bands [may want to change these to 5 or 10 year age bands???]
# Whatever way we choose, we will need to join on M/LSOA population level data to match this
subset_data$age_band <- cut(subset_data[, "age"], c(-1, 15.5, 24.5, 34.5, 44.5, 54.5, 64.5, 74.5, 121),
                            labels=c("0-15","16-24","25-34","35-44","45-54","55-64","65-74","75+"))

# Aggregate counts to M/LSOAs
dt <- data.table(subset_data)
data <- dt[, list(admissions=.N), by = c("sex", "age_band", "M/LSOA")]
data <- as.data.frame(data)

## Join on population data in same format here based on M/LSOA data (variable: data$population)


### Create expected counts ###


# Aggregate counts by age and sex to calcuate the 'standard population'
std_pop <- dt[, list(admissions=.N, population=sum(population)), by = c("sex", "age_band")]

# Calculate age- and sex-specific rates
std_pop <- as.data.frame(std_pop)
std_pop$adm_rate <- std_pop$admissions / std_pop$population
std_pop$population <- NULL
std_pop$admissions <- NULL

# Join the age- and sex-specific rates onto the data
data2 <- join(data, std_pop, by = c("sex", "age_band"), type = "left", match = "first")

# Calcuate expected rate
data2$adm_expt <- data2$adm_rate * data2$population

## What we want left is a file for M/LSOAs disaggregated by sex and age-bands with counts of
## admissions and the expected count of admissions. We can later aggregate by sex (or for total
## persons) the counts but better to keep disaggregated for now
