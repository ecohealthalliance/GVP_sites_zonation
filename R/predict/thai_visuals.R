################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#Load Packages
library(tidyverse)
library(stringr)
library(devtools)
library(repmis)
library(rgdal)
library(raster)
library(cshapes)
library(rprojroot)
library(dplyr)
library(ggmap)
library(RColorBrewer)
library(rasterVis)  # raster visualisation
library(maptools)
library(rgeos)
library(classInt)
library(viridis)
library(maps)
# and their dependencies
#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file


THA <-readRDS(P("data/location/gadm36_THA_0_sp.rds"))
#IUCN/UNEP data on protected areas
#protected <- download.shapefile("https://www.protectedplanet.net/downloads/WDPA_Nov2018?type=shapefile") 
#protected <- readOGR(dsn = P("data/location/WDPA_Nov2018-shapefile/"), 
#layer = "WDPA_Nov2018-shapefile-polygons", verbose = TRUE)
#thai_protected <- crop(protected, THA)
#write_rds(thai_protected, P("data/location/thai_protected.RDS"))
thai_protected <- readRDS(P("data/location/thai_protected.RDS"))

ABF_logcost <- raster(P("zproject/post_thai/post_thai_logcost_ABF/outputs/post_thai_logcost_ABF.ABF_CE.rank.compressed.tif"))
ABF_nocost <- raster(P("zproject/post_thai/post_thai_nocost_ABF/outputs/post_thai_nocost_ABF.ABF_E.rank.compressed.tif"))
CAZ_logcost <- raster(P("zproject/post_thai/CAZ_logcost/outputs/CAZ_logcost.CAZ_CE.rank.compressed.tif"))
CAZ_nocost <- raster(P("zproject/post_thai/CAZ_nocost/outputs/CAZ_nocost.CAZ_E.rank.compressed.tif"))
ABF_urban <-raster(P("zproject/post_thai/ABF_logcost_urban/outputs/ABF_logcost_urban.ABF_CE.rank.compressed.tif"))
ABF_30 <- raster(P("zproject/post_thai/ABF_logcost_30/outputs/ABF_logcost_30.ABF_CE.rank.compressed.tif"))

ABF_nocost <- crop(ABF_nocost, THA)
ABF_logcost <-crop(ABF_logcost, THA)
CAZ_logcost <- crop(CAZ_logcost, THA)
CAZ_nocost <- crop(CAZ_nocost, THA)
ABF_urban <- crop(ABF_urban, THA)
ABF_30 <- crop(ABF_30, THA)

ABF_urban[is.na(ABF_urban[])] <- 0
ABF_30[is.na(ABF_30[])] <- 0

sum_priority <- ABF_nocost + ABF_logcost + CAZ_logcost + CAZ_nocost + ABF_urban + ABF_30
sum_priority <- sum_priority/6 *100

vdis <- viridis(50, 1, begin = 0, end = 1, direction = 1)
magma <- magma(50, 1, begin = 0, end = 1, direction = 1)
civ <- cividis(50, 1, begin = 0, end = 1, direction = 1)
inf <- inferno(50, 1, begin = 0, end = 1, direction = 1)

colors3 <- rev(brewer.pal(10, "Spectral"))
colors3 <- colorRampPalette(colors3)
colors <- colors3(100)


color2 <- colorRampPalette(c("black", "dark blue", "dark green", "yellow"))(10)
meh5 <- colorRampPalette(color2)
colors <- meh5(100)

zClass <- classIntervals(na.omit(sampleRegular(sum_priority, 1000)), n = 11, style = "jenks")   
zClass$brks[1] <- zClass$brks[1] - 1 

plot(sum_priority, main = "Thailand: ABF with no costs",
     xaxt = "n",
     yaxt = "n",
     #breaks = seq(),
     col = inf, 
     bty = "n",
     axes = FALSE,
     box = FALSE
     #addfun = plot(THA, add = TRUE)
)



