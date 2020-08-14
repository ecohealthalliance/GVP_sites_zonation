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
library(filesstrings)


#Set working directory to my SSD
setwd("D:/EHA/Zonation_GVP")


####################1 Create list of files of each type that I want to sort out #######################

#R FILES
R_short <- list.files(path = "D:/EHA/recovered", pattern = "\\.R$")
R_long <- paste("D:/EHA/recovered",list.files(path = "recovered", pattern = "\\.R$"), sep = "/") 
new_r <- paste("D:/EHA/Zonation_GVP/R", R_short, sep = "/")
file.move(R_long, new_r)

#TIF FILES
#dir.create("Zonation_GVP/tif")
tif_short <- list.files(path = "D:/EHA/recovered", pattern = "\\.tif$")
tif_long <- paste("D:/EHA/recovered",list.files(path = "D:/EHA/recovered", pattern = "\\.tif$"), sep = "/") 
new_tif <-  paste("D:/EHA/Zonation_GVP/tif", tif_short, sep = "/")
file.move(tif_long, "D:/EHA/Zonation_GVP/tif")

#dat files
#dir.create("Zonation_GVP/tif")
dat_short <- list.files(path = "D:/EHA/recovered", pattern = "\\.dat$")
dat_long <- paste("D:/EHA/recovered",list.files(path = "D:/EHA/recovered", pattern = "\\.dat$"), sep = "/") 
new_dat <-  paste("D:/EHA/Zonation_GVP/dat", dat_short, sep = "/")
file.move(dat_long, "D:/EHA/Zonation_GVP/dat")

#txt files
#dir.create("Zonation_GVP/tif")
txt_short <- list.files(path = "D:/EHA/recovered", pattern = "\\.txt$")
txt_long <- paste("D:/EHA/recovered",list.files(path = "D:/EHA/recovered", pattern = "\\.txt$"), sep = "/") 
new_txt <-  paste("D:/EHA/Zonation_GVP/txt", txt_short, sep = "/")
file.move(txt_long, "D:/EHA/Zonation_GVP/txt")

#bat files
#dir.create("Zonation_GVP/tif")
bat_short <- list.files(path = "D:/EHA/recovered", pattern = "\\.bat$")
bat_long <- paste("D:/EHA/recovered",list.files(path = "D:/EHA/recovered", pattern = "\\.bat$"), sep = "/") 
new_bat <-  paste("D:/EHA/Zonation_GVP/bat", bat_short, sep = "/")
file.move(bat_long, "D:/EHA/Zonation_GVP/bat")

#spp files
#dir.create("Zonation_GVP/tif")
spp_short <- list.files(path = "D:/EHA/recovered", pattern = "\\.spp$")
spp_long <- paste("D:/EHA/recovered",list.files(path = "D:/EHA/recovered", pattern = "\\.spp$"), sep = "/") 
new_spp <-  paste("D:/EHA/Zonation_GVP/spp", spp_short, sep = "/")
file.move(spp_long, "D:/EHA/Zonation_GVP/spp")


###################  SORT OUT HP3 TIF FILES ###################
all_tifs <- list.files("D:/EHA/Zonation_GVP/tif/")

all_tifs %>% filter(sssss) 

boolean <- str_ends(all_tifs, "_1.tif")
names <- as.data.frame(cbind(all_tifs, boolean))
hp3_names <- names %>% filter(str_detect(boolean, "TRUE"))


