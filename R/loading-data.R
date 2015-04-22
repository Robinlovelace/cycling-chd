# Aim load-in the data
pkgs <- c("readxl", "rgdal")
# install.packages(pkgs) uncomment to install these packages
lapply(pkgs, library, character.only = TRUE)

# available from here: http://fingertips.phe.org.uk/profile/health-profiles/data#gid/1938132694/pat/6/ati/101/page/9/par/E12000004/are/E07000032
df <- read_excel("data/PublicHealthEngland-Data.xls", sheet = 3)

