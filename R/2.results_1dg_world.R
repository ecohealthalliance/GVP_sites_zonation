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


P <- rprojroot::find_rstudio_root_file


#Load Raster Results
#i messed up by not renaming the bat files, so the results outputs are all called "flat2" but they're in the correct folder names
flat <- raster(P("zonation_runs/test/test_1dg_flat/outputs/test_1dg_flat2.CAZ_E.rank.compressed.tif"))
flat_hp3 <- raster(P("zonation_runs/test/test_1dg_flat_hp3/outputs/test_1dg_flat2.CAZ_E.rank.compressed.tif"))
uneven <- raster(P("zonation_runs/test/test_1dg_uneven/outputs/test_1dg_flat2.CAZ_CE.rank.compressed.tif"))
uneven_hp3 <- raster(P("zonation_runs/test/test_1dg_uneven_hp3/outputs/test_1dg_flat2.CAZ_CE.rank.compressed.tif"))
