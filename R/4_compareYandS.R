################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#Load Packages
library(tidyverse)
library(tidyr)
library(readr)
library(tibble)
library(stringr)
library(raster)
library(rprojroot)
library(dplyr)
library(RColorBrewer)
library(magrittr)
library(rprojroot)


#Set working directory
P <- rprojroot::find_rstudio_root_file

#Load TIF results from Sam
Sacc <- raster(P("zproject/world3/hp3logmask/outputs/hp3logmask.CAZ_CE.rank.compressed.tif"))
Sflat <- raster(P("zproject/world3/hp3nomask/outputs/hp3nomask.CAZ_E.rank.compressed.tif"))

#Load RDS Results from Sam
Shp3acc <- readRDS(P("data/speciescurves/hp3acc.RDS"))
#by 11.4% all species are sampled
Shpflat <- readRDS(P("data/speciescurves/hp3flat.RDS"))
#by 7.801% all species have been sampled


#select top 710 sites from my solutions
Sacc[Sacc > 0] <- 1
Sacc[Sacc <= 0] <- 0
cutoff <- (1/cellStats(Sacc, sum)) * 710
#18177 sites 

#Write rasters with just the top 710 sites
Sacc <- raster(P("zproject/world3/hp3logmask/outputs/hp3logmask.CAZ_CE.rank.compressed.tif"))
Sacc[Sacc > 1-cutoff] <- 1
Sacc[Sacc <= 1-cutoff] <- 0
writeRaster(Sacc, P("zproject/world3/hp3logmask/outputs/hp3log_710.tif"))
Sflat[Sflat > 1-cutoff] <- 1
Sflat[Sflat <= 1-cutoff] <- 0
writeRaster(Sflat, P("zproject/world3/hp3nomask/outputs/hp3flat_710.tif"))


#IGNORE FOR NOW
wzon_process <- function(ranking){
  name <- raster(ranking)
  top5 <- raster(ranking)
  top5[top5 > .92] <- 1
  top5[top5 <= .92] <- 0
  return(stack(name, top5))
}

Sacc1 <- wzon_process(P("zproject/world3/hp3logmask/outputs/hp3logmask.CAZ_CE.rank.compressed.tif"))
cellStats(Sacc1[[2]], sum)
writeRaster(Sacc1[[2]], P("zproject/world3/hp3logmask/outputs/hp3log_1455.tif"))
#Load Yasha's Results


#LOAD YASHA's results  
#710 is the flat cost
#4180 is access costs
sites710 <- readRDS(P("data/yasharesults/710.RDS"))
sum710 <- readRDS(P("data/yasharesults/710.RDS"))
sum710[sum710 >= 0] <- 1
sitenumY <- cellStats(sum710, sum)
sitenumS <- 18177
sitenumS/sitenumY
writeRaster(sites710, P("data/yasharesults/710.tif"))

Y4180 <- readRDS(P("data/yasharesults/4180.rds"))
writeRaster(Y4180, P("data/yasharesults/4180.tif"))

yacc <- raster(P("data/yasharesults/4180.tif"))
yflat <-raster(P("data/yasharesults/710.tif"))

#compare flat cost results
flatcomp <- Sflat+ yflat
flatcomp[flatcomp >=2] <-10
flatcomp[flatcomp < 2] <- 0
flatcomp <- flatcomp/10
cellStats(flatcomp, sum)
writeRaster(flatcomp, P("data/yasharesults/compare/flatcomp.tif"))

#comapre access cost results
acccomp <- Sacc+ yacc
acccomp[acccomp >=2] <-10
acccomp[acccomp < 2] <- 0
acccomp <- acccomp/10
writeRaster(flatcomp, P("data/yasharesults/compare/acccomp.tif"))
cellStats(acccomp, sum)

#LOAD RDS FILES FOR CURVES
Y_ac_hp3_t <- readRDS(P("data/yasharesults/data_ac_hp3.RDS"))
Y_fc_hp3_t <- readRDS(P("data/yasharesults/data_fc_hp3.RDS"))

plot(Y4180)

#Sam's data for curves
ac_hp3 <- readRDS(P("data/speciescurves/hp3acc.RDS"))
fc_hp3 <- readRDS(P("data/speciescurves/hp3flat.RDS"))


#PROCESS RDS FILES
maxvirusA <- max(Y_ac_hp3$max_species_ac_hp3)
Y_ac_hp3 <- Y_ac_hp3_t %>%
  mutate(global_percentage_ac_hp3 = global_percentage_ac_hp3*100) %>%
  mutate(max_species_ac_hp3 = max_species_ac_hp3/maxvirusA*max(fc_hp3$totspecies))

#PROCESS RDS FILES
maxvirus <- max(Y_fc_hp3$max_species_fc_hp3)
Y_fc_hp3 <- Y_fc_hp3_t %>%
  mutate(global_percentage_fc_hp3 = global_percentage_fc_hp3*100) %>%
  mutate(max_species_fc_hp3 = max_species_fc_hp3/maxvirus*max(fc_hp3$totspecies))

#make fake data for tail end
  num <- seq(from = 3.89, to = 15, by = .10)
  species <- rep(5253, length(num))
  linez <- as.data.frame(cbind(num, species))
  
  
#PLot that shit  
plot(ac_hp3$totspecies ~ ac_hp3$percentsam,
     col = "white",
     xlim = c(0,8),
     ylim = c(0, 6000),
     xlab = "% of sites",
     ylab = "Number of Species Sampled"
)
lines(ac_hp3$totspecies ~ ac_hp3$percentsam, col = "red", lwd = 2)
lines(fc_hp3$totspecies ~ fc_hp3$percentsam, col = "blue", lwd = 2)
lines(Y_ac_hp3$max_species_ac_hp3 ~ Y_ac_hp3$global_percentage_ac_hp3, col = "purple", lwd = 2)
lines(Y_fc_hp3$max_species_fc_hp3 ~ Y_fc_hp3$global_percentage_fc_hp3, col = "orange", lwd = 2)
lines(linez$species ~ linez$num, col = "purple", lwd = 2)
lines(linez$species ~ linez$num, col = "orange", lwd = 2)
legend("bottomright", legend = c("Flat costs Zonation", "Access costs Znation", "Flat costs Prioritizr", "Access costs Prioritizr"), 
       col = c("blue", "red", "orange", "purple"), 
       lwd = c(2,2,2,2))

