
if(!require(easypackages)){install.packages("easypackages")}
library(easypackages)
packages("dplyr", "data.table", "xda","ggplot2", "forcats", "readr", prompt = FALSE)

#Get Data
Users <- read_csv("C:/Users/cweaver/Downloads/Users/Users.csv", col_types = cols(StoreId = col_integer()))

myData <- Users
rm(Users)

dim(myData)
glimpse(myData)

#Remove NA
myData <- myData %>%  mutate_if(is.integer, funs(replace(., is.na(.), 0)))#changes int to dbl
myData[,-41] <- myData %>%  mutate_if(is.double, as.integer)#return to int
glimpse(myData)

#Char to factors
myData <- myData %>% mutate_if(is.character, as.factor)
charSummary(myData)

myData_factor <- myData %>% select_if(is.factor)
myData_num <- myData %>% select_if(is.numeric)

factor_var <- names(myData_factor)
numeric_var <- names(myData_num)

#Tables for the Factors
for(i in 1:length(myData_factor)){
  print(names(myData_factor[i]))
  print(table(myData_factor[i]))
}

#Factor - Gender
myData %>% group_by(Gender) %>% summarize(Unique_Values = n()) %>% arrange(desc(Unique_Values))
ggplot(myData, aes(fct_infreq(Gender))) + geom_bar() + xlab(paste("ClubReady Subset - ", names(myData)[1])) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

levels(myData$Gender)[levels(myData$Gender) == "F"] <- "Female"
levels(myData$Gender)[levels(myData$Gender) == "female"] <- "Female"
levels(myData$Gender)[levels(myData$Gender) == "f"] <- "Female"

levels(myData$Gender)[levels(myData$Gender) == "M"] <- "Male"
levels(myData$Gender)[levels(myData$Gender) == "male"] <- "Male"
levels(myData$Gender)[levels(myData$Gender) == "m"] <- "Male"

myData %>% group_by(Gender) %>% summarize(Unique_Values = n()) %>% arrange(desc(Unique_Values))

myData <- filter(myData, Gender == "Female" | Gender == "Male")
myData$Gender <- factor(myData$Gender)

ggplot(myData, aes(fct_infreq(Gender))) + geom_bar() + xlab("ClubReady Subset - Gender") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Factor - UserType
myData %>% group_by(UserType) %>% summarize(Unique_Values = n()) %>% arrange(desc(Unique_Values))
ggplot(myData, aes(fct_infreq(UserType))) + geom_bar() + xlab(paste("ClubReady Subset - ", names(myData)[2])) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

myData <- filter(myData, UserType == 'ClubClient' | UserType == 'DeletedClubClient' | UserType == 'ClubAdmin' | UserType == 'ClubTrainer' | UserType == 'DeletedClubTrainer')
myData$UserType <- factor(myData$UserType)

ggplot(myData, aes(fct_infreq(UserType))) + geom_bar() + xlab("ClubReady Subset - UserType") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Evaluate numerical data - had to take random sample b/c csv too large
myNumSum <- numSummary(sample_frac(myData, .3))[, c(1,7,8,16,17)]
myNumSum <- tibble::rownames_to_column(myNumSum)
names(myNumSum)[5] <- "missPCT"
names(myNumSum)[1] <- "Variable_Name"
myNumSum <- arrange(myNumSum, desc(missPCT))
head(myNumSum, 20)

# Variance
#Do not include UserId, StoreId, Gender, UserType, TotalSpent
myVariance <- as.data.frame(apply(myData[,-c(1,2,4,5,41)], 2, var))
myVariance <- tibble::rownames_to_column(myVariance)
names(myVariance)[2] <- "Variance"
myVariance <-  myVariance %>% mutate(Variance2 = ifelse(Variance == 0, "No", "Yes"))
table(myVariance$Variance2)

if(table(myVariance$Variance2)[1] > 0){
  filter(myVariance, Variance2 == "No")
  VarNames <- myVariance %>% filter(Variance > 0) %>% select(rowname)
  myData <- myData %>% select(StoreId, unlist(VarNames))
}

# Duplication
cat("The number of duplicated rows is", nrow(myData) - nrow(unique(myData)))

#http://www.cookbook-r.com/Manipulating_data/Finding_and_removing_duplicate_records/
if(nrow(myData) - nrow(unique(myData)) > 0){
  head(myData[duplicated(myData),])
  myData <- myData[!duplicated(myData),]
}

glimpse(myData)

