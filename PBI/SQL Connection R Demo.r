library(RODBC)
library(ggplot2)
library(scales)
cn<-odbcDriverConnect('driver={SQL Server};server=DESKTOP-KIN0GTH;database=AdventureWorksDW2014;trusted_connection=true')
dataset<-sqlQuery(cn, 'select   CalendarYear, EnglishMonthName, ResellerName, SalesAmount
from FactResellerSales s inner join DimReseller r on s.ResellerKey = r.ResellerKey
inner join DimDate d on s.ShipDateKey=d.DateKey')
#
# Just show one year of data
dataset <- subset(dataset,CalendarYear = "2011")
#
ggplot(dataset,aes(x=EnglishMonthName, y=SalesAmount)) +
geom_bar(stat = "identity", fill="black")
#
# Format Months to display in correct order
dataset$EnglishMonthName = factor(dataset$EnglishMonthName, levels = month.name)
#
ggplot(dataset,aes(x=EnglishMonthName, y=SalesAmount)) +
geom_bar(stat = "identity", fill="black")
