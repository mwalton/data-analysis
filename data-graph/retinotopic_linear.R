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

########## compute R2s
golomb_S = c(8, 21, 21)
golomb_I = c(8, 5, 13)
golomb_R = c(24, 15, 9.5)

epic_S = c(9.804074, 46.113835, 59.938499)
epic_I = c(33.635838, 31.693449, 378.0808)
epic_R = c(78.352804, 59.209275, 43.710729)

R_S = cor(golomb_S,epic_S)
R_I = cor(golomb_I,epic_I)
R_R = cor(golomb_R,epic_R)

Rsq_S = R_S*R_S
Rsq_I = R_I*R_I
Rsq_R = R_R*R_R

rlbl_S <- paste("R^2 == ", round(Rsq_S,4))
rlbl_I <- paste("R^2 == ", round(Rsq_I,4))
rlbl_R <- paste("R^2 == ", round(Rsq_R,4))
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
  annotate("text", x = 3, y = 80, label = rlbl_S, parse=TRUE, colour="blue") +
  annotate("text", x = 3, y = 77, label = rlbl_I, parse=TRUE, colour="darkred") +
  annotate("text", x = 3, y = 74, label = rlbl_R, parse=TRUE, colour="darkgreen") +
  my.theme + labs(y=paste('RT ',modifier,'Difference (ms)',sep=""), x='Probe Delay (MS after saccade completion)') + 
  ggtitle(paste("  Attentional Facilitation by Probe Location (N=",N,")",sep="")) +
  theme(legend.position = "right")

