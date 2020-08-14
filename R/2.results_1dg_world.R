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
library(rasterVis)  
library(maptools)
library(rgeos)
library(raster)


P <- rprojroot::find_rstudio_root_file


##############Load Raster Results#############
#i messed up by not renaming the bat files, so the results outputs are all called "flat2" but they're in the correct folder names
flat <- raster(P("zonation_runs/test/test_1dg_flat/outputs/rank_flat.tif"))
flat_hp3 <- raster(P("zonation_runs/test/test_1dg_flat_hp3/outputs/rank_flat_hp3.tif"))
uneven <- raster(P("zonation_runs/test/test_1dg_uneven/outputs/rank_uneven.tif"))
uneven_hp3 <- raster(P("zonation_runs/test/test_1dg_uneven_hp3/outputs/rank_uneven_hp3.tif"))

site_num <- flat
site_num[site_num > 0] <- 1
cellStats(site_num, sum)  #Number of sites given is 18177

site_num_hp3 <- flat_hp3
site_num_hp3[site_num_hp3 > 0] <- 1
sites <- cellStats(site_num_hp3, sum) #same in other one too yay, so I'll sure this one 
  
#############Load in Species Curves###############

###################################### HP3 #########################################
#load curve
#flat_curve <- read.delim(P("zonation_runs/test/test_1dg_flat/outputs/test_1dg_flat2.CAZ_E.curves.txt"), skip = 1, header= FALSE, sep = "")
#flat_hp3_curve <- read.delim(P("zonation_runs/test/test_1dg_flat_hp3/outputs/test_1dg_flat2.CAZ_E.curves.txt"), skip = 1, header= FALSE, sep = "")
#resave as csv
#write.csv(flat_curve, P("zonation_runs/test/test_1dg_flat/outputs/flat_curve.csv"))
#write.csv(flat_hp3_curve, P("zonation_runs/test/test_1dg_flat_hp3/outputs/flat_hp3_curve.csv"))
#reload the csv bc for some reason that solves formatting errors
flat_curve <- read.csv(P("zonation_runs/test/test_1dg_flat/outputs/flat_curve.csv"))
uneven_curve <- read.csv(P("zonation_runs/test/test_1dg_uneven/outputs/uneven_curve.csv"))


#get rid of columns we don't need. cloumn one is just the row #
flat_curve <- flat_curve %>%
  select(2,3,9:dim(flat_curve)[2]) %>%  #column 1 is trash, #column 2 is te proportion of cells removed, 3-7 can be found on page 141 of manual but aren't useful here
  mutate(V1 = (100 - V1*100))  
#break into two groups so species can get summed up
sub <- flat_curve[,3:dim(flat_curve)[2]]
base <- flat_curve[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
flat_curve <- cbind(base, sub)
names(flat_curve)[1:3] <- c("percentsam", "cost", "totspecies") 
flat_curve %<>% 
  mutate(cost = 0) %>%   #putting cost as 0  because this is the flat cost curve, cost should just be # num of sites multiples by 1?
  mutate(numsites = sites*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) 
View(flat_curve)
saveRDS(flat_curve, P("results/curves/flat_curve.RDS"))

#get rid of columns we don't need. cloumn one is just the row #
uneven_curve <- uneven_curve %>%
  select(2,3,9:dim(uneven_curve)[2]) %>%  #column 1 is trash, #column 2 is te proportion of cells removed, 3-7 can be found on page 141 of manual but aren't useful here
  mutate(V1 = (100 - V1*100))  
#break into two groups so species can get summed up
sub <- uneven_curve[,3:dim(uneven_curve)[2]]
base <- uneven_curve[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
uneven_curve <- cbind(base, sub)
names(uneven_curve)[1:3] <- c("percentsam", "cost", "totspecies") 
uneven_curve %<>% 
  #mutate(cost = 0) %>%   
  mutate(numsites = sites*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) #%>%
View(uneven_curve)
saveRDS(uneven_curve, P("results/curves/uneven_curve.RDS"))

###################################### HP3 #########################################
#load curve
#uneven_curve<- read.delim(P("zonation_runs/test/test_1dg_uneven/outputs/test_1dg_flat2.CAZ_CE.curves.txt"), skip = 1, header= FALSE, sep = "")
#uneven_hp3_curve <- read.delim(P("zonation_runs/test/test_1dg_uneven_hp3/outputs/test_1dg_flat2.CAZ_CE.curves.txt"), skip = 1, header= FALSE, sep = "")
#resave as csv
#write.csv(uneven_curve, P("zonation_runs/test/test_1dg_uneven/outputs/uneven_curve.csv"))
#write.csv(uneven_hp3_curve, P("zonation_runs/test/test_1dg_uneven_hp3/outputs/uneven_hp3_curve.csv"))
#reload bc somehow that solves programming error
flat_hp3_curve <- read.csv(P("zonation_runs/test/test_1dg_flat_hp3/outputs/flat_hp3_curve.csv"))
uneven_hp3_curve <- read.csv(P("zonation_runs/test/test_1dg_uneven_hp3/outputs/uneven_hp3_curve.csv"))

#get rid of columns we don't need. cloumn one is just the row #
flat_hp3_curve <- flat_hp3_curve %>%
  select(2,3,9:dim(flat_hp3_curve)[2]) %>%  #column 1 is trash, #column 2 is te proportion of cells removed, 3-7 can be found on page 141 of manual but aren't useful here
  mutate(V1 = (100 - V1*100))  
#break into two groups so species can get summed up
sub <- flat_hp3_curve[,3:dim(flat_hp3_curve)[2]]
base <- flat_hp3_curve[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
flat_hp3_curve <- cbind(base, sub)
names(flat_hp3_curve)[1:3] <- c("percentsam", "cost", "totspecies") 
flat_hp3_curve %<>% 
  mutate(cost = 0) %>%   
  mutate(numsites = sites*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) #%>%
View(flat_hp3_curve)
saveRDS(flat_hp3_curve, P("results/curves/flat_hp3_curve.RDS"))

#get rid of columns we don't need. cloumn one is just the row #
uneven_hp3_curve <- uneven_hp3_curve %>%
  select(2,3,9:dim(uneven_hp3_curve)[2]) %>%  #column 1 is trash, #column 2 is te proportion of cells removed, 3-7 can be found on page 141 of manual but aren't useful here
  mutate(V1 = (100 - V1*100))  
#break into two groups so species can get summed up
sub <- uneven_hp3_curve[,3:dim(uneven_hp3_curve)[2]]
base <- uneven_hp3_curve[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
uneven_hp3_curve <- cbind(base, sub)
names(uneven_hp3_curve)[1:3] <- c("percentsam", "cost", "totspecies") 
uneven_hp3_curve %<>% 
  #mutate(cost = 0) %>%   
  mutate(numsites = sites*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) #%>%
View(uneven_hp3_curve)
saveRDS(uneven_hp3_curve, P("results/curves/uneven_hp3_curve.RDS"))
