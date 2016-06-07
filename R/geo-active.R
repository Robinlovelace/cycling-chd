# Aim: get geographical data on active travel over time
library(tmap)
library( abind)
# data from https://github.com/npct/pct-bigdata
msoas = read_shape("~/npct/pct-bigdata/msoasmapshaped_25%.shp")
qtm(msoas)

# merge in travel data
msoas_age_mode = readr::read_csv("data/msoas-age-mode.csv")
names(msoas_age_mode) = gsub("Method of travel to work \\(2001 specification\\): ", "", names(msoas_age_mode))
names(msoas_age_mode) = gsub("Method of travel to work \\(2001 specification\\);", "", names(msoas_age_mode))
names(msoas_age_mode) = gsub("; measures: Value", "", names(msoas_age_mode))
names(msoas_age_mode) = gsub(" categories:  Age:", "", names(msoas_age_mode))
names(msoas_age_mode) = gsub(" All categories: Age 16 to 74", "", names(msoas_age_mode))
names(msoas_age_mode) = gsub(" Age ", "_", names(msoas_age_mode))
names(msoas_age_mode) = gsub(" to ", "_", names(msoas_age_mode))
names(msoas_age_mode) = gsub("; Age:", "", names(msoas_age_mode))

# sort out the modes
names(msoas_age_mode) = gsub("All other methods of travel_work", "other", names(msoas_age_mode))
names(msoas_age_mode) = gsub("On foot", "foot", names(msoas_age_mode))
names(msoas_age_mode) = gsub("Driving a car or van", "drive", names(msoas_age_mode))
names(msoas_age_mode) = gsub("Train, underground, metro, light rail, tram, bus, minibus or coach", "public", names(msoas_age_mode))
names(msoas_age_mode) = gsub("Work mainly at or from home", "home", names(msoas_age_mode))
names(msoas_age_mode) = tolower(names(msoas_age_mode))

write.csv(msoas_age_mode, "data/msoas-age-mode.csv")
