
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
library(rprojroot)
library(dplyr)
library(ggmap)
library(stats)
# and their dependencies
#Set project root path function and projection (WGS 84)
P <- rprojroot::find_rstudio_root_file