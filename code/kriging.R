library(kriging)
library(sf)
library(ggplot2)

c_tracks <- st_read('./data/census_tracks.shx')

ggplot() + 
  geom_sf(data = c_tracks, size = 3, color = "black", fill = "cyan1") + 
  ggtitle("AOI Boundary Plot") + 
  coord_sf()

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