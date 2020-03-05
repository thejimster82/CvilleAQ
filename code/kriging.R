library(kriging)

# boxes 3, 5, 6, 7, 8, 9, 10, 11

# latitude coords from 38.00 to 38.08
# longitute coords from -78.53 to -78.45



x = c(.01998, .03562, .02758, .02557, .04745, .02576, .03061, .02988)
y = c(.0564, .0381, .01481, .01339, .04697, .0607, .05094, .04595)
response = c(1.707865, 3.800915, 1.611111, 1.977870, 2.125756, 2.442308, 2.935176, 1.951181)


krig = kriging(x, y, response, model = "spherical", lags = 4, pixels = 100, polygons = NULL)

plot(krig)

image(krig, xlab = "latitude from 38.00 to 38.08", ylab = "longitude from -78.53 to -78.45")
