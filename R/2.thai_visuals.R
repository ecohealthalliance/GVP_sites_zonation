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


#Function for processing raster results
zon_process <- function(ranking, top5, name){
  ranking <- crop(raster(ranking), THA)
  top5 <- crop(raster(top5), THA)
  top5[top5 > 0] <- 1
  top5[top5 <= 0] <- 0
  name <- stack(ranking, top5)
}

#ABF with log costs and urban areas masked out
ABF_log_urb2 <- zon_process(P("zproject/post_thai/ABF_logcost_urban/outputs/ABF_logcost_urban.ABF_CE.rank.compressed.tif"), 
                            P("zproject/post_thai/ABF_logcost_urban/outputs/ABF_logcost_urban.nwout.1.ras.compressed.tif"),
                            ABF_log_urb2)

#ABF with no costs 
ABF_no_urb2 <- zon_process(P("zproject/post_thai/post_thai_nocost_ABF/outputs/post_thai_nocost_ABF.ABF_E.rank.compressed.tif"), 
                          P("zproject/post_thai/post_thai_nocost_ABF/outputs/post_thai_nocost_ABF.nwout.1.ras.compressed.tif"),
                          ABF_no_urb2)

#CAZ with no costs and urban masked out
CAZ_no_urb2 <- zon_process(P("zproject/post_thai/CAZ_nocost/outputs/CAZ_nocost.CAZ_E.rank.compressed.tif"), 
                           P("zproject/post_thai/CAZ_nocost/outputs/CAZ_nocost.nwout.1.ras.compressed.tif"),
                          CAZ_no_urb2)          

#CAZ with logcosts and urban masked out
CAZ_log_urb2 <- zon_process(P("zproject/post_thai/CAZ_logcost/outputs/CAZ_logcost.CAZ_CE.rank.compressed.tif"), 
                            P("zproject/post_thai/CAZ_logcost/outputs/CAZ_logcost.nwout.1.ras.compressed.tif"),
                           CAZ_log_urb2)          



##COLORS AND GRAPHING
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

zClass <- classIntervals(na.omit(sampleRegular(ABF_log_urb, 1000)), n = 11, style = "jenks")   
zClass$brks[1] <- zClass$brks[1] - 1 

#PLOT OF INDIVIDUAL RANKINGS
plot(biodiversity, main = "ABF w/log(costs)",
     xaxt = "n",
     yaxt = "n",
     # breaks = zClass$brks,
     col = colors, 
     bty = "n",
     axes = FALSE,
     box = FALSE
     #addfun = plot(THA, add = TRUE)
)

#PLOT OF SUM OF PRIORITY RANKINGS
sum_priority2 <- (ABF_no_urb2[[1]] + ABF_log_urb2[[1]] + CAZ_no_urb2[[1]] + CAZ_log_urb2[[1]])/4

plot(biodiversity, main = "Viral Diversity Sampling Hotpsots of China",
     xaxt = "n",
     yaxt = "n",
     # breaks = zClass$brks,
     col = inf, 
     bty = "n",
     axes = FALSE,
     box = FALSE
     #addfun = plot(THA, add = TRUE)
)

#COLORS
abf30 <- rgb(255, 0, 0, max = 255, alpha = 200, names = "red")
darkgreen <- rgb(0, 100, 0, max = 255, alpha = 255, names = "dark green")
red <- rgb(171,5,5, max = 255, alpha = 180, names = "red")
red2 <- rgb(171,5,5, max = 255, alpha = 150, names = "red")
clear <- rgb(255, 255, 255, max = 255, alpha = 1, names = "clear")
blue <- rgb(10, 10, 245, max = 255, alpha = 180, names = "blue")
key <- c("One Solution", "Two Solutions", "Three Solutions", "All Solutions", "Protected Areas")

color2 <- colorRampPalette(c("pink", "dark red"))(10)
meh5 <- colorRampPalette(color2)
sumcol <- meh5(4)


sum22 <- ABF_log_urb2[[2]] + CAZ_log_urb2[[2]] + ABF_no_urb2[[2]] + CAZ_no_urb2[[2]]
writeRaster(sum22, P("visualization/GVP_gis/thairesults2.tif"))
plot(CHN, main = "Viral Diversity Hotsots and Protected Areas in China",
     xaxt = "n",
     yaxt = "n",
     legend = FALSE,
     # border = FALSE,
     #breaks = c(0, 0.5 ,1),
     #col = darkgreen, 
     #alpha = .9,
     bty = "n",
     axes = FALSE,
     # box = FALSE, 
     addfun = c(plot(CHN_protected, border = NA, col = darkgreen, add = TRUE), 
                plot(sum2, add = TRUE, breaks = c(.5,1,2,3,4), col = sumcol, legend = FALSE))
     #addfun = c(plot(ABF_logcost5, add = TRUE, breaks = c(0, 0.5, 1),
     #                col = c(clear, urban), legend = FALSE), plot(THA, add = TRUE))
)
legend("bottomleft", legend = key, fill = c(sumcol, darkgreen), bty = "n")




