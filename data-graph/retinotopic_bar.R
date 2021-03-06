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

data.summary <- summarySEwithin(data=alldata, measurevar="wRT", withinvars=c("TRIAL_TYPE","PROBE_DELAY"))
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
ggplot(data.summary, aes(fill=TRIAL_TYPE, y=wRT, x=PROBE_DELAY)) +
  geom_bar(position="dodge", stat="identity",colour="black") + #coord_cartesian(ylim = c(250, 450)) +
  geom_errorbar(position = position_dodge(0.85),aes(ymax = (wRT + se), ymin = (wRT - se)), width=0.25) +
  my.theme + labs(y=paste('RT ',modifier,'Difference (ms)',sep=""), x='Probe Delay (MS after saccade completion)') + 
  ggtitle(paste("  Attentional Facilitation by Probe Location (N=",N,")",sep="")) + 
  #scale_fill_manual(values=c("firebrick2","dodgerblue2","chartreuse3")) +
  #geom_hline(yintercept = 10) +
#   facet_wrap(~ RULES) +
  theme(legend.position = "right") 







