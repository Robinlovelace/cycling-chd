# Aim: generate data at LA level for Paul and draft facetted choropleth
library(sf)
library(tidyverse)
library(tmap)
las = readRDS("data/las_exposures_2001.Rds")
class(las)
# las_sf = ukboundaries::lad2011_simple
las_sf = read_sf("data/las.geojson")
write_csv(las, "data/las_exposures_2001.csv")
las2011 = read_csv("data/la_commuting_data_age_sex_2011.csv")
las_geo = readRDS("data/las-geo-mode.Rds")
las_sf = st_as_sf(las_geo)

nrow(las)
nrow(las_sf)
summary(las$la_code %in% las_sf$code)
summary(las$la_code %in% las_sf$code)
las = rename(las, code = la_code)
las_sf = left_join(las_sf, las)
qtm(las_sf, "pcp01_1624_walk")
qtm(las_sf, names(las_sf)[5:9])

las_exposure_2011 = read_csv("data/2011_exposure_25_74.csv")
las_exposure_2001 = read_csv("data/2001_exposure_25_74.csv")
summary(sel <- las_exposure_2001$la_code %in% las_sf$geo_code)
las_exposure_2001$la_code[!sel]
las_geo = select(las_sf, la_code = geo_code)
las_geo = left_join(las_geo, las_exposure_2001)
names_cycling = names(las_geo) %>%
  grep(pattern = "cycle", .)
names_walk = names(las_geo) %>%
  grep(pattern = "walk", .)
qtm(las_geo, names(las_geo)[names_cycling])
qtm(las_geo, names(las_geo)[names_walk])
