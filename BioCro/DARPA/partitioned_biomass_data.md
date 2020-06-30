How to Generate Weather and Biomass Data for Coefficient Optimization
================
Kristina Riemer, University of Arizona

For biomass partitioning using [`OpBioGro`](https://github.com/ebimodeling/biocro/blob/master/R/OpBioGro.R).

### Weather data

Assemble weather dataframe:

``` r
opt_weather <- data.frame(year = rep(2019, 8760), 
                                      doy = rep(1:365, each = 24), 
                                      hour = rep(seq(0, 23), 365), 
                                      solarR = rep(c(rep(0, each = 8), rep(936, each = 12), rep(0, each = 4)), times = 365),
                                      Temp = rep(31, times = 365 * 24), 
                                      RH = rep(55.5 / 100,  times = 365 * 24), 
                                      WS = rep(0, times = 365 * 24), 
                                      precip = rep(c(0.000462963, rep(0, 23)), 365))

write.csv(opt_weather, "opt_inputs/opt_weather.csv", row.names = FALSE)
```

Visualize these data:

``` r
library(dplyr)
library(ggplot2)
library(lubridate)

opt_weather_plot <- opt_weather %>% 
  mutate(date = seq(as.POSIXct("2019-01-01 00:00:00"), 
                    as.POSIXct("2019-12-31 23:00:00"), 
                    by = "hour")) %>% 
  dplyr::select(solarR:date) %>%
  tidyr::pivot_longer(cols = solarR:precip)

ggplot(opt_weather_plot, aes(date, value)) +
  geom_line(size = 0.1) +
  facet_wrap(~name, ncol = 1, scales = 'free_y')
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-2-1.png)

``` r
ggplot(opt_weather_plot %>% filter(month(date) ==1 & day(date) < 3), aes(date, value)) +
    geom_line() +
    facet_wrap(~name, ncol = 1, scales = 'free_y')
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-2-2.png)

### Biomass data

These data are in [the project's private data repo](https://github.com/az-digitalag/model-vignettes-data). Plants all started to grow at same time (Jan 3, 2019). Plants harvested on six different dates, from Jan 15 - Feb 19. The plants were grown at three different temperatures, and there were three genotypes. Initially only using data for the middle temperature (31\*C) and taking the median of the three values. Biomass measurements are from destructively harvesting plants, so plants from different harvest dates are different plants.

``` r
library(udunits2)
area_cm2 <- 64
area_ha <- ud.convert(area_cm2, "cm2", "ha")
getwd()
```

    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA"

``` r
biomass_data_all <- read.csv("../../../model-vignettes-data/2019-01-me034-mutant-biomass.csv") %>% 
  mutate(panicle.DW.mg.byarea = ud.convert(panicle.DW.mg., "mg", "Mg") / area_ha, 
         stemDW.mg.byarea = ud.convert(stemDW.mg., "mg", "Mg") / area_ha, 
         leaf.DW.mg.byarea = ud.convert(leaf.DW.mg., "mg", "Mg") / area_ha, 
         roots.DW.mg.byarea = ud.convert(roots.DW..mg., "mg", "Mg") / area_ha) %>% 
  filter(genotype == "ME034V-1", 
         temperature_celsius == 31)
```

Plot of three replicate 31\*C dry weights for stem, leaf, panicle/grain, and roots across six time points when biomass was measured.

``` r
s <- biomass_data_all %>% 
  mutate(date = lubridate::mdy(biomas_harvested)) %>% 
  select(temperature_celsius, date, contains('DW.mg.byarea')) %>% 
  tidyr::pivot_longer(panicle.DW.mg.byarea:roots.DW.mg.byarea)

s2 <- s %>% 
  group_by(date, name) %>% 
  summarize(value_mean = mean(value),
            value_median = median(value), 
            value_sd = sd(value)) %>% 
  mutate(sd_high = value_mean + value_sd, 
         sd_low = value_mean - value_sd)

ggplot(s, aes(date, value, color = name)) +
  geom_point() +
  facet_wrap(~name)
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-4-1.png)

``` r
ggplot(s2, aes(date, value_mean, color = name)) +
  geom_point() +
  geom_errorbar(aes(ymin = sd_low, ymax = sd_high)) +
  geom_point(aes(date, value_median), color = "black") +
  facet_wrap(~name)
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-4-2.png)

``` r
ggplot(s, aes(date, value, color = name)) +
  geom_smooth(method = "lm", fill = NA) +
  geom_point(shape = 4)
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-4-3.png)

Calculated median for each plant part and harvest date and added how many days each plant was grown before harvested to the biomass dataframe. Then calculated thermal times for weather data using `BioGro`, using only the thermal times for the days of harvest. Note that this uses BioCro version 0.95.

``` r
library(BioCro)
if(packageVersion(pkg = 'BioCro') >= 1.0){
  warning("need to use BioCro v0.9x")
} else {
  #devtools::install_github('ebimodeling/biocro-dev')
  devtools::install_github('ebimodeling/biocro')  
}
biomass_data_single <- biomass_data_all %>% 
  select(biomas_harvested, Stem = stemDW.mg.byarea, Leaf = leaf.DW.mg.byarea, Root = roots.DW.mg.byarea, Grain = panicle.DW.mg.byarea) %>% 
  group_by(biomas_harvested) %>% 
  summarise_at(vars(Stem:Grain), median) %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomas_harvested), format = "%m/%d/%Y") - as.Date(as.character(biomass_data_all$seeds_in_germination[1]), format = "%m/%d/%Y")))

weather_only_run <- BioGro(opt_weather, day1 = 1, dayn = 365)
```

    ## [1] 6

``` r
weather_only_run_df <- as.data.frame(unclass(weather_only_run)[1:11]) %>%
  select(Hour, DayofYear, ThermalT) %>% 
  filter(Hour == 0, 
         DayofYear %in% biomass_data_single$days_grown) %>% 
  mutate(days_grown = DayofYear)
```

Combined biomass data for stem, leaf, panicle/grain, and root from data with corresponding calculated thermal time. Added in values of zero for rhizome at each thermal time point. Lastly estimated LAI using leaf biomass measurements with SLA. All values are plotted against thermal time.

``` r
SLA_mg <- 80 / 1000000

opt_biomass <- left_join(biomass_data_single, weather_only_run_df, by = "days_grown") %>% 
  mutate(Rhizome = rep(0, nrow(biomass_data_single)), 
         LAI = SLA_mg * Leaf) %>%
  select(ThermalT, Stem, Leaf, Root, Rhizome, Grain, LAI) %>% 
  arrange(ThermalT) %>% 
  data.frame() %>% 
  slice(-6)

opt_biomass1 <- opt_biomass %>% 
  slice(1:4) %>% 
  mutate(Stem = Stem + Grain, 
         Grain = rep(0, nrow(.)))
opt_biomass2 <- opt_biomass %>% 
  slice(5) %>% 
  mutate(Stem = Stem + opt_biomass$Grain[4], 
         Grain = Grain - opt_biomass$Grain[4])

opt_biomass_comb <- bind_rows(opt_biomass1, opt_biomass2)

write.csv(opt_biomass_comb, "opt_inputs/opt_biomass.csv", row.names = FALSE)

opt_biomass_plot <- opt_biomass_comb %>% 
  tidyr::pivot_longer(Stem:LAI)
ggplot(opt_biomass_plot %>% filter(name != "LAI"), aes(x = ThermalT, y = value, color = name)) +
  geom_line() +
  ylab("Dry Weight (mg)")
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
ggplot(opt_biomass_plot %>% filter(name == "LAI"), aes(x = ThermalT, y = value)) +
  geom_line() +
  ylab("Leaf Area Index (m2 leaf/m2 ground)")
```

![](partitioned_biomass_data_files/figure-markdown_github/unnamed-chunk-6-2.png)
