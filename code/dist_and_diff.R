library(geosphere)

#Working directory = /data

pre_df <- read.csv("pre_means.csv")

post_df <- read.csv("post_means.csv")

for (i in 1:length(pre_df[,1])){
  pre_df[i,]$X = i
}

for (i in 1:length(post_df[,1])){
  post_df[i,]$X = i
}

combs_pre <- t(combn(pre_df$X, 2))

combs_post <- t(combn(post_df$X, 2))

pre_corr_df <- data.frame(combs_pre)
colnames(pre_corr_df) <- c("box1", "box2")
  
post_corr_df <- data.frame(combs_post)
colnames(post_corr_df) <- c("box1", "box2") 

pre_corr_df$geo_dist_meters = 0
post_corr_df$geo_dist_meters = 0

# getting straight line distance between every pair of sensors in meters (pre)
for (i in 1:length(pre_corr_df[,1])){
  b1 = pre_corr_df[i,]$box1
  b2 = pre_corr_df[i,]$box2
  pre_corr_df[i,]$geo_dist_meters <- distm(c(pre_df[b1,]$longitude, pre_df[b1,]$latitude), c(pre_df[b2,]$longitude, pre_df[b2,]$latitude), fun = distHaversine)
}

# getting straight line distance between every pair of sensors in meters (post)
for (i in 1:length(post_corr_df[,1])){
  b1 = post_corr_df[i,]$box1
  b2 = post_corr_df[i,]$box2
  post_corr_df[i,]$geo_dist_meters <- distm(c(post_df[b1,]$longitude, post_df[b1,]$latitude), c(post_df[b2,]$longitude, post_df[b2,]$latitude), fun = distHaversine)
}

difference_df <- data.frame(pre_df[,1:3])
difference_df$co2_diff <- 0
difference_df$pm2_5_diff <- 0
difference_df$pm10_diff <- 0

# difference in pre to post
for (i in 1:length(pre_df[,1])){
  co2_pre = pre_df[i,]$co2
  co2_post = post_df[i,]$co2
  difference_df[i,]$co2_diff <- co2_post - co2_pre
  pm2_5_pre = pre_df[i,]$pm25
  pm2_5_post = post_df[i,]$pm25
  difference_df[i,]$pm2_5_diff <- pm2_5_post - pm2_5_pre
  pm10_pre = pre_df[i,]$pm10
  pm10_post = post_df[i,]$pm10
  difference_df[i,]$pm10_diff <- pm10_post - pm10_pre
}

#

