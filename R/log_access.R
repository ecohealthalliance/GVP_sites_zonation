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

#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file


###Take log of accessibility
access_10km <- raster(P("data/access/access_10km.tif"))

access_10km[access_10km < 0] <- NA
access_log_10km <- log(1+access_10km)

writeRaster(access_log_10km, P('data/access/access_log_10km.tif'), format = 'GTiff')

access_log_10km <- raster(P('data/access/access_log_10km.tif'))
 plot(access_log_10km)
 plot(access_10km)
 
#ACCESS at 1 DG processing
tempmam <- raster(P("data/mammals_1dg_world/Abditomys_latidens.tif")) 
access_1dg <- raster(P("data/access/access_1dg460.tif"))

access_1dg[access_1dg < 0] <- NA
access_1dg <- log(1+access_1dg)
writeRaster(access_1dg, P("data/access/logaccess_1dg.tif"))



access_1dg[is.na(access_1dg[])] <- 0 
access_1dg2 <- projectRaster(access_1dg, template)
writeRaster(access_1dg2, P("data/access/access_1dg.tif"))
 
template <- projectExtent(tempmam, "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")



###Mammal Files
mammals_10km <- stack(paste(P("data/mammal_10km_world"), 
                        list.files(P("data/mammal_10km_world")), sep = "/"))

access_1dg <- raster(P("data_raw/access/world_accessibility_1dg.tif"))
access_1dg[access_1dg < 0] <- NA
access_1dg <- log(1+access_1dg)
writeRaster(access_1dg, P("data_raw/access/logaccess_1dg.tif"))


##Reload original accessibility file, resmaple with mammal files so that the edges don't have that 9999 value
accessibility_raw <- raster(P("data_raw/access/accessibility_to_cities_2015_v1.0.tif"))
template <- raster(P("data/mammals_1dg_world/Abrothrix_illutea.tif"))
accessibility_raw 




#create thailand mask
THA <-readRDS(P("data/location/gadm36_THA_0_sp.rds"))
mask <- mask(x = access_10km, mask = THA, updatevalue = 0)
mask[mask < 0] <- 1
mask[mask > 0] <- 1
plot(mask)
writeRaster(mask, P('data/location/mask_thai_10km'), format = 'GTiff')


thai_access <- mask(x = access_10km, mask = THA)
writeRaster(thai_access, P('data/location/thai_access_10km'), format = 'GTiff')

thai_names <- read.csv(P("zproject/post_thai/thai_names.csv"), 
                       header = FALSE, 
                       row.names = NULL)

thai_names2 <- as.character(thai_names[,1])
thai_mammal_raster <- stack(thai_names2)


short_names <- read.csv(P("zproject/post_thai/286_names.csv"), 
                       header = FALSE, 
                       row.names = NULL)

short_names2 <- as.character(short_names[,1])

writeRaster(x = thai_mammal_raster, filename =  paste(P('data/mammals_10km_thai'), 
                                      short_names2, sep = "/" ), format = 'GTiff', bylayer = TRUE)
