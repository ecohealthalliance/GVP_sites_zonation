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
library(rgdal)


#Set working directory
P <- rprojroot::find_rstudio_root_file

flatcomp <- raster(P("data/yasharesults/compare/flatcomp.tif"))
flatcomp[flatcomp < 1] <- NA
acccomp <- raster(P("data/yasharesults/compare/acccomp.tif"))

aus <- readOGR(P("visualization/paper_GVP/continents/AusOcean.shp"))
africa <- readOGR(P("visualization/paper_GVP/continents/africa.shp"))
europe <- readOGR(P("visualization/paper_GVP/continents/europe.shp"))
namerica <- readOGR(P("visualization/paper_GVP/continents/Namerica.shp"))
samerica <- readOGR(P("visualization/paper_GVP/continents/Samerica.shp"))
asia <- readOGR(P("visualization/paper_GVP/continents/asia.shp"))


#Australia
ausraster <- rasterize(aus, flatcomp, getCover = TRUE, updatevalue = TRUE)
ausraster[ausraster > 0] <- 1

ausr <- flatcomp + ausraster
ausr[ausr < 2] <- 0
ausr[ausr >= 2] <- 1
cellStats(ausr, sum)
#16
#+1 island missing

#Africa
afraster <- rasterize(africa, flatcomp, getCover = TRUE, updatevalue = TRUE)
afraster[afraster > 0] <- 1

africar <- flatcomp + afraster
africar[africar < 2] <- 0
africar[africar >= 2] <- 1
cellStats(africar, sum)
#49

#Europe
euraster <- rasterize(europe, flatcomp, getCover = TRUE, updatevalue = TRUE)
euraster[euraster > 0] <- 1

europer <- flatcomp + euraster
europer[europer < 2] <- 0
europer[europer >= 2] <- 1
cellStats(europer, sum)
#2

#North America
naraster <- rasterize(namerica, flatcomp, getCover = TRUE, updatevalue = TRUE)
naraster[naraster > 0] <- 1

namericar <- flatcomp + naraster
namericar[namericar < 2] <- 0
namericar[namericar >= 2] <- 1
cellStats(namericar, sum)
#29

#South America
saraster <- rasterize(samerica, flatcomp, getCover = TRUE, updatevalue = TRUE)
saraster[saraster > 0] <- 1

samericar <- flatcomp + saraster
samericar[samericar < 2] <- 0
samericar[samericar >= 2] <- 1
cellStats(samericar, sum)
#54

#Asia
asraster <- rasterize(asia, flatcomp, getCover = TRUE, updatevalue = TRUE)
asraster[asraster > 0] <- 1

asiar <- flatcomp + asraster
asiar[asiar < 2] <- 0
asiar[asiar >= 2] <- 1
cellStats(asiar, sum)
#55
# +2 unfound ones

#205, so missing 3




