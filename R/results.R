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

logcost <- raster(P("zproject/post_thai/post_thai_logcost_ABF/outputs/post_thai_logcost_ABF.ABF_CE.rank.compressed.tif"))
nocost <- raster(P("zproject/post_thai/post_thai_nocost_ABF/outputs/post_thai_nocost_ABF.ABF_E.rank.compressed.tif"))
logcost_noedge <- raster(P("zproject/post_thai/post_thai_logcost_ABF_noedge/outputs/post_thai_logcost_ABF_noedge.ABF_CE.rank.compressed.tif"))
nocost_noedge <- raster(P("zproject/post_thai/post_thai_nocost_ABF_noedge/outputs/post_thai_nocost_ABF_noedge.ABF_E.rank.compressed.tif"))
CAZ_logcost <- raster(P("zproject/post_thai/CAZ_logcost/outputs/CAZ_logcost.CAZ_CE.rank.compressed.tif"))
CAZ_nocost <- raster(P("zproject/post_thai/CAZ_nocost/outputs/CAZ_nocost.CAZ_E.rank.compressed.tif"))
CAZ_logcost_noedge <- raster(P("zproject/post_thai/CAZ_logcost_noedge/outputs/CAZ_logcost_noedge.CAZ_C.rank.compressed.tif"))
ABF_urban <-raster(P("zproject/post_thai/ABF_logcost_urban/outputs/ABF_logcost_urban.ABF_CE.rank.compressed.tif"))
ABF_30 <- raster(P("zproject/post_thai/ABF_logcost_30/outputs/ABF_logcost_30.ABF_CE.rank.compressed.tif"))

ABF_nocost <- crop(nocost, THA)
ABF_logcost <-crop(logcost, THA)
ABF_nocost_noedge <- crop(nocost, THA)
ABF_logcost_noedge <-crop(logcost, THA)
CAZ_logcost <- crop(CAZ_logcost, THA)
CAZ_nocost <- crop(CAZ_nocost, THA)
CAZ_logcost_noedge <- crop(CAZ_logcost_noedge, THA)
ABF_urban <- crop(ABF_urban, THA)
ABF_30 <- crop(ABF_30, THA)

#levelplot(ABF_30, main = "ABF Urban",
#          xlab = NULL,
#         ylab = NULL)

palette <- c('#063EB5','#06679B', '#3288bd', '#66c2a5', '#abdda4','#e6f598','#ffffbf', '#fee08b', '#fdae61', '#f46d43', '#d53e4f', '#9e0142')


#top 5% for cost and log cost for ABF
ABF_nocost5 <- raster(P('zproject/post_thai/post_thai_nocost_ABF/outputs/post_thai_nocost_ABF.nwout.1.ras.compressed.tif'))
ABF_logcost5 <- raster(P('zproject/post_thai/post_thai_logcost_ABF/outputs/post_thai_logcost_ABF.nwout.1.ras.compressed.tif'))
ABF_nocost5 <- crop(ABF_nocost5, THA)
ABF_nocost5[ABF_nocost5 > 0] <- 1
ABF_nocost5[ABF_nocost5 <= 0] <- 0
ABF_logcost5 <- crop(ABF_logcost5 , THA)
ABF_logcost5[ABF_logcost5  > 0] <- 1
ABF_logcost5[ABF_logcost5 <= 0] <- 0

#top 5% for cost and no cost for CAZ
CAZ_logcost5 <- raster(P('zproject/post_thai/CAZ_logcost/outputs/CAZ_logcost.nwout.1.ras.compressed.tif'))
CAZ_nocost5 <- raster(P('zproject/post_thai/CAZ_nocost/outputs/CAZ_nocost.nwout.1.ras.compressed.tif'))

CAZ_logcost5 <- crop(CAZ_logcost5, THA)
CAZ_logcost5[CAZ_logcost5 > 0] <- 1
CAZ_logcost5[CAZ_logcost5<= 0] <- 0

CAZ_nocost5  <- crop(CAZ_nocost5 , THA)
CAZ_nocost5[CAZ_nocost5 > 0] <- 1
CAZ_nocost5[CAZ_nocost5 <= 0] <- 0

#top5% for ABF_urban and ABF_30min
ABF_30_5 <- raster(P('zproject/post_thai/ABF_logcost_30/outputs/ABF_logcost_30.nwout.1.ras.compressed.tif'))
ABF_urban5 <- raster(P('zproject/post_thai/ABF_logcost_urban/outputs/ABF_logcost_urban.nwout.1.ras.compressed.tif'))

ABF_30_5 <- crop(ABF_30_5, THA)
ABF_30_5[ABF_30_5 > 0] <- 1
ABF_30_5[ABF_30_5 <= 0] <- 0

ABF_urban5 <- crop(ABF_urban5, THA)
ABF_urban5[ABF_urban5 > 0] <- 1
ABF_urban5[ABF_urban5 <= 0] <- 0

compare_logcostS <- raster(P('zproject/post_thai/CAZ_logcost/outputs/1CAZ_logcost_vs_ABFlogcost.compressed.tif'))
compare_logcostS <- crop(compare_logcostS, THA)


color2 <- colorRampPalette(c("black", "blue", "green", "yellow"))(10)
meh5 <- colorRampPalette(color2)
meow5 <- meh5(100)

plot(ABF_urban, main = "Thailand: ABF with no costs",
     xaxt = "n",
     yaxt = "n",
     breaks = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 1.0),
     col = colors2, 
     bty = "n",
     axes = FALSE,
     box = FALSE
    #addfun = plot(THA, add = TRUE)
  )

plot(ABF_urban, main = "Top 5% of sampling sites (ABF, no costs)",
     xaxt = "n",
     yaxt = "n",
     legend = FALSE,
     breaks = c(0,1),
     col = "red", 
     bty = "n",
     axes = FALSE,
     box = FALSE,
     addfun = plot(THA, add = TRUE)
)

difference <- abs(ABF_logcost - CAZ_logcost)
difference.2 <- difference
difference.2[difference.2 > .2] <- 1
difference.2[difference.2 <= .2] <- 0

colors3 <- rev(brewer.pal(10, "Spectral"))
colors4 <- c("white", "purple")
colors5 <- brewer.pal(9, "RdPu")

plot(difference.2, main = "Difference in priority rank >20% b/w ABF and CAZ (cost)",
     xaxt = "n",
     yaxt = "n",
     col = colors4, 
     bty = "n",
     axes = FALSE,
     box = FALSE,
    addfun = plot(THA, add = TRUE),
    legend = FALSE
)

differencep <- difference * 100
plot(differencep, main = "% Difference in priority rank b/w ABF and CAZ (no cost)",
     xaxt = "n",
     yaxt = "n",
     col = colors5, 
    # breaks = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0),
     breaks = c(0, 20, 30, 40, 50, 60, 70 ,80 ,90, 100),
     bty = "n",
     axes = FALSE,
     box = FALSE
     #addfun = plot(THA, add = TRUE)
     #legend = FALSE
)


abf30 <- rgb(255, 0, 0, max = 255, alpha = 125, names = "red")
urban <- rgb(20, 70, 210, max = 255, alpha = 125, names = "blue")
clear <- rgb(255, 255, 255, max = 255, alpha = 125, names = "clear")
yellow <- rgb(200, 200, 10, max = 255, alpha = 255, names = "yellow")

plot(ABF_30_5, main = "Top 5% with urban (blue) and 30 min (red) masks",
     xaxt = "n",
     yaxt = "n",
     legend = FALSE,
     breaks = c(0, 0.5 ,1),
     col = c(clear, abf30), 
     #alpha = .9,
     bty = "n",
     axes = FALSE,
     box = FALSE,
     addfun = c(plot(ABF_logcost5, add = TRUE, breaks = c(0, 0.5, 1),
                                          col = c(clear, urban), legend = FALSE), plot(THA, add = TRUE))
)


 #add up all 4 sets of results
sum <- ABF_nocost5 + ABF_logcost5 + CAZ_logcost5 + CAZ_nocost5 + ABF_30_5 + ABF_urban5
colors8 <- rev(brewer.pal(4, "OrRd"))
colors9 <- brewer.pal(6, "Greys")
plot(sum, main = "Priority Across Iterations",
     xaxt = "n",
     yaxt = "n",
     #legend = FALSE,
     #breaks = c(0,1,2,3,4),
     #col = colors9, 
     bty = "n",
     axes = FALSE,
     box = FALSE,
     addfun = plot(THA, add = TRUE)
)

#Overlay results with protected areas
sum[sum <= 3] <- 0
sum[sum >3] <- 1
colors8 <- rev(brewer.pal(4, "OrRd"))
colors9 <- rev(brewer.pal(6, "Greys"))
mycol <- rgb(255, 255, 255, max = 255, alpha = 125, names = "red")


darkgreen <- rgb(0, 100, 0, max = 255, alpha = 170, names = "dark green")
red <- rgb(178,34,34, max = 255, alpha = 255, names = "red")
clear <- rgb(255, 255, 255, max = 255, alpha = 1, names = "clear")

plot(THA, main = "Protected Areas and Sites in > 50% of solutions",
     xaxt = "n",
     yaxt = "n",
     #legend = FALSE,
     #breaks = c(0,1,2,3,4),
     bty = "n",
     axes = FALSE,
     #box = FALSE,
     addfun = c(plot(thai_protected, col = darkgreen, border = NA),
                plot(sum, add = TRUE, breaks = c(-.5, .5, 1), col = c(clear, red), legend = FALSE))
)
legend("bottomright", legend = c("Protected Areas", "Sample Sites"), 
       fill = c(darkgreen, red ), bty = "n")



