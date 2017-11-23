library(RODBC)
library (dplyr)
library(ggplot2)
library(gridExtra)
dbhandle <- odbcDriverConnect('driver={SQL Server};server=VCG-CWEAVER;database=SQLProfile;trusted_connection=true')
resClust <- sqlQuery(dbhandle, 'SELECT te.name as EventClassName
                ,[EventClass]
                ,[Duration]
                ,[EndTime]
                ,[TextData]
                ,[CPU]
                ,[Reads]
                ,[SPID]
                ,[StartTime]
                ,[Writes]
                FROM [SQLProfile].[dbo].[FTDB_Baseline_Clustered_YTD_11-8] as ftdb
                left join sys.trace_events as te
                on ftdb.EventClass = te.trace_event_id')

resNonClust <- sqlQuery(dbhandle, 'SELECT te.name as EventClassName
                ,[EventClass]
                     ,[Duration]
                     ,[EndTime]
                     ,[TextData]
                     ,[CPU]
                     ,[Reads]
                     ,[SPID]
                     ,[StartTime]
                     ,[Writes]
                     FROM [SQLProfile].[dbo].[FTDB_Baseline_Nonclustered_YTD_11-8] as ftdb
                     left join sys.trace_events as te
                     on ftdb.EventClass = te.trace_event_id')


#First record is all NA so remove
resClust <- resClust[3:nrow(resClust),]
resNonClust <- resNonClust[3:nrow(resNonClust),]

recordCountClust <- nrow(resClust)
recordCountNonClust <- nrow(resNonClust)

#Calc run duration
runtimeClust <- resClust$StartTime[recordCountClust] - resClust$StartTime[1]
runtimeNonClust <- resNonClust$StartTime[recordCountNonClust] - resNonClust$StartTime[1]

eventNameClust <- group_by(resClust, EventClassName)
eventNameNonClust <- group_by(resNonClust, EventClassName)

clustData <- summarize(eventNameClust, UniqueDesc = n(),  UniqueSPID = n_distinct(SPID), Duration = sum(as.numeric(Duration)))
NonClustData <- summarize(eventNameNonClust, UniqueDesc = n(),  UniqueSPID = n_distinct(SPID), Duration = sum(as.numeric(Duration)))

#Prep for plotting
clustData$IndexType <- "Clustered"
NonClustData$IndexType <- "NonClustered"

allData <- rbind(clustData, NonClustData)
eventclassnames <-  as.character(unique(allData$EventClassName))
#Remove the eventnames that are not too interesting (not high values)
# SP:StmtStarting (3), Data File Auto Grow (6), 
exclude <- c(eventclassnames[3], eventclassnames[6])
allData <- subset(allData, !EventClassName %in% exclude)
allData[is.na(allData)] <- 0
allData$EventClassName <- gsub(":", "_", allData$EventClassName)
allData

pScans <- ggplot(data=filter(allData, EventClassName=="Scan_Started"), aes(x=IndexType, y=UniqueDesc, fill=IndexType)) + 
  geom_bar(stat = "identity") + labs(title="Compare Scan Started Counts", y = "Scans Started")
  
pSQL_StmtCompleted <- ggplot(data=filter(allData, EventClassName=="SQL_StmtCompleted"), aes(x=IndexType, y=UniqueDesc, fill=IndexType)) + 
  geom_bar(stat = "identity") + labs(title="Compare SQL_StmtCompleted Counts", y = "SQL_StmtCompleted")

pSQL_StmtStarting <- ggplot(data=filter(allData, EventClassName=="SQL_StmtStarting"), aes(x=IndexType, y=UniqueDesc, fill=IndexType)) + 
  geom_bar(stat = "identity") + labs(title="Compare SQL_StmtStarting Counts", y = "SQL_StmtStarting")

pSP_StmtCompleted <- ggplot(data=filter(allData, EventClassName=="SP_StmtCompleted"), aes(x=IndexType, y=UniqueDesc, fill=IndexType)) + 
  geom_bar(stat = "identity") + labs(title="Compare SP_StmtCompleted Counts", y = "SP_StmtCompleted")

grid.arrange(pScans, pSP_StmtCompleted, pSQL_StmtStarting,pSQL_StmtCompleted)

#####Aside Start####
sum(as.numeric(resClust[,3]), na.rm=TRUE)
#colSums does not work with one-dimensional objects like vectors
#specify drop = FALSE, a one-column data frame is returned rather than a vector
colSums(resClust[,3, drop = FALSE], na.rm=TRUE)
#####Aside End#####

write.csv(res, "FTDB_Baseline_Clustered_YTD_11-8.csv", col.names = TRUE)
#write.csv(myData, "ProfileBaselineTotalData.csv")
write.csv(myData, "ProfileClusterIHGUIDTotalData.csv")


################################################################################################################

####Original Work - Could Not Repro Locks########
#Filter with ClassID that are not lock related
removeClassID <- c(40, 41, 44, 45, 65529, 65528, 65534, 148)
resSubset <- filter(res, !(EventClass %in% removeClassID))

recordCountLocks <- nrow(resSubset)
eventName2 <- group_by(resSubset, EventClassName)
myLocks1 <- summarize(eventName2, UniqueDesc = n(),  UniqueSPID = n_distinct(SPID))
#write.csv(myLocks1, "ProfileBaselineSubSetData.csv")
write.csv(myLocks1, "ProfileClusterIDGUIDSubSetData.csv")

myLocks2 <- summarize(resSubset, UniqueLockDesc = n_distinct(EventClassName),  UniqueSPID = n_distinct(SPID), LockCountRecords=n())

