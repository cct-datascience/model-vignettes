Prepare Physiological Parameter Data for Upload to BETYdb
================
Kristina Riemer, University of Arizona

Read in parameters data from [model-vignettes-data repository](https://github.com/az-digitalag/model-vignettes-data), which should be cloned into the same folder as model-vignettes repo.

``` r
all_parameters <- read.csv("../../../model-vignettes-data/parameters_data.csv")
```

Necessary R libraries.

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
library(stringr)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
library(tidyr)
```

Clean up data to have the final columns:

1.  `notes`: records which row in the Google Sheet the record came from
2.  `date`: convert date into machine readable format
3.  `treatment`: specifies record's treatment using BETYdb treatment names
4.  `Vcmax`, `leaf_respiration_rate_m2`, `stomatal_slope.g1`, `stomatal_slope.BB`: measured values of physiological parameters specified
5.  `leafT`: leaf temperature, which is required by BETYdb

``` r
upload_parameters <- all_parameters %>% 
  mutate(notes = paste("row", row_number(), "in https://docs.google.com/spreadsheets/d/1doQI0T7vav7LmNdMEoZJDx9iY_Imqa229CLRbRvurFc/edit#gid=967233489")) %>% 
  filter(genotype == "ME034", 
         TR %in% c("low night temp low light", 
                   "high night temp low light", 
                   "low night temp high light"), 
         trait %in% c("vmax", "Rd", "g1M", "g1BB")) %>% 
  mutate(value = ifelse(!is.na(New_Value), New_Value, Value), 
         se = ifelse(!is.na(New_Value), SE.1, SE)) %>% 
  mutate(date = ymd(paste0(str_sub(File, -4, -1), 
                           "-", match(str_sub(File, 1, 3), month.abb), 
                           "-", str_sub(File, -6, -5))), 
         treatment = case_when(TR == "low night temp low light" ~ "regular night temperature", 
                               TR == "high night temp low light" ~ "high night temperature", 
                               TR == "low night temp high light" ~ "high light")) %>% 
  select(-File, -genotype, -TR, -rep, -method, -Value, -SE, -New_Value, -SE.1, -SD) %>% 
  spread(trait, value) %>% 
  rename(local_datetime = date, 
         Vcmax = vmax, 
         leaf_respiration_rate_m2 = Rd, 
         stomatal_slope.g1 = g1M, 
         stomatal_slope.BB = g1BB, 
         SE = se) %>% 
  mutate(leafT = 25, 
         n = 9999) %>% 
  replace(is.na(.), "")
```

Save cleaned parameter as a .csv file in `upload_params_data` folder in `model-vignettes/BioCro/DARPA`.

``` r
if(!dir.exists("upload_params_data/")){
  dir.create("upload_params_data")
}

write.csv(upload_parameters, "upload_params_data/phys_parameters.csv", row.names = FALSE)
```

Upload that new parameter data file using the [Bulk Upload](http://welsch.cyverse.org:8000/bety/bulk_upload/start_upload) in Welsch BETYdb. The following additional data, which applies across all the parameters, will have to be entered

-   site: Donald Danforth Plant Science Center Growth Chamber
-   species: Setaria viridis
-   access\_level: Internal & Collaborators
-   cultivar: ME-034