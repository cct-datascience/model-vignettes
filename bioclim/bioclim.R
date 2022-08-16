library(raster)
library(sp)

r <- getData("worldclim", var = "bio", res = 10) 
# 10 min of a degree
#    ~=11 mi lat; ~=10 mi lon at equator
#    other values could be 0.5, 2.5, 5
#    https://gis.stackexchange.com/a/227595/1239
#    https://rpubs.com/spoonerf/SDM2

bioclim_names <-
  c(
    "mean_annual_temp", 
    "mean_diurnal_range", 
    "isothermality",
    "temp_seasonality", 
    "max_temp_warmest month", "min_temp_coldest_month",
    "temp_annual_range", 
    "mean_temp_wettest_quarter", "mean_temp_driest_quarter",
    "mean_temp_warmest_quarter", "mean_temp_coldest_quarter", 
    "mean_annual_precip",
    "precip_wettest_month", 
    "precip_driest_month", 
    "precip_seasonality",
    "precip_wettest_quarter", "precip_driest_quarter", 
    "precip_warmest_quarter",
    "precip_coldest_quarter"
  )


sites <- read.csv("sites.csv")
coords <- data.frame(x = sites$lon, y = sites$lat)
points <- SpatialPoints(coords, proj4string = r@crs)
values <- extract(r, points)

colnames(values) <- bioclim_names
d <- cbind(sites, values)
