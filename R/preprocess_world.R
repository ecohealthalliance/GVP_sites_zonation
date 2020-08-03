################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#### This script downloads rasters and processes them to be same extent/resolution (Entire world)
####for input into the Zonation program developed by cbig, https://github.com/cbig/zonator

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

#Retrieve and test amazon key (follow instructions: https://ecohealthalliance.github.io/eha-ma-handbook/11-cloud-computing-services.html)
if (!require(aws.s3)) devtools::install_github("cloudyr/aws.s3")
if (!require(aws.signature)) devtools::install_github("cloudyr/aws.signature")
library(aws.s3)

# load credentials from your credentials file 
aws.signature::use_credentials()

# check list of aws S3 buckets 
head(aws.s3::bucketlist())

############# Download accessibility data from amazon cloud
b <- get_bucket("zonation.gvp")

if(!dir.exists(P("data/access"))) { 
  dir.create("data/access")
}

if(!file.exists("data/access/accessibility_to_cities_2015_v1.0.tif")) {
  save_object(object = "accessibility_to_cities_2015_v1.0.tif", bucket = "zonation.gvp", file = P("data/access/accessibility_to_cities_2015_v1.0.tif"))
}

#This isn't working right now^ so I'm going to read it in directly (file is corrupted during download)
accessibility_raw <- raster(P("data/access/accessibility_to_cities_2015_v1.0.tif"))
accessibility_1km <- projectRaster(accessibility_raw, crs = newproj)

###########Download Mammal Rasters (both preprocessed for world, and original unprocessed)
#There are two sets of mammal rasters, one thats been resampled to match the accessibility layer 
#and saved as individual .tif files. 
#The second is a .RDS file that is the original 1 dg data, not yet processed.
#This will be the template for any runs with different extents/resolutions
unprocessed_mammal_1dgWorld <- readRDS(P("data/raw/terr_pam_all_0.2dg_ras.RDS"))
processed_mammal_names <- paste(P("data/mammal_processed_1dgworld"),
                                   list.files(P("data/mammal_processed_1dgworld")),
                                   sep = "/")
processed_mammal_1dgworld <- stack(processed_mammal_names)
 #plot(unprocessed_mammal_1dgWorld[[6]])

#Reprocess Original Raster file (to check work)
accessibility_1dgT <- resample(accessibility_1km, unprocessed_mammal_1dgWorld, method = "bilinear")
acessibility_1dg <- crop(accessibility_1dgT, accessibility_1km, snap = "near")
processed_mammalstack_1dgworld <- crop(unprocessed_mammal_1dgWorld, acessibility_1dg, snap = "near")

#crop all mammal extent rasters by extent of acess file
names <- paste(P("data/mammals_1dg_world"), list.files(P("data/mammals_1dg_world")), sep = "/")
accessibility_raw <- raster(P("data_raw/access/accessibility_to_cities_2015_v1.0.tif"))
tempmam <- raster(P("data/mammals_1dg_world/Abditomys_latidens.tif"))
raster_template_1dg = raster(matrix(NA, 180,360), c(-180, 180, -90, 90))
f <- res(tempmam[[1]])/res(accessibility_raw[[1]])

accessibility_raw[accessibility_raw < 0] <- NA
access_1dg <- aggregate(accessibility_raw, fact = 120, na.rm = TRUE) 
access_1dg[access_1dg < 0] <- NA

access_1dg_resamp <- resample(access_1dg, tempmam)
writeRaster(access_1dg_resamp, P("data/access/access_1dg2.tif"), overwrite = TRUE)

accessibility_raw <- log(1+accessibility_raw)


yRDS <- readRDS(P("data_raw/terr_pam_all_1dg_ras.RDS"))
species <- labels(yRDS)
sp_file_nm <- paste(P("data/mammals_1dg_world"), species, sep = "/")
writeRaster(yRDS, sp_file_nm, format = "GTiff", bylayer = TRUE)




