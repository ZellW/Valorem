if(!require(easypackages)){install.packages("easypackages")}
library(easypackages)
packages("plyr","dplyr","ggplot2", "readr", "tidyr", "gridExtra", "readxl", "stringr", "lubridate", 
         "xda", "magrittr", "funModeling",   prompt = TRUE)
setwd("~/Github/Valorem/ClientProjects/MS_O365")
options(scipen = 999)#Do not display exponents

SSATver2 <- read_csv("C:/Users/cweaver/OneDrive - Valorem LLC/Projects/MS-O365/sharedData/SSATDeclineTicketDataJuly2017.csv", col_names = FALSE)

names(SSATver2) <- c("RequestId", "CreateDateTime", "AcknowledgeDateTime", "PartnerId", "SupportAreaName", "IsResolved", "Rating", 
                     "Modality", "RoleIds", "ProgramId", "SkillIds", "ContactOutcome", "Resolution", "Verified", "AgentRating")

SSATver2 <- SSATver2 %>% mutate(isDAO = ifelse(grepl("196608", SSATver2$SkillIds), 1, 0))
table(SSATver2$isDAO)
