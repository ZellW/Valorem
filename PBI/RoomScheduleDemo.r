library(ggplot2)
library(scales)
library(Redmonder)
library(dplyr)
library(lubridate)

RoomSchedule <- read.csv("./data/RoomSchedule.csv", header=TRUE, stringsAsFactors = FALSE)
str(RoomSchedule)

# RoomNumber is brought in as continuous - finite set of room numbers - do not have 400 rooms
# RoomNumbers on top of each other.  Date showing on scale when only want hours
ggplot(RoomSchedule, aes(x = ScheduledStartTime, y = RoomNumber, color=Department)) + geom_segment(aes(x = ScheduledStartTime, 
                           xend = ScheduledStopTime, yend = RoomNumber), size=5)

dataset <- RoomSchedule#dataset name required for PBI

# Format scheduled date as date
dataset$ScheduledDate <- mdy(dataset$ScheduledDate)

# Limit data to 1 date
dataset <- subset(dataset, ScheduledDate == "2018-01-17")

#Add Scheduled From datetime field
dataset$From <- mdy_hm(dataset$ScheduledStartTime)

#Add Scheduled To datetime field
dataset$To <- mdy_hm(dataset$ScheduledStopTime)

#Treat Room Number as Factor rather than continuous variable
dataset$RoomNumber<-as.factor(dataset$RoomNumber)

#See how it looks now with data transformations and only showing one date
ggplot(dataset,aes(x=From,y=RoomNumber,color=Department)) + geom_segment(aes(x=From,xend=To,yend=RoomNumber),size=5) 
#
#Add scaling to x axis
ggplot(dataset,aes(x=From,y=RoomNumber,color=Department)) + geom_segment(aes(x=From,xend=To,yend=RoomNumber),size=5) +
  scale_x_datetime(breaks=date_breaks("30 min"),labels=date_format("%H:%M"))

#Add formatting to X and Y axis 
ggplot(dataset,aes(x=From,y=RoomNumber,color=Department)) + geom_segment(aes(x=From,xend=To,yend=RoomNumber),size=5) +
  scale_x_datetime(breaks=date_breaks("30 min"),labels=date_format("%H:%M")) +
  theme(axis.text.x = element_text(angle = -70, hjust = 0.1, size=rel(1.5))) +
  scale_y_discrete(limits=rev(levels(dataset$RoomNumber))) + theme(axis.text.y = element_text(size=rel(1.25)))

# Create Title
title<- paste("Room Schedule for " , substr(dataset$ScheduledDate[1],1,10))

#Final plot - Add Title, change labels, use Power BI Colors, format legend
ggplot(dataset,aes(x=From,y=RoomNumber,color=Department)) + geom_segment(aes(x=From,xend=To,yend=RoomNumber),size=5) +
  scale_x_datetime(breaks=date_breaks("30 min"),labels=date_format("%H:%M")) +
  theme(axis.text.x = element_text(angle = -70, hjust = 0.1, size=rel(1.25))) +
  scale_y_discrete(limits=rev(levels(dataset$RoomNumber))) +
  theme(axis.text.y = element_text(size=rel(1.25)))  +
  ggtitle(title) + xlab("Time") + ylab("Room Number") +
  theme(plot.title = element_text(face="bold")) +
  scale_color_manual(values=redmonder.pal(8,"qPBI")) +
  theme(legend.key = element_rect(fill = NA, colour = NA, size = 0.25))  

