library(lightgbm)
library(data.table)
library(dplyr)

# Read in the data
train <- data.table::fread(file.choose())
sub <- fread(file.choose(), header = TRUE)
prop <- data.table::fread(file.choose(), header = TRUE)

# Join train and properties
df_train <- train %>% left_join(prop, by = 'parcelid')
rm(train)
x_train <- df_train %>% select(-c(parcelid, logerror, transactiondate, propertyzoningdesc,
                                  propertycountylandusecode))

y_train <- df_train$logerror
rm(df_train)
train_columns <- colnames(x_train)

# Get test and validate groups
set.seed(3828)
xvs = rbinom(nrow(x_train), 1, .05)
x_valid <- x_train[xvs==1,]; y_valid <- y_train[xvs==1]
x_train <- x_train[xvs==0, ]; y_train <- y_train[xvs==0]

# lightgbm params
params <- list(max_bin = 9,
               learning_rate = 0.0021,
               boosting_type = 'gbdt',
               objective = "regression",
               metric = 'mae',
               sub_feature = 0.5,
               bagging_fraction = 0.85,
               bagging_freq = 20,
               num_leaves = 60,
               min_data = 500,
               min_hessian = 0.05)

x_train[] <- lapply(x_train, as.numeric)
x_valid[]<-lapply(x_valid, as.numeric)

dtrain <- lgb.Dataset(as.matrix(x_train), label = y_train)
dvalid <- lgb.Dataset(as.matrix(x_valid), label = y_valid)

valids <- list(test = dvalid)

clf = lightgbm(params = params, dtrain, nrounds = 500, valids, early_stopping_rounds=40) # I used 500 for nrounds

# Join submission with prop
colnames(sub)[1] <- 'parcelid'
df_test <- sub %>% left_join(prop, by = 'parcelid')
x_test <- df_test[train_columns]
rm(df_test)

# Get test set
x_test[]<-lapply(x_test, as.numeric)
dtest <- lgb.Dataset(as.matrix(x_test))

# Predict using 4 digits
p_test <- predict(clf, as.matrix(x_test))
p_test <- round(p_test, digits = 4)
p_test <- format(p_test, scientific = FALSE)
colnames(sub)[1] <- 'ParcelId'

for(i in 2:7){
  sub[, i] <- p_test
}

write.csv(sub,"lgb_starter.csv",row.names = FALSE)
