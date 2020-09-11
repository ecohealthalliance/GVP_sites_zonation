terra_test <- readRDS(P("data_big/terr_pam_all_1dg_ras.RDS"))
access_log <- raster(P("data_big/access/access_log_1dg.tif"))
access_log[access_log > 0] <- 1
sites_access <- cellStats(access_log, sum)
ahhhh <- sum(terra_test)
richness <-ahhhh
cellStats(richness, mean)
cellStats(richness, median)
richness[richness>0] <- 1
cellStats(richness, sum)

writeRaster(richness, P("data_big/richness/richness_world_1dg.tif"))
richness_1dg <- raster(("data_big/richness/richness_world_1dg.tif"))


data_av <- richness + access_log
data_av[data_av < 2] <- 0
cellStats(data_av, sum)/2



km_names <- list.files(path = P("data_big/mammals_10km_world"))
km_stack <- stack(paste(P("data_big/mammals_10km_world"), km_names, sep = "/"))
saveRDS(km_stack, P("data_big/mammals_10km_world.RDS"))
km_stack <- readRDS(P("data_big/mammals_10km_world.RDS"))
richness_10km <- sum(km_stack)
writeRaster(richness_10km, P("data_big/richness/richness_world_10km.tif"))


#Make Liberia 10 km species map
library(GADMTools)
library(rgdal)
library(pbapply)
library(rgeos)
lbr <- getData("GADM", country = "LBR", level = 0) 


template <- km_stack[[1]]
template[template] <- 1
liberia_mask <- mask(x = template, mask = lbr, updatevalue = 0)
stack_lbr <- mask(km_stack, lbr, updatevalue = 0, progress = "text")


liberia_mask <- function(country, template){
  mask <- mask(x = template, mask = country, updatevalue = 0)
  return(mask)
  #filename <- paste(P("data/predict_masks"), paste(country, ".tif", sep = ""), sep = "/")
  #writeRaster(mask, filename)
}
#liberia_rich <- mask(x = km_stack, mask = lbr, progress = 'text')
liberia_species <- crop(km_stack, lbr, progress = "text")
liberia_species <- mask()
#liberia_species[liberia_species == NA] <- 0

sum_lbr <- sum(liberia_species, progress = "text")
writeRaster(sum_lbr, P("data_big/richness/liberia_10km.tif"))

            