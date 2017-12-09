
if(!require(easypackages)){install.packages("easypackages")}
library(easypackages)
packages("dplyr", "data.table", "xda","ggplot2", "forcats", "readr", prompt = FALSE)

#Get Data
Classes_Services <- read_csv("C:/Users/cweaver/Downloads/Classes_Services.csv", 
                   col_types = cols(AvailablePIF = col_integer(), 
                      ByPerson = col_integer(), CanSeeInstructor = col_integer(), 
                      CancellationHrs = col_integer(), 
                      ClassMins = col_integer(), CustSelfBook = col_integer(), 
                      Disabled = col_integer(), EmailReminders = col_integer(), 
                      HalfHour = col_integer(), MultipleInstructors = col_integer(), 
                      MustHaveCredit = col_integer(), MustPreBook = col_integer(), 
                      NumPerClass = col_integer(), OnTheHour = col_integer(), 
                      QuarterPast = col_integer(), QuarterTill = col_integer(), 
                      RescheduleDeadline = col_integer(), 
                      RuleCustomers = col_integer(), RuleFrontDesk = col_integer(), 
                      SMSReminders = col_integer(), ServicesId = col_integer(), 
                      ShowPublic = col_integer(), StandardPrice = col_integer()), 
                   na = "NA")

myData <- Classes_Services
rm(Classes_Services)

dim(myData)
glimpse(myData)

#Remove NA
myData <- myData %>%  mutate_if(is.integer, funs(replace(., is.na(.), 0)))#changes int to dbl
myData <- myData %>%  mutate_if(is.double, as.integer)#return to int
glimpse(myData)

#Char to factors
myData <- myData %>% mutate_if(is.character, as.factor)
myData_cat <- myData_cat %>% mutate_if(is.character, as.factor)
charSummary(myData)

myData_factor <- myData %>% select_if(is.factor)
myData_num <- myData %>% select_if(is.numeric)

categorical_var <- names(myData_cat)
numeric_var <- names(myData_num)

#Tables for the Factors
for(i in 1:length(myData_factor)){
  print(names(myData_factor[i]))
  print(table(myData_factor[i]))
}

#Plot the factors
for(i in 1:length(myData_factor)){
  print(ggplot(myData_factor, aes_string(names(myData_factor[i]))) + geom_bar())
}

#Evaluate numerical data
myNumSum <- numSummary(myData)[, c(1,7,8,16,17)]
myNumSum <- tibble::rownames_to_column(myNumSum)
names(myNumSum)[5] <- "missPCT"
names(myNumSum)[1] <- "Variable_Name"
myNumSum <- arrange(myNumSum, desc(missPCT))
head(myNumSum, 20)


#Do not include Type
myVariance <- as.data.frame(apply(myData[,-c(1)], 2, var))
myVariance <- tibble::rownames_to_column(myVariance)
names(myVariance)[2] <- "Variance"
myVariance <-  myVariance %>% mutate(Variance2 = ifelse(Variance == 0, "No", "Yes"))
table(myVariance$Variance2)

if(table(myVariance$Variance2)[1] > 0){
  filter(myVariance, Variance2 == "No")
  VarNames <- myVariance %>% filter(Variance > 0) %>% select(rowname)
  myData <- myData %>% select(StoreId, unlist(VarNames))
}

# Duplicate Records
cat("The number of duplicated rows is", nrow(myData) - nrow(unique(myData)))

#http://www.cookbook-r.com/Manipulating_data/Finding_and_removing_duplicate_records/
if(nrow(myData) - nrow(unique(myData)) > 0){
  head(myData[duplicated(myData),])
  myData <- myData[!duplicated(myData),]
}

#Final Output (Initial Data Cleaning)
glimpse(myData)

