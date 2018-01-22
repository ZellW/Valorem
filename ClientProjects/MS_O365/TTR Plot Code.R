

if(!require(easypackages)){install.packages("easypackages")}
library(easypackages)
packages("plyr", "dplyr", "ggplot2", "tidyr", "stringr", "lubridate", "ggpubr", "gridExtra", "readxl", "scales", "modes", prompt = FALSE)

options(scipen = 999)#Avoid exponents in plots

myData <- read_excel("~/Github/Valorem/ClientProjects/MS_O365/data/CaseNotesSearchABHistorical_Dec13.xlsx")

myData2 <- myData %>% mutate(Date = as.Date(CreateDateTime), Hour = hour(CreateDateTime), ReScenario = factor(ReScenario)) %>%
  filter(TTR > 0) %>% drop_na(IsResolved, Roles) %>% mutate(Concierge = str_detect(Roles, "FirstRelease")) %>% 
  mutate(Agent = str_detect(Roles, "Agent")) %>%    
  select(-RequestID, -PartnerId,-CreateDateTime,  -Date, -Hour)
# remove 3 records where Agent = FALSE and Rave2 = FALSE:  table(myData2$Agent)
myData2 <- filter(myData2, Agent == TRUE)
myData2 <- myData2 %>% mutate(NewRole = ifelse(Concierge == TRUE, "Concierge", "Agent"))


p1 <- ggplot(aes(x = TTR), data = myData2) + geom_histogram() + ggtitle("TTR")
p2 <- p1 + scale_x_log10() + ggtitle("log(TTR)")

grid.arrange(p1, p2, ncol=2)

myData2Peak <- myData2 %>% filter(TTR > 650)
myData2Min <- myData2 %>% filter(TTR < 651)

p3 <- ggplot(aes(x = TTR), data = myData2Min) + geom_histogram() + ggtitle("TTR") + scale_x_log10() + ggtitle("log(TTR<650)")
p4 <- ggplot(aes(x = TTR), data = myData2Peak) + geom_histogram() + ggtitle("TTR") + scale_x_log10() + ggtitle("log(TTR<650)")

grid.arrange(p3, p4, ncol=2)


p5 <- ggplot(aes(x = TTR), data = filter(myData2Min, NewRole == "Agent")) + geom_histogram() + scale_x_log10() + ggtitle("Agent - log(TTR<650)")
             
p6 <- ggplot(aes(x = TTR), data = filter(myData2Min, NewRole == "Concierge")) + geom_histogram() + scale_x_log10() + ggtitle("Concierge - log(TTR<650)")

p7 <- ggplot(aes(x = TTR), data = filter(myData2Peak, NewRole == "Agent")) + geom_histogram() + scale_x_log10() + ggtitle("Agent - log(TTR>650)")

p8 <- ggplot(aes(x = TTR), data = filter(myData2Peak, NewRole == "Concierge")) + geom_histogram() + scale_x_log10() + ggtitle("Concierge - log(TTR>650)")

grid.arrange(p5, p6, p7, p8, ncol=2)
