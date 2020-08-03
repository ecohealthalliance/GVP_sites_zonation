#Load Packages
library(tidyverse)
library(tidyr)
library(stringr)
#library(devtools)
#library(repmis)
library(raster)
library(rprojroot)
library(dplyr)
library(RColorBrewer)
library(rasterVis)  # raster visualisation
library(magrittr)


#Set working directory to my SSD
setwd("D:/EHA/Zonation_GVP")


####################1 Create list of files of each type that I want to sort out #######################

#R FILES
R_short <- list.files(path = "recovered", pattern = "\\.R$")
R_long <- paste("D:/EHA/recovered",list.files(path = "recovered", pattern = "\\.R$"), sep = "/") 
new_r <- paste("D:/EHA/Zonation_GVP/R", R_short, sep = "/")
file.move(R_long, new_r)

#TIF FILES
#dir.create("Zonation_GVP/tif")
tif_short <- list.files(path = "recovered", pattern = "\\.tif$")
tif_long <- paste("D:/EHA/recovered",list.files(path = "recovered", pattern = "\\.tif$"), sep = "/") 
new_tif <-  paste("D:/EHA/Zonation_GVP/tif", tif_short, sep = "/")
file.move(tif_long, new_tif)

#dat files
#dir.create("Zonation_GVP/tif")
dat_short <- list.files(path = "recovered", pattern = "\\.dat$")
dat <- paste("D:/EHA/recovered",list.files(path = "recovered", pattern = "\\.dat$"), sep = "/") 
new_dat <-  paste("D:/EHA/Zonation_GVP/tif", dat_short, sep = "/")
file.move(dat_long, new_dat)


#dat, bat, txt


#2  Rewrite path names to new files

#3 sort just by file type to start

#.spp, .dat, .tif, .rds, .R, unknown

#once files are sorted, recreate old data structure in NEW github repos, update .gitignore, re-initiate

#re-install zonation and re-run all the ones we needed for the paper specifically 
