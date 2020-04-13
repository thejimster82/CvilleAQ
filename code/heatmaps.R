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

#Define percent change columns
df_diff$co2_pctcng <- 0
df_diff$pm25_pctcng <- 0
df_diff$pm10_pctcng <- 0

#Populate percent change columns
for (i in 1:length(df_pre[,1])){
  df_diff$co2_pctcng[i] <- 100*(df_post$co2[i] - df_pre$co2[i]) / df_pre$co2[i]
  df_diff$pm25_pctcng[i] <- 100*(df_post$pm25[i] - df_pre$pm25[i]) / df_pre$pm25[i]
  df_diff$pm10_pctcng[i] <- 100*(df_post$pm10[i] - df_pre$pm10[i]) / df_pre$pm10[i]
}

#non-spatial parts of dataframe
data_pre = df_pre[,4:6]
data_post = df_post[,4:6]
data_diff = df_diff[,4:9]

shape <- readOGR("tl_2019_51540_faces.shp")
shp = shape@polygons
shp = SpatialPolygons(shp, proj4string=CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))

shapeAlbemarle <- readOGR("tl_2019_51003_faces.shp")

extractCoords <- function(sp.df)
{
  results <- list()
  for(i in 1:length(sp.df@polygons[[1]]@Polygons))
  {
    for(j in 1:length(sp.df))
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

colors <- colorRampPalette(c('blue', 'green', 'red'))(10) 

### CO2 Maps
kriging_co2_pre = autoKrige(spdf_pre$co2~1, spdf_pre, sp_pts, model = "Exp")
plot(kriging_co2_pre, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_co2_pre$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean CO2 pre-announcement heatmap (ppm)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


kriging_co2_post = autoKrige(spdf_post$co2~1, spdf_post, sp_pts, model = "Exp")
plot(kriging_co2_post, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_co2_post$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean CO2 post-announcement heatmap (ppm)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


colors_co2_diff <- colorRampPalette(c('dark blue', 'light blue'))(8) 
kriging_co2_diff = autoKrige(spdf_diff$co2_pctcng~1, spdf_diff, sp_pts, model = "Exp")
plot(kriging_co2_diff, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_co2_diff$krige_output, zcol="var1.pred", col.regions = colors_co2_diff, main = "Mean CO2 percent change from before announcement (ppm)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))

### PM2.5 Maps
kriging_pm25_pre = autoKrige(spdf_pre$pm25~1, spdf_pre, sp_pts, model = "Exp")
plot(kriging_pm25_pre, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_pm25_pre$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean PM2.5 pre-announcement heatmap (µg/m³)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


kriging_pm25_post = autoKrige(spdf_post$pm25~1, spdf_post, sp_pts, model = "Exp")
plot(kriging_pm25_post, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_pm25_post$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean PM2.5 post-announcement heatmap (µg/m³)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


kriging_pm25_diff = autoKrige(spdf_diff$pm25_pctcng~1, spdf_diff, sp_pts, model = "Exp")
plot(kriging_pm25_diff, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_pm25_diff$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean PM2.5 percent change from before announcement (µg/m³)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


### PM10 Maps
kriging_pm10_pre = autoKrige(spdf_pre$pm10~1, spdf_pre, sp_pts, model = "Exp")
plot(kriging_pm10_pre, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_pm10_pre$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean PM10 pre-announcement heatmap (µg/m³)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


kriging_pm10_post = autoKrige(spdf_post$pm10~1, spdf_post, sp_pts, model = "Exp")
plot(kriging_pm10_post, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_pm10_post$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean PM10 post-announcement heatmap (µg/m³)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))


kriging_pm10_diff = autoKrige(spdf_diff$pm10_pctcng~1, spdf_diff, sp_pts, model = "Exp")
plot(kriging_pm10_diff, sp.layout =  list(pts = list("sp.points", df_pre)))
automapPlot(kriging_pm10_diff$krige_output, zcol="var1.pred", col.regions = colors, main = "Mean PM10 percent change from before announcement (µg/m³)", sp.layout = list(pts = list("sp.points", df_pre, col = "black", pch = 18, cex = 1.6), list(shapeAlbemarle, fill="grey"), shape, pts=list("sp.points", df_pre, col = "orange", pch = 18, cex = 1.2)))
