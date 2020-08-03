#Load Packages
library(tidyverse)
library(stringr)
library(devtools)
library(repmis)
library(rgdal)
library(raster)
library(rprojroot)
library(dplyr)
library(GADMTools)
# raster visualisation
#library(maptools)
library(rgeos)
library(classInt)
library(viridis)
#library(maps)
# and their depend

#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file

# china, egypt, malaysia, india, indonesia, ivory coast, jordan, rep. of congo, south sudan, thailand
chn <- getData("GADM", country = "CHN", level = 0) 
tha <- getData("GADM", country = "THA", level = 0)
mys <- getData("GADM", country = "MYS", level = 0)
egy <- getData("GADM", country = "EGY", level = 0)
idn <- getData("GADM", country = "IDN", level = 0)
ind <- getData("GADM", country = "IND", level = 0)
civ <- getData("GADM", country = "CIV", level = 0)
jor <- getData("GADM", country = "JOR", level = 0)
cog <- getData("GADM", country = "COG", level = 0)
ssd <- getData("GADM", country = "SSD", level = 0)
bgd <- getData("GADM", country = "BGD", level = 0)
lbr <- getData("GADM", country = "LBR", level = 0)  

#load access layer to mask
access_10km <- raster(P("data/access/access_10km.tif"))

#MASK OUT URBAN AREAS
urban_mask <- function(country, template){
  mask <- mask(x = template, mask = country, updatevalue = 0)
  mask[mask <= 5] <- 0
  mask[mask > 5] <- 1
  return(mask)
  #filename <- paste(P("data/predict_masks"), paste(country, ".tif", sep = ""), sep = "/")
  #writeRaster(mask, filename)
}

#create country masls
writeRaster(urban_mask(chn, access_10km), P("data/predict_masks/chn.tif"))
writeRaster(urban_mask(tha, access_10km), P("data/predict_masks/tha.tif"))
writeRaster(urban_mask(mys, access_10km), P("data/predict_masks/mys.tif"))
writeRaster(urban_mask(egy, access_10km), P("data/predict_masks/egy.tif"))
writeRaster(urban_mask(idn, access_10km), P("data/predict_masks/idn.tif"))
writeRaster(urban_mask(ind, access_10km), P("data/predict_masks/ind.tif"))
writeRaster(urban_mask(civ, access_10km), P("data/predict_masks/civ.tif"))
writeRaster(urban_mask(jor, access_10km), P("data/predict_masks/jor.tif"))
writeRaster(urban_mask(cog, access_10km), P("data/predict_masks/cog.tif"))
writeRaster(urban_mask(ssd, access_10km), P("data/predict_masks/ssd.tif"))
writeRaster(urban_mask(bgd, access_10km), P("data/predict_masks/bgd.tif"))
writeRaster(urban_mask(lbr, access_10km), P("data/predict_masks/lbr.tif"))
