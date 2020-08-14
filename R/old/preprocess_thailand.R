################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#### This script downloads rasters and processes them to be same extent/resolution (THailand)
####for input into the Zonation program developed by cbig, https://github.com/cbig/zonator

#Load Packages
library(letsR)
library(tidyverse)
library(stringr)
library(devtools)
library(repmis)
library(rgdal)
library(raster)
library(cshapes)
library(rprojroot)
library(GADMTools)

#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file
newproj <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

#Download raw accessibility layer (1km resolution) from amazon account (requires an amazon key)
#OR download manually from https://map.ox.ac.uk/research-project/accessibility_to_cities/
if(!file.exists(P("data/access/accessibility_to_cities_2015_v1.0.tif"))) {
  download.file("https://s3.amazonaws.com/zonation.gvp/accessibility_to_cities_2015_v1.0.tif", 
                destfile = P("data/access/accessibility_to_cities_2015_v1.0.tif"))
}

#Download Extent file (in this case Thailand)
#THA = getData(name  = "GADM", country = "THA", level = 0)
#THA <- gadm.loadCountries(c("THA"), level=0, basefile = "./data")
#THA <- readRDS(P("dataTHA_adm0.RDS"))
THA <-readRDS(P("data/location/gadm36_THA_0_sp.rds"))  #shapefile at country level
THA2 <-readRDS(P("data/location/gadm36_THA_2_sp.rds"))  #shapefile with districts (same extent)
THA_raster_1dg <- raster(THA, crs = newproj) #rasterize 
THA_raster_10km <- resample(THA_raster_1dg, access_10km_rds)
access_10km_testcrop <- crop(access_10km_rds, THA_raster_1dg)
mammals_10km_testcrop <- crop(mammal_10km_rds, THA_raster_1dg)

#Load mammal rasters at 10km and stack them
mammal_10km_names <- paste(P("data/mammal_10km_world"),
                                              list.files(P("data/mammal_10km_world")),
                                              sep = "/")
mammal_10km <- stack(mammal_10km_names)

#Resample accessibility layer so that it is 10km, write it to local drive
raster_template_1km <- raster(P('data/access/accessibility_to_cities_2015_v1.0.tif'))
raster_template_10km <- aggregate(raster_template_1km, fact = 10)
writeRaster(raster_template_10km, P('data/access/access_10km'), overwrite = TRUE, format = "GTiff")
access_10km <- raster_template_10km
write_rds(path = P("data/processed/access_10km.rds"), x = access_10km)

#Crop mammal and accessibiltiy layers by Thailand extent in RDS format
access_10km_rds<-read_rds(P("data/processed/access_10km.rds"))
mammal_10km_rds<-read_rds(P("data/processed/mammal_10km_stack.rds"))
mams_sub_stack_THA <- crop(mammal_10km, THA_raster)
site_cost_raster_THA <- crop(access_10km, THA_raster)

#Write new mammal files onto local drive
mammal_names_thai <- paste(list.files(P("data/mammal_10km_world"), "_thai"))
mammalpath_thai<- paste(P("data/mammal_10km_thai"),
                        thai_names,
                         sep = "/")
writeRaster(mams_sub_stack_THA, mammalnames_thai, format = "GTiff", bylayer = TRUE)

##CHINA MAMMALS
names_china <- read.csv(P("zproject/china/chinatest/outputs/specieslist_china.csv"), header = FALSE)
names_china <- as.data.frame(names_china)
names_china <- as.character(names_china[,1])
names_chinapath <- paste(P("data/mammal_10km_china"), names_china, sep = "/")
View(names_chinapath)

names_chinasource <- paste(P("data/mammal_10km_world"), names_china, sep = "/")
chinamammal_stack <- stack(names_chinasource)

writeRaster(chinamammal_stack, names_chinapath, format = "GTiff", bylayer = TRUE)

