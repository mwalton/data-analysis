############################################ SETUP R ENVIRONMENT

#make sure we have access to some required packages
if (!require('ggplot2'))install.packages("ggplot2", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('plyr'))install.packages("plyr", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
#if (!require('psych'))install.packages("psych", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
library(reshape2)
########################################### LOAD AND PROCESS DATA

#set working directory
setwd("/Users/michaelwalton/workspace/data-analysis/matrix-heatmap")
#load in some special functions
source("helper_functions.R")
setwd("/Users/michaelwalton/workspace/endogenous-attn-task/Rules/")

alldata <- read.csv("saliency.csv", header = FALSE, sep=",")

########################################### SUMMARIZE DATA
sal_matrix <- t(data.matrix(alldata))

########################################### CREATE GRAPH
jet.colors <- 
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000", "white"))
colorzjet <- jet.colors(256)

sal_heatmap <- heatmap(sal_matrix, Rowv=NA, Colv=NA, col = colorzjet, scale="none", margins=c(5,5), labRow = NULL, labCol = NULL)
