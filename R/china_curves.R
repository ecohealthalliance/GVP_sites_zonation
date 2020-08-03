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

caznoc1 <-read.delim(P("zproject/china/CAZ_no_urban/outputs/CAZ_no_urban.CAZ_E.curves.txt"), skip = 1, header= FALSE, sep = "")
cazlogc1 <- read.delim(P("zproject/china/CAZ_log_urban/outputs/CAZ_log_urban.CAZ_CE.curves.txt"), skip = 1, header= FALSE, sep = "")
abflogc1 <-read.delim(P("zproject/china/ABF_log_urban/outputs/ABF_log_urban.ABF_CE.curves.txt"), skip = 1, header= FALSE, sep = "")
abfnoc1 <- read.delim(P("/zproject/china/ABF_no_urban/outputs/ABF_no_urban.ABF_E.curves.txt"), skip = 1, header= FALSE, sep = "")

#just for viewing purpsoes
write.csv(cazlogc1, P("data/cazlogc.csv"))
write.csv(caznoc1, P("data/caznoc.csv"))
write.csv(abflogc1, P("data/abflogc.csv"))
write.csv(abfnoc1, P("data/abfnoc.csv"))

#Calculate how many sites there are in the solution
sumcaznoc <- raster(P("zproject/china/CAZ_no_urban/outputs/CAZ_no_urban.CAZ_E.rank.compressed.tif"))
rascaznoc <- raster(P("zproject/china/CAZ_no_urban/outputs/CAZ_no_urban.CAZ_E.rank.compressed.tif"))
sumcaznoc [sumcaznoc  >= 0] <-1
sumcaznoc [sumcaznoc  < 0] <-0
sumcaznoc [is.na(sumcaznoc)==TRUE] <- 0
site1 <- cellStats(sumcaznoc , sum)

sumcazlogc <- raster(P("zproject/china/CAZ_log_urban/outputs/CAZ_log_urban.CAZ_CE.rank.compressed.tif"))
rascazlogc <- raster(P("zproject/china/CAZ_log_urban/outputs/CAZ_log_urban.CAZ_CE.rank.compressed.tif"))
sumcazlogc [sumcazlogc  >= 0] <-1
sumcazlogc [sumcazlogc  < 0] <-0
sumcazlogc [is.na(sumcazlogc)==TRUE] <- 0
site1 <- cellStats(sumcazlogc , sum)

sumabfnoc <- raster(P("zproject/china/ABF_no_urban/outputs/ABF_no_urban.ABF_E.rank.compressed.tif"))
rasabfnoc <- raster(P("zproject/china/ABF_no_urban/outputs/ABF_no_urban.ABF_E.rank.compressed.tif"))
sumabfnoc [sumabfnoc  >= 0] <-1
sumabfnoc [sumabfnoc  < 0] <-0
sumabfnoc [is.na(sumabfnoc)==TRUE] <- 0
site3 <- cellStats(sumabfnoc , sum)

sumabflogc <- raster(P("zproject/china/ABF_log_urban/outputs/ABF_log_urban.ABF_CE.rank.compressed.tif"))
rasabflogc <- raster(P("zproject/china/ABF_log_urban/outputs/ABF_log_urban.ABF_CE.rank.compressed.tif"))
sumabflogc  [sumabflogc   >= 0] <-1
sumabflogc  [sumabflogc   < 0] <-0
sumabflogc  [is.na(sumabflogc)==TRUE] <- 0
site4 <- cellStats(sumabflogc  , sum)


#Data manipulation pipeline
caznoc <- caznoc1 %>%
  select(1,2,8:578) %>%
  mutate(V1 = (100 - V1*100))  
#mutate(.[,4:5285] = if_else(.[,4:5285] > 0, .[,4:5285], 0))
sub <- caznoc[,3:573]
base <- caznoc[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
caznoc <- cbind(base, sub)
names(caznoc)[1:3] <- c("percentsam", "cost", "totspecies") 
caznoc %<>% 
  mutate(cost = 0) %>% 
  mutate(numsites = siteR*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) %>%
  mutate(percentsp = totspecies/571*100)
View(caznoc)
saveRDS(caznoc, P("data/speciescurves/china/caznocost.RDS"))

#Data manipulation pipeline
cazlogc <- cazlogc1 %>%
  select(1,2,8:578) %>%
  mutate(V1 = (100 - V1*100))  
#mutate(.[,4:5285] = if_else(.[,4:5285] > 0, .[,4:5285], 0))
sub <- cazlogc[,3:573]
base <- cazlogc[,1:2]
sub[sub > 0] <- 1
sub[sub <= 0] <- 0
sub <- rowSums(sub, na.rm = TRUE)
cazlogc <- cbind(base, sub)
names(cazlogc)[1:3] <- c("percentsam", "cost", "totspecies") 
cazlogc %<>% 
 # mutate(cost = 0) %>% 
  mutate(numsites = siteR*percentsam/100) %>%
  mutate(numsites = ceiling(numsites)) %>%
mutate(percentsp = totspecies/571*100)
View(cazlogc)
saveRDS(cazlogc, P("data/speciescurves/china/cazlogcost.RDS"))

device.off()
plot(caznoc$totspecies ~ caznoc$percentsam,
     col = "white",
     main = "Species Discovery Curve",
     xlim = c(0,50),
     ylim = c(0, 100),
     xlab = "Number of 10 x 10 km Sampling Sites",
     ylab = "Perecent of Species Sampled"
)
lines(caznoc$percentsp ~ caznoc$numsites, col = "blue", lwd = 3)
grid(10,10)

#lines(cazlogc$percentsp ~ cazlogc$numsites, col = "red", lwd = 3)


