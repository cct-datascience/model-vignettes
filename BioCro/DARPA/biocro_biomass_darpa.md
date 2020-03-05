How to Do Biomass Partitioning on DARPA Data Using BioCro Model
================
Kristina Riemer, University of Arizona

For biomass partitioning using
[`OpBioGro`](https://github.com/ebimodeling/biocro/blob/master/R/OpBioGro.R).

### Weather data

From CLM file `clm_version.nc` to a dataframe with hourly rows and five
weather variables.

| BioCro var name | BioCro var unit | CLM var name | CLM var unit  |
| --------------- | --------------- | ------------ | ------------- |
| solarR          | umol/m2/s       | FSDS         | W/m2 (J/m2/s) |
| DailyTemp.C     | C               | TBOT         | K             |
| RH              | 0-1             | RH           | %             |
| WindSpeed       | m/s             | WIND         | m/s           |
| precip          | mm (mm/h)       | PRECTmms     | mm/s          |

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

Several different visualizations to check these weather data are
created.

``` r
skimr::skim(OpBioGro_weather)
```

|                                                  |                   |
| :----------------------------------------------- | :---------------- |
| Name                                             | OpBioGro\_weather |
| Number of rows                                   | 8760              |
| Number of columns                                | 8                 |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |                   |
| Column type frequency:                           |                   |
| numeric                                          | 8                 |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |                   |
| Group variables                                  | None              |

Data summary

**Variable type:
numeric**

| skim\_variable | n\_missing | complete\_rate |    mean |     sd |      p0 |     p25 |     p50 |     p75 |    p100 | hist  |
| :------------- | ---------: | -------------: | ------: | -----: | ------: | ------: | ------: | ------: | ------: | :---- |
| year           |          0 |              1 | 2019.00 |   0.00 | 2019.00 | 2019.00 | 2019.00 | 2019.00 | 2019.00 | ▁▁▇▁▁ |
| doy            |          0 |              1 |  183.00 | 105.37 |    1.00 |   92.00 |  183.00 |  274.00 |  365.00 | ▇▇▇▇▇ |
| hour           |          0 |              1 |   11.50 |   6.92 |    0.00 |    5.75 |   11.50 |   17.25 |   23.00 | ▇▇▆▇▇ |
| solarR         |          0 |              1 |  461.94 | 394.40 |    0.00 |    0.00 |  426.44 |  914.90 |  965.80 | ▇▂▂▂▇ |
| DailyTemp.C    |          0 |              1 |   30.66 |   0.08 |   30.49 |   30.65 |   30.70 |   30.71 |   30.73 | ▂▁▂▂▇ |
| RH             |          0 |              1 |    0.56 |   0.00 |    0.55 |    0.55 |    0.55 |    0.56 |    0.56 | ▇▂▃▁▂ |
| WindSpeed      |          0 |              1 |    0.00 |   0.00 |    0.00 |    0.00 |    0.00 |    0.00 |    0.00 | ▁▁▇▁▁ |
| precip         |          0 |              1 |    0.00 |   0.00 |    0.00 |    0.00 |    0.00 |    0.00 |    0.00 | ▇▁▁▁▁ |

``` r
tabplot::tableplot(OpBioGro_weather, sortCol = "doy")
```

    ## Registered S3 methods overwritten by 'ffbase':
    ##   method   from
    ##   [.ff     ff  
    ##   [.ffdf   ff  
    ##   [<-.ff   ff  
    ##   [<-.ffdf ff

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
t <- OpBioGro_weather %>% 
  mutate(date = new.date$date) %>% 
  dplyr::select(solarR:date) %>% 
  tidyr::pivot_longer(cols = solarR:precip)
t
```

    ## # A tibble: 43,800 x 3
    ##    date                name            value
    ##    <dttm>              <chr>           <dbl>
    ##  1 2000-01-01 00:00:00 solarR       0       
    ##  2 2000-01-01 00:00:00 DailyTemp.C 30.7     
    ##  3 2000-01-01 00:00:00 RH           0.555   
    ##  4 2000-01-01 00:00:00 WindSpeed    0       
    ##  5 2000-01-01 00:00:00 precip       0.000463
    ##  6 2000-01-01 01:00:00 solarR       0       
    ##  7 2000-01-01 01:00:00 DailyTemp.C 30.7     
    ##  8 2000-01-01 01:00:00 RH           0.555   
    ##  9 2000-01-01 01:00:00 WindSpeed    0       
    ## 10 2000-01-01 01:00:00 precip       0       
    ## # … with 43,790 more rows

``` r
library(ggplot2)
ggplot(t, aes(date, value)) +
  geom_line(size = 0.1) + 
  facet_wrap(~name, ncol = 1, scales = 'free_y')
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
ggplot(t %>% filter(month(date) ==1), aes(date, value)) +
  geom_line(size = 0.1) + 
  facet_wrap(~name, ncol = 1, scales = 'free_y')
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->
\#\#\# Biomass data

Plants all started to grow at same time (Jan 3, 2019). Plants harvested
on six different dates, from Jan 15 - Feb 19. The plants were grown at
three different temperatures, and there were three genotypes. Initially
only using data for the middle temperature (31\*C) and the first
replicate from that.

Biomass measurements are estimates from pixel sizes for images taken of
plants.

``` r
library(BioCro)

biomass_data_all <- read.csv("biomass_setaria_me034_gehan.csv") %>% 
  filter(genotype == "ME034V-1", 
         temperature_celsius == 31) %>% 
  group_by(biomas_harvested) %>% 
  slice(1) %>% 
  ungroup()

skimr::skim(biomass_data_all %>% select(temperature_celsius, panicle.FW.g.:roots.DW..mg.))
```

|                                                  |                               |
| :----------------------------------------------- | :---------------------------- |
| Name                                             | biomass\_data\_all %\>% sele… |
| Number of rows                                   | 6                             |
| Number of columns                                | 8                             |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |                               |
| Column type frequency:                           |                               |
| numeric                                          | 8                             |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |                               |
| Group variables                                  | None                          |

Data summary

**Variable type:
numeric**

| skim\_variable       | n\_missing | complete\_rate |    mean |      sd |   p0 |     p25 |     p50 |     p75 |    p100 | hist  |
| :------------------- | ---------: | -------------: | ------: | ------: | ---: | ------: | ------: | ------: | ------: | :---- |
| temperature\_celsius |          0 |              1 |   31.00 |    0.00 | 31.0 |   31.00 |   31.00 |   31.00 |   31.00 | ▁▁▇▁▁ |
| panicle.FW.g.        |          0 |              1 |    0.80 |    0.70 |  0.0 |    0.24 |    0.85 |    1.10 |    1.86 | ▇▃▃▃▃ |
| stemFW.mg.           |          0 |              1 | 2171.65 | 1560.45 | 64.4 | 1072.50 | 2675.00 | 2826.62 | 4200.00 | ▅▁▁▇▂ |
| leaf.FW.mg.          |          0 |              1 |  942.32 |  553.95 | 99.4 |  614.95 | 1078.95 | 1286.97 | 1580.00 | ▃▃▁▇▇ |
| panicle.DW.mg.       |          0 |              1 |  336.67 |  309.06 |  0.0 |   89.33 |  322.00 |  504.28 |  799.20 | ▇▃▃▃▃ |
| stemDW.mg.           |          0 |              1 |  401.12 |  313.59 |  6.0 |  139.32 |  453.70 |  640.20 |  756.40 | ▇▁▃▃▇ |
| leaf.DW.mg.          |          0 |              1 |  172.73 |  119.29 | 13.4 |   85.35 |  194.65 |  248.68 |  318.10 | ▇▁▃▃▇ |
| roots.DW..mg.        |          0 |              1 |   97.57 |   82.81 |  4.3 |   32.75 |   93.30 |  143.28 |  222.00 | ▇▃▃▃▃ |

Plot of first replicate 31\*C dry weights for stem, leaf, panicle/grain,
and roots across six time points when biomass was measured.

``` r
s <- biomass_data_all %>% 
  mutate(date = lubridate::mdy(biomas_harvested)) %>% 
  select(temperature_celsius, date, contains('DW.')) %>% 
  tidyr::pivot_longer(panicle.DW.mg.:roots.DW..mg.)

ggplot(s, aes(date, value, color = name)) +
  geom_line() 
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

Added how many days each plant was grown before harvested to the biomass
dataframe. Then calculated thermal times for weather data using
`BioGro`, using only the thermal times for the days of harvest.

``` r
biomass_data_single <- biomass_data_all %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomas_harvested),format="%m/%d/%Y") - as.Date(as.character(seeds_in_germination),format="%m/%d/%Y")))

weather_only_run <- BioGro(OpBioGro_weather, day1 = 1, dayn = 365)
```

    ## [1] 6

``` r
weather_only_run_df <- as.data.frame(unclass(weather_only_run)[1:11]) %>%
  select(Hour, DayofYear, ThermalT) %>% 
  filter(Hour == 0, 
         DayofYear %in% biomass_data_single$days_grown) %>% 
  mutate(days_grown = DayofYear)
```

Combined biomass data for stem, leaf, panicle/grain, and root from data
with corresponding calculated thermal time. Added in values of zero for
rhizome at each thermal time point. Lastly estimated LAI using leaf
biomass measurements with SLA. All values are plotted against thermal
time.

``` r
SLA_mg <- 80 / 1000000
OpBioGro_biomass <- left_join(biomass_data_single, weather_only_run_df, by = "days_grown") %>% 
  select(ThermalT, Stem = stemDW.mg., Leaf = leaf.DW.mg., Root = roots.DW..mg., Grain = panicle.DW.mg.) %>% 
  mutate(Rhizome = rep(0, 6), 
         LAI = SLA_mg * Leaf)
OpBioGro_biomass <- data.frame(OpBioGro_biomass) %>% 
  arrange(ThermalT)

OpBioGro_biomass_plot <- OpBioGro_biomass %>% 
  tidyr::pivot_longer(Stem:LAI)
ggplot(OpBioGro_biomass_plot %>% filter(name != "LAI"), aes(x = ThermalT, y = value, color = name)) +
  geom_line() +
  ylab("Dry Weight (mg)")
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

``` r
ggplot(OpBioGro_biomass_plot %>% filter(name == "LAI"), aes(x = ThermalT, y = value)) +
  geom_line() +
  ylab("Leaf Area Index (units?)")
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

### Estimate coefficients

Updating phenological parameters that will go into partitioning
estimates. This includes setting the thermal times to correspond to the
dates of biomass measurements, and setting all rhizome growth values to
zero so that this stays zero. Otherwise using default values.

``` r
p <- phenoParms() 
p[1:6] <- OpBioGro_biomass$ThermalT#c(400, 600, 800, 1000, 1200, 1500)
p['kRhizome1'] <- 0
p['kRhizome2'] <- 0
p['kRhizome3'] <- 0
p['kRhizome4'] <- 0
p['kRhizome5'] <- 0
p['kRhizome6'] <- 0
```

Generate initial guesses at coefficients using these updated
phenological parameters and the measured biomass values using `idbp`.
These values than are validated using `valid_dbp`. The eighth value had
to be changed manually to pass this validation step because it was
initially shown as
    `Inf`.

``` r
initial_coefs <- idbp(OpBioGro_biomass, phenoControl = p)
```

    ## Warning in idbp(OpBioGro_biomass, phenoControl = p): only one row for phen stage
    ## 1

``` r
initial_coefs[8] <- -0.000000000000001
valid_dbp(initial_coefs)
```

    ##  [1]  5.654008e-01  2.531646e-01  1.814346e-01 -1.000000e-04  3.468809e-01
    ##  [6]  5.189036e-01  1.342155e-01 -1.000000e-15  1.787979e-01  3.977936e-01
    ## [11]  7.227999e-02  3.511286e-01  7.175234e-02  3.682129e-01  7.570643e-02
    ## [16]  4.843283e-01  2.500000e-01  2.500000e-01  2.500000e-01  2.500000e-01
    ## [21]  3.205882e-01  3.828877e-01  2.965241e-01  2.673797e-09  0.000000e+00

The previously generated weather data, along with those initial
estimated biomass coefficients and the biomass measurements, are passed
to the function that optimizes for biomass partitioning coefficients.
This is optimized for all six phenological stages because of the `phen`
argument.

``` r
# defaults day1 = 90; dayn = 330
biomass_coefs <- constrOpBioGro(phen = 0, 
                                WetDat = OpBioGro_weather,
                                data = OpBioGro_biomass, 
                                iCoef = initial_coefs, 
                                iRhizome = 0, 
                                phenoControl = p)
```

    ## Warning in max(WetDat1s[, 1]): no non-missing arguments to max; returning -Inf

    ## Warning in min(WetDat1s[, 1]): no non-missing arguments to min; returning Inf

    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ##  Stage 1. Converged:  YES... 
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ##  Stage 2. Converged:  YES... 
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ##  Stage 3. Converged:  YES... 
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ##  Stage 4. Converged:  YES... 
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ##  Stage 5. Converged:  YES... 
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ## [1] 6
    ##  Stage 6. Converged:  YES.

``` r
biomass_coefs
```

    ## 
    ##  Optimization for stage: 1 2 3 4 5 6 
    ## 
    ##  Optimized coefficients
    ##           Leaf         Stem         Root       Rhizome         Grain
    ## 1 3.051125e-05 0.9999692287 2.600381e-07 -1.265702e-01  0.000000e+00
    ## 2 3.834088e-03 0.9961625469 3.365196e-06 -5.249042e-04  0.000000e+00
    ## 3 9.475528e-01 0.0412321575 1.120795e-02  7.131488e-06  0.000000e+00
    ## 4 9.965629e-01 0.0015138245 1.157337e-04  1.807532e-03  0.000000e+00
    ## 5 5.260159e-01 0.0000624169 9.305356e-03  4.646163e-01  0.000000e+00
    ## 6 3.205882e-01 0.3828876885 2.965241e-01  1.092235e-07 -9.428291e-08
    ## 
    ##  Residual Sum of Squares: 2955744 
    ## 
    ##  Convergence 
    ##   stage:  1 YES 
    ##   stage:  2 YES 
    ##   stage:  3 YES 
    ##   stage:  4 YES 
    ##   stage:  5 YES 
    ##   stage:  6 YES

``` r
biomass_coefs_list <- list(tp1 = as.vector(unlist(biomass_coefs$list1$phenoP[1])), 
                           tp2 = as.vector(unlist(biomass_coefs$list1$phenoP[2])), 
                           tp3 = as.vector(unlist(biomass_coefs$list1$phenoP[3])), 
                           tp4 = as.vector(unlist(biomass_coefs$list1$phenoP[4])), 
                           tp5 = as.vector(unlist(biomass_coefs$list1$phenoP[5])), 
                           tp6 = as.vector(unlist(biomass_coefs$list1$phenoP[6])), 
           kLeaf1 = biomass_coefs$coefs[1], kStem1 = biomass_coefs$coefs[2], 
           kRoot1 = biomass_coefs$coefs[3], kRhizome1 = biomass_coefs$coefs[4], #kGrain1 = 0.0, 
           kLeaf2 = biomass_coefs$coefs[5], kStem2 = biomass_coefs$coefs[6], 
           kRoot2 = biomass_coefs$coefs[7], kRhizome2 = biomass_coefs$coefs[8], #kGrain2 = 0.0,
           kLeaf3 = biomass_coefs$coefs[9], kStem3 = biomass_coefs$coefs[10], 
           kRoot3 = biomass_coefs$coefs[11], kRhizome3 = biomass_coefs$coefs[12], #kGrain3 = 0.0, 
           kLeaf4 = biomass_coefs$coefs[13], kStem4 = biomass_coefs$coefs[14], 
           kRoot4 = biomass_coefs$coefs[15], kRhizome4 = biomass_coefs$coefs[16], #kGrain4 = 0.0, 
           kLeaf5 = biomass_coefs$coefs[17], kStem5 = biomass_coefs$coefs[18], 
           kRoot5 = biomass_coefs$coefs[19], kRhizome5 = biomass_coefs$coefs[20], #kGrain5 = 0.0, 
           kLeaf6 = biomass_coefs$coefs[21], kStem6 = biomass_coefs$coefs[22], 
           kRoot6 = biomass_coefs$coefs[23], kRhizome6 = biomass_coefs$coefs[24], kGrain6 = biomass_coefs$coefs[25]) 

biomass_ests <- BioGro(WetDat = OpBioGro_weather, 
                       #iCoef = initial_coefs, 
                       #iRhizome = 0, 
                       phenoControl = biomass_coefs_list)
```

    ## [1] 6

``` r
plot(biomass_ests)
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
#points(OpBioGro_biomass$ThermalT, OpBioGro_biomass$Stem)
```
