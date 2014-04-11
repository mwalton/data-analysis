#!/bin/bash

R --no-save --no-restore --slave << "EOF"

############################################ SETUP R ENVIRONMENT

#make sure we have access to some required packages
if (!require('ggplot2'))install.packages("ggplot2", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('plyr'))install.packages("plyr", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('psych'))install.packages("psych", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)

########################################### LOAD AND PROCESS DATA
#set working directory
setwd("/Users/michaelwalton/workspace/data-analysis/data-graph/")

#load in some special functions
source("helper_functions.R")

#set working directory
setwd("/Users/michaelwalton/workspace/endogenous-attn-task/Rules")

#read in data file directly while creating this graph script
alldata<-read.csv(file="/Users/michaelwalton/workspace/endogenous-attn-task/Rules/data_output.csv",header=TRUE,sep=",")

#create a winsorized version of the RT variable
#alldata$wRT<-winsor(alldata$RT,.05) ; modifier = "Winsorized " 
alldata$wRT<-alldata$RT; modifier = " " #easier to test DataGraph app without winsorization

#keep only accurate trials
alldata<-subset(alldata,ACCURACY=="CORRECT")

########################################### SUMMARIZE DATA

#use the plyr package to summarize data
#  without error bars
#data.summary <- ddply(cbind(alldata["STIMCOLOR"],alldata["wRT"],alldata["RULES"]), c("STIMCOLOR","RULES"), summarise, meanRT=mean(wRT))
#  with error bars
data.summary <- summarySEwithin(data=alldata, measurevar="wRT", withinvars=c("CUEVALIDITY","RULES"))

########################################### CREATE GRAPH

#some settings to make a pretty graph (not really required)
my.theme<-theme_classic() + theme(axis.title.x = element_text(size=18), axis.title.y = element_text(size=18), 
                                  axis.text.x = element_text(size=16), axis.text.y = element_text(size=16), 
                                  plot.title=element_text(size=20,face="bold"),legend.title=element_text(size=14), 
                                  legend.text=element_text(size=14))

#draw graph using ggplot.
#http://docs.ggplot2.org/current/

N <- dim(alldata)[1]
ggplot(data.summary, aes(fill=CUEVALIDITY, y=wRT, x=CUEVALIDITY)) +
  geom_bar(position="dodge", stat="identity",colour="black") + #coord_cartesian(ylim = c(250, 450)) +
  geom_errorbar(aes(ymax = (wRT + se), ymin = (wRT - se)), width=0.25) +
  my.theme + labs(y=paste('Mean ',modifier,'RT (ms)',sep=""), x='Position Uncertainty') + 
  ggtitle(paste("Posner Task: RT By Position Uncertainty (N=",N,")",sep="")) + 
  scale_fill_manual(values=c("red","blue","green")) +
  facet_wrap(~ RULES) +
  theme(legend.position = "none") 








ggsave(file = "/Users/michaelwalton/workspace/data-analysis/data-graph/output.pdf",height=8.,width=8.)
