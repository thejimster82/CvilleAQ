library(kriging)
<<<<<<< HEAD
library(rgdal)
library(spatstat)
library(maptools)
library(raster)
library(sp)
=======
library(sf)
library(ggplot2)
>>>>>>> f225f555fb3ca6a84e0cf4fe68b092a236973c86

c_tracks <- st_read('./data/census_tracks.shx')

ggplot() + 
  geom_sf(data = c_tracks, size = 3, color = "black", fill = "cyan1") + 
  ggtitle("AOI Boundary Plot") + 
  coord_sf()

<<<<<<< HEAD
long = c(-78.473602, -78.4919011, -78.515191, -78.51661, -78.48303, -78.469295, -78.479057, -78.484047)

lat = c(38.019983, 38.03562, 38.02758, 38.02557, 38.04745, 38.025759, 38.030613, 38.029883)

pm2_5 = c(1.707865, 3.800915, 1.611111, 1.977870, 2.125756, 2.442308, 2.935176, 1.951181)

pm10 = c(1.920507, 4.303371, 1.950673, 2.580524	, 2.398693, 2.583113, 3.286492, 2.142101)
=======
# boxes 3, 5, 6, 7, 8, 9, 10, 11
# latitude coords from 38.00 to 38.08
# longitute coords from -78.53 to -78.45

AQ <- read.table('./code/pm_na_new.csv', header = TRUE,  sep = ',',  stringsAsFactors = FALSE)
AQ_subset <- subset(AQ, select=-c(X,temp,humidity,latitude,longitude,fdt))
AQ_subset_means <- aggregate(AQ_subset[, 0:3], list(AQ_subset$dev_id), mean, na.rm = TRUE)
x = c(.01998, .03562, .02758, .02557, .04745, .02576, .03061, .02988)
y = c(.0564, .0381, .01481, .01339, .04697, .0607, .05094, .04595)
response_pm25 = AQ_subset_means$pm25[-2]
response_pm10 = AQ_subset_means$pm10[-2]
response_pmco2 = AQ_subset_means$co2[-2]
>>>>>>> f225f555fb3ca6a84e0cf4fe68b092a236973c86

co2 = c(431.254675, 496.498385, 225.677387, 543.795502, 575.115702, 316.401837, 477.587446, 494.818579)

<<<<<<< HEAD
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

	
	
	
	
	
	

=======
krigpm25 = kriging(x, y, response_pm25, model = "spherical", lags = 4, pixels = 100, polygons = NULL)
plot(krigpm25)
image(krigpm25, xlab = "latitude from 38.00 to 38.08", ylab = "longitude from -78.53 to -78.45")

krigpm10 = kriging(x, y, response_pm10, model = "spherical", lags = 4, pixels = 100, polygons = NULL)
plot(krigpm10)
image(krigpm10, xlab = "latitude from 38.00 to 38.08", ylab = "longitude from -78.53 to -78.45")

krigco2 = kriging(x, y, response_pmco2, model = "spherical", lags = 4, pixels = 100, polygons = NULL)
plot(krigco2)
image(krigco2, xlab = "latitude from 38.00 to 38.08", ylab = "longitude from -78.53 to -78.45")
points(x,y, pch=16)
>>>>>>> f225f555fb3ca6a84e0cf4fe68b092a236973c86
