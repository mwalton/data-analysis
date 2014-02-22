############################################ SETUP R ENVIRONMENT

#make sure we have access to some required packages
if (!require('ggplot2'))install.packages("ggplot2", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('plyr'))install.packages("plyr", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)
if (!require('psych'))install.packages("psych", repos="http://cran.stat.ucla.edu/", dependencies = TRUE)

########################################### LOAD AND PROCESS DATA

#set working directory
setwd("<RSCRIPTPATH>")

#read in data file directly while creating this graph script
#alldata<-read.csv(file="demo_data.csv",header=TRUE,sep=",")
#now that this graph script works, allow datagraph app to fill in datafile
alldata<-read.csv(file="<DATAFILE>",header=TRUE,sep=",")

#create a winsorized version of the RT variable
#alldata$wRT<-winsor(alldata$RT,.05) 
alldata$wRT<-alldata$RT #easier to test DataGraph app without winsorization

########################################### SUMMARIZE DATA

#use the plyr package to summarize data
data.summary <- ddply(alldata, c("GENDER","PREPARATION","TEST","ACCURACY"), summarise, meanRT=mean(wRT))


########################################### CREATE GRAPH

#some settings to make a pretty graph (not really required)
my.theme<-theme_classic() + theme(axis.title.x = element_text(size=18), axis.title.y = element_text(size=18), 
                                  axis.text.x = element_text(size=16), axis.text.y = element_text(size=16), 
                                  plot.title=element_text(size=20,face="bold"),legend.title=element_text(size=14), 
                                  legend.text=element_text(size=14))

#draw graph using ggplot.
#http://docs.ggplot2.org/current/

N <- dim(alldata)[1]
ggplot(data.summary, aes(fill=TEST, y=meanRT, x=GENDER)) +
  geom_bar(position="dodge", stat="identity") + coord_cartesian(ylim = c(475, 725)) +
  my.theme + labs(y='Mean Winsorized RT (ms)', x='Gender') + ggtitle(paste("Data From Fake Task (N=",N,")",sep=""))

# ggplot(data.summary, aes(fill=TEST, y=meanRT, x=GENDER)) +
#   geom_bar(position="dodge", stat="identity") + coord_cartesian(ylim = c(475, 725)) +
#   my.theme + labs(y='Mean Winsorized RT (ms)', x='Gender') + facet_wrap(~ ACCURACY)





