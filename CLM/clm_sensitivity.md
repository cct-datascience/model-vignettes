CLM Sensitivity Analysis
================

``` r
library(broom)
library(magrittr)
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
library(tidyr)
```

    ## 
    ## Attaching package: 'tidyr'

    ## The following object is masked from 'package:magrittr':
    ## 
    ##     extract

``` r
library(ggplot2)
```

Data are parameter values with corresponding response variable
values.

``` r
vegc <- readr::read_csv("clm5_CIG_C4grass_e101_Annual_mean_TOTVEGC_for_decomposition.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   sla = col_double(),
    ##   c2nleaf = col_double(),
    ##   fineroot2leaf = col_double(),
    ##   flnr_vc = col_double(),
    ##   stom_slope = col_double(),
    ##   Annual_mean_TOTVEGC = col_double()
    ## )

### Elasticity

Sensitivity is the change in the response variable given a change in an
input variable, which can be a parameter, initial condition, etc. This
is representated by the derivative dY/dX. This is calculated below from
the slope of the linear regression between the parameter values and
response variable.

``` r
slopes <- tidy(lm(data = vegc, formula = Annual_mean_TOTVEGC ~ .)) %>% 
  rename(sensitivity = estimate)
```

Because the units of the derviative are determined by X’s units,
elasticity is used to standardize sensitivity across variables.
Elasticity is dY/dX \* (mean X/mean Y).

``` r
mean_vegc_response <- mean(vegc$Annual_mean_TOTVEGC)

mean_vegc_params <- vegc %>% 
  select(-Annual_mean_TOTVEGC) %>% 
  summarise_all(funs(mean)) %>% 
  gather(parameter, mean) %>% 
  mutate(elasticity_multiplier = mean / mean_vegc_response)

elasticity <- left_join(slopes, mean_vegc_params, by = c("term" = "parameter")) %>% 
  mutate(elasticity = sensitivity * elasticity_multiplier)
```

Elasticity values increasingly farther from zero mean change in x is
causing increasingly greater change in y. A change in x causes the same
change in y when elasticity is one.

``` r
ggplot(elasticity, aes(x = elasticity, y = term)) +
  geom_point() +
  geom_vline(xintercept = 0) +
  lims(x = c(-1, 1))
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](clm_sensitivity_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

### Coefficient of Variation

CV is the normalized parameter variance of all the input parameters.

``` r
CVs <- vegc %>% 
  select(-Annual_mean_TOTVEGC) %>% 
  gather(parameter, value) %>% 
  group_by(parameter) %>% 
  summarize(mean = mean(value), 
            var = var(value)) %>% 
  mutate(sd = sqrt(var), 
         cv = (sd / mean) * 100)
```

``` r
ggplot(CVs, aes(x = cv, y = parameter)) +
  geom_point() +
  geom_vline(xintercept = 0)
```

![](clm_sensitivity_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

### Explained Standard Deviation

How much of the response variable uncertainty is explained by each of
the parameters. Incorporates both parameter variance and sensitivity.

``` r
SDs <- tidy(aov(Annual_mean_TOTVEGC ~ ., data = vegc)) %>% 
  mutate(sd = sqrt(sumsq)) %>% 
  select(term, sd)
```

``` r
ggplot(SDs, aes(x = sd, y = term)) +
  geom_point() +
  geom_vline(xintercept = 0)
```

![](clm_sensitivity_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->
