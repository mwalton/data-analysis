############################################ SETUP R ENVIRONMENT

#make sure we have access to some required packages
if (!require('ggplot2'))install.packages("ggplot2", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('plyr'))install.packages("plyr", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('reshape2'))install.packages("reshape2", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('RColorBrewer'))install.packages("RColorBrewer", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)

########################################### LOAD AND PROCESS DATA

#set working directory
setwd("/Users/michaelwalton/workspace/data-analysis/matrix-heatmap")
#load in some special functions
source("helper_functions.R")
setwd("/Users/michaelwalton/workspace/exogenous-attn-task/Rules/")

alldata <- read.csv("saliency.csv", header = FALSE, sep=",")

########################################### SUMMARIZE DATA
mat <- t(data.matrix(alldata))
longData <- melt(mat, id="x")

########################################### CREATE GRAPH
myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))

#sal_heatmap <- heatmap(mat, Rowv=NA, Colv=NA, col = colorzjet, scale="none", margins=c(5,5), labRow = NULL, labCol = NULL)

jet.colors <- 
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000", "white"))
colorzjet <- jet.colors(256)

zp1 <- ggplot(longData,
              aes(Var1, Var2, fill = value))
zp1 <- zp1 + scale_fill_gradientn(colours = myPalette(100))
zp1 <- zp1 + geom_tile()
#zp1 <- zp1 + scale_fill_gradientn(colours = myPalette(100))
zp1 <- zp1 + scale_x_discrete(expand = c(0, 0))
zp1 <- zp1 + scale_y_discrete(expand = c(0, 0))
zp1 <- zp1 + coord_equal()
zp1 <- zp1 + theme_bw()
#zp1 <- zp1 + heatmap(mat, Rowv=NA, Colv=NA, col = colorzjet, scale="none", margins=c(5,5), labRow = NULL, labCol = NULL)

print(zp1)
