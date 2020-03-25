library(kriging)
library(rgdal)
library(spatstat)
library(maptools)
library(raster)
library(sp)

# boxes 3, 5, 6, 7, 8, 9, 10, 11

long = c(-78.473602, -78.4919011, -78.515191, -78.51661, -78.48303, -78.469295, -78.479057, -78.484047)

lat = c(38.019983, 38.03562, 38.02758, 38.02557, 38.04745, 38.025759, 38.030613, 38.029883)

pm2_5 = c(1.707865, 3.800915, 1.611111, 1.977870, 2.125756, 2.442308, 2.935176, 1.951181)

pm10 = c(1.920507, 4.303371, 1.950673, 2.580524	, 2.398693, 2.583113, 3.286492, 2.142101)

co2 = c(431.254675, 496.498385, 225.677387, 543.795502, 575.115702, 316.401837, 477.587446, 494.818579)

shape <- readOGR("municipal_boundary_area_03_12_2020.shp")

plot(shape)

extent(shape)

# Transforming to lat/long coord system from lambert conformal conic
shpLL = spTransform(shape, "+init=epsg:4326")

extent(shpLL)
       
krig = kriging(long, lat, pm2_5, model = "spherical", lags = 4, pixels = 100, polygons = NULL)       
image(krig, xlab = "longitude", ylab = "latitude", xlim = c(-78.53, -78.44), ylim = c(38.00, 38.08), main="PM 2.5 Heatmap")
points(long,lat,pch=16)       
plot(shpLL, add=T) 

krig2 = kriging(long, lat, pm10, model = "spherical", lags = 4, pixels = 100, polygons = NULL) 

image(krig2, xlab = "longitude", ylab = "latitude", xlim = c(-78.53, -78.44), ylim = c(38.00, 38.08), main="PM 10 Heatmap")
points(long,lat,pch=16)       
plot(shpLL, add=T)   

krig3 = kriging(long, lat, co2, model = "spherical", lags = 4, pixels = 100, polygons = NULL) 
       
image(krig3, xlab = "longitude", ylab = "latitude", xlim = c(-78.53, -78.44), ylim = c(38.00, 38.08), main="CO2 Heatmap")
points(long,lat,pch=16)       
plot(shpLL, add=T)   

	
	
	
	
	
	

