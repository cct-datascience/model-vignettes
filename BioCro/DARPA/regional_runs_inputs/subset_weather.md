How to Subset Large netCDF Weather Data Files
================
Author: Kristina Riemer

## Data file information

These instructions walk through how to subset the NARR `all.nc` file.
This data file is on Globus [in the UA Field Scanner
collection](https://app.globus.org/file-manager?origin_id=cbae3a96-d081-4951-bd1e-a8fda974cefa&origin_path=%2Fmet%2Fnarr%2Fthreehourly%2F).
The file is ~650GB. These data do not have global coverage, but are
rather restricted to the northern hemisphere as below:

  - Latitudinal range: 10.125 - 83.875
  - Longitudinal range: -169.875 to -50.125

The entire global file is the CRUNCEP `all.nc`, which is ~1.3TB and in
the same Globus collection [in a different
location](https://app.globus.org/file-manager?origin_id=cbae3a96-d081-4951-bd1e-a8fda974cefa&origin_path=%2Fmet%2Fcruncep%2F).
We will need more data space on the HPC to subset this global data file
because the upper limit for HPC data storage is currently 1TB.

## Subsetting process

### 1\. Copy entire data file onto HPC

First increase data space by requesting an xdisk allocation on the HPC.
Go to [the HPC web
interface](https://ood.hpc.arizona.edu/pun/sys/dashboard), and open up
the terminal by clicking on Files -\> Home Directory -\> Open in
terminal -\> Ocelote. Use `xdisk -c create -m 1000` to get 1TB of space.

Open up the `all.nc` file on Globus using the link above. Then open up
the HPC collection, which is called `arizona#sdmz-dtn`. Navigate to the
new terrabyte of space in this collection at `/xdisk/username/`. Use the
“Start” button to initiate transfer, which will take about an hour. Also
transfer `champaign.nc` if desired.

### 2\. Determine desired dimensions

Use the following plotting functionality in R to figure out which
latitudes and longitudes to clip the weather data to.

``` r
library(ncdf4)
library(dplyr)
library(maps)
library(ggplot2)
```

The first example shows the four corners of a long latitudinal slice
that includes area in both China and Russia. Change out the `lat` and
`lon` values in the data frame and the filtered region in the
`background_map` as desired.

``` r
chiruss_corners = expand.grid(lat = c(44.9, 55.1), 
                             lon = c(123.9, 127.1))
background_map <- map_data("world") %>% 
  filter(region == "China" | region == "Russia")
ggplot() +
  geom_polygon(data = background_map, aes(x = long, y = lat, group = group), fill = "white", color = "black") +
  geom_point(data = chiruss_corners, aes(x = lon, y = lat), color = "red")
```

![](subset_weather_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

This plot shows the limits of the NARR `all.nc` file.

``` r
narr_all_corners = expand.grid(lat = c(10.125, 83.875), 
                             lon = c(-169.875, -50.125))
background_map <- map_data("world")
ggplot() +
  geom_polygon(data = background_map, aes(x = long, y = lat, group = group), fill = "white", color = "black") +
  geom_point(data = narr_all_corners, aes(x = lon, y = lat), color = "red")
```

![](subset_weather_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

### 3\. Use nco to subset file

Navigate in the HPC web interface to `/xdisk/username/`. The .nc files
should be there now. You can see the subsetting command by looking at
the first line under history after running this:

``` shell
ncdump -h champaign.nc | grep ':history'
```

The command is below. This is what was used to generate `champaign.nc`
from `all.nc`, and will be the basis for creating new subsets. The
`ncks` arguments -O is for overwrite, and -d is for dimensions for
specified
variables.

``` shell
ncks -O -d longitude,-88.9,-87.5 -d latitude,39.8,40.5 all.nc champaign.nc
```

The following are modified commands for different weather subsets,
including new file names.

Eastern Illinois:

``` shell
ncks -O -d longitude,-88.9,-87.5 -d latitude,38.8,41.5 all.nc eaill.nc
```

USA/Canada:

``` shell
ncks -O -d longitude,-108.5,-105.5 -d latitude,45.5,55.5 all.nc usca.nc
```

Russia/China (*this will only work with CRUNCEP all.nc data file*):

``` shell
ncks -O -d longitude,123.9,127.1 -d latitude,44.9,55.1 all.nc chiruss.nc
```

### 4\. Copy to local machine using Globus

Once the desired subset has been generated, you will need to transfer
the file from the HPC collection `arizona#sdmz-dtn` on Globus to your
own endpoint. This will require downloading Globus Connect Personal.
From the [Globus Connect Personal
website](https://www.globus.org/globus-connect-personal), select the
link for your operating system and follow the instructions on that page
to create an endpoint on your machine.

Once this is ready, select the file on the HPC collection and click the
“Start” button to transfer to your local selected location. This can
take an hour for for files 3-4GB in size.

### 5\. Check that dimensions are correct

Use the following example R code to plot all the locations in a
transferred data subset. Each location gets a randomly chosen value, not
from the weather data itself. The `background_map` may need to be
modified depending on where on the globe the values are.

Champaign:

``` r
champaign <- nc_open("champaign.nc")
champaign_latlon <- expand.grid(lat = ncvar_get(champaign, "latitude"), 
                                lon = ncvar_get(champaign, "longitude"))
champaign_latlon$value <- sample(1:nrow(champaign_latlon), nrow(champaign_latlon))
background_map <- map_data("state") %>% 
  filter(region == "illinois")

ggplot() +
  geom_polygon(data = background_map, aes(x = long, y = lat, group = group), 
               fill = "white", color = "black") +
  geom_raster(data = champaign_latlon, aes(x = lon, y = lat, fill = value)) +
  coord_quickmap()
```

![](subset_weather_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Eastern Illinois:

``` r
eaill <- nc_open("eaill.nc")
eaill_latlon <- expand.grid(lat = ncvar_get(eaill, "latitude"), 
                                lon = ncvar_get(eaill, "longitude"))
eaill_latlon$value <- sample(1:nrow(eaill_latlon), nrow(eaill_latlon))
background_map <- map_data("state") %>% 
  filter(region == "illinois")

ggplot() +
  geom_polygon(data = background_map, aes(x = long, y = lat, group = group), 
               fill = "white", color = "black") +
  geom_raster(data = eaill_latlon, aes(x = lon, y = lat, fill = value)) +
  coord_quickmap()
```

![](subset_weather_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

USA/Canada:

``` r
usca <- nc_open("usca.nc")
usca_latlon <- expand.grid(lat = ncvar_get(usca, "latitude"), 
                                lon = ncvar_get(usca, "longitude"))
usca_latlon$value <- sample(1:nrow(usca_latlon), nrow(usca_latlon))
background_map <- map_data("world") %>% 
  filter(region == "USA" | region == "Canada")

ggplot() +
  geom_polygon(data = background_map, aes(x = long, y = lat, group = group), 
               fill = "white", color = "black") +
  geom_raster(data = usca_latlon, aes(x = lon, y = lat, fill = value)) +
  coord_quickmap() +
  lims(x = c(-150, -50), y = c(20, 80))
```

![](subset_weather_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->
