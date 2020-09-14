
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
library(rprojroot)
library(dplyr)
library(ggmap)
library(stats)
# and their dependencies
#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file

############################## MASK COST FILE AND ADD TOGETHER ACCESS TIME ###################################
access_1dg_min <-raster(P("data_big/access/access_1dg_slack.tif"))

#RASTERS
flat <- raster(P("results/rasters/rank_flat.tif"))
flat_hp3 <- raster(P("results/rasters/rank_flat_hp3.tif"))
uneven <- raster(P("results/rasters/rank_uneven.tif"))
uneven_hp3 <- raster(P("results/rasters/rank_uneven_hp3.tif"))

flat_thresh <- 1-734/181771
uneven_thresh <- 1-806/18177
flat_hp3_thresh <- 1-2123/18177
uneven_hp3_thresh <- 1-2372/18177


#Create masks for sites it takes to find all species in each iterations
flat[flat > flat_thresh] <- 1
flat[flat < 1] <- NA

flat_hp3[flat_hp3 > flat_hp3_thresh] <- 1
flat_hp3[flat_hp3 < 1] <- NA

uneven[uneven > uneven_thresh] <- 1
uneven[uneven < 1] <- NA

uneven_hp3[uneven_hp3 > uneven_hp3_thresh] <- 1
uneven_hp3[uneven_hp3 < 1] <- NA

#apply masks to access time to get sum of costs in access minutes
access_1dg_min %>% 
  mask(.,flat) %>% 
  cellStats(.,sum)


flat_hp3_acc
flat




all <- flat + flat_hp3 + uneven + uneven_hp3
#writeRaster(all, P("results/rasters/add_zonation.tif"))
all[all != 4] <- 0
all <- all/4
cellStats(all, sum)
