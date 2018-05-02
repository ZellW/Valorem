#https://www.kaggle.com/kevinbonnes/r-churn-prediction-baseline/data
set.seed(12345)

PATH <- "./data/subscription/"

train2 <- fread(paste0(PATH,"train2.csv"), sep=",", na.strings = "", stringsAsFactors=T)
transactions2 <- fread(paste0(PATH,"transactions2.csv"), sep=",", na.strings = "", stringsAsFactors=T)
members2 <- fread(paste0(PATH,"members2.csv"), sep=",", na.strings = "", stringsAsFactors=T)
test2 <- fread(paste0(PATH,"test0.csv"), sep=",", na.strings = "", stringsAsFactors=T)

#Combine train and test files
test2$is_churn <- NA
data2 <- rbind(train2, test2)
#data1 <- data[,is_duplicate := as.numeric(duplicated(as.character(data$msno)) | duplicated(as.character(data$msno),fromLast=T))]
data2 <- mutate(data2, is_duplicate =as.numeric(duplicated(msno, fromLast = TRUE)))
#logical indicating if duplication should be considered from the reverse side, i.e., the last (or rightmost) of identical elements would correspond to duplicated = FALSE

#Format gender and remove NA's
# members1 <- members
# members1 <-  members1[,gender := as.numeric(gender)]
# members1$gender[is.na(members1$gender)] <- 0
# 
# #Format dates and do some feature engineering
# members1[,":="(reg_fulldate = members1$registration_init_time
#              ,registration_init_time = as.Date(as.character(registration_init_time), '%Y%m%d'))]
#              #,exp_fulldate = expiration_date
#              #,expiration_date = as.Date(as.character(expiration_date), '%Y%m%d'))]
# members1[,":="(reg_year = year(registration_init_time)
#              ,reg_month = month(registration_init_time)
#              ,reg_mday = mday(registration_init_time)
#              ,reg_wday = wday(registration_init_time))]
#              #,exp_year = year(expiration_date)
#              #,exp_month = month(expiration_date)
#              #,exp_mday = mday(expiration_date)
#              #,exp_wday = wday(expiration_date)
#              #,date_diff = as.numeric(expiration_date - registration_init_time))]
# #members1 <- subset(members1, select = -c(registration_init_time, expiration_date))
# members1 <- subset(members1, select = -c(registration_init_time))

members2 <- members2 %>% mutate(gender = as.numeric(members2$gender))
members2 <- members2 %>% mutate(gender = if_else(is.na(gender), 0, gender))

members2 <- members2 %>% mutate(reg_fulldate = registration_init_time, registration_init_time = as.Date(as.character(registration_init_time), '%Y%m%d'))
#members2 <- members2 %>% mutate(exp_fulldate = expiration_date, expiration_date = as.Date(as.character(expiration_date), '%Y%m%d'))

members2 <- members2 %>% mutate(reg_year = year(registration_init_time), reg_month = month(registration_init_time), reg_mday = mday(registration_init_time),
                              reg_wday = wday(registration_init_time))
members2 <- members2 %>% select(-c(registration_init_time))

#Merge data and members
data2 <- merge(data2, members2, by = "msno", all.x = TRUE)

#Reduce size of transactions
transactions2 <- transactions2[transactions2$msno %in% levels(data2$msno),]

# #Get amount of transactions per user
# transactions1 <- transactions
# transactions1[,n_transactions := .N, by = msno]
# 
# #Get difference between plan price and payment amount
# transactions1[,payment_price_diff := plan_list_price - actual_amount_paid]

transactions2 <- transactions2 %>% group_by(msno) %>% mutate(n_transactions = n())
transactions2 <- transactions2 %>% mutate(payment_price_diff = plan_list_price - actual_amount_paid)

WORK HERE BELOW
transactions2_1 <- transactions2
#Aggregate by user, get mean of columns.  The transaction dates are useful for now, so remove them
#transactions2_1 <- transactions2_1[,lapply(.SD,mean,na.rm=T), by = msno, .SDcols = names(transactions2_1)[c(2:6,9:11)]]
transactions2_2 <- transactions2_1 %>% group_by(msno) %>% mutate(payment_plan_days = mean(payment_plan_days))
transactions2_2 <- transactions2_2 %>% group_by(msno) %>% mutate(plan_list_price = mean(plan_list_price), actual_amount_paid = mean(actual_amount_paid),
                                                                 payment_price_diff = mean(payment_price_diff))
transactions2_2 <- transactions2_2 %>% group_by(msno) %>% mutate(is_auto_renew = mean(is_auto_renew), is_cancel = mean(is_cancel), payment_method_id = mean(payment_method_id))

transactions2_2 <- distinct(transactions2_2, msno, .keep_all = TRUE)
transactions2_2 <- transactions2_2 %>% select(-c(transaction_date, membership_expire_date))

#Merge data and transactions
data3 <- merge(data2, transactions2_2, by = "msno", all.x = TRUE)

#save(train, test, transactions, data, members, file="../data/subscription/subscrData.RData")
data <- data3
