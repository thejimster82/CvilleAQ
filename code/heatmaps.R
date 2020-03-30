library(automap)
library(kriging)
library(rgdal)
library(spatstat)
library(maptools)
library(raster)
library(sp)

### SET WORKING DIRECTORY TO /data/tl_2019_51540_faces

df_pre <- read.csv("pre_means.csv")
df_post <- read.csv("post_means.csv")
df_diff <- read.csv("difference.csv")

#non-spatial parts of dataframe
data_pre = df_pre[,4:6]
data_post = df_post[,4:6]
data_diff = df_diff[,4:6]

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

#extracted coordinates from the shape file
cds = extractCoords(shp)

#converting to spatial data type
coordinates(df_pre) <- ~ longitude + latitude
coordinates(df_post) <- ~ longitude + latitude
coordinates(df_diff) <- ~ longitude + latitude

spdf_pre = SpatialPointsDataFrame(df_pre@coords, data_pre)
spdf_post = SpatialPointsDataFrame(df_post@coords, data_post)
spdf_diff = SpatialPointsDataFrame(df_post@coords, data_diff)

sp_pts <- SpatialPoints(cds)

#jimmy help me with a better palate i cant see thanks
colors <- colorRampPalette(c('yellow', 'red'))(8) 

### CO2 Maps
kriging_co2_pre = autoKrige(spdf_pre$co2~1, spdf_pre, sp_pts, model = "Exp")
plot(kriging_co2_pre)
automapPlot(kriging_co2_pre$krige_output, zcol="var1.pred", col.regions = colors, main = "CO2 pre-announcement heatmap")


kriging_co2_post = autoKrige(spdf_post$co2~1, spdf_post, sp_pts, model = "Exp")
plot(kriging_co2_post)
automapPlot(kriging_co2_post$krige_output, zcol="var1.pred", col.regions = colors, main = "CO2 post-announcement heatmap")


colors_co2_diff <- colorRampPalette(c('dark green', 'light green'))(8) 
kriging_co2_diff = autoKrige(spdf_diff$co2_diff~1, spdf_diff, sp_pts, model = "Exp")
plot(kriging_co2_diff)
automapPlot(kriging_co2_diff$krige_output, zcol="var1.pred", col.regions = colors_co2_diff, main = "CO2 change from before announcement")


### PM2.5 Maps
kriging_pm25_pre = autoKrige(spdf_pre$pm25~1, spdf_pre, sp_pts, model = "Exp")
plot(kriging_pm25_pre)
kriging_pm25_post = autoKrige(spdf_post$pm25~1, spdf_post, sp_pts, model = "Exp")
plot(kriging_pm25_post)
kriging_pm25_diff = autoKrige(spdf_diff$pm2_5_diff~1, spdf_diff, sp_pts, model = "Exp")
plot(kriging_pm25_diff)

### PM10 Maps
kriging_pm10_pre = autoKrige(spdf_pre$pm10~1, spdf_pre, sp_pts, model = "Exp")
plot(kriging_pm10_pre)
kriging_pm10_post = autoKrige(spdf_post$pm10~1, spdf_post, sp_pts, model = "Exp")
plot(kriging_pm25_post)
kriging_pm10_diff = autoKrige(spdf_diff$pm10_diff~1, spdf_diff, sp_pts, model = "Exp")
plot(kriging_pm25_diff)


