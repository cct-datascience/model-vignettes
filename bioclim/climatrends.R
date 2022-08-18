library(climatrends)
library(lubridate)
sites <- read.csv("sites.csv")

latlon <- data.frame(lon = sites$lon, lat = sites$lat)
# lonlat <- data.frame(lon = 129.19,
#                      lat = 36.39)

# GDD(lonlat, 
#     day.one = "2019-04-01",
#     last.day = "2019-10-01",
#     degree.days = 150, 
#     return.as = "ndays")

crop_sensitive(latlon, 
               day.one = "2019-04-01",
               last.day = "2019-10-01",
               degree.days = 150, 
               return.as = "ndays")
