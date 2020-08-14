#RECREATE ZONATION FILES
#Load, examine, and process RDS and tif files into Zonation inputs
#1 dg, masked by access file? 

#### Goals #####
#1 1 dg log(access) file that matches yasha's
#2 5000-something mammal files with same sampling as access file
#  

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

#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file
newproj <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

#load rasters to see whats what
yasha_access <- raster(P("data_big/access/access_1dg.tif"))  #Yasha sent this 8/5/2020 and idk if it's the right one no CRS, weird values)
yasha_log <- raster(P("data_big/access/access_log_1dg.tif"))  #this file was sent over slack april 2019
yasha_slack <- raster(P("data_big/access/access_1dg_slack.tif")) #this file was sent over slack from Yasha slack april 201


yasha_mammals <- readRDS(P("data_big/terr_pam_all_1dg_ras.RDS"))
mam_names <- list.files(path = P("data_big/mammals_1dg_world"))
sam_mammals <- stack(paste(P("data_big/mammals_1dg_world"), mam_names, sep = "/"))

#Create log(access) file that is the same extent and resolution as the mammal files
sam_access_log <- raster(P("data_big/access/access_log_10km.tif"))

template <- sam_mammals[[1]]


#make two access files: flat and log(access), and use them as masks?


########### hp3 file prep ############




