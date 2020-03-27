Setaria Biomass Data Cleaning & Visualization
================
Kristina Riemer, University of Arizona

### Download data

Data downloaded from [Google
Sheet](https://docs.google.com/spreadsheets/d/134qzz1mcfKyGSS4vMOh0CONUECUuMiDyp6D_pzGjfi0/edit#gid=1249864874)
as an .xlsx.

``` r
library(readxl)

data_path <- "biocro_biomass_clean_darpa_files/Darpa_setaria_chambers_experiments.xlsx"
sheets_names <- excel_sheets(data_path)

biomass_sheets <- c(11, 9, 7, 5, 3, 2, 1)
for(sheet in biomass_sheets){
  exp_name <- paste0("exp", substr(sheets_names[sheet], 0, 1))
  assign(exp_name, read_excel(data_path, sheet = sheets_names[sheet]))
}
```

    ## New names:
    ## * `` -> ...23
    ## * `` -> ...24
    ## * `` -> ...25
    ## * `` -> ...26

### First experiment

Plots for first experiment. Plot by treatment started date (2), genotype
(1), temperature (3), light intensity (3), separate plots by sowing date
(2). Skipping conversion to mass by area. Removing yield for now.

Questions:

  - Why do some rows have no biomass or yield measurements?

Each row has a unique plantID. There’s only one genotype (ME034) of
Setaria viridis. There are three temperature treatments, with each
temperature treatment split into three light intensities. Seems to have
been two replicates of this experiment, with different sowing dates and
treatment started dates. Each temperature/lighting combo, which had four
plants each, was harvested on a different date.

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

colnames(exp1) <- stringr::str_replace_all(colnames(exp1), " ", "_")
exp1 <- data.frame(exp1)

# retaining only rows with biomass for plant parts (i.e., no yield and no NA)
exp1 <- exp1 %>% 
  mutate(date = lubridate::ymd(biomas_harvested), 
         days_grown = as.integer(as.Date(as.character(biomas_harvested),format="%Y-%m-%d") - as.Date(as.character(sowing_date_T.31Cday.night),format="%Y-%m-%d"))) %>% 
  filter(is.na(Yield_.mg.), !is.na(roots_DW_.g.))

# split data up by replicate
exp1_sowing1 <- exp1 %>% 
  filter(sowing_date_T.31Cday.night == unique(exp1$sowing_date_T.31Cday.night)[1])

exp1_sowing1_plot <- exp1_sowing1 %>% 
  select(date, genotype, temperature_..C._day.night, light_intensity.umol.m2.s., sowing_date_T.31Cday.night, days_grown, contains('DW')) %>% 
  tidyr::pivot_longer(panicle_DW.g.:roots_DW_.g.)

ggplot(exp1_sowing1_plot, aes(days_grown, value, color = name)) +
  geom_point() +
  facet_wrap(vars(temperature_..C._day.night, light_intensity.umol.m2.s.))
```

![](biocro_biomass_clean_darpa_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
exp1_sowing2 <- exp1 %>% 
  filter(sowing_date_T.31Cday.night == unique(exp1$sowing_date_T.31Cday.night)[2])

exp1_sowing2_plot <- exp1_sowing2 %>% 
  select(date, genotype, temperature_..C._day.night, light_intensity.umol.m2.s., sowing_date_T.31Cday.night, days_grown, contains('DW')) %>% 
  tidyr::pivot_longer(panicle_DW.g.:roots_DW_.g.)

ggplot(exp1_sowing2_plot, aes(days_grown, value, color = name)) +
  geom_point() +
  facet_wrap(vars(temperature_..C._day.night, light_intensity.umol.m2.s.))
```

![](biocro_biomass_clean_darpa_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

I don’t think we can use these data for the biomass validation because
the data from different dates had different experimental treatments.

### Second experiment

Also have unique plantIDs (per plant?). These seem to have had images
taken of them.

3 genotypes of Setaria viridis, at 3 temperatures. No treatment started
replicates and no lighting treatments. Also no yield measurements. Bunch
of missing measurements for plant parts.

``` r
colnames(exp2) <- stringr::str_replace_all(colnames(exp2), " ", "_")
exp2 <- data.frame(exp2)

exp2 <- exp2 %>% 
  mutate(date = lubridate::ymd(biomas_harvested), 
         days_grown = as.integer(as.Date(as.character(biomas_harvested),format="%Y-%m-%d") - as.Date(as.character(seeds_in_germination),format="%Y-%m-%d"))) %>% 
  filter(!is.na(biomas_harvested))

exp2_plot <- exp2 %>% 
  select(date, genotype, temperature_..C., seeds_in_germination, days_grown, contains('DW')) %>% 
  tidyr::pivot_longer(panicle_DW.mg.:roots_DW_.mg.)

ggplot(exp2_plot, aes(date, value, color = name)) +
  geom_point() +
  facet_wrap(vars(genotype, temperature_..C.))
```

    ## Warning: Removed 3 rows containing missing values (geom_point).

![](biocro_biomass_clean_darpa_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

We can use these data.

### Third experiment

two temps, two light intensities? Multiple treatments (GA1, GA2), what
are these? (last row first column has note about them) Includes yield.
One sowing/treatment started date, 3 harvest dates (only 2 after
cleaning).

``` r
colnames(exp3) <- stringr::str_replace_all(colnames(exp3), " ", "_")
exp3 <- data.frame(exp3)

exp3 <- exp3 %>% 
  mutate(date = lubridate::ymd(biomas_harvested), 
         days_grown = as.integer(as.Date(as.character(biomas_harvested),format="%Y-%m-%d") - as.Date(as.character(sowing_date_T.31Cday.night),format="%Y-%m-%d"))) %>% 
  filter(is.na(yield_.g.))

exp3_plot <- exp3 %>% 
  select(date, genotype, treatment, temperature_..C._day.night, light_intensity.umol.m2.s., sowing_date_T.31Cday.night, days_grown, contains('DW')) %>% 
  tidyr::pivot_longer(stemDW.mg.:panicles_DW_.mg.) %>% 
  filter(!is.na(value))

ggplot(exp3_plot, aes(date, value, color = name)) +
  geom_point() +
  facet_wrap(vars(temperature_..C._day.night))
```

![](biocro_biomass_clean_darpa_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
ggplot(exp3_plot, aes(date, value, color = name)) +
  geom_point() +
  facet_wrap(vars(temperature_..C._day.night, light_intensity.umol.m2.s., treatment))
```

![](biocro_biomass_clean_darpa_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

I don’t think we can use these because they’re only harvested on two
dates, and each date has its own temperature treatment.
