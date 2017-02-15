#################################################
####### Process population data for MSOAs #######
#################################################

## 2002 ##

# Load data
male_2002 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2002_msoa.csv")
female_2002 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2002_msoa.csv")

# Calculate age bound counts
male_2002$mpop_0_17 <- apply(male_2002[,3:20], 1, sum)
male_2002$mpop_18_24 <- apply(male_2002[,21:27], 1, sum)
male_2002$mpop_25_34 <- apply(male_2002[,28:37], 1, sum)
male_2002$mpop_35_44 <- apply(male_2002[,38:47], 1, sum)
male_2002$mpop_45_54 <- apply(male_2002[,48:57], 1, sum)
male_2002$mpop_55_64 <- apply(male_2002[,58:67], 1, sum)
male_2002$mpop_65_74 <- apply(male_2002[,68:77], 1, sum)
male_2002$mpop_75plus <- apply(male_2002[,78:93], 1, sum)
male_2002 <- male_2002[,c(1,94:101)]

female_2002$fpop_0_17 <- apply(female_2002[,3:20], 1, sum)
female_2002$fpop_18_24 <- apply(female_2002[,21:27], 1, sum)
female_2002$fpop_25_34 <- apply(female_2002[,28:37], 1, sum)
female_2002$fpop_35_44 <- apply(female_2002[,38:47], 1, sum)
female_2002$fpop_45_54 <- apply(female_2002[,48:57], 1, sum)
female_2002$fpop_55_64 <- apply(female_2002[,58:67], 1, sum)
female_2002$fpop_65_74 <- apply(female_2002[,68:77], 1, sum)
female_2002$fpop_75plus <- apply(female_2002[,78:93], 1, sum)
female_2002 <- female_2002[,c(1,94:101)]

# Restructure files
pop_2002_m <- reshape(male_2002,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2002_m$sex <- "Male"
pop_2002_m$id <- NULL
rm(male_2002)

pop_2002_f <- reshape(female_2002,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2002_f$sex <- "Female"
pop_2002_f$id <- NULL
rm(female_2002)

# Join data sets together
pop_2002 <- rbind(pop_2002_f, pop_2002_m)
pop_2002$year <- 2002
rm(pop_2002_f, pop_2002_m)

# Save Data
save(pop_2002, file = "data/Population Data/Processed Data/pop_2002.RData")
rm(pop_2002)
gc()


## 2003 ##

# Load data
male_2003 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2003_msoa.csv")
female_2003 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2003_msoa.csv")

# Calculate age bound counts
male_2003$mpop_0_17 <- apply(male_2003[,3:20], 1, sum)
male_2003$mpop_18_24 <- apply(male_2003[,21:27], 1, sum)
male_2003$mpop_25_34 <- apply(male_2003[,28:37], 1, sum)
male_2003$mpop_35_44 <- apply(male_2003[,38:47], 1, sum)
male_2003$mpop_45_54 <- apply(male_2003[,48:57], 1, sum)
male_2003$mpop_55_64 <- apply(male_2003[,58:67], 1, sum)
male_2003$mpop_65_74 <- apply(male_2003[,68:77], 1, sum)
male_2003$mpop_75plus <- apply(male_2003[,78:93], 1, sum)
male_2003 <- male_2003[,c(1,94:101)]

female_2003$fpop_0_17 <- apply(female_2003[,3:20], 1, sum)
female_2003$fpop_18_24 <- apply(female_2003[,21:27], 1, sum)
female_2003$fpop_25_34 <- apply(female_2003[,28:37], 1, sum)
female_2003$fpop_35_44 <- apply(female_2003[,38:47], 1, sum)
female_2003$fpop_45_54 <- apply(female_2003[,48:57], 1, sum)
female_2003$fpop_55_64 <- apply(female_2003[,58:67], 1, sum)
female_2003$fpop_65_74 <- apply(female_2003[,68:77], 1, sum)
female_2003$fpop_75plus <- apply(female_2003[,78:93], 1, sum)
female_2003 <- female_2003[,c(1,94:101)]

# Restructure files
pop_2003_m <- reshape(male_2003,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2003_m$sex <- "Male"
pop_2003_m$id <- NULL
rm(male_2003)

pop_2003_f <- reshape(female_2003,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2003_f$sex <- "Female"
pop_2003_f$id <- NULL
rm(female_2003)

# Join data sets together
pop_2003 <- rbind(pop_2003_f, pop_2003_m)
pop_2003$year <- 2003
rm(pop_2003_f, pop_2003_m)

# Save Data
save(pop_2003, file = "data/Population Data/Processed Data/pop_2003.RData")
rm(pop_2003)
gc()

## 2004 ##

# Load data
male_2004 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2004_msoa.csv")
female_2004 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2004_msoa.csv")

# Calculate age bound counts
male_2004$mpop_0_17 <- apply(male_2004[,3:20], 1, sum)
male_2004$mpop_18_24 <- apply(male_2004[,21:27], 1, sum)
male_2004$mpop_25_34 <- apply(male_2004[,28:37], 1, sum)
male_2004$mpop_35_44 <- apply(male_2004[,38:47], 1, sum)
male_2004$mpop_45_54 <- apply(male_2004[,48:57], 1, sum)
male_2004$mpop_55_64 <- apply(male_2004[,58:67], 1, sum)
male_2004$mpop_65_74 <- apply(male_2004[,68:77], 1, sum)
male_2004$mpop_75plus <- apply(male_2004[,78:93], 1, sum)
male_2004 <- male_2004[,c(1,94:101)]

female_2004$fpop_0_17 <- apply(female_2004[,3:20], 1, sum)
female_2004$fpop_18_24 <- apply(female_2004[,21:27], 1, sum)
female_2004$fpop_25_34 <- apply(female_2004[,28:37], 1, sum)
female_2004$fpop_35_44 <- apply(female_2004[,38:47], 1, sum)
female_2004$fpop_45_54 <- apply(female_2004[,48:57], 1, sum)
female_2004$fpop_55_64 <- apply(female_2004[,58:67], 1, sum)
female_2004$fpop_65_74 <- apply(female_2004[,68:77], 1, sum)
female_2004$fpop_75plus <- apply(female_2004[,78:93], 1, sum)
female_2004 <- female_2004[,c(1,94:101)]

# Restructure files
pop_2004_m <- reshape(male_2004,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2004_m$sex <- "Male"
pop_2004_m$id <- NULL
rm(male_2004)

pop_2004_f <- reshape(female_2004,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2004_f$sex <- "Female"
pop_2004_f$id <- NULL
rm(female_2004)

# Join data sets together
pop_2004 <- rbind(pop_2004_f, pop_2004_m)
pop_2004$year <- 2004
rm(pop_2004_f, pop_2004_m)

# Save Data
save(pop_2004, file = "data/Population Data/Processed Data/pop_2004.RData")
rm(pop_2004)
gc()

## 2005 ##

# Load data
male_2005 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2005_msoa.csv")
female_2005 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2005_msoa.csv")

# Calculate age bound counts
male_2005$mpop_0_17 <- apply(male_2005[,3:20], 1, sum)
male_2005$mpop_18_24 <- apply(male_2005[,21:27], 1, sum)
male_2005$mpop_25_34 <- apply(male_2005[,28:37], 1, sum)
male_2005$mpop_35_44 <- apply(male_2005[,38:47], 1, sum)
male_2005$mpop_45_54 <- apply(male_2005[,48:57], 1, sum)
male_2005$mpop_55_64 <- apply(male_2005[,58:67], 1, sum)
male_2005$mpop_65_74 <- apply(male_2005[,68:77], 1, sum)
male_2005$mpop_75plus <- apply(male_2005[,78:93], 1, sum)
male_2005 <- male_2005[,c(1,94:101)]

female_2005$fpop_0_17 <- apply(female_2005[,3:20], 1, sum)
female_2005$fpop_18_24 <- apply(female_2005[,21:27], 1, sum)
female_2005$fpop_25_34 <- apply(female_2005[,28:37], 1, sum)
female_2005$fpop_35_44 <- apply(female_2005[,38:47], 1, sum)
female_2005$fpop_45_54 <- apply(female_2005[,48:57], 1, sum)
female_2005$fpop_55_64 <- apply(female_2005[,58:67], 1, sum)
female_2005$fpop_65_74 <- apply(female_2005[,68:77], 1, sum)
female_2005$fpop_75plus <- apply(female_2005[,78:93], 1, sum)
female_2005 <- female_2005[,c(1,94:101)]

# Restructure files
pop_2005_m <- reshape(male_2005,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2005_m$sex <- "Male"
pop_2005_m$id <- NULL
rm(male_2005)

pop_2005_f <- reshape(female_2005,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2005_f$sex <- "Female"
pop_2005_f$id <- NULL
rm(female_2005)

# Join data sets together
pop_2005 <- rbind(pop_2005_f, pop_2005_m)
pop_2005$year <- 2005
rm(pop_2005_f, pop_2005_m)

# Save Data
save(pop_2005, file = "data/Population Data/Processed Data/pop_2005.RData")
rm(pop_2005)
gc()


## 2006 ##

# Load data
male_2006 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2006_msoa.csv")
female_2006 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2006_msoa.csv")

# Calculate age bound counts
male_2006$mpop_0_17 <- apply(male_2006[,3:20], 1, sum)
male_2006$mpop_18_24 <- apply(male_2006[,21:27], 1, sum)
male_2006$mpop_25_34 <- apply(male_2006[,28:37], 1, sum)
male_2006$mpop_35_44 <- apply(male_2006[,38:47], 1, sum)
male_2006$mpop_45_54 <- apply(male_2006[,48:57], 1, sum)
male_2006$mpop_55_64 <- apply(male_2006[,58:67], 1, sum)
male_2006$mpop_65_74 <- apply(male_2006[,68:77], 1, sum)
male_2006$mpop_75plus <- apply(male_2006[,78:93], 1, sum)
male_2006 <- male_2006[,c(1,94:101)]

female_2006$fpop_0_17 <- apply(female_2006[,3:20], 1, sum)
female_2006$fpop_18_24 <- apply(female_2006[,21:27], 1, sum)
female_2006$fpop_25_34 <- apply(female_2006[,28:37], 1, sum)
female_2006$fpop_35_44 <- apply(female_2006[,38:47], 1, sum)
female_2006$fpop_45_54 <- apply(female_2006[,48:57], 1, sum)
female_2006$fpop_55_64 <- apply(female_2006[,58:67], 1, sum)
female_2006$fpop_65_74 <- apply(female_2006[,68:77], 1, sum)
female_2006$fpop_75plus <- apply(female_2006[,78:93], 1, sum)
female_2006 <- female_2006[,c(1,94:101)]

# Restructure files
pop_2006_m <- reshape(male_2006,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2006_m$sex <- "Male"
pop_2006_m$id <- NULL
rm(male_2006)

pop_2006_f <- reshape(female_2006,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2006_f$sex <- "Female"
pop_2006_f$id <- NULL
rm(female_2006)

# Join data sets together
pop_2006 <- rbind(pop_2006_f, pop_2006_m)
pop_2006$year <- 2006
rm(pop_2006_f, pop_2006_m)

# Save Data
save(pop_2006, file = "data/Population Data/Processed Data/pop_2006.RData")
rm(pop_2006)
gc()


## 2007 ##

# Load data
male_2007 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2007_msoa.csv")
female_2007 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2007_msoa.csv")

# Calculate age bound counts
male_2007$mpop_0_17 <- apply(male_2007[,3:20], 1, sum)
male_2007$mpop_18_24 <- apply(male_2007[,21:27], 1, sum)
male_2007$mpop_25_34 <- apply(male_2007[,28:37], 1, sum)
male_2007$mpop_35_44 <- apply(male_2007[,38:47], 1, sum)
male_2007$mpop_45_54 <- apply(male_2007[,48:57], 1, sum)
male_2007$mpop_55_64 <- apply(male_2007[,58:67], 1, sum)
male_2007$mpop_65_74 <- apply(male_2007[,68:77], 1, sum)
male_2007$mpop_75plus <- apply(male_2007[,78:93], 1, sum)
male_2007 <- male_2007[,c(1,94:101)]

female_2007$fpop_0_17 <- apply(female_2007[,3:20], 1, sum)
female_2007$fpop_18_24 <- apply(female_2007[,21:27], 1, sum)
female_2007$fpop_25_34 <- apply(female_2007[,28:37], 1, sum)
female_2007$fpop_35_44 <- apply(female_2007[,38:47], 1, sum)
female_2007$fpop_45_54 <- apply(female_2007[,48:57], 1, sum)
female_2007$fpop_55_64 <- apply(female_2007[,58:67], 1, sum)
female_2007$fpop_65_74 <- apply(female_2007[,68:77], 1, sum)
female_2007$fpop_75plus <- apply(female_2007[,78:93], 1, sum)
female_2007 <- female_2007[,c(1,94:101)]

# Restructure files
pop_2007_m <- reshape(male_2007,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2007_m$sex <- "Male"
pop_2007_m$id <- NULL
rm(male_2007)

pop_2007_f <- reshape(female_2007,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2007_f$sex <- "Female"
pop_2007_f$id <- NULL
rm(female_2007)

# Join data sets together
pop_2007 <- rbind(pop_2007_f, pop_2007_m)
pop_2007$year <- 2007
rm(pop_2007_f, pop_2007_m)

# Save Data
save(pop_2007, file = "data/Population Data/Processed Data/pop_2007.RData")
rm(pop_2007)
gc()


## 2008 ##

# Load data
male_2008 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2008_msoa.csv")
female_2008 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2008_msoa.csv")

# Calculate age bound counts
male_2008$mpop_0_17 <- apply(male_2008[,3:20], 1, sum)
male_2008$mpop_18_24 <- apply(male_2008[,21:27], 1, sum)
male_2008$mpop_25_34 <- apply(male_2008[,28:37], 1, sum)
male_2008$mpop_35_44 <- apply(male_2008[,38:47], 1, sum)
male_2008$mpop_45_54 <- apply(male_2008[,48:57], 1, sum)
male_2008$mpop_55_64 <- apply(male_2008[,58:67], 1, sum)
male_2008$mpop_65_74 <- apply(male_2008[,68:77], 1, sum)
male_2008$mpop_75plus <- apply(male_2008[,78:93], 1, sum)
male_2008 <- male_2008[,c(1,94:101)]

female_2008$fpop_0_17 <- apply(female_2008[,3:20], 1, sum)
female_2008$fpop_18_24 <- apply(female_2008[,21:27], 1, sum)
female_2008$fpop_25_34 <- apply(female_2008[,28:37], 1, sum)
female_2008$fpop_35_44 <- apply(female_2008[,38:47], 1, sum)
female_2008$fpop_45_54 <- apply(female_2008[,48:57], 1, sum)
female_2008$fpop_55_64 <- apply(female_2008[,58:67], 1, sum)
female_2008$fpop_65_74 <- apply(female_2008[,68:77], 1, sum)
female_2008$fpop_75plus <- apply(female_2008[,78:93], 1, sum)
female_2008 <- female_2008[,c(1,94:101)]

# Restructure files
pop_2008_m <- reshape(male_2008,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2008_m$sex <- "Male"
pop_2008_m$id <- NULL
rm(male_2008)

pop_2008_f <- reshape(female_2008,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2008_f$sex <- "Female"
pop_2008_f$id <- NULL
rm(female_2008)

# Join data sets together
pop_2008 <- rbind(pop_2008_f, pop_2008_m)
pop_2008$year <- 2008
rm(pop_2008_f, pop_2008_m)

# Save Data
save(pop_2008, file = "data/Population Data/Processed Data/pop_2008.RData")
rm(pop_2008)
gc()


## 2009 ##

# Load data
male_2009 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2009_msoa.csv")
female_2009 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2009_msoa.csv")

# Calculate age bound counts
male_2009$mpop_0_17 <- apply(male_2009[,3:20], 1, sum)
male_2009$mpop_18_24 <- apply(male_2009[,21:27], 1, sum)
male_2009$mpop_25_34 <- apply(male_2009[,28:37], 1, sum)
male_2009$mpop_35_44 <- apply(male_2009[,38:47], 1, sum)
male_2009$mpop_45_54 <- apply(male_2009[,48:57], 1, sum)
male_2009$mpop_55_64 <- apply(male_2009[,58:67], 1, sum)
male_2009$mpop_65_74 <- apply(male_2009[,68:77], 1, sum)
male_2009$mpop_75plus <- apply(male_2009[,78:93], 1, sum)
male_2009 <- male_2009[,c(1,94:101)]

female_2009$fpop_0_17 <- apply(female_2009[,3:20], 1, sum)
female_2009$fpop_18_24 <- apply(female_2009[,21:27], 1, sum)
female_2009$fpop_25_34 <- apply(female_2009[,28:37], 1, sum)
female_2009$fpop_35_44 <- apply(female_2009[,38:47], 1, sum)
female_2009$fpop_45_54 <- apply(female_2009[,48:57], 1, sum)
female_2009$fpop_55_64 <- apply(female_2009[,58:67], 1, sum)
female_2009$fpop_65_74 <- apply(female_2009[,68:77], 1, sum)
female_2009$fpop_75plus <- apply(female_2009[,78:93], 1, sum)
female_2009 <- female_2009[,c(1,94:101)]

# Restructure files
pop_2009_m <- reshape(male_2009,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2009_m$sex <- "Male"
pop_2009_m$id <- NULL
rm(male_2009)

pop_2009_f <- reshape(female_2009,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2009_f$sex <- "Female"
pop_2009_f$id <- NULL
rm(female_2009)

# Join data sets together
pop_2009 <- rbind(pop_2009_f, pop_2009_m)
pop_2009$year <- 2009
rm(pop_2009_f, pop_2009_m)

# Save Data
save(pop_2009, file = "data/Population Data/Processed Data/pop_2009.RData")
rm(pop_2009)
gc()


## 2010 ##

# Load data
male_2010 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2010_msoa.csv")
female_2010 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2010_msoa.csv")

# Calculate age bound counts
male_2010$mpop_0_17 <- apply(male_2010[,3:20], 1, sum)
male_2010$mpop_18_24 <- apply(male_2010[,21:27], 1, sum)
male_2010$mpop_25_34 <- apply(male_2010[,28:37], 1, sum)
male_2010$mpop_35_44 <- apply(male_2010[,38:47], 1, sum)
male_2010$mpop_45_54 <- apply(male_2010[,48:57], 1, sum)
male_2010$mpop_55_64 <- apply(male_2010[,58:67], 1, sum)
male_2010$mpop_65_74 <- apply(male_2010[,68:77], 1, sum)
male_2010$mpop_75plus <- apply(male_2010[,78:93], 1, sum)
male_2010 <- male_2010[,c(1,94:101)]

female_2010$fpop_0_17 <- apply(female_2010[,3:20], 1, sum)
female_2010$fpop_18_24 <- apply(female_2010[,21:27], 1, sum)
female_2010$fpop_25_34 <- apply(female_2010[,28:37], 1, sum)
female_2010$fpop_35_44 <- apply(female_2010[,38:47], 1, sum)
female_2010$fpop_45_54 <- apply(female_2010[,48:57], 1, sum)
female_2010$fpop_55_64 <- apply(female_2010[,58:67], 1, sum)
female_2010$fpop_65_74 <- apply(female_2010[,68:77], 1, sum)
female_2010$fpop_75plus <- apply(female_2010[,78:93], 1, sum)
female_2010 <- female_2010[,c(1,94:101)]

# Restructure files
pop_2010_m <- reshape(male_2010,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2010_m$sex <- "Male"
pop_2010_m$id <- NULL
rm(male_2010)

pop_2010_f <- reshape(female_2010,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
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

## 2011 ##

# Load data
male_2011 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2011_msoa.csv")
female_2011 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2011_msoa.csv")

# Calculate age bound counts
male_2011$mpop_0_17 <- apply(male_2011[,3:20], 1, sum)
male_2011$mpop_18_24 <- apply(male_2011[,21:27], 1, sum)
male_2011$mpop_25_34 <- apply(male_2011[,28:37], 1, sum)
male_2011$mpop_35_44 <- apply(male_2011[,38:47], 1, sum)
male_2011$mpop_45_54 <- apply(male_2011[,48:57], 1, sum)
male_2011$mpop_55_64 <- apply(male_2011[,58:67], 1, sum)
male_2011$mpop_65_74 <- apply(male_2011[,68:77], 1, sum)
male_2011$mpop_75plus <- apply(male_2011[,78:93], 1, sum)
male_2011 <- male_2011[,c(1,94:101)]

female_2011$fpop_0_17 <- apply(female_2011[,3:20], 1, sum)
female_2011$fpop_18_24 <- apply(female_2011[,21:27], 1, sum)
female_2011$fpop_25_34 <- apply(female_2011[,28:37], 1, sum)
female_2011$fpop_35_44 <- apply(female_2011[,38:47], 1, sum)
female_2011$fpop_45_54 <- apply(female_2011[,48:57], 1, sum)
female_2011$fpop_55_64 <- apply(female_2011[,58:67], 1, sum)
female_2011$fpop_65_74 <- apply(female_2011[,68:77], 1, sum)
female_2011$fpop_75plus <- apply(female_2011[,78:93], 1, sum)
female_2011 <- female_2011[,c(1,94:101)]

# Restructure files
pop_2011_m <- reshape(male_2011,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2011_m$sex <- "Male"
pop_2011_m$id <- NULL
rm(male_2011)

pop_2011_f <- reshape(female_2011,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2011_f$sex <- "Female"
pop_2011_f$id <- NULL
rm(female_2011)

# Join data sets together
pop_2011 <- rbind(pop_2011_f, pop_2011_m)
pop_2011$year <- 2011
rm(pop_2011_f, pop_2011_m)

# Save Data
save(pop_2011, file = "data/Population Data/Processed Data/pop_2011.RData")
rm(pop_2011)
gc()

## 2012 ##

# Load data
male_2012 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2012_msoa.csv")
female_2012 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2012_msoa.csv")

# Calculate age bound counts
male_2012$mpop_0_17 <- apply(male_2012[,3:20], 1, sum)
male_2012$mpop_18_24 <- apply(male_2012[,21:27], 1, sum)
male_2012$mpop_25_34 <- apply(male_2012[,28:37], 1, sum)
male_2012$mpop_35_44 <- apply(male_2012[,38:47], 1, sum)
male_2012$mpop_45_54 <- apply(male_2012[,48:57], 1, sum)
male_2012$mpop_55_64 <- apply(male_2012[,58:67], 1, sum)
male_2012$mpop_65_74 <- apply(male_2012[,68:77], 1, sum)
male_2012$mpop_75plus <- apply(male_2012[,78:93], 1, sum)
male_2012 <- male_2012[,c(1,94:101)]

female_2012$fpop_0_17 <- apply(female_2012[,3:20], 1, sum)
female_2012$fpop_18_24 <- apply(female_2012[,21:27], 1, sum)
female_2012$fpop_25_34 <- apply(female_2012[,28:37], 1, sum)
female_2012$fpop_35_44 <- apply(female_2012[,38:47], 1, sum)
female_2012$fpop_45_54 <- apply(female_2012[,48:57], 1, sum)
female_2012$fpop_55_64 <- apply(female_2012[,58:67], 1, sum)
female_2012$fpop_65_74 <- apply(female_2012[,68:77], 1, sum)
female_2012$fpop_75plus <- apply(female_2012[,78:93], 1, sum)
female_2012 <- female_2012[,c(1,94:101)]

# Restructure files
pop_2012_m <- reshape(male_2012,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2012_m$sex <- "Male"
pop_2012_m$id <- NULL
rm(male_2012)

pop_2012_f <- reshape(female_2012,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2012_f$sex <- "Female"
pop_2012_f$id <- NULL
rm(female_2012)

# Join data sets together
pop_2012 <- rbind(pop_2012_f, pop_2012_m)
pop_2012$year <- 2012
rm(pop_2012_f, pop_2012_m)

# Save Data
save(pop_2012, file = "data/Population Data/Processed Data/pop_2012.RData")
rm(pop_2012)
gc()

## 2013 ##

# Load data
male_2013 <- read.csv("data/Population Data/Cleaned Raw Data/male_pop_2013_msoa.csv")
female_2013 <- read.csv("data/Population Data/Cleaned Raw Data/female_pop_2013_msoa.csv")

# Calculate age bound counts
male_2013$mpop_0_17 <- apply(male_2013[,3:20], 1, sum)
male_2013$mpop_18_24 <- apply(male_2013[,21:27], 1, sum)
male_2013$mpop_25_34 <- apply(male_2013[,28:37], 1, sum)
male_2013$mpop_35_44 <- apply(male_2013[,38:47], 1, sum)
male_2013$mpop_45_54 <- apply(male_2013[,48:57], 1, sum)
male_2013$mpop_55_64 <- apply(male_2013[,58:67], 1, sum)
male_2013$mpop_65_74 <- apply(male_2013[,68:77], 1, sum)
male_2013$mpop_75plus <- apply(male_2013[,78:93], 1, sum)
male_2013 <- male_2013[,c(1,94:101)]

female_2013$fpop_0_17 <- apply(female_2013[,3:20], 1, sum)
female_2013$fpop_18_24 <- apply(female_2013[,21:27], 1, sum)
female_2013$fpop_25_34 <- apply(female_2013[,28:37], 1, sum)
female_2013$fpop_35_44 <- apply(female_2013[,38:47], 1, sum)
female_2013$fpop_45_54 <- apply(female_2013[,48:57], 1, sum)
female_2013$fpop_55_64 <- apply(female_2013[,58:67], 1, sum)
female_2013$fpop_65_74 <- apply(female_2013[,68:77], 1, sum)
female_2013$fpop_75plus <- apply(female_2013[,78:93], 1, sum)
female_2013 <- female_2013[,c(1,94:101)]

# Restructure files
pop_2013_m <- reshape(male_2013,
                      varying = c("mpop_0_17", "mpop_18_24", "mpop_25_34", "mpop_35_44",
                                  "mpop_45_54", "mpop_55_64", "mpop_65_74", "mpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2013_m$sex <- "Male"
pop_2013_m$id <- NULL
rm(male_2013)

pop_2013_f <- reshape(female_2013,
                      varying = c("fpop_0_17", "fpop_18_24", "fpop_25_34", "fpop_35_44",
                                  "fpop_45_54", "fpop_55_64", "fpop_65_74", "fpop_75plus"),
                      v.names = "population",
                      timevar = "age_band",
                      times = c("0-17","18-24","25-34","35-44","45-54","55-64","65-74","75+"),
                      #new.row.names = 1:60392,
                      direction = "long")

pop_2013_f$sex <- "Female"
pop_2013_f$id <- NULL
rm(female_2013)

# Join data sets together
pop_2013 <- rbind(pop_2013_f, pop_2013_m)
pop_2013$year <- 2013
rm(pop_2013_f, pop_2013_m)

# Save Data
save(pop_2013, file = "data/Population Data/Processed Data/pop_2013.RData")
rm(pop_2013)
gc()



### MG: Lazy as can't be bothered to write for loop, but it works! ##



### Combine all years together into one file ###

# Load data
load("data/Population Data/Processed Data/pop_2002.RData")
load("data/Population Data/Processed Data/pop_2003.RData")
load("data/Population Data/Processed Data/pop_2004.RData")
load("data/Population Data/Processed Data/pop_2005.RData")
load("data/Population Data/Processed Data/pop_2006.RData")
load("data/Population Data/Processed Data/pop_2007.RData")
load("data/Population Data/Processed Data/pop_2008.RData")
load("data/Population Data/Processed Data/pop_2009.RData")
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
pop_02_13 <- rbind(pop_2002, pop_2003, pop_2004, pop_2005, pop_2006, pop_2007, pop_2008, pop_2009, pop_2010, pop_2011, pop_2012, pop_2013)
save(pop_02_13, file = "data/Population Data/Processed Data/pop_02_13.RData")
rm(list=ls())
gc()
