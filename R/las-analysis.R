# Aim: generate data at LA level for Paul and draft facetted choropleth
library(sf)
library(tidyverse)
library(tmap)
las = readRDS("data/las_exposures_2001.Rds")
class(las)
las_sf = ukboundaries::lad2011_simple
write_csv(las, "data/las_exposures_2001.csv")
las2011 = read_csv("data/la_commuting_data_age_sex_2011.csv")

nrow(las)
nrow(las_sf)
summary(las$la_code %in% las_sf$code)
summary(las$la_code %in% las_sf$code)
las = rename(las, code = la_code)
las_sf = left_join(las_sf, las)
qtm(las_sf, "pcp01_1624_walk")
qtm(las_sf, names(las_sf)[5:9])


las_sf = "GIS/"
