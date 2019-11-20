How to Do Biomass Partitioning on DARPA Data Using BioCro Model
================
Kristina Riemer, University of Arizona

For biomass partitioning using
[`OpBioGro`](https://github.com/ebimodeling/biocro/blob/master/R/OpBioGro.R).

### Weather data

From CLM file `clm_version.nc` to a dataframe with hourly rows and five
weather variables.

| BioCro var name | BioCro var unit | CLM var name | CLM var unit |
| --------------- | --------------- | ------------ | ------------ |
| solarR          | umol/m2/s       | FSDS         | W/m2         |
| DailyTemp.C     | C               | TBOT         | K            |
| RH              | 0-1             | RH           | %            |
| WindSpeed       | m/s             | WIND         | m/s          |
| precip          | mm (mm/h)       | PRECTmms     | mm/s         |

Need to downscale all weather data from every three hours to hourly, and
also convert some units, as shown in the table above.

Specific downscaling and conversion for each variable:

1.  Radiation: used spline interpolation from PEcAn
    (<https://github.com/PecanProject/pecan/blob/develop/modules/data.atmosphere/R/temporal.downscaling.R#L48>),
    converted from W/m2 (1 W/m2 = 4.6 umol/m2/s)
2.  Temperature: made three copies of each value, and converted from K
    to C
3.  Humidity: made three copies of each value, and converted from
    percentage to 0-1 scale
4.  Wind: no wind, filled in with zeroes
5.  Precipitation: filled in with zeroes, didn’t convert single daily
    value

Read in data and libraries:

``` r
library(ncdf4)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
clm_met <- nc_open("clm_version.nc")
```

Do variable conversions and downscaling:

``` r
DailyTemp.C <- rep(ncvar_get(clm_met, "TBOT") - 273.15, each = 3)
RH <- rep(ncvar_get(clm_met, "RH") / 100, each = 3)
WindSpeed <- rep(ncvar_get(clm_met, "WIND"), each = 3)
PRECTmms <- ncvar_get(clm_met, "PRECTmms")
precip <- rep(c(unique(PRECTmms)[1], rep(0, 23)), 365)

FSDS <- ncvar_get(clm_met, "FSDS") * 4.6
FSDS_df <- data.table::data.table(data.frame(
  date = seq(as.POSIXct(strptime("2000-01-01 00:00:00", "%Y-%m-%d %H:%M:%S")), 
             as.POSIXct(strptime("2000-12-30 21:00:00", "%Y-%m-%d %H:%M:%S")), 
             3*60*60), 
  year = rep(2000, 2920), 
  doy = rep(1:365, each = 8), 
  hour = rep(seq(0, 21, by = 3), 365), 
  FSDS = FSDS) %>% 
    mutate(day = day(date), 
           month = month(date)))

output.dt <- 1
hrscale <- 1
downscaled.result <- list()

new.date <- FSDS_df[,list(hour = 0:(23 / output.dt) / output.dt),
                        by = c("year", "month", "day", "doy")]
new.date$date <- new.date[,list(date = lubridate::ymd_h(paste(year, month, day, hour)))]

f <- stats::splinefun(as.double(FSDS_df$date), (FSDS_df$FSDS / hrscale), method = "monoH.FC")
downscaled.result$FSDS <- f(as.double(new.date$date))
downscaled.result$FSDS[downscaled.result$FSDS < 0] <- 0
downscaled.result <- cbind(new.date, data.table::as.data.table(downscaled.result))
```

Assemble final weather dataframe:

``` r
time <- data.frame(year = rep(2019, 8760), 
                   doy = rep(1:365, each = 24), 
                   hour = rep(seq(0, 23), 365))
OpBioGro_weather <- data.frame(time, solarR = downscaled.result$FSDS, DailyTemp.C, RH, WindSpeed, precip)
```

### Biomass data

Plants all started to grow at same time (Jan 3, 2019). Plants harvested
on six different dates, from Jan 15 - Feb 19. The plants were grown at
three different temperatures, and there were three genotypes.

### TODO

  - Get correct columns
      - Thermal temperature ~~= temp col \* (harvest date - germination
        date)~~
          - Is equal to growing degree days. Run weather data through
            BioCro to get thermal temperature
      - Biomass = stem, leaf, root DW columns & zeroes for rhizome and
        grain
      - LAI is SLA (use single value for all from other experiments) \*
        leaf mass
  - Calculate coefficients for a single temperature and a single set of
    values for that temperature (1/3 of current values). Then average
    resulting coefficients.

<!-- end list -->

``` r
library(dplyr)

biomass_data_all <- read.csv("biomass_setaria_me034_gehan.csv") %>% 
  filter(genotype == "ME034V-1", 
         temperature_celsius == 31)

biomass_data_by_tt <- biomass_data_all %>% 
  mutate(days_grown = as.Date(as.character(biomas_harvested),format="%m/%d/%Y") - as.Date(as.character(seeds_in_germination),format="%m/%d/%Y"), 
         ThermalT = as.numeric(days_grown * temperature_celsius)) %>% 
  select(ThermalT, stemDW.mg., leaf.DW.mg., roots.DW..mg.) %>% 
  group_by(ThermalT) %>% 
  summarise(Stem = mean(stemDW.mg.), 
            Leaf = mean(leaf.DW.mg.), 
            Root = mean(roots.DW..mg.))

biomass_data_by_tt$Rhizome <- rep(0, 6)
biomass_data_by_tt$Grain <- rep(0, 6)
biomass_data_by_tt$LAI <- biomass_data_by_tt$Leaf * 2
biomass_data_by_tt <- data.frame(biomass_data_by_tt)
biomass_data_by_tt[2, 1] <- 550
```

### Estimate coefficients

``` r
library(BioCro)

#coef_estimates <- valid_dbp(idbp(biomass_data_by_tt))
#biomass_coefs <- OpBioGro(phen = 0, WetDat = weather_data, data = biomass_data_by_tt, iCoef = approx_biomass_coefs)
```
