################Zonation_GVP
###########Sam Maher
#####EcoHealth Alliance

#Load Packages
library(tidyverse)
library(tidyr)
library(stringr)
library(devtools)
library(repmis)
library(raster)
library(rprojroot)
library(dplyr)
library(RColorBrewer)
library(rasterVis)  # raster visualisation
library(magrittr)



#Set working directory
P <- rprojroot::find_rstudio_root_file

#Load species curves, top 5% files
W_nCAZ_curve <- read.csv(P("zproject/world2/CAZno/outputs/CAZno.curve.csv"))
#W_nABF_curve <- read.csv(P(""))
W_logCAZ_curve <- read.csv(P("zproject/world2/CAZlog/outputs/CAZlog.curve.csv"))
#W_logABF_curve <- read.csv(P(""))

#names <- as.character(seq(from =1, to = 5283, by =1))

#W_nCAZ_curve %<>%
#  as.character() %>%
#  separate(data = W_nCAZ_curve, col = 1, into = names, sep = " ", remove = TRUE, 
#           convert = TRUE, extra = "warn", sep = "warn")

sitenum <- 18216

#CAZno
curves1 <- W_nCAZ_curve[,8:5280]
prop1 <- W_nCAZ_curve[,1]

curves1[curves1 > 0] <- 1
curves1[curves1 <= 0] <- 0
sums1 <- rowSums(curves1)
species1 <- cbind(prop1, sums1)
species1 <- as.data.frame(species1)
names(species1)[1]<-"proportion"
species1$proportion <- species1$proportion *100
species1$proportion <- 100-species1$proportion
species1$sums <- species1$sums/5280*100
#species %>% map_df(rev)
plot(species1$sums ~ species1$proportion,
     col = "white",
     xlim = c(0,5),
     ylim = c(0, 100),
     xlab = "Percent of Planet Sampled",
     ylab = "Number of Species Sampled"
)
lines(species1$sums ~ species1$proportion, col = "blue", lwd = 2)

#CAZlog
curves2 <- W_logCAZ_curve[,8:5280]
prop2 <- W_nCAZ_curve[,1]

curves2[curves2 > 0] <- 1
curves2[curves2 <= 0] <- 0
sums2 <- rowSums(curves2)
species2 <- cbind(prop2, sums2)
species2 <- as.data.frame(species2)
names(species2)[1]<-"proportion"
species2$proportion <- species2$proportion * 100
species2$proportion <- 100-species2$proportion
species2$sums <- species2$sums/5280*100
#species %>% map_df(rev)
threshold <- rep(71, 1000)
meh <- seq(from = 0.1, to = 100, by = .1)
lines(species2$sums ~ species2$proportion, col = "red", lwd = 2)
lines(threshold ~ meh, col = "dark grey", lty = 6, lwd =2)


ggplot(data = species, aes (x = proportion, y = sums)) +
    geom_path()
