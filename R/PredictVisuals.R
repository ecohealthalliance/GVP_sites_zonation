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
library(classInt)
# and their dependencies
#Set project root path function and pr

P <- rprojroot::find_rstudio_root_file

wzon_process <- function(ranking,shape){
  name <- raster(ranking)
  top5 <- raster(ranking)
  top5[top5 > .95] <- 1
  top5[top5 <= .95] <- NA
  name <- crop(name, shape)
  top5 <-crop(top5, shape)
  return(stack(name, top5))
}


#load africa shapefiles
africa <- readOGR(P("visualization/GVP_gis/PREDCIT2/gadmafrica/africamerge.shp"))
africamap <- wzon_process(P("zproject/PREDICT/africa/outputs/africa.CAZ_C.rank.compressed.tif"), afcont)
afcont <- readOGR(P("visualization/GVP_gis/PREDCIT2/cont.shp"))
access_10km <- raster(P("data/access/access_log_10km.tif"))

#make raster background for africa
cont <- mask(access_10km, afcont)
cont[cont >= 0] <- 1
cont <- crop(cont, afcont)
plot(cont)

vdis <- viridis(50, 1, begin = 0, end = 1, direction = 1)
magma <- magma(50, 1, begin = 0, end = 1, direction = 1)
civ <- cividis(50, 1, begin = 0, end = 1, direction = 1)
inf <- inferno(50, 1, begin = 0, end = 1, direction = 1)
clear <- rgb(255, 255, 255, max = 255, alpha = 1, names = "clear")

seq <- seq(from = 1, to = 50, by = 1)
inf1 <- inf[c(seq)]
inf2 <- colorRampPalette(inf1)(10)
inf3 <-colorRampPalette(inf2)
inf4 <-inf3(11)
clear <- rgb(255, 255, 255, max = 255, alpha = 1, names = "clear")

zClass <- classIntervals(na.omit(sampleRegular(africamap[[1]], 1000)), n = 20, style = "pretty")   
breakz <- c(0, .25, .5, .6, .7, .8, .9, .925, .95, .975, .99, 1.00)

#classInt2 <- classIntervals(data$log_damages_diff_pr_so2_per_ha, n=20, style="pretty")
#catMethod2 = classInt2$brks

#PLOT OF INDIVIDUAL RANKINGS
plot(cont, 
     col = "#262626",
     main = "",
     bty = "n",
     axes = FALSE,
     legend = FALSE,
      box = FALSE,
     #box = FALSE,
     addfun = c(plot( africamap[[1]],
                      #xaxt = "n",
                      #yaxt = "n",
                      #breaks = breakz,
                      col = inf4, 
                     # bty = "n",
                      #axes1 = FALSE,
                      #box = FALSE),
                      #legend = TRUE,
                      add = TRUE),
                plot(africa, border = "#262626", lwd = .05, col = clear, add = TRUE))
)

