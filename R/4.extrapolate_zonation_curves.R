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

#CURVES
curve_flat_s <- readRDS(P("results/curves/flat_curve.RDS"))
curve_flat_hp3_s <- readRDS(P("results/curves/flat_hp3_curve.RDS"))
curve_uneven_s <-  readRDS(P("results/curves/uneven_curve.RDS"))
curve_uneven_hp3_s <-  readRDS(P("results/curves/uneven_hp3_curve.RDS"))


#approxfun {stats}
#totspecies and #numsites
#want to extrapolate to fill out #numsites 18,177 
site_series <- as.data.frame(seq(from = 1, to = 18177, by = 1))
colnames(site_series)[1] <- "site_series"
#site_series <- site_series %>% arrange(rev(site_series))

#INTERPOLATE FLAT CURVE
curve_flat <- approx(x = curve_flat_s$numsites, 
                     y = curve_flat_s$totspecies, xout = site_series$site_series, method = "linear")
curve_flat <- cbind(curve_flat[[1]],curve_flat[[2]])
colnames(curve_flat) <- c("num_sites", "num_species")
saveRDS(curve_flat, P("results/curves/interpolated/flat_curve.RDS"))
#results  734 sites to sample all

#INTERPOLATE FLAT HP3 CURVE
curve_flat_hp3 <- approx(x = curve_flat_hp3_s$numsites, 
                         y = curve_flat_hp3_s$totspecies, xout = site_series$site_series, method = "linear")
curve_flat_hp3 <- cbind(curve_flat_hp3[[1]],curve_flat_hp3[[2]])
colnames(curve_flat_hp3) <- c("num_sites", "num_species")
saveRDS(curve_flat_hp3, P("results/curves/interpolated/curve_flat_hp3.RDS"))
#results 2123   sites to sample all

#INTERPOLATE UNEVEN CURVE
curve_uneven <- approx(x = curve_uneven_s$numsites,
                       y = curve_uneven_s$totspecies, xout = site_series$site_series, method = "linear")
curve_uneven <- cbind(curve_uneven[[1]],curve_uneven[[2]])
colnames(curve_uneven) <- c("num_sites", "num_species")
saveRDS(curve_uneven, P("results/curves/interpolated/curve_uneven.RDS"))
#results 806 sites to sample all

#INTERPOLATE UNEVEN HP3 CURVE
curve_uneven_hp3 <- approx(x = curve_uneven_hp3_s$numsites,
                           y = curve_uneven_hp3_s$totspecies, xout = site_series$site_series, method = "linear")
curve_uneven_hp3 <- cbind(curve_uneven_hp3[[1]],curve_uneven_hp3[[2]])
colnames(curve_uneven_hp3) <- c("num_sites", "num_species")
saveRDS(curve_uneven_hp3, P("results/curves/interpolated/curve_uneven_hp3.RDS"))
#results 2372 sites to sample all


