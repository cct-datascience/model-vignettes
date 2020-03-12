How to Do Biomass Partitioning on DARPA Data Using BioCro Model
================
Kristina Riemer, University of Arizona

For biomass partitioning using
[`OpBioGro`](https://github.com/ebimodeling/biocro/blob/master/R/OpBioGro.R).

### Weather data

Assemble weather dataframe:

``` r
OpBioGro_weather <- data.frame(year = rep(2019, 8760), 
                               doy = rep(1:365, each = 24), 
                               hour = rep(seq(0, 23), 365), 
                               solarR = rep(c(0, 936), times = 365, each = 12),
                               DailyTemp.C = rep(31, times = 365 * 24), 
                               RH = rep(55.5 / 100,  times = 365 * 24), 
                               WindSpeed = rep(0, times = 365 * 24), 
                               precip = rep(c(0.000462963, rep(0, 23)), 365))
```

Visualize these data:

``` r
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
library(ggplot2)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
OpBioGro_weather_plot <- OpBioGro_weather %>% 
  mutate(date = seq(as.POSIXct("2019-01-01 00:00:00"), 
                    as.POSIXct("2019-12-31 23:00:00"), 
                    by = "hour")) %>% 
  dplyr::select(solarR:date) %>% 
  tidyr::pivot_longer(cols = solarR:precip)

ggplot(OpBioGro_weather_plot, aes(date, value)) +
  geom_line(size = 0.1) + 
  facet_wrap(~name, ncol = 1, scales = 'free_y')
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
ggplot(OpBioGro_weather_plot %>% filter(month(date) ==1 & day(date) < 3), aes(date, value)) +
    geom_line() + 
    facet_wrap(~name, ncol = 1, scales = 'free_y')
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

### Biomass data

[These
data](https://docs.google.com/spreadsheets/d/1Nc2g-gPEb-rUW9R4QLDqAZvRRYk1whWAJlb8kLEQZ5c/edit#gid=0)
are in the project’s Google Drive. They have been downloaded and saved
as `biomass_setaria_me034_gehan.csv`.

Plants all started to grow at same time (Jan 3, 2019). Plants harvested
on six different dates, from Jan 15 - Feb 19. The plants were grown at
three different temperatures, and there were three genotypes. Initially
only using data for the middle temperature (31\*C) and taking the mean
of the three values. Biomass measurements are from destructively
harvesting plants, so plants from different harvest dates are different
plants.

``` r
biomass_data_all <- read.csv("biomass_setaria_me034_gehan.csv") %>% 
  filter(genotype == "ME034V-1", 
         temperature_celsius == 31)
```

Plot of three replicate 31\*C dry weights for stem, leaf, panicle/grain,
and roots across six time points when biomass was measured.

``` r
s <- biomass_data_all %>% 
  mutate(date = lubridate::mdy(biomas_harvested)) %>% 
  select(temperature_celsius, date, contains('DW.')) %>% 
  tidyr::pivot_longer(panicle.DW.mg.:roots.DW..mg.)

s2 <- s %>% 
  group_by(date, name) %>% 
  summarize(value_mean = mean(value), 
            value_sd = sd(value)) %>% 
  mutate(sd_high = value_mean + value_sd, 
         sd_low = value_mean - value_sd)

ggplot(s, aes(date, value, color = name)) +
  geom_point() +
  facet_wrap(~name)
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
ggplot(s2, aes(date, value_mean, color = name)) +
  geom_point() +
  geom_errorbar(aes(ymin = sd_low, ymax = sd_high)) +
  facet_wrap(~name)
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

``` r
ggplot(s, aes(date, value, color = name)) +
  geom_smooth(method = "lm", fill = NA) +
  geom_point(shape = 4)
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->

Calculated mean for each plant part and harvest date and added how many
days each plant was grown before harvested to the biomass dataframe.
Then calculated thermal times for weather data using `BioGro`, using
only the thermal times for the days of harvest.

``` r
library(BioCro)

biomass_data_single <- biomass_data_all %>% 
  select(biomas_harvested, Stem = stemDW.mg., Leaf = leaf.DW.mg., Root = roots.DW..mg., Grain = panicle.DW.mg.) %>% 
  group_by(biomas_harvested) %>% 
  summarise_at(vars(Stem:Grain), mean) %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomas_harvested), format = "%m/%d/%Y") - as.Date(as.character(biomass_data_all$seeds_in_germination[1]), format = "%m/%d/%Y")))

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
  mutate(Rhizome = rep(0, nrow(biomass_data_single)), 
         LAI = SLA_mg * Leaf) %>%
  select(ThermalT, Stem, Leaf, Root, Rhizome, Grain, LAI) %>% 
  arrange(ThermalT) %>% 
  data.frame()

OpBioGro_biomass_plot <- OpBioGro_biomass %>% 
  tidyr::pivot_longer(Stem:LAI)
ggplot(OpBioGro_biomass_plot %>% filter(name != "LAI"), aes(x = ThermalT, y = value, color = name)) +
  geom_line() +
  ylab("Dry Weight (mg)")
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
ggplot(OpBioGro_biomass_plot %>% filter(name == "LAI"), aes(x = ThermalT, y = value)) +
  geom_line() +
  ylab("Leaf Area Index (m2 leaf/m2 ground)")
```

![](biocro_biomass_darpa_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

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
initially shown as `Inf`.

``` r
# all idbp uses from phenoControl is the thermal times
initial_coefs <- idbp(OpBioGro_biomass, phenoControl = p)
```

    ## Warning in idbp(OpBioGro_biomass, phenoControl = p): only one row for phen stage
    ## 1

``` r
initial_coefs[8] <- -0.000000000000001
valid_dbp(initial_coefs)
```

    ##  [1]  5.550787e-01  2.274678e-01  2.174535e-01 -1.000000e-04  3.405851e-01
    ##  [6]  5.226307e-01  1.367842e-01 -1.000000e-15  2.929325e-01  6.105692e-01
    ## [11]  9.649824e-02  0.000000e+00  7.743934e-09  7.715539e-01  2.284460e-01
    ## [16]  0.000000e+00  1.588646e-01  7.391266e-01  1.020087e-01  0.000000e+00
    ## [21]  2.272726e-07  2.272726e-07  9.999993e-01  0.000000e+00  2.272726e-07

The previously generated weather data, along with those initial
estimated biomass coefficients and the biomass measurements, are passed
to the function that optimizes for biomass partitioning coefficients.
This is optimized for all six phenological stages because of the `phen`
argument.

``` r
biomass_coefs <- constrOpBioGro(phen = 0, 
                                WetDat = OpBioGro_weather,
                                data = OpBioGro_biomass, 
                                iCoef = initial_coefs, 
                                iRhizome = 0, 
                                phenoControl = p)
biomass_coefs
```

The biomass coefficients are converted into the format required by the
function `BioGro` and then read into this function with the weather data
to get biomass estimates. These are plotted, along with the biomass
measurements.

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
plot(biomass_ests)
#points(OpBioGro_biomass$ThermalT, OpBioGro_biomass$Stem)
```
