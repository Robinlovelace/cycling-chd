# Aim load-in the data
pkgs <- c("readxl", "rgdal")
lapply(pkgs, library, character.only = TRUE)

df <- read_excel("data/PublicHealthEngland-Data.xls", sheet = 3)

