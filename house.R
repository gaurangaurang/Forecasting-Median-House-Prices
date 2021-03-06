library(forecast)
library(ggplot2)

#Data Preprocessing. 
#The data set had median prices of one bedroom apartments 
#from various neighbourhoods in the US for the period between January 2010 to
#September 2016.
#For the purpose of this repository, I have considered only the median prices of
#houses in Upper East Side because it was the only neighbourhood with complete
#data available.
#I have tried to predict the median apartment price for the next 12 months using
#ARIMA model.
median_price <- median_price[-c(2:67), ]

medianprice <- median_price[,-c(1:6)]

m1 <- t(medianprice)
fcd <- data.frame(r1= row.names(m1), m1, row.names=NULL) 
fcd <- fcd[,-c(1)]

fcd <- as.data.frame(fcd)
fcd <- tibble::rowid_to_column(fcd, "Month")

names(fcd) <- c("Month", "MedianPrice")


plot(MedianPrice~Month, data = fcd, col = "Blue", bg = 'Blue') #Non Stationary data with a clearly increasing trend. See plot

#Transform data into time series data
fcdts <- ts(fcd$MedianPrice, start = min(fcd$Month), end = max(fcd$Month))
summary(fcdts)
#Summary of the data:
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 751.0   785.0   819.8   916.3   988.7  1396.5

#Build ARIMA model.
pricefc <- auto.arima(fcdts)

coef(pricefc)

#Forecast apartment prices for the next 12 months.
predict(pricefc, n.ahead = 12, se.fit = T)

##These are the values according to the model for the next 12 months.
#1391.946 1414.204 1434.908 1454.732 1474.059 1493.103 1511.987 1530.781
#1549.524 1568.238 1586.935 1605.623

PriceForecast <- forecast(object = pricefc, h= 12)
plot(PriceForecast) #See plot
