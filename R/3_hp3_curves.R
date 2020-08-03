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


#Set working directory
P <- rprojroot::find_rstudio_root_file

hp3acct<- read.delim(P("zproject/world3/hp3logmask/outputs/hp3logmask.CAZ_CE.curves.txt"), skip = 1, header= FALSE, sep = "")
hp3flatt <- read.delim(P("zproject/world3/hp3nomask/outputs/hp3nomask.CAZ_E.curves.txt"), skip = 1, header= FALSE, sep = "")

write.csv(hp3acc, P("data/testing/hp3acc.csv"))
write.csv(hp3flat, P("data/testing/hp3flat.csv"))

#calculate how many sites there are in the solution
sumacc <- raster(P("zproject/world3/hp3logmask/outputs/hp3logmask.CAZ_CE.rank.compressed.tif"))
sumflat <- raster(P("zproject/world3/hp3nomask/outputs/hp3nomask.CAZ_E.rank.compressed.tif"))

sumacc[sumacc >= 0] <-1
sumacc[sumacc < 0] <-0
sumacc[is.na(sumacc)==TRUE] <- 0
sitesacc <- cellStats(sumacc, sum) 

sumflat[sumflat >= 0] <-1
sumflat[sumflat < 0] <-0
sumflat[is.na(sumflat)==TRUE] <- 0
sitesflat <- cellStats(sumflat, sum) 

#18177 total sites for both

#Data manipulation pipeline
hp3acc <- hp3acct %>%
  select(1,2,8:5261) %>%
  mutate(V1 = (100 - V1*100))  
#mutate(.[,4:5285] = if_else(.[,4:5285] > 0, .[,4:5285], 0))
sub <- hp3acc[,3:5256]
base <- hp3acc[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
hp3acc <- cbind(base, sub)
names(hp3acc)[1:3] <- c("percentsam", "cost", "totspecies") 
hp3acc %<>% 
  mutate(cost = 0) %>% 
  mutate(numsites = sitesacc*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) #%>%
  #arrange(rev(rownames(.)))
View(hp3acc)
saveRDS(hp3acc, P("data/speciescurves/hp3acc.RDS"))



hp3flat <- hp3flatt %>%
  select(1,2,8:5261) %>%
  mutate(V1 = (100 - V1*100))  
#mutate(.[,4:5285] = if_else(.[,4:5285] > 0, .[,4:5285], 0))
sub <- hp3flat[,3:5256]
base <- hp3flat[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
hp3flat <- cbind(base, sub)
names(hp3flat)[1:3] <- c("percentsam", "cost", "totspecies") 
hp3flat %<>% 
  mutate(cost = 0) %>% 
  mutate(numsites = sitesflat*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) #%>%
  #arrange(rev(rownames(.)))
View(hp3flat)
saveRDS(hp3flat, P("data/speciescurves/hp3flat.RDS"))

astote <- rep(5256, 100)

plot(hp3acc$totspecies ~ hp3acc$percentsam,
     col = "white",
     xlim = c(0,10),
     ylim = c(0, 6000),
     xlab = "% of sites",
     ylab = "Number of Species Sampled"
)
lines(hp3acc$totspecies ~ hp3acc$percentsam, col = "red")
lines(hp3flat$totspecies ~ hp3flat$percentsam, col = "blue")

