library(daymetr)
library(dplyr)

sites <- readr::read_csv('sites.csv')

mets <- list()
for(i in 1:nrow(sites)){
    site <- sites[i,]
    tmp <- 
        download_daymet(
                    site = site$name,
                    lat = site$lat, 
                    lon = site$lon, 
                    start = year(ymd(site$start)), 
                    end = year(ymd(site$end))
                    )
    mets[[site$name]] <- cbind(site = tmp$site,
                               lat = tmp$lat,
                               lon = tmp$longitude,
                               alt = tmp$altitude,
                               tmp$data)
}

m <- dplyr::bind_rows(mets)
write_csv(m, file = 'daymet.csv')

mymean <- function(x) {
    a <- mean(x, na.rm = TRUE)
    b <- signif(a, 4)
    return(b)
}
d <- m  %>% 
  group_by(site, year, alt) %>%
  summarise(
    mean_temp = mymean((tmax..deg.c. + tmin..deg.c.)/2),
    mean_vpd = mymean(vp..Pa.),
    mean_precip = mymean(prcp..mm.day.),
    mean_srad = mymean(srad..W.m.2.),
    mean_swe = mymean(swe..kg.m.2.),
    mean_dayl = mymean(dayl..s.)/86400)

write_csv(d, file = 'daymet_annual.csv')
