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

# Keep only years interested in [need to make a decision on this]
minap <- minap[minap$year>2009,]
# Remove observations with no location
minap = minap[!is.na(minap$easting) & !is.na(minap$easting),]

## RL - need to attach M/LSOA codes here ##
library(sp)
summary(minap$easting)
coords = cbind(minap$easting * 100, minap$northing * 100)
minap_sp = SpatialPointsDataFrame(coords = coords, data = minap)
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

# Create age bands
minap$age_band <- cut(minap[, "age"], c(-1, 15.5, 24.5, 34.5, 44.5, 54.5, 64.5, 74.5, 121),
                            labels=c("0-15","16-24","25-34","35-44","45-54","55-64","65-74","75+"))

# Aggregate counts to M/LSOAs
dt <- data.table(minap)
data <- dt[, list(admissions=.N), by = c("sex", "age_band", "year", "msoa_code")]
data <- as.data.frame(data)

## Join on population data in same format here based on M/LSOA data (RL)


### Create expected counts ###


# Aggregate counts by age and sex to calcuate the 'standard population'
std_pop <- dt[, list(admissions=.N, population=sum(data$population)), by = c("sex", "age_band")]

# Calculate age- and sex-specific rates
std_pop <- as.data.frame(std_pop)
std_pop$adm_rate <- std_pop$admissions / std_pop$population
std_pop$population <- NULL
std_pop$admissions <- NULL

# Join the age- and sex-specific rates onto the data
data2 <- join(data, std_pop, by = c("sex", "age_band"), type = "left", match = "first")

# Calcuate expected rate
data2$adm_expt <- data2$adm_rate * data2$population

## What we want left is a file for MSOAs disaggregated by sex and age-bands with counts of
## admissions and the expected count of admissions. We can later aggregate by sex (or for total
## persons) the counts but better to keep disaggregated for now
