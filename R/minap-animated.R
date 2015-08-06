pkgs <- c(
  "animation",
  "ggmap",       # package for map visualisation
  "lubridate",   # package for converting time data
  "readr"
  )
lapply(pkgs, library, character.only = TRUE)

mibig <- read_csv("~/Desktop/Eastings_Northings_MINAP_RL.csv")
sel <- is.na(mibig$easting) | is.na(mibig$northing)
mibig <- mibig[!sel,]
head(mibig)
mibig$yrmnth <- paste(mibig$year, mibig$arrival_month)
mibig$yrmnth <- paste(mibig$yrmnth, "01")
head(mibig)
mibig$Time <- lubridate::ymd(mibig$yrmnth)
mi <- mibig[sample(nrow(mibig), 1000),]

plot(mi$Time, mi$easting)
qplot(data = mi, easting, northing) # very basic map
plot(1:nrow(mi), mi$Time)
mi <- mi[order(mi$Time),]
plot(1:nrow(mi), mi$Time) # times in order now
u <- unique(mi$Time)
length(u)

sel <- mi$Time == u[1]
plot(mi$easting, mi$northing, col = "white")
for(i in 2:length(u)){
  sel <- mi$Time == u[i]
  points(mi$easting[sel], mi$northing[sel])
}

# First animated plot
plot(mi$easting, mi$northing, col = "white")
oopt <- ani.options(interval = 0.08, nmax = length(u))
for(i in 1:ani.options("nmax")) {
  sel <- mi$Time == u[i]
  points(mi$easting[sel], mi$northing[sel])
  ## draw your plots here, then pause for a while with
  ani.pause()
}
ani.options(oopt)

saveHTML({
  plot(mi$easting, mi$northing, col = "white")
  ani.options(interval = 0.08, nmax = length(u))
  for(i in 1:length(u)) {
    sel <- mi$Time == u[i]
    points(mi$easting[sel], mi$northing[sel])
    ## draw your plots here, then pause for a while with
    ani.pause()
  }
}, img.name = "testplot", ani.height = 300, ani.width = 550)


pmi <- function(mi, xlim = c(min(mi$easting), max(mi$easting)), ...){
  for(i in seq_len(ani.options("nmax"))){
    sel <- mi$Time < u[i]
    dev.hold()
    plot(mi$easting, mi$northing, col = "white")
    points(mi$easting[sel], mi$northing[sel], ...)
    ani.pause()
  }
}

saveHTML({
  ani.options(interval = 0.05, nmax = 50)
  par(mar = c(4, 4, .1, 0.1), mgp = c(2, 0.7, 0))
  ani.options(interval = 0.05, nmax = 50)
  pmi(mi, col = "black")
  }, img.name = "bm_plot3", htmlfile = "test4.html")

# make a nice plot

qplot(data = mi, easting, northing, alpha = 0.01) +
  coord_fixed() +
  theme_nothing()

pmi2 <- function(mi){
  for(i in seq_len(ani.options("nmax"))){
  sel <- mi$Time < u[i]
  dev.hold()
  p <- ggplot(mi[sel,]) +
    geom_point(aes(easting, northing), alpha = 1, size = 1) +
    xlim(c(1470, 6540)) +
    ylim(c(310, 8450)) +
    theme_nothing()
  print(p)
  #     plot(mi$easting, mi$northing, col = "white")
  #     points(mi$easting[sel], mi$northing[sel])
  ani.pause()
  }
}

mi <- mibig[sample(nrow(mibig), 10000),]
mi <- mibig

saveGIF({
  ani.options(interval = 0.05, nmax = 128)
  par(mar = c(4, 4, .1, 0.1), mgp = c(2, 0.7, 0))
  ani.options(interval = 0.05, nmax = 50)

  pmi2(mi)

}, movie.name = "gg4.gif", img.name = "bm_plot")

saveVideo({
  ani.options(interval = 0.05, nmax = 128)
  par(mar = c(4, 4, .1, 0.1), mgp = c(2, 0.7, 0))
  ani.options(interval = 0.05, nmax = 50)

  pmi2(mi)

}, video.name = "gg5.mp4", img.name = "bm_plot")

