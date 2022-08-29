Predicting Setaria growth by modeling ensemble results
================
Kristina Riemer & David LeBauer

## Purpose

Predict is to predict Setaria growth for modified plant (e.g.,
anthocyanin) at new sites and times. Inputs that can be changed are
parameter values and site-level environmental variables.

Necessary packages:

``` r
library(PEcAn.settings)
library(dplyr)
library(tidyr)
library(lubridate)
library(leaflet)
library(daymetr)
library(ggplot2)
library(tidymodels)
library(readr)
library(vip)
```

## Data

Combine ED2 output variables from ensemble runs with parameter values
and environmental data by month for all sites with ED2 results.

Steps:

1.  Get cumulative monthly NPP by ensemble and site (from ensemble.ts
    .Rdata file, which has hourly values by ensemble)
2.  Get parameter values for each ensemble run (from ensemble.samples
    .Rdata file; same across years)
3.  Get monthly environmental values for each site and year (lookup from
    Daymet)

### Step 0: get site info

We currently have ED2 results for five sites across North America. Get
dataframe of site coordinates and run dates.

``` r
sites <- c()
site_list_kr <- c("LW", "SR", "WB")
for(site in site_list_kr){
  pecan_xml_path <- paste0("/data/tests/ed2_transect_", site, "/pecan.CHECKED.xml")
  pecan_xml <- read.settings(pecan_xml_path)
  site <- data.frame(name = pecan_xml$run$site$name, id = pecan_xml$run$site$id,
                     lat = pecan_xml$run$site$lat, lon = pecan_xml$run$site$lon, 
                     start = pecan_xml$run$start.date, end = pecan_xml$run$end.date, 
                     site = site)
  sites <- bind_rows(sites, site)
}

pecan_xml_NC <- read.settings("/data/output/pecan_runs/transect_runs/ed2_transect_NC/pecan_checked.xml")
site_NC <- data.frame(name = "North Carolina Loblolly Pine (US-NC2)", id = pecan_xml_NC$run$site$id,
                     lat = pecan_xml_NC$run$site$lat, lon = pecan_xml_NC$run$site$lon, 
                     start = pecan_xml_NC$run$start.date, end = pecan_xml_NC$run$end.date, 
                     site = "NC")
sites <- bind_rows(sites, site_NC)

pecan_xml_WL <- read.settings("/data/output/pecan_runs/transect_runs/ed2_transect_WL/pecan_checked.xml")
site_WL <- data.frame(name = pecan_xml_WL$run$site$name, id = pecan_xml_WL$run$site$id,
                     lat = pecan_xml_WL$run$site$lat, lon = pecan_xml_WL$run$site$lon, 
                     start = pecan_xml_NC$run$start.date, end = pecan_xml_NC$run$end.date, 
                     site = "WL") 
sites <- bind_rows(sites, site_WL) %>% 
  mutate(lat = as.numeric(lat), 
         lon = as.numeric(lon))
sites
```

    ##                                    name         id     lat       lon      start
    ## 1     Little Washita Watershed (US-LWW) 1000000042 34.9604  -97.9789 2019/03/01
    ## 2         Santa Rita Grassland (US-SRG) 1000000111 31.7894 -110.8277 2019/03/01
    ## 3      Walker Branch Watershed (US-WBW) 1000000075 35.9588  -84.2874 2019/03/01
    ## 4 North Carolina Loblolly Pine (US-NC2) 1000000009 35.8031  -76.6679 2009-01-01
    ## 5              Park Falls WLEF (US-PFa)        678 45.9408  -90.2700 2009-01-01
    ##          end site
    ## 1 2019/09/01   LW
    ## 2 2019/09/01   SR
    ## 3 2019/09/01   WB
    ## 4 2015-12-31   NC
    ## 5 2015-12-31   WL

Plot site locations.

``` r
# leaflet(sites) %>% addTiles() %>%
#   addCircleMarkers(lng = ~lon, lat = ~lat, 
#              popup = ~name)
```

### Step 1: ensemble results data

From dataframe of ED2 results for all ensemble runs daily results,
summarize data to include only the Setaria PFT and August dates.

Code from
[`plot.R`](https://github.com/cct-datascience/model-vignettes/blob/6a77020a1218334cc8243f3f4b038fb99c947006/ED2/SR_recent_mult_set_run/plot.R)

``` r
site_list_ec <- c("NC", "WL")
ens_results <- c()
for(site in site_list_ec){
  ens_path <- paste0("/data/output/pecan_runs/transect_runs/ed2_transect_", site, "/npp_out.csv")
  single_site_ens_results <- read.csv(ens_path) %>% 
    filter(pft == 1, 
           grepl("-08-", date)) %>% 
    select(ensemble, npp, date) %>% 
    mutate(ensemble = stringr::str_remove(substr(ensemble, 8, 9), "^0+"), 
           site = site)
  ens_results <- bind_rows(single_site_ens_results, ens_results)
}

for(site in site_list_kr){
  ens_path <- paste0("/data/tests/ed2_transect_", site, "/npp_out.csv")
  single_site_ens_results <- read.csv(ens_path) %>% 
    filter(pft == 1, 
           grepl("-08-", date)) %>% 
    select(ensemble, npp, date) %>% 
    mutate(ensemble = stringr::str_remove(substr(ensemble, 8, 9), "^0+"), 
           site = site)
  ens_results <- bind_rows(single_site_ens_results, ens_results)
}

ens_results <- ens_results%>% 
  mutate(year = year(ymd(date))) %>% 
  select(-date)

head(ens_results)
```

    ##   ensemble       npp site year
    ## 1        1 10.331732   WB 2019
    ## 2        2 11.316664   WB 2019
    ## 3        3  8.551664   WB 2019
    ## 4        4  1.321510   WB 2019
    ## 5        5  6.878200   WB 2019
    ## 6        6  3.893143   WB 2019

### Step 2: parameter values

Getting dataframe of parameter values for each ensemble run for each
site. We assume the order of ensembles in the .Rdata file is in
ascending order, and are only using values for Setaria.

``` r
params <- c()
for(site in site_list_ec){
  param_path <- paste0("/data/output/pecan_runs/transect_runs/ed2_transect_", site, "/ensemble.samples.NOENSEMBLEID.Rdata")
  load(param_path)

  single_site_params <- ens.samples$SetariaWT %>% 
    tibble::rownames_to_column() %>% 
    mutate(ensemble = rowname) %>% 
    select(-rowname) %>% 
    mutate(site = site)
  params <- bind_rows(single_site_params, params)
  
  rm(ens.samples)
}

for(site in site_list_kr){
    param_path <- paste0("/data/tests/ed2_transect_", site, "/ensemble.samples.NOENSEMBLEID.Rdata")
  load(param_path)

  single_site_params <- ens.samples$SetariaWT %>% 
    tibble::rownames_to_column() %>% 
    mutate(ensemble = rowname) %>% 
    select(-rowname) %>% 
    mutate(site = site)
  params <- bind_rows(single_site_params, params)
  
  rm(ens.samples)
}

head(params)
```

    ##      mort2 growth_resp_factor leaf_turnover_rate leaf_width nonlocal_dispersal
    ## 1 11.13893          0.4871350           2.898474   5.557746          0.2487311
    ## 2 18.53879          0.2645960           2.627776   5.092490          0.1756728
    ## 3 49.13044          0.1103022          10.269791   2.938951          0.1947960
    ## 4 19.09883          0.5088787           2.922398   4.371935          0.2266820
    ## 5 35.64275          0.2772274           1.265735   5.241849          0.2662204
    ## 6 13.87209          0.4724325           6.928165   4.707636          0.1568788
    ##   fineroot2leaf root_turnover_rate seedling_mortality stomatal_slope
    ## 1      3.120933         0.44851945          0.5706694       4.185201
    ## 2      7.641881         0.46078749          0.7489275       4.297691
    ## 3      4.108058         0.77581570          0.9904241       4.245950
    ## 4      1.241859         0.04905587          0.9261225       4.078625
    ## 5     11.345634         0.92761811          0.7008471       3.511513
    ## 6      4.919994         0.70522213          0.9669986       4.352425
    ##   quantum_efficiency    Vcmax   r_fract cuticular_cond root_respiration_rate
    ## 1         0.06156974 25.72734 0.5398076     38381.2309              4.571341
    ## 2         0.05565244 25.14103 0.6772581     12967.3038              5.651096
    ## 3         0.05708744 29.86401 0.4696743      8399.1734              4.283418
    ## 4         0.05338324 15.13592 0.4986162       794.3702              6.622718
    ## 5         0.05789673 23.50118 0.1356274     18071.9383              4.199408
    ## 6         0.05832891 22.40633 0.6196150      4858.8740              5.065966
    ##   Vm_low_temp      SLA ensemble site
    ## 1   12.189034 51.03482        1   WB
    ## 2    9.697720 41.10559        2   WB
    ## 3    9.678040 40.20160        3   WB
    ## 4    9.866339 31.92208        4   WB
    ## 5   10.363777 47.67684        5   WB
    ## 6    8.999575 46.49837        6   WB

Combine parameters with ensemble results by site and ensemble.

``` r
ens_params <- left_join(ens_results, params, by = c("ensemble", "site"))
head(ens_params)
```

    ##   ensemble       npp site year    mort2 growth_resp_factor leaf_turnover_rate
    ## 1        1 10.331732   WB 2019 11.13893          0.4871350           2.898474
    ## 2        2 11.316664   WB 2019 18.53879          0.2645960           2.627776
    ## 3        3  8.551664   WB 2019 49.13044          0.1103022          10.269791
    ## 4        4  1.321510   WB 2019 19.09883          0.5088787           2.922398
    ## 5        5  6.878200   WB 2019 35.64275          0.2772274           1.265735
    ## 6        6  3.893143   WB 2019 13.87209          0.4724325           6.928165
    ##   leaf_width nonlocal_dispersal fineroot2leaf root_turnover_rate
    ## 1   5.557746          0.2487311      3.120933         0.44851945
    ## 2   5.092490          0.1756728      7.641881         0.46078749
    ## 3   2.938951          0.1947960      4.108058         0.77581570
    ## 4   4.371935          0.2266820      1.241859         0.04905587
    ## 5   5.241849          0.2662204     11.345634         0.92761811
    ## 6   4.707636          0.1568788      4.919994         0.70522213
    ##   seedling_mortality stomatal_slope quantum_efficiency    Vcmax   r_fract
    ## 1          0.5706694       4.185201         0.06156974 25.72734 0.5398076
    ## 2          0.7489275       4.297691         0.05565244 25.14103 0.6772581
    ## 3          0.9904241       4.245950         0.05708744 29.86401 0.4696743
    ## 4          0.9261225       4.078625         0.05338324 15.13592 0.4986162
    ## 5          0.7008471       3.511513         0.05789673 23.50118 0.1356274
    ## 6          0.9669986       4.352425         0.05832891 22.40633 0.6196150
    ##   cuticular_cond root_respiration_rate Vm_low_temp      SLA
    ## 1     38381.2309              4.571341   12.189034 51.03482
    ## 2     12967.3038              5.651096    9.697720 41.10559
    ## 3      8399.1734              4.283418    9.678040 40.20160
    ## 4       794.3702              6.622718    9.866339 31.92208
    ## 5     18071.9383              4.199408   10.363777 47.67684
    ## 6      4858.8740              5.065966    8.999575 46.49837

### Step 3: environmental data

Download data for these sites and years from
[Daymet](https://daymet.ornl.gov/overview).

``` r
met_data_path <- "/data/output/daymet/ensembles_modeling/model_met.csv"
if(!file.exists(met_data_path)){
  mets <- list()
  for(i in 1:nrow(sites)){
    site <- sites[i,]
    tmp <- 
        download_daymet(
                    site = site$site,
                    lat = site$lat, 
                    lon = site$lon, 
                    start = year(ymd(site$start)),
                    end = 2019
                    )
    mets[[site$name]] <- cbind(site = tmp$site,
                               lat = tmp$lat,
                               lon = tmp$longitude,
                               alt = tmp$altitude,
                               tmp$data)
    }

  mets_all <- dplyr::bind_rows(mets)
  write_csv(mets_all, met_data_path)
}
```

Get mean environmental variables of interest for July and August of each
year by site.

``` r
met_data <- read_csv(met_data_path)

mymean <- function(x) {
    a <- mean(x, na.rm = TRUE)
    b <- signif(a, 4)
    return(b)
}

mets_mean_summer <- met_data %>% 
  mutate(date = as.Date(yday - 1, origin = paste0(year, "-01-01")), 
         month = month(ymd(date))) %>% 
  filter(month %in% c(7, 8)) %>% 
  group_by(site, year) %>% 
  summarise(
    mean_temp = mymean((tmax..deg.c. + tmin..deg.c.)/2),
    mean_vpd = mymean(vp..Pa.),
    mean_precip = mymean(prcp..mm.day.),
    mean_srad = mymean(srad..W.m.2.),
    mean_swe = mymean(swe..kg.m.2.),
    mean_dayl = mymean(dayl..s.)/86400)

head(mets_mean_summer)
```

    ## # A tibble: 6 x 8
    ## # Groups:   site [2]
    ##   site   year mean_temp mean_vpd mean_precip mean_srad mean_swe mean_dayl
    ##   <chr> <dbl>     <dbl>    <dbl>       <dbl>     <dbl>    <dbl>     <dbl>
    ## 1 LW     2019      28.2     2586        1.42      398.        0     0.570
    ## 2 NC     2009      25.9     2470        8.21      353.        0     0.572
    ## 3 NC     2010      26.9     2478        3.22      378.        0     0.572
    ## 4 NC     2011      27       2540        9.78      370.        0     0.572
    ## 5 NC     2012      26.9     2645        7.30      319.        0     0.571
    ## 6 NC     2013      25.7     2522        5.42      350.        0     0.572

``` r
ens_params_env <- left_join(ens_params, mets_mean_summer, by = c("site", "year")) %>%
  janitor::clean_names()

head(ens_params_env)
```

    ##   ensemble       npp site year    mort2 growth_resp_factor leaf_turnover_rate
    ## 1        1 10.331732   WB 2019 11.13893          0.4871350           2.898474
    ## 2        2 11.316664   WB 2019 18.53879          0.2645960           2.627776
    ## 3        3  8.551664   WB 2019 49.13044          0.1103022          10.269791
    ## 4        4  1.321510   WB 2019 19.09883          0.5088787           2.922398
    ## 5        5  6.878200   WB 2019 35.64275          0.2772274           1.265735
    ## 6        6  3.893143   WB 2019 13.87209          0.4724325           6.928165
    ##   leaf_width nonlocal_dispersal fineroot2leaf root_turnover_rate
    ## 1   5.557746          0.2487311      3.120933         0.44851945
    ## 2   5.092490          0.1756728      7.641881         0.46078749
    ## 3   2.938951          0.1947960      4.108058         0.77581570
    ## 4   4.371935          0.2266820      1.241859         0.04905587
    ## 5   5.241849          0.2662204     11.345634         0.92761811
    ## 6   4.707636          0.1568788      4.919994         0.70522213
    ##   seedling_mortality stomatal_slope quantum_efficiency    vcmax   r_fract
    ## 1          0.5706694       4.185201         0.06156974 25.72734 0.5398076
    ## 2          0.7489275       4.297691         0.05565244 25.14103 0.6772581
    ## 3          0.9904241       4.245950         0.05708744 29.86401 0.4696743
    ## 4          0.9261225       4.078625         0.05338324 15.13592 0.4986162
    ## 5          0.7008471       3.511513         0.05789673 23.50118 0.1356274
    ## 6          0.9669986       4.352425         0.05832891 22.40633 0.6196150
    ##   cuticular_cond root_respiration_rate vm_low_temp      sla mean_temp mean_vpd
    ## 1     38381.2309              4.571341   12.189034 51.03482      25.3     2301
    ## 2     12967.3038              5.651096    9.697720 41.10559      25.3     2301
    ## 3      8399.1734              4.283418    9.678040 40.20160      25.3     2301
    ## 4       794.3702              6.622718    9.866339 31.92208      25.3     2301
    ## 5     18071.9383              4.199408   10.363777 47.67684      25.3     2301
    ## 6      4858.8740              5.065966    8.999575 46.49837      25.3     2301
    ##   mean_precip mean_srad mean_swe mean_dayl
    ## 1       3.867     380.8        0 0.5726852
    ## 2       3.867     380.8        0 0.5726852
    ## 3       3.867     380.8        0 0.5726852
    ## 4       3.867     380.8        0 0.5726852
    ## 5       3.867     380.8        0 0.5726852
    ## 6       3.867     380.8        0 0.5726852

## Model

Using a random forest model to model NPP for each site with
environmental data and parameter values. Will use to predict using
different parameter values and environmental data as input.

Investigating relationship between NPP and possible features of
interest.

``` r
ggplot(ens_params_env, aes(x = quantum_efficiency, y = npp)) +
  geom_point() + 
  facet_grid(vars(site))
```

![](predict_growth_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

``` r
ggplot(ens_params_env, aes(x = mean_temp, y = npp)) +
  geom_point() + 
  facet_grid(vars(site))
```

![](predict_growth_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

``` r
ggplot(ens_params_env, aes(x = mean_precip, y = npp)) +
  geom_point() + 
  facet_grid(vars(site))
```

![](predict_growth_files/figure-gfm/unnamed-chunk-10-3.png)<!-- -->

### Simple models

Use anova to determine which parameter and environmental variables have
a significant effect on NPP.

``` r
sig_vars <- aov(npp ~ ., 
                data = ens_params_env %>% select(-ensemble, -site, -year, -mean_dayl)) %>% 
  broom::tidy() %>% 
  mutate_if(is.numeric, signif, 3) %>% 
  filter(p.value < 0.1) %>% 
  select(term)
sig_vars
```

    ## # A tibble: 9 x 1
    ##   term              
    ##   <chr>             
    ## 1 mort2             
    ## 2 growth_resp_factor
    ## 3 leaf_turnover_rate
    ## 4 leaf_width        
    ## 5 fineroot2leaf     
    ## 6 seedling_mortality
    ## 7 mean_vpd          
    ## 8 mean_precip       
    ## 9 mean_srad

Assessing linear relationship between parameter and environmental
variables and NPP.

``` r
lm(npp ~ ., data = ens_params_env) %>% 
  broom::tidy() %>% 
  mutate_if(is.numeric, signif, 3)
```

    ## # A tibble: 77 x 5
    ##    term        estimate std.error statistic p.value
    ##    <chr>          <dbl>     <dbl>     <dbl>   <dbl>
    ##  1 (Intercept) 1900       1780       1.07     0.286
    ##  2 ensemble10     0.246      7.5     0.0329   0.974
    ##  3 ensemble11     2.26       7.21    0.314    0.754
    ##  4 ensemble12    -1.53       6.1    -0.25     0.803
    ##  5 ensemble13     2.28       7.12    0.321    0.749
    ##  6 ensemble14     3.41       7.25    0.47     0.638
    ##  7 ensemble15     2.97       6.98    0.426    0.671
    ##  8 ensemble16     4.79       6.33    0.756    0.45 
    ##  9 ensemble17     4.29       6.24    0.687    0.493
    ## 10 ensemble18    -4.06       6.67   -0.609    0.543
    ## # … with 67 more rows

### Prepare data for machine learning models

Generate training data. Choosing to hold out no testing data from this
dataset because it is limited in size, and only including data with a
large number of ensembles. Also only including features that had
statistically significant impact in ANOVA and the parameters relevant to
the three modified plants.

``` r
set.seed(1234)
ens_params_env %>% group_by(site, year) %>% summarise(n = n())
```

    ## `summarise()` regrouping output by 'site' (override with `.groups` argument)

    ## # A tibble: 21 x 3
    ## # Groups:   site [5]
    ##    site   year     n
    ##    <chr> <dbl> <int>
    ##  1 LW     2019    50
    ##  2 NC     2009    25
    ##  3 NC     2010    19
    ##  4 NC     2011    17
    ##  5 NC     2012    13
    ##  6 NC     2013    12
    ##  7 NC     2014    11
    ##  8 NC     2015    10
    ##  9 SR     2019    44
    ## 10 WB     2019    50
    ## # … with 11 more rows

``` r
data_train <- ens_params_env %>% 
  filter(!(site == "WL" & year > 2012)) %>% 
  select(npp, stomatal_slope, cuticular_cond, quantum_efficiency, fineroot2leaf, sig_vars$term)
```

Preprocess training data, including removing features that are not
useful or of interest.

``` r
data_recipe <- recipe(npp ~ ., data = data_train)
```

### Model with linear regression

Set up model, create workflow, fit model to training data, and use
cross-validation to generate model metrics to evaluate.

``` r
lm_model <- 
  linear_reg() %>% 
  set_engine("lm")

lm_wf <- workflow() %>% 
  add_recipe(data_recipe) %>% 
  add_model(lm_model)

lm_fit <- lm_wf %>% 
  fit(data = data_train)

lm_folds <- vfold_cv(data_train)
lm_resamp_wf <- workflow() %>% 
  add_recipe(data_recipe) %>% 
  add_model(lm_model)
lm_resamp_fit <- fit_resamples(lm_resamp_wf, lm_folds, 
                            control = control_resamples(save_pred = TRUE))
lm_resamp_metrics <- collect_metrics(lm_resamp_fit)
```

### Model with random forest

Set up model, create workflow, fit model to training data, and use
cross-validation to generate model metrics to evaluate.

``` r
rf_model <- rand_forest() %>% 
  set_mode("regression") %>% 
  set_engine("ranger", importance = 'impurity')

rf_wf <- workflow() %>% 
  add_recipe(data_recipe) %>% 
  add_model(rf_model)

rf_fit <- rf_wf %>% 
  fit(data = data_train)

rf_folds <- vfold_cv(data_train)
rf_resamp_wf <- workflow() %>% 
  add_recipe(data_recipe) %>% 
  add_model(rf_model)
rf_resamp_fit <- fit_resamples(rf_resamp_wf, rf_folds, 
                            control = control_resamples(save_pred = TRUE))
rf_resamp_metrics <- collect_metrics(rf_resamp_fit)
rf_resamp_metrics
```

    ## # A tibble: 2 x 5
    ##   .metric .estimator  mean     n std_err
    ##   <chr>   <chr>      <dbl> <int>   <dbl>
    ## 1 rmse    standard   7.38     10  0.562 
    ## 2 rsq     standard   0.841    10  0.0287

Metrics definitions:

  - `rmse`: average deviation between predicted NPP and measured NPP; 0
    means perfect fit, closer to zero is better
  - `rsq`: how much variation in NPP explained by predictor variables;
    from 0 to 1, closer to 1 is better

<!-- end list -->

``` r
rf_rmse <- rf_resamp_metrics %>% filter(.metric == 'rmse') %>% select(mean) 
rf_rmse/mean(data_train$npp) #this is high, want it below 10%? 
```

    ##        mean
    ## 1 0.5303053

## Predictions

### Get environmental data for predictions

Set up file of locations to get environmental variable data for.

``` r
pred_sites_path <- "/data/output/daymet/ensembles_modeling/preds_sites.csv"

if(!file.exists(pred_sites_path)){
  pred_lats <- seq(35, 40, by = 0.25)
  pred_lons <- seq(-105, -80, by = 0.25)
  n <- expand.grid(pred_lats, pred_lons)
  pred_sites <- data.frame(site = 1:nrow(n), n)
  colnames(pred_sites) <- c('site', 'lat', 'lon')
  write.table(pred_sites, pred_sites_path,
              sep = ",",
              col.names = TRUE,
              row.names = FALSE,
              quote = FALSE)
}
```

Download data for those locations, and save out as a file because this
can take a long time depending on number of sites.

``` r
pred_met_data_path <- "/data/output/daymet/ensembles_modeling/preds_met.csv"

ptm <- proc.time()
if(!file.exists(pred_met_data_path)){
  df_batch <- download_daymet_batch(
    file_location = pred_sites_path,
    start = 2010,
    end = 2014,
    internal = TRUE)
  
  pred_mets <- list()
  for(i in 1:length(df_batch)){
    tmp <- df_batch[[i]]
    pred_mets[[i]] <- cbind(site = tmp$site,
                          lat = tmp$lat,
                          lon = tmp$longitude,
                          alt = tmp$altitude,
                          tmp$data)
    }
  pred_mets_all <- bind_rows(pred_mets)
  write_csv(pred_mets_all, pred_met_data_path)
}
proc.time() - ptm
```

    ##    user  system elapsed 
    ##   0.005   0.000   0.004

Get mean environmental variables of interest for July and August of each
year by site.

``` r
pred_mets <- read_csv(pred_met_data_path)

mymean <- function(x) {
    a <- mean(x, na.rm = TRUE)
    b <- signif(a, 4)
    return(b)
}

pred_mets_mean_summer <- pred_mets  %>% 
  mutate(date = as.Date(yday - 1, origin = paste0(year, "-01-01")), 
         month = month(ymd(date))) %>% 
  filter(month %in% c(7, 8)) %>% 
  group_by(site, year) %>% 
  summarise(
    mean_temp = mymean((tmax..deg.c. + tmin..deg.c.)/2),
    mean_vpd = mymean(vp..Pa.),
    mean_precip = mymean(prcp..mm.day.),
    mean_srad = mymean(srad..W.m.2.),
    mean_swe = mymean(swe..kg.m.2.),
    mean_dayl = mymean(dayl..s.)/86400)

head(pred_mets_mean_summer)
```

    ## # A tibble: 6 x 8
    ## # Groups:   site [2]
    ##    site  year mean_temp mean_vpd mean_precip mean_srad mean_swe mean_dayl
    ##   <dbl> <dbl>     <dbl>    <dbl>       <dbl>     <dbl>    <dbl>     <dbl>
    ## 1     1  2010      23.4    1229         2.00      450.        0     0.570
    ## 2     1  2011      25.6     865.        1.60      451.        0     0.570
    ## 3     1  2012      24.1     810.        1.52      462.        0     0.569
    ## 4     1  2013      23.3    1186         2.65      445.        0     0.570
    ## 5     1  2014      22.8    1482         2.68      419.        0     0.570
    ## 6     2  2010      23.6     936.        2.00      460.        0     0.571

### Create parameter sets

Generating sets of parameter values for wild type Setaria, and three
modified Setaria plants. Parameter values are increased or decreased by
25% for modified plants, as specified in the list below.

1.  `hotleaf`: parameters stomatal slope and cuticular conductance are
    lower resulting in warmer temperature leaves
2.  `antho`: plants with increased anthocyanin production have lower
    quantum efficiency
3.  `short`: plants that are shorter in height would have higher fine
    root to leaf carbon allocation

The wild type parameter values, which are used to generate the other
parameter sets, come from an ED2 run at the Santa Ritas site. The median
quantile for values are used.

``` r
load('/data/tests/ed2_SR_recent_sa/sensitivity.samples.NOENSEMBLEID.Rdata')

params_wt <- data.frame(sa.samples$SetariaWT) %>% 
  filter(row.names(.) == "50") %>% 
  janitor::clean_names()
  
inputs_wt <- cbind(pred_mets_mean_summer, params_wt)
inputs_wt
```

    ## # A tibble: 10,605 x 24
    ## # Groups:   site [2,121]
    ##     site  year mean_temp mean_vpd mean_precip mean_srad mean_swe mean_dayl mort2
    ##    <dbl> <dbl>     <dbl>    <dbl>       <dbl>     <dbl>    <dbl>     <dbl> <dbl>
    ##  1     1  2010      23.4    1229         2.00      450.        0     0.570  20.0
    ##  2     1  2011      25.6     865.        1.60      451.        0     0.570  20.0
    ##  3     1  2012      24.1     810.        1.52      462.        0     0.569  20.0
    ##  4     1  2013      23.3    1186         2.65      445.        0     0.570  20.0
    ##  5     1  2014      22.8    1482         2.68      419.        0     0.570  20.0
    ##  6     2  2010      23.6     936.        2.00      460.        0     0.571  20.0
    ##  7     2  2011      25.8     843.        1.43      454.        0     0.571  20.0
    ##  8     2  2012      24.1     688.        1.01      475.        0     0.570  20.0
    ##  9     2  2013      23.6    1034         2.21      460.        0     0.571  20.0
    ## 10     2  2014      23.0    1166         1.25      449.        0     0.571  20.0
    ## # … with 10,595 more rows, and 15 more variables: growth_resp_factor <dbl>,
    ## #   leaf_turnover_rate <dbl>, leaf_width <dbl>, nonlocal_dispersal <dbl>,
    ## #   fineroot2leaf <dbl>, root_turnover_rate <dbl>, seedling_mortality <dbl>,
    ## #   stomatal_slope <dbl>, quantum_efficiency <dbl>, vcmax <dbl>, r_fract <dbl>,
    ## #   cuticular_cond <dbl>, root_respiration_rate <dbl>, vm_low_temp <dbl>,
    ## #   sla <dbl>

Modified Setaria plants have parameter lists that are generated based on
the wild type values.

``` r
inputs_hotleaf <- inputs_wt %>% 
  mutate(stomatal_slope = 0.75 * stomatal_slope,
         cuticular_cond = 0.75 * cuticular_cond)

inputs_antho <- inputs_wt %>% 
  mutate(quantum_efficiency = 0.75 * quantum_efficiency)

inputs_short <- inputs_wt %>% 
  mutate(fineroot2leaf = 1.25 * fineroot2leaf)
```

### Get predictions

Generate predictions of NPP for all four types of Setaria at all sites,
combined and cleaned up in a single dataframe.

``` r
npp_pred <- predict(rf_fit, 
                    inputs_wt, 
                    type = "numeric")$.pred

npp_pred_hotleaf <- predict(rf_fit, 
                            inputs_hotleaf, 
                            type = "numeric")$.pred

npp_pred_antho <- predict(rf_fit, 
                            inputs_antho, 
                            type = "numeric")$.pred

npp_pred_short <- predict(rf_fit, 
                            inputs_short, 
                            type = "numeric")$.pred

preds <- data.frame(site    = inputs_wt$site, 
                    year    = inputs_wt$year, 
                    wt      = npp_pred,
                    hotleaf = npp_pred_hotleaf,
                    anthox  = npp_pred_antho,
                    short   = npp_pred_short) %>% 
  left_join(., pred_mets %>% select(site, lat, lon) %>% distinct(), by = "site") %>% 
  select(-site)

preds_long <- preds %>% 
  pivot_longer(cols = c(-lat, -lon, -year))

head(preds)
```

    ##   year       wt  hotleaf   anthox    short   lat  lon
    ## 1 2010 3.065622 3.135708 3.873364 3.099888 35.00 -105
    ## 2 2011 2.892494 2.919489 3.759044 2.964141 35.00 -105
    ## 3 2012 2.892494 2.919489 3.759044 2.964141 35.00 -105
    ## 4 2013 5.985762 6.200064 7.634942 6.010254 35.00 -105
    ## 5 2014 6.641088 6.878824 8.580335 6.676455 35.00 -105
    ## 6 2010 2.751445 2.771513 3.606341 2.815145 35.25 -105

Getting percent difference between wild type predictions and three
modified plants predictions.

\[
percent difference = \frac{mod - wt}{wt} * 100
\]

``` r
preds_perc_diff <- preds %>% 
  transmute(lat = lat,
            lon = lon,
            year = year, 
            d_hotleaf = (hotleaf - wt) / wt * 100, 
            d_anthox  = (anthox - wt) / wt * 100, 
            d_short   = (short - wt) / wt * 100)

preds_perc_diff_long <- preds_perc_diff %>% 
  pivot_longer(cols = c(-lat, -lon, -year))

head(preds_perc_diff)
```

    ##     lat  lon year d_hotleaf d_anthox   d_short
    ## 1 35.00 -105 2010 2.2862065 26.34840 1.1177408
    ## 2 35.00 -105 2011 0.9332816 29.95859 2.4770022
    ## 3 35.00 -105 2012 0.9332816 29.95859 2.4770022
    ## 4 35.00 -105 2013 3.5802047 27.55172 0.4091750
    ## 5 35.00 -105 2014 3.5797806 29.20075 0.5325432
    ## 6 35.25 -105 2010 0.7293650 31.07080 2.3151391

### Plot predictions

Create background map for all plots.

``` r
NA_background <- map_data("state")
NA_map <- ggplot() +
  geom_polygon(data = NA_background, 
               aes(x = long, y = lat, group = group), 
               fill = "white", color = "black")
```

Plot predictions values on map for all Setaria types. Due to not being
able to install the `gifski` R package on Welsch, the commented out code
to generating a gif by year has to be run outside of Welsch.

``` r
NA_map +
  geom_raster(data = preds_long, aes(x = lon, y = lat, fill = value), 
              alpha = 0.9) +
  coord_cartesian(xlim = c(-108, -78), ylim = c(33, 42)) +
  theme_classic(base_size = 12) +
  theme(panel.background = element_rect(fill = "grey", colour = "grey"), 
        panel.grid.major = element_line(colour = "grey"),
        panel.grid.minor = element_line(colour = "grey")) +
  labs(x = "", y = "", fill = "") +
  facet_grid(name ~ year)
```

![](predict_growth_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

``` r
# write.csv(preds_long, "predictions.csv", row.names = FALSE)
#   facet_grid(~name) +
#   transition_manual(year) +
#   ggtitle('Year: {current_frame}')
# 
# animate(preds_gif)
# anim_save("predictions.gif", animation = preds_gif)
```

Plot percent difference between wild type Setaria and three modified
plants on map. Due to not being able to install the `gifski` R package
on Welsch, the commented out code to generating a gif by year has to be
run outside of Welsch.

``` r
#write.csv(preds_perc_diff_long, "predictions_perc.csv", row.names = FALSE)
dp <- list()  
color_scales <- c("YlOrRd", "RdPu", "YlGnBu")

for(i in 1:length(unique(preds_perc_diff_long$name))){
  dname <- unique(preds_perc_diff_long$name)[i]
  df <- preds_perc_diff_long %>% 
    filter(name == dname)
  dp[[dname]] <- NA_map +
    geom_raster(data = df, aes(x = lon, y = lat, fill = value), 
              alpha = 0.9) +
  scale_fill_distiller(palette = color_scales[i]) +
    coord_cartesian(xlim = c(-108, -78), ylim = c(33, 42))  +
    theme_classic(base_size = 12) +
    theme(panel.background = element_rect(fill = "grey", colour = "grey"), 
          panel.grid.major = element_line(colour = "grey"),
          panel.grid.minor = element_line(colour = "grey")) +
    labs(x = "", y = "", fill = "") +
    facet_wrap(~name)
  #   transition_manual(year) +
  #   ggtitle('Year: {current_frame}')
  # anim_save(paste0(dname, "_predictions.gif"), animation = dp[[dname]], height = 200, width = 600)
}

cowplot::plot_grid(plotlist = dp)
```

![](predict_growth_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

There are two possible measures of importance for random forest models.
The first uses randomly shuffled left out data called OOB. The second,
which we chose to use above when specifying the model, is the residual
sum of squares of node impurity.

The `vip` R package requires a newer version of R than Welsch currently
has, so this chunk has to be run with the saved out model fit in a
different instance of RStudio.

``` r
labels <- c(
  mort2 = 'Mortality', 
  growth_resp_factor = 'Growth Respiration', 
  leaf_turnover_rate = 'Leaf Turnover Rate', 
  leaf_width = 'Leaf Width', 
  nonlocal_dispersal = 'Seed Dispersal', 
  fineroot2leaf = 'Root:Leaf C Allocation', 
  root_turnover_rate = "Root Turnover Rate", 
  seedling_mortality = "Seedling Mortality", 
  stomatal_slope = "Stomatal Slope", 
  quantum_efficiency = "Quantum Efficiency", 
  vcmax = "Vcmax", 
  r_fract = "Respiration Fraction", 
  cuticular_cond = "Cuticular Conductance", 
  root_respiration_rate = "Root Respiration", 
  vm_low_temp = "Min Temp Photosynthesis", 
  sla = "Specific Leaf Area", 
  mean_temp = "Air Temperature", 
  mean_vpd = "Vapor Pressure Deficit", 
  mean_precip = "Precipitation", 
  mean_srad = "Solar Radiation", 
  mean_swe = "Soil Moisture"
)

rf_fit %>% 
  extract_fit_parsnip() %>%
  vip(num_features = 10, geom = 'point') + 
  theme_minimal() + 
  scale_x_discrete(labels = labels)
```
