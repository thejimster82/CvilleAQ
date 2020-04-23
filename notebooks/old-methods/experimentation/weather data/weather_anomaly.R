library(stringr)
library(openair)
library(useful)
library(MASS)
library(e1071)
library(dplyr)
library(solitude)
library(anomalize)
library(tidyverse)
library(fitdistrplus)
library(forecast)
library(mclust)
library(plotly)


weatherData = read.csv("./data/2020-01-01,2020-02-22.csv")

df = weatherData[c(3, 4, 7, 9)]

df <- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)

df$Temperature <- substr(df$Temperature, 1, nchar(df$Temperature)-2)
df$Dew.Point <- substr(df$Dew.Point, 1, nchar(df$Dew.Point)-2)
df$Speed <- substr(df$Speed, 1, nchar(df$Speed)-4)
df$Pressure <- substr(df$Pressure, 1, nchar(df$Pressure)-3)

df2 <- data.frame(lapply(df, as.numeric))

df2 <- na.omit(df2)

n_cluster = 1:15   # set upper bound for number of clusters

wss <- 1:15   # between sum of squares for plotting

# record between sum of squares for each number of clusters
for (i in n_cluster){    
  km = kmeans(df2, i)
  wss[i] = km$withinss
}

plot(1:15,wss)                

#Appears a good number of clusters to pick is 6

webgl = TRUE
km = kmeans(df2, 6)
km$centers

eucDists <- sqrt(rowSums(df2 - fitted(km)) ^ 2)
outlierFrac <- 0.01
numOutliers = as.integer(outlierFrac*length(eucDists))
threshold = min(tail(sort(as.matrix(eucDists)), numOutliers)) 
# All observations with distances greater than or equal to the threshold labeled as 1
dfAnom <- df2 # Creating a duplicate of the dataframe but adding classification columns
dfAnom$km_anomaly = as.integer(eucDists >= threshold) 

fig <- plot_ly(dfAnom, x = ~Temperature, y = ~Dew.Point, z = ~Speed, color = ~km_anomaly, colors = c('green', 'red'))
fig


