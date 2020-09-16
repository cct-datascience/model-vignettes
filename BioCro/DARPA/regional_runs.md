How to Do Regional Runs on DARPA Data Using BioCro Model
================
Author: Kristina Riemer

## Read in libraries

``` r
library(ncdf4)
library(PEcAn.all)
```

    ## Loading required package: PEcAn.DB

    ## Loading required package: PEcAn.settings

    ## Loading required package: PEcAn.MA

    ## Loading required package: XML

    ## Loading required package: lattice

    ## Loading required package: MASS

    ## Loading required package: PEcAn.utils

    ## 
    ## Attaching package: 'PEcAn.utils'

    ## The following object is masked from 'package:utils':
    ## 
    ##     download.file

    ## Loading required package: PEcAn.logger

    ## 
    ## Attaching package: 'PEcAn.logger'

    ## The following objects are masked from 'package:PEcAn.utils':
    ## 
    ##     logger.debug, logger.error, logger.getLevel, logger.info,
    ##     logger.setLevel, logger.setOutputFile, logger.setQuitOnSevere,
    ##     logger.setWidth, logger.severe, logger.warn

    ## Loading required package: PEcAn.uncertainty

    ## Loading required package: PEcAn.priors

    ## Loading required package: ggplot2

    ## Loading required package: ggmap

    ## Google's Terms of Service: https://cloud.google.com/maps-platform/terms/.

    ## Please cite ggmap if you use it! See citation("ggmap") for details.

    ## Loading required package: gridExtra

    ## 
    ## Attaching package: 'PEcAn.uncertainty'

    ## The following objects are masked from 'package:PEcAn.utils':
    ## 
    ##     get.ensemble.samples, read.ensemble.output, write.ensemble.configs

    ## Loading required package: PEcAn.data.atmosphere

    ## Loading required package: PEcAn.data.land

    ## Loading required package: datapack

    ## Loading required package: dataone

    ## Loading required package: redland

    ## Loading required package: sirt

    ## - sirt 3.5-53 (2019-06-20 10:09:28)

    ## Loading required package: sf

    ## Linking to GEOS 3.7.2, GDAL 2.4.2, PROJ 5.2.0

    ## Loading required package: PEcAn.data.remote

    ## Loading required package: PEcAn.assim.batch

    ## Loading required package: PEcAn.emulator

    ## Loading required package: mvtnorm

    ## Loading required package: mlegp

    ## Loading required package: MCMCpack

    ## Loading required package: coda

    ## ##
    ## ## Markov Chain Monte Carlo Package (MCMCpack)

    ## ## Copyright (C) 2003-2020 Andrew D. Martin, Kevin M. Quinn, and Jong Hee Park

    ## ##
    ## ## Support provided by the U.S. National Science Foundation

    ## ## (Grants SES-0350646 and SES-0350613)
    ## ##

    ## Loading required package: PEcAn.benchmark

    ## Loading required package: PEcAn.remote

    ## Loading required package: PEcAn.workflow

    ## 
    ## Attaching package: 'PEcAn.workflow'

    ## The following objects are masked from 'package:PEcAn.utils':
    ## 
    ##     do_conversions, run.write.configs, runModule.run.write.configs

``` r
library(PEcAn.BIOCRO)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following object is masked from 'package:gridExtra':
    ## 
    ##     combine

    ## The following object is masked from 'package:MASS':
    ## 
    ##     select

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(ncdf.tools)
library(ggplot2)
library(maps)
library(speciesgeocodeR)
```

    ## Loading required package: sp

``` r
library(rgdal)
```

    ## rgdal: version: 1.4-4, (SVN revision 833)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 2.1.3, released 2017/20/01
    ##  Path to GDAL shared files: /Library/Frameworks/R.framework/Versions/3.6/Resources/library/sf/gdal
    ##  GDAL binary built with GEOS: FALSE 
    ##  Loaded PROJ.4 runtime: Rel. 4.9.3, 15 August 2016, [PJ_VERSION: 493]
    ##  Path to PROJ.4 shared files: /Library/Frameworks/R.framework/Versions/3.6/Resources/library/sf/proj
    ##  Linking to sp version: 1.3-1

``` r
library(maptools)
```

    ## Checking rgeos availability: TRUE

``` r
library(gganimate)
```

## Read in input files

The config file here is based on [the default *Setaria*
file](https://github.com/PecanProject/pecan/blob/ac5aef2e755a8961591196428753eb184fb4c6cb/models/biocro/inst/extdata/defaults/setaria.xml)
used for PEcAn. This one was generated from a run on the Sentinel
project data.

``` r
config <- read.biocro.config("biocro_regional_darpa_files/config.xml")
```

A weather data file, such as that read in below, is required to run
BioCro. The weather data comes from [the North American Regional
Reanalysis
(NARR)](https://www.esrl.noaa.gov/psd/data/gridded/data.narr.html)
global gridded dataset provided by NOAA. We are using a subset of NARR
in the eastern part of Illinois, near Chapaign. This subset is in the
Pecan standard format, which is a netCDF file. The dimensions are
latitude x longitude x time (3 x 6 x 93,504). These time steps are every
three hours from 1979 through 2010. There are 10 weather variables,
including temperature, precipitation flux, and solar radiation.

We also read in a soil file, which is not necessary but is useful. These
data are from [the harmonized world soil
database](http://www.fao.org/soils-portal/soil-survey/soil-maps-and-databases/harmonized-world-soil-database-v12/en/).

``` r
metfile <- "biocro_regional_darpa_files/chiruss.nc"
met_chiruss <- nc_open(metfile)
soil_nc <- nc_open("biocro_regional_darpa_files/hwsd.nc")
```

## Convert weather data

The weather dataset has to be converted from netCDF file format to the
format required for BioCro. Data for each of the locations (unique
latitude and longitude combinations) is turned into a flat csv file,
with one row per hour for the time range of the weather dataset
(approximately 32 years).

``` r
# Get all locations
lat <- ncvar_get(met_chiruss, "latitude")
lon <- ncvar_get(met_chiruss, "longitude")
latlon <- expand.grid(lat = lat, lon = lon)

# Get met conversion inputs that apply across all locations
time_vec <- ncvar_get(met_chiruss, "time")
time_origin1 <- ncatt_get(met_chiruss, "time", "units")
time_origin2 <- gsub( ".*(\\d{4}-\\d{2}-\\d{2}).*", "\\1", time_origin1$value)
start_date <- as.Date(time_origin2) + time_vec[1]
end_date <- as.Date(time_origin2) + time_vec[length(time_vec)] - 1

# Convert met from Pecan to BioCro format for all locations
dir.create("biocro_regional_darpa_files/biocro_met_by_location/")
met_nc <- ncdf4::nc_open(metfile)
point <- 1
biocro_met_locations <- c()
for(point in 1:nrow(latlon)){
  met <- load.cfmet(met_nc, lat = latlon$lat[point], lon = latlon$lon[point],
                    start.date = start_date, end.date = end_date)
  met_hourly <- cfmet.downscale.time(met, output.dt = 1)
  biocro_met <- cf2biocro(met_hourly)
  biocro_met <- biocro_met %>%
    mutate(RH = case_when(RH >= 1 ~ 0.99999999999999,
                          RH < 1 ~ RH))
  biocro_met_location <- biocro_met %>% 
    mutate(latitude = latlon$lat[point], 
           longitude = latlon$lon[point])
  biocro_met_locations <- rbind(biocro_met_locations, biocro_met_location)
  biocro_met_path <- paste0("biocro_regional_darpa_files/biocro_met_by_location/biocromet-", 
                            latlon$lat[point], "-", latlon$lon[point], ".2010.csv")
  write.csv(biocro_met, biocro_met_path, row.names = FALSE)
}
```

We plot the first day of all the weather data variables to examine the
daily patterns in them.

``` r
biocro_met_plot <- biocro_met_locations %>% 
  tidyr::unite(latitudelongitude, latitude:longitude) %>% 
  mutate(date = as.Date(paste0(year, "-01-01")) - 1 + doy, 
         time = case_when(
           hour < 10 ~ paste0("0", hour, ":00"), 
           hour >= 10 ~ paste0(hour, ":00")
         ), 
         datetime_gmt = as.POSIXct(paste(date, time), tz = "GMT"), 
         datetime = as.POSIXct(format(datetime_gmt, tz = "America/Chicago")), 
         date = as.Date(datetime, tz = "America/Chicago"), 
         year_plot = format(date, "%Y"), 
         latitudelongitude = as.factor(latitudelongitude)) 

biocro_met_plot_year <- biocro_met_plot %>% 
  filter(year_plot == 1995 & latitudelongitude == "40.375_-87.875") %>%
  select(datetime, latitudelongitude, solar:precip) %>% 
  tidyr::gather(weather_var, weather_value, solar:precip)
  
ggplot(biocro_met_plot_year, aes(x = datetime, y = weather_value, color = latitudelongitude)) +
  geom_line() +
  facet_wrap(~weather_var, scales = "free_y")

biocro_met_plot_day <- biocro_met_plot %>% 
  filter(date == as.Date("1979-06-01")) %>% 
  select(datetime, latitudelongitude, solar:precip) %>% 
  tidyr::gather(weather_var, weather_value, solar:precip)

ggplot(biocro_met_plot_day, aes(x = datetime, y = weather_value, color = latitudelongitude)) +
  geom_line() +
  facet_wrap(~weather_var, scales = "free_y")
```

## Run BioCro on each location

The BioCro model is then run on weather and soil data for each of the
locations, using *Setaria* input data. This produces hourly, daily, and
yearly estimates for biomass, transpiration, etc. for the time range we
specified in the config file. We are using only the daily values.

``` r
dir.create("biocro_regional_darpa_files/results_by_location/")
biocro_results <- c()
for(point in 1:nrow(latlon)){
  biocro_met_path <- paste0("biocro_regional_darpa_files/biocro_met_by_location/biocromet-", 
                            latlon$lat[point], "-", latlon$lon[point])
  biocro_results_all <- run.biocro(latlon$lat[point], latlon$lon[point],
                               metpath = biocro_met_path,
                               soil.nc = soil_nc,
                               config = config)
  biocro_results_daily <- biocro_results_all$daily
  write.csv(biocro_results_daily, paste0("biocro_regional_darpa_files/results_by_location/daily-", 
                                         latlon$lat[point], "-", latlon$lon[point], ".csv"))
  biocro_results_daily$lat <- latlon$lat[point]
  biocro_results_daily$lon <- latlon$lon[point]
  biocro_results <- rbind(biocro_results, biocro_results_daily)
  write.csv(biocro_results, "biocro_regional_darpa_files/all_biocro_results.csv")
}
```

## Plot estimated biomass

The results for total biomass (the sum of stem, leaf, grain, rhizome,
and root biomasses) are then
visualized.

``` r
biocro_results <- read.csv("biocro_regional_darpa_files/chiruss_results/all_biocro_results.csv")
biocro_results <- biocro_results %>% 
  mutate(date = as.Date(doy, "2009-12-31"), 
         latlon = paste0(lat, lon), 
         total_biomass = Stem + Leaf + Root + Rhizome + Grain)

ggplot(biocro_results, aes(x = date, y = total_biomass, group = latlon, color = latlon)) +
  geom_line() +
  theme(legend.position = "none")
```

    ## Warning: Removed 364 rows containing missing values (geom_path).

![](biocro_regional_darpa_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

This map shows where the locations are in the two countries

``` r
overall_map <- map_data("world") %>% 
  filter(region == "China" | region == "Russia")

ggplot() +
  geom_polygon(data = overall_map, aes(x = long, y = lat, group = group), 
               fill = "white", color = "black") +
  geom_raster(data = biocro_results, aes(x = lon, y = lat), fill = "red") +
  coord_quickmap()
```

![](biocro_regional_darpa_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

This map shows the locations closer up with the nearby ecoregions
plotted in various colors.

``` r
ecoregions_background <- map_data("world") %>% 
  filter(region == "China" | region == "Russia") 

ecoregions <- readOGR(file.path("biocro_regional_darpa_files", 
                                                "WWF_ecoregions", "official", 
                                                "wwf_terr_ecos.shp"))
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/Users/kristinariemer/Dropbox/Documents/UofA/Projects/Group/model-vignettes/BioCro/DARPA/biocro_regional_darpa_files/WWF_ecoregions/official/wwf_terr_ecos.shp", layer: "wwf_terr_ecos"
    ## with 14458 features
    ## It has 21 fields

``` r
ecoregions@data$id <- rownames(ecoregions@data)
ecoregions_points <- fortify(ecoregions, region = "id")
```

    ## Warning in RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid"): Ring Self-
    ## intersection at or near point -53.266666579999999 2.4331516999999998

    ## SpP is invalid

    ## Warning in rgeos::gUnaryUnion(spgeom = SpP, id = IDs): Invalid objects found;
    ## consider using set_RGEOS_CheckValidity(2L)

``` r
ecoregions_df <- plyr::join(ecoregions_points, ecoregions@data, by = "id")
ecoregions_df_chiruss <- ecoregions_df %>% 
   filter(lat > 20 & lat < 80,
          long > 60 & long < 130)

ggplot() +
  geom_polygon(data = ecoregions_df_chiruss, aes(long, lat, group = group, fill = ECO_NAME)) +
  geom_polygon(data = ecoregions_background, aes(x = long, y = lat, group = group), fill = NA, color = "black") +
  geom_raster(data = biocro_results, aes(x = lon, y = lat), fill = "red") +
  coord_cartesian(xlim = c(mean(biocro_results$lon) - 20, mean(biocro_results$lon) + 20), 
                  ylim = c(min(biocro_results$lat) - 5, max(biocro_results$lat) + 5)) +
  theme(legend.position = "none")
```

![](biocro_regional_darpa_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

The final map plots estimated biomass values for the 160 locations on
this zoomed in map of east Asia, running through each day’s values.

``` r
gif_background <- map_data("world") %>% 
  filter(region == "China" | region == "Russia")

colfunc <- colorRampPalette(c("yellow", "darkgreen"))
biomass_animation <- ggplot() +
  geom_polygon(data = gif_background, aes(x = long, y = lat, group = group), 
               fill = "white", color = "black") +
  geom_raster(data = biocro_results, aes(x = lon, y = lat, fill = total_biomass)) +
    coord_cartesian(xlim = c(mean(biocro_results$lon) - 20, mean(biocro_results$lon) + 20), 
                  ylim = c(min(biocro_results$lat) - 5, max(biocro_results$lat) + 5)) +
  scale_fill_gradientn(colors = colfunc(10)) +
  transition_manual(doy) +
  ggtitle('Day: {current_frame}')

animate(biomass_animation, fps = 100)
```

![](biocro_regional_darpa_files/figure-gfm/unnamed-chunk-10-1.gif)<!-- -->

``` r
anim_save("biomass_animation_chiruss.gif", animation = biomass_animation, 
          path = "biocro_regional_darpa_files/", fps = 100)
```
