########################################### LOAD AND PROCESS DATA

#set working directory
setwd("/Users/michaelwalton/workspace/ChoiceTask/Rules/")

alldata <- read.csv("saliency.csv", header = FALSE, sep=",")

########################################### SUMMARIZE DATA
sal_matrix <- t(data.matrix(alldata))

########################################### CREATE GRAPH
jet.colors <- 
  colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000", "white"))
colorzjet <- jet.colors(256)

sal_heatmap <- heatmap(sal_matrix, Rowv=NA, Colv=NA, col = colorzjet, scale="none", margins=c(5,5), labRow = NULL, labCol = NULL)