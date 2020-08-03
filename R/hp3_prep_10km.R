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
spc <-read.delim(P("zproject/se_asia/asia_log/inputs/features_list.spp"), skip = 1, header= FALSE, sep = "")
hp3_rds <- readRDS(P("data/hp3/filtered_terr_pam_all_1dg_ras_subset_hp3.RDS"))
listnames <- hp3_rds[2]

#List of raster files I have

specieslist <- list.files(P("data/mammal_10km_world"))
specieslsit <- as.character(specieslist)
raslist <- str_remove(specieslist, "_2018-10-04.tif")
#rasspecies <- as.data.frame(raslist)

hp3zoo <- read.csv(P("data/hp3/hp3_vir_predictions.csv"))
hp3vir <- read.csv(P("data/hp3/hp3_zoo_predictions.csv"))

#select just those species from the Hp3 list
hp3 <- hp3zoo %>% arrange(species)

#Figure out which species are in both the raster files and hp3 files
newhp3 <- hp3[hp3$species %in% raslist ,]
filhp3 <- as.character(newhp3[,1])
raslist <- as.data.frame(raslist)
matchingnames <- raslist[raslist[,1] %in% filhp3,]
hp3final<- hp3[hp3$species %in% matchingnames ,]
hp3final %<>% mutate(ceiling = ceiling(pred_mean))

#create a new directory with raster files for the matching mammals
oldrasnames <- paste(P("data/mammal_10km_world"), paste(matchingnames, "_2018-10-04.tif", sep = ""), sep = "/")
newrasnames <- paste(P("data/hp3_mammals_10km"), paste(matchingnames, ".tif", sep = ""), sep = "/")
file.copy(from=oldrasnames, to=newrasnames, 
          overwrite = TRUE, recursive = FALSE, 
          copy.mode = TRUE)

###DO IT FOR HP3 ZOONOTICS

#####Create .spp file
alpha <- rep(2, 5295)
bqp <- rep (1, 5295)
bqp_p <- rep(1, 5295)
cellrem <- rep(.25, 5295)
create_spp(filename = P("zproject/templates/hp3_10km"), weight = hp3final$ceiling, alpha = alpha, bqp =bqp,
           bqp_p = bqp_p, cellrem = cellrem, spp_file_dir = P("data/hp3_mammals_10km"), recursive = FALSE, 
           spp_file_pattern = ".tif",
           override_path = NULL)




mistake <- read.delim(P("zproject/PREDICT/chmong/inputs/features_list.txt"))
correct <- read.delim(P("zproject/PREDICT/chmong1/inputs/features_list.txt"))
