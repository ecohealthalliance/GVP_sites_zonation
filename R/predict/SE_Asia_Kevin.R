#Load Packages
library(tidyverse)
library(stringr)
library(devtools)
library(repmis)
library(rgdal)
library(raster)
library(rprojroot)
library(dplyr)
# raster visualisation
#library(maptools)
library(rgeos)
library(classInt)
library(viridis)
#library(maps)
# and their depend

#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file

sing <- getData("GADM", country = "SGP", level = 0) 
tha <- getData("GADM", country = "THA", level = 0)
mys <- getData("GADM", country = "MYS", level = 0)##download jordan shapefile
seasia <- union(tha, sing)
asia<- union(seasia, mys)
plot(asia)
write_rds(asia, P("data/location/asiakevin.rds"))
asia <- readRDS(P("data/location/asiakevin.rds"))

access_log_10km <- raster(P("data/access/access_log_10km.tif")) #log version of carlos file

#create thailand mask
mask <- mask(x = access_log_10km, mask = asia, updatevalue = 0)
mask[mask <= 0] <- 0
mask[mask > 0] <- 1
plot(mask)

writeRaster(mask, P('data/location/mask_asia_10km'), format = 'GTiff')

#POST PROCESSING
thai_protected <- readRDS(P("data/location/asiakevin.RDS"))


### PREDICT MASK 
chmong <- readOGR(P("visualization/GVP_gis/PREDCIT2/southasia/chinamong.shp"))
SEasia <- readOGR(P("visualization/GVP_gis/PREDCIT2/southasia/SEasia.shp"))
southasia <- readOGR(P("visualization/GVP_gis/PREDCIT2/southasia/southasia.shp"))

allasia <- readOGR(P("visualization/GVP_gis/PREDCIT2/allasia.shp"))

africa <- readOGR(P("visualization/GVP_gis/PREDCIT2/gadmafrica/africamerge.shp"))

access_log_10km <- raster(P("data/access/access_log_10km.tif")) #log version of carlos file
access_10km <- raster(P("data/access/access_10km.tif"))

mask_chmong <- mask(x = access_log_10km, mask = chmong, updatevalue = 0)
mask_chmong[mask_chmong <= 0] <- 0
mask_chmong[mask_chmong] <- 1
plot(mask_chmong)
writeRaster(mask_chmong, P('data/location/mask_chmong'), format = 'GTiff')

mask_SEasia <- mask(x = access_log_10km, mask = SEasia, updatevalue = 0)
mask_SEasia[mask_SEasia <= 0] <- 0
mask_SEasia[mask_SEasia] <- 1
plot(mask_SEasia)
writeRaster(mask_SEasia, P('data/location/mask_SEasia'), format = 'GTiff')

mask_southasia <- mask(x = access_log_10km, mask = southasia, updatevalue = 0)
mask_southasia[mask_southasia <= 0] <- 0
mask_southasia[mask_southasia] <- 1
plot(mask_southasia)
writeRaster(mask_southasia, P('data/location/mask_southasia'), format = 'GTiff')

urban_mask <- function(country, template){
  mask <- mask(x = template, mask = country, updatevalue = 0)
  mask[mask <= 5] <- 0
  mask[mask > 5] <- 1
  return(mask)
}


mask_chmong <- urban_mask(chmong, access_10km)
plot(mask_chmong)
writeRaster(mask_chmong, P('data/location/mask_chmong'), format = 'GTiff', overwrite = TRUE)

mask_SEasia <- urban_mask(SEasia, access_10km)
plot(mask_SEasia)
writeRaster(mask_SEasia, P('data/location/mask_SEasia'), format = 'GTiff', overwrite = TRUE)

mask_southasia <- urban_mask(southasia, access_10km)
plot(mask_southasia)
writeRaster(mask_southasia, P('data/location/mask_southasia'), format = 'GTiff', overwrite = TRUE)

mask_africa <- urban_mask(africa, access_10km)
plot(mask_africa)
writeRaster(mask_africa, P('data/location/mask_africa'), format = 'GTiff', overwrite = TRUE)

mask_asia <- urban_mask(allasia, access_10km)
plot(mask_asia)
writeRaster(mask_asia, P('data/location/mask_asia'), format = 'GTiff', overwrite = TRUE)



#
#regions for gvp analysis:
#1. South east Asia: Thailand and everything south (indo, malaysia)
#2. South Asia: including India & Myanmar

#SOUTHEAST ASIA
tha <- getData("GADM", country = "THA", level = 0)
mys <- getData("GADM", country = "MYS", level = 0)
idn <- getData("GADM", country = "IDN", level = 0)
seasia <- union(tha, idn)
asia<- union(seasia, mys)
plot(asia)
write_rds(asia, P("data/location/SEasia.rds"))
asia <- readRDS(P("data/location/SEasia.rds"))

access_log_10km <- raster(P("data/access/access_log_10km.tif")) #log version of carlos file


mask <- mask(x = access_log_10km, mask = asia, updatevalue = 0)
mask[mask <= 0] <- 0
mask[mask > 0] <- 1
plot(mask)
writeRaster(mask, P('data/location/SEasia'), format = 'GTiff')


#SOUTH ASIA
bgd <- getData("GADM", country = "BGD", level = 0)
ind <- getData("GADM", country = "IND", level = 0)
mmr <- getData("GADM", country = "MMR", level = 0)


southasia <- union(bgd, ind)
southasia <- union(southasia, mmr)
plot(southasia)
write_rds(southasia, P("data/location/southasia.rds"))
southasia1 <- readRDS(P("data/location/southasia.rds"))

mask1 <- mask(x = access_log_10km, mask = southasia, updatevalue = 0)
mask1[mask1 <= 0] <- 0
mask1[mask1 > 0] <- 1
plot(mask1)
writeRaster(mask1, P('data/location/southasia'), format = 'GTiff')




