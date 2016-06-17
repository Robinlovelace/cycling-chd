#################################################
####### Process population data for MSOAs #######
#################################################

# Load data
male_2010 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2010_msoa.csv")
female_2010 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2010_msoa.csv")

# Calculate age bound counts
male_2010$mpop_0_15 <- apply(male_2010[,3:18], 1, sum)
male_2010$mpop_16_24 <- apply(male_2010[,19:27], 1, sum)
male_2010$mpop_25_34 <- apply(male_2010[,28:37], 1, sum)
male_2010$mpop_35_44 <- apply(male_2010[,38:47], 1, sum)
male_2010$mpop_45_54 <- apply(male_2010[,48:57], 1, sum)
male_2010$mpop_55_64 <- apply(male_2010[,58:67], 1, sum)
male_2010$mpop_65_74 <- apply(male_2010[,68:77], 1, sum)
male_2010$mpop_75plus <- apply(male_2010[,78:93], 1, sum)
male_2010 <- male_2010[,c(1,94:101)]

female_2010$fpop_0_15 <- apply(female_2010[,3:18], 1, sum)
female_2010$fpop_16_24 <- apply(female_2010[,19:27], 1, sum)
female_2010$fpop_25_34 <- apply(female_2010[,28:37], 1, sum)
female_2010$fpop_35_44 <- apply(female_2010[,38:47], 1, sum)
female_2010$fpop_45_54 <- apply(female_2010[,48:57], 1, sum)
female_2010$fpop_55_64 <- apply(female_2010[,58:67], 1, sum)
female_2010$fpop_65_74 <- apply(female_2010[,68:77], 1, sum)
female_2010$fpop_75plus <- apply(female_2010[,78:93], 1, sum)
female_2010 <- female_2010[,c(1,94:101)]

# Restructure files
pop_2010_m <- reshape(male_2010,
                      varying = c("mpop_0_15", "mpop_16_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-15","16-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2010_m$sex <- "Male"
pop_2010_m$id <- NULL
rm(male_2010)

pop_2010_f <- reshape(female_2010,
                      varying = c("fpop_0_15", "fpop_16_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-15","16-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2010_f$sex <- "Female"
pop_2010_f$id <- NULL
rm(female_2010)

# Join data sets together
pop_2010 <- rbind(pop_2010_f, pop_2010_m)
pop_2010$year <- 2010
rm(pop_2010_f, pop_2010_m)

# Save Data
save(pop_2010, file = "data/Population Data/Processed Data/pop_2010.RData")
rm(pop_2010)
gc()

###
# For each year I just select all above lines of code, 'control and F' and then replace all years '2010' (eg) with '2011' - 60 occurrences
# Lazy - yes, but it works!

### Combine all years together into one file ###

# Load data
load("data/Population Data/Processed Data/pop_2010.RData")
load("data/Population Data/Processed Data/pop_2011.RData")
load("data/Population Data/Processed Data/pop_2012.RData")
load("data/Population Data/Processed Data/pop_2013.RData")

# Some of 2012 and 2013 codes are LAs as well (how data presented) so need removing
pop_2012$geography <- substr(pop_2012$msoa_code,1,3) # Take first 3 characters of MSOA code to decipher what type of geography
pop_2013$geography <- substr(pop_2013$msoa_code,1,3)

pop_2012 <- pop_2012[pop_2012$geography=="E02"|pop_2012$geography=="W02",] # Subset non-msoas out of data
pop_2013 <- pop_2013[pop_2013$geography=="E02"|pop_2013$geography=="W02",]

pop_2012$geography <- NULL # Delete variable
pop_2013$geography <- NULL

# Join together
pop_10_13 <- rbind(pop_2010, pop_2011, pop_2012, pop_2013)
save(pop_10_13, file = "data/Population Data/Processed Data/pop_10_13.RData")
rm(list=ls())
gc()
