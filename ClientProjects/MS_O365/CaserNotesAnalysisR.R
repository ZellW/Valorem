
#if(!require(bayesian_first_aid)){devtools::install_github("rasmusab/bayesian_first_aid")}
if(!require(kableExtra)){devtools::install_github("haozhu233/kableExtra")}
if(!require(easypackages)){install.packages("easypackages")}
library(easypackages)
packages("plyr", "dplyr", "ggplot2", "readr", "gridExtra", "readxl", "tidyr","stringr", "lubridate","knitr", "kableExtra",  prompt = FALSE)

setwd("~/Github/Valorem/ClientProjects/MS_O365")

AllAgents_CI <- read_excel("C:/Users/cweaver/OneDrive - Valorem LLC/Projects/MS-O365/sharedData/CompleteAgentList.xlsx", sheet="ConciergeInsiders")#updated 2/8/18 - 459 records
AllAgents_NCI <- read_excel("C:/Users/cweaver/OneDrive - Valorem LLC/Projects/MS-O365/sharedData/CompleteAgentList.xlsx", sheet="NCI")#updated 2/8/18 - 9973 records
ABData_TicketData <- read_excel("C:/Users/cweaver/OneDrive - Valorem LLC/Projects/MS-O365/sharedData/CaseNotesSearch_AB_Jan08_Feb08_Correction2.xlsx")#2/9/18, adds AfterCallWorkCompleted

AllAgents_CI <- AllAgents_CI %>% mutate(InsiderRole = "CI")
AllAgents_NCI <- AllAgents_NCI %>% mutate(InsiderRole = "NCI")
AllAgents <- rbind(AllAgents_NCI, AllAgents_CI)
AllAgents <- plyr::rename(AllAgents, c("PartnerId" = "AgentID"))#Required only when data gets updated
rm(AllAgents_CI, AllAgents_NCI)
AllAgents$InsiderRole <-as.factor(AllAgents$InsiderRole)

ABData_TicketData$IsResolved <- as.integer(ABData_TicketData$IsResolved)
ABData_TicketData <- ABData_TicketData %>% mutate(IsResolved = ifelse(is.na(IsResolved), -1, IsResolved))
ABData_TicketData$IsResolved <- as.integer(ABData_TicketData$IsResolved)

ABData_TicketData$CSATScore <- as.integer(ABData_TicketData$CSATScore)
ABData_TicketData$TTR <- as.integer(ABData_TicketData$TTR)

ABData_TicketData$ReScenario <- as.factor(ABData_TicketData$ReScenario)
ABData_TicketData$ModalityChannel <- as.factor(ABData_TicketData$ModalityChannel)

ABData_TicketData$CreateDateTime <- ymd_hms(ABData_TicketData$CreateDateTime)
ABData_TicketData <- ABData_TicketData %>% mutate(createDoW = wday(CreateDateTime, label=TRUE))
ABData_TicketData <- ABData_TicketData %>% mutate(createHour = hour(CreateDateTime))

ABData_TicketData$AgentCaseAcceptTime <- ymd_hms(ABData_TicketData$AgentCaseAcceptTime)
ABData_TicketData <- ABData_TicketData %>% mutate(agentAcceptDoW = wday(AgentCaseAcceptTime, label=TRUE))
ABData_TicketData <- ABData_TicketData %>% mutate(agentAcceptHour = hour(AgentCaseAcceptTime))

ABData_TicketData$AgentPhoneContactTime <- ymd_hms(ABData_TicketData$AgentPhoneContactTime)
ABData_TicketData <- ABData_TicketData %>% mutate(agentPhoneDoW = wday(AgentPhoneContactTime, label=TRUE))
ABData_TicketData <- ABData_TicketData %>% mutate(agentPhoneHour = hour(AgentPhoneContactTime))


ABData_TicketData$ResolvedTime <- ymd_hms(ABData_TicketData$ResolvedTime)
ABData_TicketData <- ABData_TicketData %>% mutate(resolvedDoW = wday(ResolvedTime, label=TRUE))
ABData_TicketData <- ABData_TicketData %>% mutate(resolvedHour = hour(ResolvedTime))

ABData_TicketData$AfterCallWorkCompleted <- ymd_hms(ABData_TicketData$AfterCallWorkCompleted)
ABData_TicketData <- ABData_TicketData %>% mutate(completedDoW = wday(AfterCallWorkCompleted, label=TRUE))
ABData_TicketData <- ABData_TicketData %>% mutate(completedHour = hour(AfterCallWorkCompleted))

ABData_TicketData <- ABData_TicketData %>% select(RequestId, OrganizationId, AgentID, 
                                                  CreateDateTime, createDoW, createHour, 
                                                  AgentCaseAcceptTime, agentAcceptDoW, agentAcceptHour, 
                                                  AgentPhoneContactTime, agentPhoneDoW, agentPhoneHour,
                                                  ResolvedTime, resolvedDoW, resolvedHour, 
                                                  AfterCallWorkCompleted, completedDoW, completedHour, 
                                                  everything())

ABData_complete <-left_join(ABData_TicketData, AllAgents, by = "AgentID")
#Using left join rather than inner join to identify any tickets where we are missing an Agent
rm(AllAgents)



