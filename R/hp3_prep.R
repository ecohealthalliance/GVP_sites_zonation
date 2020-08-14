################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#Load Packages
library(tidyverse)
library(tidyr)
library(readr)
library(tibble)
library(stringr)
library(raster)
library(rprojroot)
library(dplyr)
library(RColorBrewer)
library(magrittr)
library(rprojroot)
library(zonator) 

#Set working directory
P <- rprojroot::find_rstudio_root_file


#RDS FILE FROM YASHA
spc <-read.delim(P("zonation_runs/test/test_1dg_flat2/inputs/features_list.spp"), header= FALSE, sep = "")
hp3_rds <- readRDS(P("data_big/filtered_terr_pam_all_1dg_ras_subset_hp3.RDS"))  #i think I can ignore this for now
listnames <- hp3_rds[2]

#List of raster files I have

specieslist <- list.files(P("data_big/mammals_1dg_world"))
specieslist <- as.character(specieslist)
raslist <- str_remove(specieslist, ".tif")
rasspecies <- as.data.frame(raslist)

hp3vir <- read.csv(P("data_small/hp3_vir_predictions.csv"))  #this is all viruses
hp3zoo <- read.csv(P("data_small/hp3_zoo_predictions.csv"))   #this is just zoonotic ones, I think we want to use this oen


#Figure out which species are in both the raster files and hp3 files
hp3 <- hp3zoo
newhp3 <- hp3[hp3$species %in% raslist ,]
filhp3 <- as.character(newhp3[,1])
raslist <- as.data.frame(raslist)
matchingnames <- raslist[raslist[,1] %in% filhp3,]   #this should give 5254 matching names between the two files

#select just those species from the Hp3 list
hp3 <- hp3zoo %>% arrange(species)
hp3final<- hp3[hp3$species %in% matchingnames ,]
hp3final %<>% mutate(spp_weight = ceiling((pred_mean *100)))   ###OK i want to edit this from the original. 
#Originally I used the ceiling but that loses a lot of the variation. What if i multiply it times 100 and then do ceiling
#since the only thing that matters is the relative weight



#create a new directory with raster files for the matching mammals
oldrasnames <- paste(P("data_big/mammals_1dg_world"), paste(matchingnames, ".tif", sep = ""), sep = "/")
newrasnames <- paste(P("data_big/mammals_1dg_hp3"), paste(matchingnames, ".tif", sep = ""), sep = "/")
file.copy(file.path(P("data_big/mammals_1dg_world"), paste(matchingnames, ".tif", sep = "")), newrasnames )


###DO IT FOR HP3 ZOONOTICS

#####Create .spp file
alpha <- rep(2, 5254)   #this doesn't matter unless i unable distribution smoothing, which I haven't
bqp <- rep (1, 5254)  #doesn't matter with CAz  
bqp_p <- rep(1, 5254)  #doesnt matter with CAZ
cellrem <- rep(.25, 5254) #doesn't matter with CAZ
create_spp(filename = P("zonation_runs/templates/hp3.spp"), weight = hp3final$spp_weight, alpha = alpha, bqp =bqp,
           bqp_p = bqp_p, cellrem = cellrem, spp_file_dir = P("data_big/mammals_1dg_hp3"), recursive = FALSE, 
           spp_file_pattern = ".tif",
           override_path = NULL)