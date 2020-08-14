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

#Load species discovery curves and rasters

#RASTERS
flat <- raster(P("zonation_runs/test/test_1dg_flat/outputs/rank_flat.tif"))
flat_hp3 <- raster(P("zonation_runs/test/test_1dg_flat_hp3/outputs/rank_flat_hp3.tif"))
uneven <- raster(P("zonation_runs/test/test_1dg_uneven/outputs/rank_uneven.tif"))
uneven_hp3 <- raster(P("zonation_runs/test/test_1dg_uneven_hp3/outputs/rank_uneven_hp3.tif"))

#CURVES
curve_flat <- readRDS(P("results/curves/flat_curve.RDS"))
curve_flat_hp3 <- readRDS(P("results/curves/flat_hp3_curve.RDS"))
curve_uneven <-  readRDS(P("results/curves/uneven_curve.RDS"))
curve_uneven_hp3 <-  readRDS(P("results/curves/uneven_hp3_curve.RDS"))

#YASHA
sites_710 <- readRDS(P("results/prioritizr/710.RDS"))
sites_4180 <- readRDS(P("results/prioritizr/4180.RDS"))
ac_hp3 <- readRDS(P("results/prioritizr/data_ac_hp3.RDS"))
af_hp3 <- readRDS(P("results/prioritizr/data_fc_hp3.RDS"))


###################################   PLOT CURVES   ##################################

plot(curve_flat$totspecies ~ curve_flat$percentsam,
     col = "white",
     xlim = c(0,10),
     ylim = c(0, 6000),
     xlab = "% of sites",
     ylab = "Number of Species Sampled"
)
lines(curve_flat$totspecies ~ curve_flat$percentsam, col = "red")
lines(curve_flat_hp3$totspecies ~ curve_flat_hp3$percentsam, col = "blue")
lines(curve_uneven$totspecies ~ curve_uneven$percentsam, col = "orange")
lines(curve_uneven_hp3$totspecies ~ curve_uneven_hp3$percentsam, col = "green")




