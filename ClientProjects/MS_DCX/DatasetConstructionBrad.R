##Install Packages

options(warn=-1)
install.packages("easypackages")
library("easypackages")
packages("readr", "dplyr", "stringr", "reshape2", "xgboost", "caret", prompt=FALSE)

##Import Data

t50proj <- read_csv("C:/Users/bllewellyn/OneDrive - Valorem/DCX/DCX 50Proj 2018_02_13.csv")
t100proj <- read_csv("C:/Users/bllewellyn/OneDrive - Valorem/DCX/DCX 100Proj 2018_02_13.csv")
t200proj <- read_csv("C:/Users/bllewellyn/OneDrive - Valorem/DCX/DCX 200Proj 2018_02_13.csv")
t400proj <- read_csv("C:/Users/bllewellyn/OneDrive - Valorem/DCX/DCX 400Proj 2018_02_13.csv")

## Summarize and Pivot Data

t50proj["TopSummaryTaskNumber"] <- paste("TopSummaryTask", str_pad(pull(t50proj, "TopSummaryTaskNumber"),2,pad="0"),sep="")
##t50proj_sum <- t50proj %>% group_by(ProjectNumber, TopSummaryTaskNumber) %>% summarise(CompletionDays=sum(CompletionDays))
t50proj_pvt <- dcast(t50proj, ProjectNumber ~ TopSummaryTaskNumber, sum, value.var="CompletionDays")
t50proj_pvt["Total"] <- apply(t50proj_pvt[,2:16],MARGIN=1,FUN=sum)

t100proj["TopSummaryTaskNumber"] <- paste("TopSummaryTask", str_pad(pull(t100proj, "TopSummaryTaskNumber"),2,pad="0"),sep="")
t100proj_pvt <- dcast(t100proj, ProjectNumber ~ TopSummaryTaskNumber, sum, value.var="CompletionDays")
t100proj_pvt["Total"] <- apply(t100proj_pvt[,2:16],MARGIN=1,FUN=sum)

t200proj["TopSummaryTaskNumber"] <- paste("TopSummaryTask", str_pad(pull(t200proj, "TopSummaryTaskNumber"),2,pad="0"),sep="")
t200proj_pvt <- dcast(t200proj, ProjectNumber ~ TopSummaryTaskNumber, sum, value.var="CompletionDays")
t200proj_pvt["Total"] <- apply(t200proj_pvt[,2:16],MARGIN=1,FUN=sum)

t400proj["TopSummaryTaskNumber"] <- paste("TopSummaryTask", str_pad(pull(t400proj, "TopSummaryTaskNumber"),2,pad="0"),sep="")
t400proj_pvt <- dcast(t400proj, ProjectNumber ~ TopSummaryTaskNumber, sum, value.var="CompletionDays")
t400proj_pvt["Total"] <- apply(t400proj_pvt[,2:16],MARGIN=1,FUN=sum)

## Determine "On-Time" Threshold

thresh_50 <- quantile(pull(t400proj_pvt, "Total"), .5)
thresh_80 <- quantile(pull(t400proj_pvt, "Total"), .8)
thresh_90 <- quantile(pull(t400proj_pvt, "Total"), .9)
thresh_95 <- quantile(pull(t400proj_pvt, "Total"), .95)

t50proj_pvt["LateNum50"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_50, 1, 0)
t50proj_pvt["LateNum20"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_80, 1, 0)
t50proj_pvt["LateNum10"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_90, 1, 0)
t50proj_pvt["LateNum05"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_95, 1, 0)
t50proj_pvt["Late50"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_50, "Late", "On Time")
t50proj_pvt["Late20"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_80, "Late", "On Time")
t50proj_pvt["Late10"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_90, "Late", "On Time")
t50proj_pvt["Late05"] <- ifelse(pull(t50proj_pvt, "Total") > thresh_95, "Late", "On Time")

t100proj_pvt["LateNum50"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_50, 1, 0)
t100proj_pvt["LateNum20"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_80, 1, 0)
t100proj_pvt["LateNum10"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_90, 1, 0)
t100proj_pvt["LateNum05"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_95, 1, 0)
t100proj_pvt["Late50"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_50, "Late", "On Time")
t100proj_pvt["Late20"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_80, "Late", "On Time")
t100proj_pvt["Late10"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_90, "Late", "On Time")
t100proj_pvt["Late05"] <- ifelse(pull(t100proj_pvt, "Total") > thresh_95, "Late", "On Time")

t200proj_pvt["LateNum50"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_50, 1, 0)
t200proj_pvt["LateNum20"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_80, 1, 0)
t200proj_pvt["LateNum10"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_90, 1, 0)
t200proj_pvt["LateNum05"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_95, 1, 0)
t200proj_pvt["Late50"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_50, "Late", "On Time")
t200proj_pvt["Late20"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_80, "Late", "On Time")
t200proj_pvt["Late10"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_90, "Late", "On Time")
t200proj_pvt["Late05"] <- ifelse(pull(t200proj_pvt, "Total") > thresh_95, "Late", "On Time")

t400proj_pvt["LateNum50"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_50, 1, 0)
t400proj_pvt["LateNum20"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_80, 1, 0)
t400proj_pvt["LateNum10"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_90, 1, 0)
t400proj_pvt["LateNum05"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_95, 1, 0)
t400proj_pvt["Late50"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_50, "Late", "On Time")
t400proj_pvt["Late20"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_80, "Late", "On Time")
t400proj_pvt["Late10"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_90, "Late", "On Time")
t400proj_pvt["Late05"] <- ifelse(pull(t400proj_pvt, "Total") > thresh_95, "Late", "On Time")

## Create Testing and Training Split

splitperc <- .7

datasize_50proj <- dim(t50proj_pvt)[1]
sampsize_50proj <- datasize_50proj * splitperc
samp_50proj <- sample(1:datasize_50proj,sampsize_50proj)
train_50proj <- t50proj_pvt[samp_50proj,]
test_50proj <- t50proj_pvt[-samp_50proj,]

datasize_100proj <- dim(t100proj_pvt)[1]
sampsize_100proj <- datasize_100proj * splitperc
samp_100proj <- sample(1:datasize_100proj,sampsize_100proj)
train_100proj <- t100proj_pvt[samp_100proj,]
test_100proj <- t100proj_pvt[-samp_100proj,]

datasize_200proj <- dim(t200proj_pvt)[1]
sampsize_200proj <- datasize_200proj * splitperc
samp_200proj <- sample(1:datasize_200proj,sampsize_200proj)
train_200proj <- t200proj_pvt[samp_200proj,]
test_200proj <- t200proj_pvt[-samp_200proj,]

datasize_400proj <- dim(t400proj_pvt)[1]
sampsize_400proj <- datasize_400proj * splitperc
samp_400proj <- sample(1:datasize_400proj,sampsize_400proj)
train_400proj <- t400proj_pvt[samp_400proj,]
test_400proj <- t400proj_pvt[-samp_400proj,]

## Fit Linear Regression and Boosted Decision Tree Models using Training Set

lrs_50proj <- list()
lrs_100proj <- list()
lrs_200proj <- list()
lrs_400proj <- list()
bdts50_50proj <- list()
bdts50_100proj <- list()
bdts50_200proj <- list()
bdts50_400proj <- list()
bdts20_50proj <- list()
bdts20_100proj <- list()
bdts20_200proj <- list()
bdts20_400proj <- list()
logs50_50proj <- list()
logs50_100proj <- list()
logs50_200proj <- list()
logs50_400proj <- list()
logs20_50proj <- list()
logs20_100proj <- list()
logs20_200proj <- list()
logs20_400proj <- list()
r_sq <- data.frame(NA, NA, NA, NA)
names(r_sq) <- c("50Proj", "100Proj", "200Proj", "400Proj")
lr_acc <- data.frame(NA, NA, NA, NA)
names(lr_acc) <- c("50Proj", "100Proj", "200Proj", "400Proj")
lr_prec <- data.frame(NA, NA, NA, NA)
names(lr_prec) <- c("50Proj", "100Proj", "200Proj", "400Proj")
lr_rec <- data.frame(NA, NA, NA, NA)
names(lr_rec) <- c("50Proj", "100Proj", "200Proj", "400Proj")
lr_f1 <- data.frame(NA, NA, NA, NA)
names(lr_f1) <- c("50Proj", "100Proj", "200Proj", "400Proj")
bdt_acc <- data.frame(NA, NA, NA, NA)
names(bdt_acc) <- c("50Proj", "100Proj", "200Proj", "400Proj")
bdt_prec <- data.frame(NA, NA, NA, NA)
names(bdt_prec) <- c("50Proj", "100Proj", "200Proj", "400Proj")
bdt_rec <- data.frame(NA, NA, NA, NA)
names(bdt_rec) <- c("50Proj", "100Proj", "200Proj", "400Proj")
bdt_f1 <- data.frame(NA, NA, NA, NA)
names(bdt_f1) <- c("50Proj", "100Proj", "200Proj", "400Proj")
log_acc <- data.frame(NA, NA, NA, NA)
names(log_acc) <- c("50Proj", "100Proj", "200Proj", "400Proj")
log_prec <- data.frame(NA, NA, NA, NA)
names(log_prec) <- c("50Proj", "100Proj", "200Proj", "400Proj")
log_rec <- data.frame(NA, NA, NA, NA)
names(log_rec) <- c("50Proj", "100Proj", "200Proj", "400Proj")
log_f1 <- data.frame(NA, NA, NA, NA)
names(log_f1) <- c("50Proj", "100Proj", "200Proj", "400Proj")

bdt_randopt <- 20
nrounds <- seq(from=25, to=200, by=25)
max_depth <- seq(from=1, to=10, by=1)
eta <- seq(from=.1, to=1, by=.1)
gamma <- seq(from=0, to=10, by=.2)
colsample_bytree <- seq(from=.5, to=1, by=.05)
min_child_weight <- 1
subsample <- 1
len <- length(nrounds)*length(max_depth)*length(eta)*length(gamma)*length(colsample_bytree)*length(min_child_weight)*length(subsample)
rand <- ceiling(runif(bdt_randopt)*len)
bdt_grid <- expand.grid(nrounds, max_depth, eta, gamma, colsample_bytree, min_child_weight, subsample)[rand,]
bdt_grid[rand+1,] <- c(1,1,1,0,1,1,1)
names(bdt_grid) <- c("nrounds", "max_depth", "eta", "gamma", "colsample_bytree", "min_child_weight", "subsample")

for(i in 1:14){
  
  temp_50proj <- data.frame(pull(train_50proj, "Total"), train_50proj[,2:(i+1)])
  names(temp_50proj) <- c("Total", names(train_50proj[2:(i+1)]))
  temp_100proj <- data.frame(pull(train_100proj, "Total"), train_100proj[,2:(i+1)])
  names(temp_100proj) <- c("Total", names(train_100proj[2:(i+1)]))
  temp_200proj <- data.frame(pull(train_200proj, "Total"), train_200proj[,2:(i+1)])
  names(temp_200proj) <- c("Total", names(train_200proj[2:(i+1)]))
  temp_400proj <- data.frame(pull(train_400proj, "Total"), train_400proj[,2:(i+1)])
  names(temp_400proj) <- c("Total", names(train_400proj[2:(i+1)]))

## Fit Linear Regression Model
  
  lr_50proj <- lm(Total ~ ., data=temp_50proj)
  lr_100proj <- lm(Total ~ ., data=temp_100proj)
  lr_200proj <- lm(Total ~ ., data=temp_200proj)
  lr_400proj <- lm(Total ~ ., data=temp_400proj)

  lrs_50proj[[i]] <- lr_50proj
  lrs_100proj[[i]] <- lr_100proj
  lrs_200proj[[i]] <- lr_200proj
  lrs_400proj[[i]] <- lr_400proj

## Fit Boosted Decision Tree Model
  
  temp_50proj <- data.frame(as.factor(pull(train_50proj, "LateNum50")), train_50proj[,2:(i+1)])
  names(temp_50proj) <- c("LateNum50", names(t50proj_pvt[2:(i+1)]))
  temp_100proj <- data.frame(as.factor(pull(train_100proj, "LateNum50")), train_100proj[,2:(i+1)])
  names(temp_100proj) <- c("LateNum50", names(train_100proj[2:(i+1)]))
  temp_200proj <- data.frame(as.factor(pull(train_200proj, "LateNum50")), train_200proj[,2:(i+1)])
  names(temp_200proj) <- c("LateNum50", names(train_200proj[2:(i+1)]))
  temp_400proj <- data.frame(as.factor(pull(train_400proj, "LateNum50")), train_400proj[,2:(i+1)])
  names(temp_400proj) <- c("LateNum50", names(train_400proj[2:(i+1)]))
  
  bdt50_50proj <- train(LateNum50 ~ ., data=temp_50proj, method="xgbTree", preProc=c("center", "scale")
                            ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  bdt50_100proj <- train(LateNum50 ~ ., data=temp_100proj, method="xgbTree", preProc=c("center", "scale")
                             ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  bdt50_200proj <- train(LateNum50 ~ ., data=temp_200proj, method="xgbTree", preProc=c("center", "scale")
                             ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  bdt50_400proj <- train(LateNum50 ~ ., data=temp_400proj, method="xgbTree", preProc=c("center", "scale")
                             ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  
  bdts50_50proj[[i]] <- bdt50_50proj
  bdts50_100proj[[i]] <- bdt50_100proj
  bdts50_200proj[[i]] <- bdt50_200proj
  bdts50_400proj[[i]] <- bdt50_400proj
  
  temp_50proj <- data.frame(as.factor(pull(train_50proj, "LateNum20")), train_50proj[,2:(i+1)])
  names(temp_50proj) <- c("LateNum20", names(t50proj_pvt[2:(i+1)]))
  temp_100proj <- data.frame(as.factor(pull(train_100proj, "LateNum20")), train_100proj[,2:(i+1)])
  names(temp_100proj) <- c("LateNum20", names(train_100proj[2:(i+1)]))
  temp_200proj <- data.frame(as.factor(pull(train_200proj, "LateNum20")), train_200proj[,2:(i+1)])
  names(temp_200proj) <- c("LateNum20", names(train_200proj[2:(i+1)]))
  temp_400proj <- data.frame(as.factor(pull(train_400proj, "LateNum20")), train_400proj[,2:(i+1)])
  names(temp_400proj) <- c("LateNum20", names(train_400proj[2:(i+1)]))
  
  bdt20_50proj <- train(LateNum20 ~ ., data=temp_50proj, method="xgbTree", preProc=c("center", "scale")
                            ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  bdt20_100proj <- train(LateNum20 ~ ., data=temp_100proj, method="xgbTree", preProc=c("center", "scale")
                             ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  bdt20_200proj <- train(LateNum20 ~ ., data=temp_200proj, method="xgbTree", preProc=c("center", "scale")
                             ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  bdt20_400proj <- train(LateNum20 ~ ., data=temp_400proj, method="xgbTree", preProc=c("center", "scale")
                             ,trControl=trainControl(method="cv", number=5, returnResamp="all"), metric="Kappa", tuneGrid=bdt_grid)
  
  bdts20_50proj[[i]] <- bdt20_50proj
  bdts20_100proj[[i]] <- bdt20_100proj
  bdts20_200proj[[i]] <- bdt20_200proj
  bdts20_400proj[[i]] <- bdt20_400proj
  
## Fit Logistic Regression Model
  
  temp_50proj <- data.frame(as.factor(pull(train_50proj, "LateNum50")), train_50proj[,2:(i+1)])
  names(temp_50proj) <- c("LateNum50", names(t50proj_pvt[2:(i+1)]))
  temp_100proj <- data.frame(as.factor(pull(train_100proj, "LateNum50")), train_100proj[,2:(i+1)])
  names(temp_100proj) <- c("LateNum50", names(train_100proj[2:(i+1)]))
  temp_200proj <- data.frame(as.factor(pull(train_200proj, "LateNum50")), train_200proj[,2:(i+1)])
  names(temp_200proj) <- c("LateNum50", names(train_200proj[2:(i+1)]))
  temp_400proj <- data.frame(as.factor(pull(train_400proj, "LateNum50")), train_400proj[,2:(i+1)])
  names(temp_400proj) <- c("LateNum50", names(train_400proj[2:(i+1)]))
  
  log50_50proj <- glm(LateNum50 ~ ., data=temp_50proj, family=binomial(link="logit"))
  log50_100proj <- glm(LateNum50 ~ ., data=temp_100proj, family=binomial(link="logit"))
  log50_200proj <- glm(LateNum50 ~ ., data=temp_200proj, family=binomial(link="logit"))
  log50_400proj <- glm(LateNum50 ~ ., data=temp_400proj, family=binomial(link="logit"))
  
  logs50_50proj[[i]] <- log50_50proj
  logs50_100proj[[i]] <- log50_100proj
  logs50_200proj[[i]] <- log50_200proj
  logs50_400proj[[i]] <- log50_400proj
  
  temp_50proj <- data.frame(as.factor(pull(train_50proj, "LateNum20")), train_50proj[,2:(i+1)])
  names(temp_50proj) <- c("LateNum20", names(t50proj_pvt[2:(i+1)]))
  temp_100proj <- data.frame(as.factor(pull(train_100proj, "LateNum20")), train_100proj[,2:(i+1)])
  names(temp_100proj) <- c("LateNum20", names(train_100proj[2:(i+1)]))
  temp_200proj <- data.frame(as.factor(pull(train_200proj, "LateNum20")), train_200proj[,2:(i+1)])
  names(temp_200proj) <- c("LateNum20", names(train_200proj[2:(i+1)]))
  temp_400proj <- data.frame(as.factor(pull(train_400proj, "LateNum20")), train_400proj[,2:(i+1)])
  names(temp_400proj) <- c("LateNum20", names(train_400proj[2:(i+1)]))
  
  log20_50proj <- glm(LateNum20 ~ ., data=temp_50proj, family=binomial(link="logit"))
  log20_100proj <- glm(LateNum20 ~ ., data=temp_100proj, family=binomial(link="logit"))
  log20_200proj <- glm(LateNum20 ~ ., data=temp_200proj, family=binomial(link="logit"))
  log20_400proj <- glm(LateNum20 ~ ., data=temp_400proj, family=binomial(link="logit"))
  
  logs20_50proj[[i]] <- log20_50proj
  logs20_100proj[[i]] <- log20_100proj
  logs20_200proj[[i]] <- log20_200proj
  logs20_400proj[[i]] <- log20_400proj
  
## Generate Predictions Using Testing Set
  
  temp_50proj <- data.frame(test_50proj[,2:(i+1)])
  names(temp_50proj) <- names(test_50proj[2:(i+1)])
  
  temp_100proj <- data.frame(test_100proj[,2:(i+1)])
  names(temp_100proj) <- names(test_100proj[2:(i+1)])
  
  temp_200proj <- data.frame(test_200proj[,2:(i+1)])
  names(temp_200proj) <- names(test_200proj[2:(i+1)])
  
  temp_400proj <- data.frame(test_400proj[,2:(i+1)])
  names(temp_400proj) <- names(test_400proj[2:(i+1)])
  
  lrpred_50proj <- predict(lr_50proj, temp_50proj)
  lrpred_100proj <- predict(lr_100proj, temp_100proj)
  lrpred_200proj <- predict(lr_200proj, temp_200proj)
  lrpred_400proj <- predict(lr_400proj, temp_400proj)
  
  lr50pred_50proj <- ifelse(predict(lr_50proj, temp_50proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  lr50pred_100proj <- ifelse(predict(lr_100proj, temp_100proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  lr50pred_200proj <- ifelse(predict(lr_200proj, temp_200proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  lr50pred_400proj <- ifelse(predict(lr_400proj, temp_400proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  
  lr20pred_50proj <- ifelse(predict(lr_50proj, temp_50proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  lr20pred_100proj <- ifelse(predict(lr_100proj, temp_100proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  lr20pred_200proj <- ifelse(predict(lr_200proj, temp_200proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  lr20pred_400proj <- ifelse(predict(lr_400proj, temp_400proj, interval="prediction")[,2] > thresh_50, "Late", "On Time")
  
  bdt50pred_50proj <- ifelse(predict(bdt50_50proj, temp_50proj)==1, "Late", "On Time")
  bdt50pred_100proj <- ifelse(predict(bdt50_100proj, temp_100proj)==1, "Late", "On Time")
  bdt50pred_200proj <- ifelse(predict(bdt50_200proj, temp_200proj)==1, "Late", "On Time")
  bdt50pred_400proj <- ifelse(predict(bdt50_400proj, temp_400proj)==1, "Late", "On Time")
  
  bdt20pred_50proj <- ifelse(predict(bdt20_50proj, temp_50proj)==1, "Late", "On Time")
  bdt20pred_100proj <- ifelse(predict(bdt20_100proj, temp_100proj)==1, "Late", "On Time")
  bdt20pred_200proj <- ifelse(predict(bdt20_200proj, temp_200proj)==1, "Late", "On Time")
  bdt20pred_400proj <- ifelse(predict(bdt20_400proj, temp_400proj)==1, "Late", "On Time")
  
  log50pred_50proj <- ifelse(predict(log50_50proj, temp_50proj, type="response")>.5, "Late", "On Time")
  log50pred_100proj <- ifelse(predict(log50_100proj, temp_100proj, type="response")>.5, "Late", "On Time")
  log50pred_200proj <- ifelse(predict(log50_200proj, temp_200proj, type="response")>.5, "Late", "On Time")
  log50pred_400proj <- ifelse(predict(log50_400proj, temp_400proj, type="response")>.5, "Late", "On Time")
  
  log20pred_50proj <- ifelse(predict(log20_50proj, temp_50proj, type="response")>.5, "Late", "On Time")
  log20pred_100proj <- ifelse(predict(log20_100proj, temp_100proj, type="response")>.5, "Late", "On Time")
  log20pred_200proj <- ifelse(predict(log20_200proj, temp_200proj, type="response")>.5, "Late", "On Time")
  log20pred_400proj <- ifelse(predict(log20_400proj, temp_400proj, type="response")>.5, "Late", "On Time")
  
  
## Calculate Evaluation Metrics
  
  r_sq[i,1] <- cor(pull(test_50proj, "Total"), lrpred_50proj)^2
  r_sq[i,2] <- cor(pull(test_100proj, "Total"), lrpred_100proj)^2
  r_sq[i,3] <- cor(pull(test_200proj, "Total"), lrpred_200proj)^2
  r_sq[i,4] <- cor(pull(test_400proj, "Total"), lrpred_400proj)^2
  
  lr_cm50_50proj <- confusionMatrix(lr50pred_50proj, pull(test_50proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  lr_cm50_100proj <- confusionMatrix(lr50pred_100proj, pull(test_100proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  lr_cm50_200proj <- confusionMatrix(lr50pred_200proj, pull(test_200proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  lr_cm50_400proj <- confusionMatrix(lr50pred_400proj, pull(test_400proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  
  lr_cm20_50proj <- confusionMatrix(lr20pred_50proj, pull(test_50proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  lr_cm20_100proj <- confusionMatrix(lr20pred_100proj, pull(test_100proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  lr_cm20_200proj <- confusionMatrix(lr20pred_200proj, pull(test_200proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  lr_cm20_400proj <- confusionMatrix(lr20pred_400proj, pull(test_400proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  
  bdt_cm50_50proj <- confusionMatrix(bdt50pred_50proj, pull(test_50proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  bdt_cm50_100proj <- confusionMatrix(bdt50pred_100proj, pull(test_100proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  bdt_cm50_200proj <- confusionMatrix(bdt50pred_200proj, pull(test_200proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  bdt_cm50_400proj <- confusionMatrix(bdt50pred_400proj, pull(test_400proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  
  bdt_cm20_50proj <- confusionMatrix(bdt20pred_50proj, pull(test_50proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  bdt_cm20_100proj <- confusionMatrix(bdt20pred_100proj, pull(test_100proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  bdt_cm20_200proj <- confusionMatrix(bdt20pred_200proj, pull(test_200proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  bdt_cm20_400proj <- confusionMatrix(bdt20pred_400proj, pull(test_400proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  
  log_cm50_50proj <- confusionMatrix(log50pred_50proj, pull(test_50proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  log_cm50_100proj <- confusionMatrix(log50pred_100proj, pull(test_100proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  log_cm50_200proj <- confusionMatrix(log50pred_200proj, pull(test_200proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  log_cm50_400proj <- confusionMatrix(log50pred_400proj, pull(test_400proj, "Late50"), positive="Late", dnn=c("Predicted", "Actual"))
  
  log_cm20_50proj <- confusionMatrix(log20pred_50proj, pull(test_50proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  log_cm20_100proj <- confusionMatrix(log20pred_100proj, pull(test_100proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  log_cm20_200proj <- confusionMatrix(log20pred_200proj, pull(test_200proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  log_cm20_400proj <- confusionMatrix(log20pred_400proj, pull(test_400proj, "Late20"), positive="Late", dnn=c("Predicted", "Actual"))
  
  lr_acc[i,1] <- lr_cm50_50proj$overall["Accuracy"]
  lr_acc[i,2] <- lr_cm50_100proj$overall["Accuracy"]
  lr_acc[i,3] <- lr_cm50_200proj$overall["Accuracy"]
  lr_acc[i,4] <- lr_cm50_400proj$overall["Accuracy"]
  
  lr_prec[i,1] <- lr_cm20_50proj$byClass["Precision"]
  lr_prec[i,2] <- lr_cm20_100proj$byClass["Precision"]
  lr_prec[i,3] <- lr_cm20_200proj$byClass["Precision"]
  lr_prec[i,4] <- lr_cm20_400proj$byClass["Precision"]
  
  lr_rec[i,1] <- lr_cm20_50proj$byClass["Recall"]
  lr_rec[i,2] <- lr_cm20_100proj$byClass["Recall"]
  lr_rec[i,3] <- lr_cm20_200proj$byClass["Recall"]
  lr_rec[i,4] <- lr_cm20_400proj$byClass["Recall"]
  
  lr_f1[i,1] <- lr_cm20_50proj$byClass["F1"]
  lr_f1[i,2] <- lr_cm20_100proj$byClass["F1"]
  lr_f1[i,3] <- lr_cm20_200proj$byClass["F1"]
  lr_f1[i,4] <- lr_cm20_400proj$byClass["F1"]
  
  bdt_acc[i,1] <- bdt_cm50_50proj$overall["Accuracy"]
  bdt_acc[i,2] <- bdt_cm50_100proj$overall["Accuracy"]
  bdt_acc[i,3] <- bdt_cm50_200proj$overall["Accuracy"]
  bdt_acc[i,4] <- bdt_cm50_400proj$overall["Accuracy"]
  
  bdt_prec[i,1] <- bdt_cm20_50proj$byClass["Precision"]
  bdt_prec[i,2] <- bdt_cm20_100proj$byClass["Precision"]
  bdt_prec[i,3] <- bdt_cm20_200proj$byClass["Precision"]
  bdt_prec[i,4] <- bdt_cm20_400proj$byClass["Precision"]
  
  bdt_rec[i,1] <- bdt_cm20_50proj$byClass["Recall"]
  bdt_rec[i,2] <- bdt_cm20_100proj$byClass["Recall"]
  bdt_rec[i,3] <- bdt_cm20_200proj$byClass["Recall"]
  bdt_rec[i,4] <- bdt_cm20_400proj$byClass["Recall"]
  
  bdt_f1[i,1] <- bdt_cm20_50proj$byClass["F1"]
  bdt_f1[i,2] <- bdt_cm20_100proj$byClass["F1"]
  bdt_f1[i,3] <- bdt_cm20_200proj$byClass["F1"]
  bdt_f1[i,4] <- bdt_cm20_400proj$byClass["F1"]
  
  log_acc[i,1] <- log_cm50_50proj$overall["Accuracy"]
  log_acc[i,2] <- log_cm50_100proj$overall["Accuracy"]
  log_acc[i,3] <- log_cm50_200proj$overall["Accuracy"]
  log_acc[i,4] <- log_cm50_400proj$overall["Accuracy"]
  
  log_prec[i,1] <- log_cm20_50proj$byClass["Precision"]
  log_prec[i,2] <- log_cm20_100proj$byClass["Precision"]
  log_prec[i,3] <- log_cm20_200proj$byClass["Precision"]
  log_prec[i,4] <- log_cm20_400proj$byClass["Precision"]
  
  log_rec[i,1] <- log_cm20_50proj$byClass["Recall"]
  log_rec[i,2] <- log_cm20_100proj$byClass["Recall"]
  log_rec[i,3] <- log_cm20_200proj$byClass["Recall"]
  log_rec[i,4] <- log_cm20_400proj$byClass["Recall"]
  
  log_f1[i,1] <- log_cm20_50proj$byClass["F1"]
  log_f1[i,2] <- log_cm20_100proj$byClass["F1"]
  log_f1[i,3] <- log_cm20_200proj$byClass["F1"]
  log_f1[i,4] <- log_cm20_400proj$byClass["F1"]
}

## Plot Results

plot(lr_acc[,4], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Accuracy"
     ,main="Predicting Late Completion (50% Late) with 400 Projects", sub="Model: Red=Linear Regression, Blue=Boosted Decision Tree, Green=Logistic Regression")
lines(bdt_acc[,4], col="blue")
lines(log_acc[,4], col="green")
abline(h=.5)

plot(r_sq[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="R-Squared"
     ,main="Predicting Total Completion Time via Linear Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(r_sq[,2], col="blue")
lines(r_sq[,3], col="green")
lines(r_sq[,4], col="orange")
abline(h=.8)

plot(lr_acc[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Accuracy"
     ,main="Predicting Late Completion (50% Late) via Linear Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(lr_acc[,2], col="blue")
lines(lr_acc[,3], col="green")
lines(lr_acc[,4], col="orange")
abline(h=.5)

prec_base <- sum(pull(t400proj_pvt, "LateNum20"))/sum(1-pull(t400proj_pvt, "LateNum20"))

plot(lr_prec[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Precision"
     ,main="Predicting Late Completion (20% Late) via Linear Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(lr_prec[,2], col="blue")
lines(lr_prec[,3], col="green")
lines(lr_prec[,4], col="orange")
abline(h=prec_base)

plot(lr_rec[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Recall"
     ,main="Predicting Late Completion (20% Late) via Linear Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(lr_rec[,2], col="blue")
lines(lr_rec[,3], col="green")
lines(lr_rec[,4], col="orange")
abline(h=.5)

plot(lr_f1[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="F1"
     ,main="Predicting Late Completion (20% Late) via Linear Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(lr_f1[,2], col="blue")
lines(lr_f1[,3], col="green")
lines(lr_f1[,4], col="orange")
abline(h=prec_base/(prec_base+.5))

plot(bdt_acc[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Accuracy"
     ,main="Predicting Late Completion (50% Late) via Boosted Decision Tree", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(bdt_acc[,2], col="blue")
lines(bdt_acc[,3], col="green")
lines(bdt_acc[,4], col="orange")
abline(h=.5)

plot(bdt_prec[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Precision"
     ,main="Predicting Late Completion (20% Late) via Boosted Decision Tree", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(bdt_prec[,2], col="blue")
lines(bdt_prec[,3], col="green")
lines(bdt_prec[,4], col="orange")
abline(h=prec_base)

plot(bdt_rec[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Recall"
     ,main="Predicting Late Completion (20% Late) via Boosted Decision Tree", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(bdt_rec[,2], col="blue")
lines(bdt_rec[,3], col="green")
lines(bdt_rec[,4], col="orange")
abline(h=.5)

plot(bdt_f1[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="F1"
     ,main="Predicting Late Completion (20% Late) via Boosted Decision Tree", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(bdt_f1[,2], col="blue")
lines(bdt_f1[,3], col="green")
lines(bdt_f1[,4], col="orange")
abline(h=prec_base/(prec_base+.5))

plot(log_acc[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Accuracy"
     ,main="Predicting Late Completion (50% Late) via Logistic Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(log_acc[,2], col="blue")
lines(log_acc[,3], col="green")
lines(log_acc[,4], col="orange")
abline(h=.5)

plot(log_prec[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Precision"
     ,main="Predicting Late Completion (20% Late) via Logistic Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(log_prec[,2], col="blue")
lines(log_prec[,3], col="green")
lines(log_prec[,4], col="orange")
abline(h=prec_base)

plot(log_rec[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="Recall"
     ,main="Predicting Late Completion (20% Late) via Logistic Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(log_rec[,2], col="blue")
lines(log_rec[,3], col="green")
lines(log_rec[,4], col="orange")
abline(h=.5)

plot(log_f1[,1], type="l", col="red", ylim=c(0,1), xlab="Top Summary Tasks Completed", ylab="F1"
     ,main="Predicting Late Completion (20% Late) via Logistic Regression", sub="Number of Projects: Red=50, Blue=100, Green=200, Orange=400")
lines(log_f1[,2], col="blue")
lines(log_f1[,3], col="green")
lines(log_f1[,4], col="orange")
abline(h=prec_base/(prec_base+.5))