library(automap)
library(kriging)
library(rgdal)
library(spatstat)
library(maptools)
library(raster)
library(sp)

### SET WORKING DIRECTORY TO /data/tl_2019_51540_faces
setwd("./data/tl_2019_51540_faces")
df_pre <- read.csv("pre_means.csv")
df_post <- read.csv("post_means.csv")
data_pre = df_pre[,4:6]
data_post = df_post[,4:6]
shape <- readOGR("tl_2019_51540_faces.shp")
shp = shape@polygons
shp = SpatialPolygons(shp, proj4string=CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))

extractCoords <- function(sp.df)
{
  results <- list()
  for(i in 1:length(sp.df@polygons[[1]]@Polygons))
  {
    for(j in 1:1014)
    {
      results[[j]] <- sp.df@polygons[[j]]@Polygons[[1]]@coords
    }
  }
  results <- Reduce(rbind, results)
  results
}

a = extractCoords(shp)

coordinates(df_pre) <- ~ longitude + latitude
coordinates(df_post) <- ~ longitude + latitude

#proj4string(df) <- CRS("+init=epsg:4326")

#ext <- as(extent(df), "SpatialPolygons")
#r <- rasterToPoints(raster(ext, resolution = 30), spatial = TRUE)
#proj4string(r) <- proj4string(df)  

spdf_pre = SpatialPointsDataFrame(df_pre@coords, data_pre)
spdf_post = SpatialPointsDataFrame(df_post@coords, data_post)

spdf_pre@data
spdf_post@data

proj4string(spdf_pre) <- proj4string(r)

sp_pts <- SpatialPoints(a)

#plotting co2 pre and post

kriging_co2_pre = autoKrige(spdf_pre$co2~1, spdf_pre, sp_pts, model = "Exp")

plot(kriging_co2_pre)

kriging_co2_post = autoKrige(spdf_post$co2~1, spdf_post, sp_pts, model = "Exp")

plot(kriging_co2_post)

#plotting pm25 pre and post

kriging_pm25_pre = autoKrige(spdf_pre$pm25~1, spdf_pre, sp_pts, model = "Exp")

plot(kriging_pm25_pre)

kriging_pm25_post = autoKrige(spdf_post$pm25~1, spdf_post, sp_pts, model = "Exp")

plot(kriging_pm25_post)

#plotting pm10 pre and post

kriging_pm10_pre = autoKrige(spdf_pre$pm10~1, spdf_pre, sp_pts, model = "Exp")

plot(kriging_pm10_pre)

kriging_pm10_post = autoKrige(spdf_post$pm10~1, spdf_post, sp_pts, model = "Exp")

plot(kriging_pm10_post)

