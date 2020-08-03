################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#####This Script sets up zonation .spp files, .dat files, and calls zonation to run
#####NOTE: the zonation .exe file (or whatever you call in a mac) must be in the master folder

#Load Packages
library(zonator) 
library(letsR)
library(tidyverse)
library(stringr)
library(raster)
library(cshapes)
library(rprojroot)
library(rgdal)

#####Make sure Zonation is in right folder
check_zonation(exe = "zig4")

#####Set project path
P <- rprojroot::find_rstudio_root_file

#####Create biological features file directory for .spp file
spp_directory <- paste(P("data/mammal_processed_1dg_world"), 
                       list.files(P("data/mammal_processed_1dgworld")), sep = "/")

#####Cheack names to make sure they're unique
check_names(spp_directory)

#####Create .spp file
create_spp(filename = P("zproject/template_cost_CAZ"), weight = 1, alpha = 1, bqp = 1,
           bqp_p = 1, cellrem = 0.25, spp_file_dir = P("data/mammal_processed_1dg_world/"), recursive = FALSE, 
           spp_file_pattern = ".tif",
           override_path = NULL)

create_spp(filename = P("zproject/template_nocost_CAZ"), weight = 1, alpha = 1, bqp = 1,
           bqp_p = 1, cellrem = 0.25, spp_directory, recursive = FALSE,
          override_path = NULL)

create_spp(filename = P("zproject/template_cost_ABF"), weight = 1, alpha = 1, bqp = 1,
           bqp_p = 1, cellrem = 0.25, spp_file_dir = P("data/mammal_processed_1dg_world/"), recursive = FALSE, 
           spp_file_pattern = ".tif",
           override_path = NULL)

create_spp(filename = P("zproject/template_nocost_ABF"), weight = 1, alpha = 1, bqp = 1,
           bqp_p = 1, cellrem = 0.25, spp_directory, recursive = FALSE,
           override_path = NULL)

####Write dat file
####There might be an issue with spacing (might have to add line between )
datcost <- list("Settings" = list("removal_rule" = 1, "warp factor" = 10, "edge_removal" = 1, "use cost" = 1,
                              "cost file" = P("data/accessibility/world_accessibility_1dg.tif")))
write_dat(datcost, P("zproject/template_cost"), overwrite = TRUE)

datnocost <- list("Settings" = list("removal_rule" = 1, "warp factor" = 10, "edge_removal" = 1))
write_dat(dat, P("zproject/template_nocost"), overwrite = TRUE)

#Create ZOnation project
variant_names <- c("withcost_CAZ", "justmammals_CAZ")
create_zproject(name = "test_R", dir = P("zproject"), 
                variants = variant_names, 
                dat_template_file = c(P("zproject/template_cost"), P("zproject/template_cost")),
                spp_template_file=  c(P("zproject/template_cost"), P("zproject/template_nocost")),
                overwrite = TRUE)




setup.dir <- system.file(P("zproject/1dg_withcost_world/inputs"))

# Get all the bat-files
bat.files <- list.files(setup.dir, "\\.bat$", full.names = TRUE)

