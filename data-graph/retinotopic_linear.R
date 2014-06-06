############################################ SETUP R ENVIRONMENT

#make sure we have access to some required packages
if (!require('ggplot2'))install.packages("ggplot2", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('plyr'))install.packages("plyr", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('psych'))install.packages("psych", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)

########################################### LOAD AND PROCESS DATA
#set working directory
setwd("/Users/michaelwalton/workspace/data-analysis/data-graph")

#load in some special functions
source("helper_functions.R")

#set working directory
setwd("/Users/michaelwalton/workspace/retinotopic-remapping/Rules")

#read in data file directly while creating this graph script
alldata<-read.csv(file="data_output.csv",header=TRUE,sep=",")

#create a winsorized version of the RT variable
#alldata$wRT<-winsor(alldata$RT,.05) ; modifier = "Winsorized " 
alldata$wRT<-alldata$RT; modifier = " " #easier to test DataGraph app without winsorization

#keep only accurate trials
alldata<-subset(alldata,ACCURACY=="CORRECT")

########################################### SUMMARIZE DATA

data.summary <- summarySEwithin(data=alldata, measurevar="wRT", withinvars=c("TRIAL_TYPE","PROBE_DELAY", "RULES"))
l = dim(data.summary)[1]
c = rep(410,l)
data.summary$wRT = c - data.summary$wRT
########################################### CREATE GRAPH

#some settings to make a pretty graph (not really required)
my.theme<-theme_classic() + theme(axis.title.x = element_text(size=18), axis.title.y = element_text(size=18), 
                                  axis.text.x = element_text(size=16), axis.text.y = element_text(size=16), 
                                  plot.title=element_text(size=20,face="bold"),legend.title=element_text(size=14), 
                                  legend.text=element_text(size=14))

#draw graph using ggplot.
#http://docs.ggplot2.org/current/

N <- dim(alldata)[1]

ggplot(data.summary, aes(ymax = (wRT + se), ymin = (wRT - se),group=TRIAL_TYPE, colour=TRIAL_TYPE, y=wRT, x=PROBE_DELAY)) +
  geom_errorbar(aes(ymax = (wRT + se), ymin = (wRT - se)), width=0.25, position=position_dodge(.1)) +
  geom_line(position=position_dodge(.1)) +
  geom_point(position=position_dodge(.1)) +
  my.theme + labs(y=paste('RT ',modifier,'Difference (ms)',sep=""), x='Probe Delay (MS after saccade completion)') + 
  ggtitle(paste("  Attentional Facilitation by Probe Location (N=",N,")",sep="")) +
  theme(legend.position = "right")








