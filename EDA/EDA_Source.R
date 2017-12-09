# Preliminary EDA Pipeline Process:
# Get Data
# Remove/transform NAs of all types
# Character to Factors when appropriate
# Explore factors with tables and plots as appropriate including refactoring
# Explore numerical data (XDA helpful)
# Explore variances and dplyr::select variables as needed
# Outlier Detection
# Manage duplicate records
# Review working dataset (glimpse)

# Determine if variable selection or dimensional reduction is appropriate


########### Missing Data Plots - START ################
#Excellent missing data visualization when many variables
plot_Missing <- function(data_in, title = NULL){
  temp_df <- as.data.frame(ifelse(is.na(data_in), 0, 1))
  temp_df <- temp_df[,order(colSums(temp_df))]
  data_temp <- expand.grid(list(x = 1:nrow(temp_df), y = colnames(temp_df)))
  data_temp$m <- as.vector(as.matrix(temp_df))
  data_temp <- data.frame(x = unlist(data_temp$x), y = unlist(data_temp$y), m = unlist(data_temp$m))
  ggplot(data_temp) + geom_tile(aes(x=x, y=y, fill=factor(m))) + 
    scale_fill_manual(values=c("white", "black"), name="Missing\n(0=Yes, 1=No)") + 
    theme_light() + ylab("") + xlab("") + ggtitle(title)
}

#Ex:  plot_Missing(myData[, colSums(is.na(myData)) > 0])

#Good if not too many variables
library(Amelia)
missmap(myData)

#Good if not too many variables
library(reshape2)
ggplot_missing <- function(x){
  x %>% is.na %>% melt %>% ggplot(data = ., aes(x = Var2, y = Var1)) +
    geom_raster(aes(fill = value)) + scale_fill_grey(name = "", labels = c("Present","Missing")) +
    theme_minimal() + theme(axis.text.x  = element_text(angle=45, vjust=0.5)) + 
    labs(x = "Variables in Dataset", y = "Rows / observations")
}
# Ex"  ggplot_missing(myData)

########### Missing Data Plots - END ################

########### Useful dplyr Code - START ################
mutate_cond <- function(.data, condition, ..., new_init = NA, envir = parent.frame()) {
  # Initialize any new variables as new_init
  new_vars <- substitute(list(...))[-1]
  new_vars %<>% sapply(deparse) %>% names %>% setdiff(names(.data))
  .data[, new_vars] <- new_init
  
  condition <- eval(substitute(condition), .data, envir)
  .data[condition, ] <- .data %>% filter(condition) %>% mutate(...)
  .data
}
# EXAMPLES
# Change Petal.Length to 88 where Species == "setosa". This will work in the original function as well as this new version.
iris %>% mutate_cond(Species == "setosa", Petal.Length = 88)

# Same as above, but also create a new variable x (NA in rows not included in the condition). Not possible before.
iris %>% mutate_cond(Species == "setosa", Petal.Length = 88, x = TRUE)

# Same as above, but rows not included in the condition for x are set to FALSE.
iris %>% mutate_cond(Species == "setosa", Petal.Length = 88, x = TRUE, new_init = FALSE)

# This example shows how new_init can be set to a list to initialize multiple new variables with different values. 
# Here, two new variables are created with excluded rows being initialized using different values (x initialised as FALSE, y as NA)
iris %>% mutate_cond(Species == "setosa" & Sepal.Length < 5, x = TRUE, y = Sepal.Length ^ 2, new_init = list(FALSE, NA))

myData_cat <- myData %>% select_if(is.character)
myData_num <- myData %>% select_if(is.numeric)

stores <- select(stores, !starts_with("show"))#fails - cannot negate starts_with
stores  <-  stores[, !grepl("^show", colnames(stores))]#regex works

deletedVars <- names(stores[grepl("^show", colnames(stores))])
deletedVars <- ldply(deletedVars, data.frame)#convert list to DF - requires plyr (always load plyr before dplyr!)

########### Useful dplyr Code - END ################

# Duplication
cat("The number of duplicated rows is", nrow(myData) - nrow(unique(myData)))
#http://www.cookbook-r.com/Manipulating_data/Finding_and_removing_duplicate_records/
if(nrow(myData) - nrow(unique(myData)) > 0){
  head(myData[duplicated(myData),])
  myData <- myData[!duplicated(myData),]
}

# Outliers

#Plot
ggplot(stores, aes(x = "", y = TotalRevenue)) + geom_boxplot(outlier.color="red", outlier.shape=8, outlier.size=4) + 
  scale_y_continuous(labels = scales::dollar)
#List outliers
tmpRev <- arrange(stores, desc(TotalRevenue)) %>% select(TotalRevenue)
tmpRev <- as.data.frame(head(scales::dollar(tmpRev$TotalRevenue), 25))
names(tmpRev) <- "Total_Revenue"
tmpRev
#Table by quartile
q <- quantile(stores$TotalRevenue)
stores$Qcut <- cut(stores$TotalRevenue, q)
levels(stores$Qcut) <- c("Q1", "Q2", "Q3", "Q4")
summary(stores$Qcut)[1:4]