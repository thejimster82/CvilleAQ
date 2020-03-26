library(automap)
library(kriging)
library(rgdal)
library(spatstat)
library(maptools)
library(raster)
library(sp)
library(rlist)

# boxes 3, 5, 6, 7, 8, 9, 10, 11

long = c(-78.473602, -78.4919011, -78.515191, -78.51661, -78.48303, -78.469295, -78.479057, -78.484047)

lat = c(38.019983, 38.03562, 38.02758, 38.02557, 38.04745, 38.025759, 38.030613, 38.029883)

pm2_5 = c(1.707865, 3.800915, 1.611111, 1.977870, 2.125756, 2.442308, 2.935176, 1.951181)

pm10 = c(1.920507, 4.303371, 1.950673, 2.580524	, 2.398693, 2.583113, 3.286492, 2.142101)

co2 = c(431.254675, 496.498385, 225.677387, 543.795502, 575.115702, 316.401837, 477.587446, 494.818579)

shape <- readOGR("tl_2019_51540_faces.shp")

shp = shape@polygons
shp = SpatialPolygons(shp, proj4string=CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))

plot(shp)


extent(shp)

df2 <- data.frame("long" = long, "lat" = lat)

  
  
p <- list(data.frame(shp@data))



# Transforming to lat/long coord system from lambert conformal conic
#shpLL = spTransform(shape, "+init=epsg:4326")

#extent(shpLL)

shp@polygons

shp@polygons[[1]]@Polygons[[1]]

shape@polygons

df<- data.frame(id = getSpPPolygonsIDSlots(shp))
row.names(df) <- getSpPPolygonsIDSlots(shp)

bound = shp@polygons
bound = SpatialPolygons(bound)

res <- list()

list.append(res, c(1,2))
list.append(res, c(1,2))
list.append(res, c(1,2))

res[[1]] <- Reduce(rbind, shp@polygons[[1000]]@Polygons[[1]]@coords)

length(shp@polygons[[1]]@Polygons)

library(maps)
usa <- map("usa", "main", plot = FALSE)
p <- list(data.frame(usa$x, usa$y))

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
p <- list(data.frame(a))

# Make spatial polygon data frame
spdf <- SpatialPolygonsDataFrame(shp, data =df)
       
krig = kriging(long, lat, pm2_5, model = "spherical", lags = 4, pixels = 200, polygons = p)       
image(krig, xlab = "longitude", ylab = "latitude", xlim = c(-78.53, -78.44), ylim = c(38.00, 38.08), main="PM 2.5 Heatmap")
points(long,lat,pch=16)       
plot(shape, add=T) 

krig2 = kriging(long, lat, pm10, model = "spherical", lags = 4, pixels = 100, polygons = NULL) 

image(krig2, xlab = "longitude", ylab = "latitude", xlim = c(-78.53, -78.44), ylim = c(38.00, 38.08), main="PM 10 Heatmap")
points(long,lat,pch=16)       
plot(shape, add=T)   

krig3 = kriging(long, lat, co2, model = "spherical", lags = 4, pixels = 100, polygons = NULL) 
       
image(krig3, xlab = "longitude", ylab = "latitude", xlim = c(-78.53, -78.44), ylim = c(38.00, 38.08), main="CO2 Heatmap")
points(long,lat,pch=16)       
plot(shape, add=T)   


df1 <- data.frame(a)

gridded(df1) = ~X1+X2	

coordinates(df2) <- ~ long + lat

df2 <- SpatialPointsDataFrame(df2, as.data.frame(pm2_5))

shape_proj<-st_transform(shape, CRS("+proj=gnom +lat_0=90 +lon_0=-50"))

pm <- data.frame(pm = pm2_5)

ab = SpatialPointsDataFrame(df@coords, pm)

bc = SpatialPoints(a)

kg = autoKrige(pm~1, ab, bc, model = "Gau")	

plot(kg)
	
	
	

