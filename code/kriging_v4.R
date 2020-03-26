library(automap)
library(kriging)
library(rgdal)
library(spatstat)
library(maptools)
library(raster)
library(sp)

### SET WORKING DIRECTORY TO /data/tl_2019_51540_faces

df <- read.csv("pre_means.csv")
df2 <- df
data = df[,4:6]
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

coordinates(df) <- ~ longitude + latitude

#proj4string(df) <- CRS("+init=epsg:4326")

#ext <- as(extent(df), "SpatialPolygons")
#r <- rasterToPoints(raster(ext, resolution = 30), spatial = TRUE)
#proj4string(r) <- proj4string(df)  

spdf = SpatialPointsDataFrame(df@coords, data)

spdf@data

proj4string(spdf) <- proj4string(r)

sp_pts <- SpatialPoints(a)

kriging_pm25 = autoKrige(spdf$pm25~1, spdf, sp_pts, model = "Exp")

plot(kriging_pm25)

kriging_pm10 = autoKrige(spdf$pm10~1, spdf, sp_pts, model = "Exp")

plot(kriging_pm10)
