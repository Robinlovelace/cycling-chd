# Aim: prepare 2001 data on TTW to explore lag effect

# Open data accessed from here: https://www.nomisweb.co.uk/census/2001/st119
las01_raw = readr::read_csv("data/st119-lad-2001-ttw-age-mode-sex-england-wales.csv")
la_transp_sex_age <- readr::read_csv("data/la_commuting_data_age_sex_2011.csv")
names(las01_raw)
names(la_transp_sex_age)
las01_raw = rename(las01_raw, la_code = `geography code`)
las01_raw = dplyr::select(las01_raw, -starts_with("date"))

las_reordered = inner_join(la_transp_sex_age["la_code"], las01_raw)

las01 = dplyr::transmute(las_reordered,
                         la_code = la_code,
                      local_authority = `geography`,
                      pcp_1624_walk = (`Sex: All persons; Age: Aged 16 to 19; Method of travel to work: On foot; measures: Value` +
                                         `Sex: All persons; Age: Aged 20 to 24; Method of travel to work: On foot; measures: Value`) /
                        (`Sex: All persons; Age: Aged 16 to 19; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 20 to 24; Method of travel to work: All categories: Method of travel to work; measures: Value`
                           ),
                      pcp_1624_cycle = (`Sex: All persons; Age: Aged 16 to 19; Method of travel to work: Bicycle; measures: Value` +
                                         `Sex: All persons; Age: Aged 20 to 24; Method of travel to work: Bicycle; measures: Value`) /
                        (`Sex: All persons; Age: Aged 16 to 19; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 20 to 24; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_2534_walk = (`Sex: All persons; Age: Aged 25 to 29; Method of travel to work: On foot; measures: Value` +
                                         `Sex: All persons; Age: Aged 30 to 34; Method of travel to work: On foot; measures: Value`) /
                        (`Sex: All persons; Age: Aged 25 to 29; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 30 to 34; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_2534_cycle = (`Sex: All persons; Age: Aged 25 to 29; Method of travel to work: Bicycle; measures: Value` +
                                         `Sex: All persons; Age: Aged 30 to 34; Method of travel to work: Bicycle; measures: Value`) /
                        (`Sex: All persons; Age: Aged 25 to 29; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 30 to 34; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_3544_walk = (`Sex: All persons; Age: Aged 35 to 39; Method of travel to work: On foot; measures: Value` +
                                         `Sex: All persons; Age: Aged 40 to 44; Method of travel to work: On foot; measures: Value`) /
                        (`Sex: All persons; Age: Aged 35 to 39; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 40 to 44; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_3544_cycle = (`Sex: All persons; Age: Aged 35 to 39; Method of travel to work: Bicycle; measures: Value` +
                                          `Sex: All persons; Age: Aged 40 to 44; Method of travel to work: Bicycle; measures: Value`) /
                        (`Sex: All persons; Age: Aged 35 to 39; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 40 to 44; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_4554_walk = (`Sex: All persons; Age: Aged 45 to 49; Method of travel to work: On foot; measures: Value` +
                                         `Sex: All persons; Age: Aged 50 to 54; Method of travel to work: On foot; measures: Value`) /
                        (`Sex: All persons; Age: Aged 45 to 49; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 50 to 54; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_4554_cycle = (`Sex: All persons; Age: Aged 45 to 49; Method of travel to work: Bicycle; measures: Value` +
                                          `Sex: All persons; Age: Aged 50 to 54; Method of travel to work: Bicycle; measures: Value`) /
                        (`Sex: All persons; Age: Aged 45 to 49; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 50 to 54; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_5564_walk = (`Sex: All persons; Age: Aged 55 to 59; Method of travel to work: On foot; measures: Value` +
                                         `Sex: All persons; Age: Aged 60 to 64; Method of travel to work: On foot; measures: Value`) /
                        (`Sex: All persons; Age: Aged 55 to 59; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 60 to 64; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        ),
                      pcp_5564_cycle = (`Sex: All persons; Age: Aged 55 to 59; Method of travel to work: Bicycle; measures: Value` +
                                          `Sex: All persons; Age: Aged 60 to 64; Method of travel to work: Bicycle; measures: Value`) /
                        (`Sex: All persons; Age: Aged 55 to 59; Method of travel to work: All categories: Method of travel to work; measures: Value` +
                           `Sex: All persons; Age: Aged 60 to 64; Method of travel to work: All categories: Method of travel to work; measures: Value`
                        )
                      )



for(i in 3:12) {
  print(paste(names(las01)[i], cor(las01[[i]], la_transp_sex_age[[i]], use = "complete.obs")))
}
