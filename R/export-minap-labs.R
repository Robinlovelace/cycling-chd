# Aim: load and 'scramble' some minap data

library(readstata13)
f <- "N:\\Faculty-of-Medicine-and-Health/LIGHT/Cardiovascular Epidemiology/Robin Lovelace/Sample_RL.dta"
df <- read.dta13(f)
names(df)
labname <- get.label.name(df)
labname <- labname[labname != ""]

x <- data.frame(shortname =names(readstata13::get.varlabel(df)),
                longname = readstata13::get.varlabel(df))

# write.csv(x, "labnames.csv")

# library(jsonlite)
# labout <- as.list(1:length(labname))
# for(i in 1:length(labname)){
#   labout[[i]] <- readstata13::get.label(df, label.name = labname[i])
#   labout[[i]] <- paste0(labout[[i]], " = ", names(readstata13::get.label(df, label.name = labname[i])))
# }

names(labout)
labout <- setNames(labout, labname)

x <- toJSON(labout, pretty = T)
writeLines(x, "labnames.json")

set.seed(54)
write.csv(df[sample(x = nrow(df), size = 100),], "testdat.csv")

labs = read.csv("labnames.csv")
labs
labs$shortname
selection = which(labs$shortname == "ecg_place")
selection
labs[selection,]

