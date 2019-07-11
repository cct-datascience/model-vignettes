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
sens_data <- readr::read_csv("clm5_Equ_C4g_default_ens_e500_output.txt", 
                                 skip = 1)
```

    ## Parsed with column specification:
    ## cols(
    ##   sla = col_double(),
    ##   fineroot2leaf = col_double(),
    ##   `c2n leaf` = col_double(),
    ##   `flnr in` = col_double(),
    ##   `target c2n leaf` = col_double(),
    ##   `target c2n froot` = col_double(),
    ##   `stom slope g1` = col_double(),
    ##   `min stom cond` = col_double(),
    ##   `root dist` = col_double(),
    ##   TLAI = col_double(),
    ##   DISPVEGC = col_double(),
    ##   QVEGT = col_double(),
    ##   LEAFC = col_double(),
    ##   TOTVEGC = col_double(),
    ##   NPP = col_double(),
    ##   LEAFN = col_double(),
    ##   GPP = col_double()
    ## )

``` r
colnames(sens_data) <- gsub(" ", "_", colnames(sens_data))
sens_data_ex <- sens_data %>% 
  select(1:10)
```

### Example of Sensitivity Analysis for Single Output Variable

#### 1\. Elasticity

Sensitivity is the change in the response variable given a change in an
input variable, which can be a parameter, initial condition, etc. This
is representated by the derivative dY/dX. This is calculated below from
the slope of the linear regression between the parameter values and
response variable.

``` r
slopes <- tidy(lm(data = sens_data_ex, formula = TLAI ~ .)) %>% 
  rename(sensitivity = estimate) %>% 
  filter(term != "(Intercept)")
```

Because the units of the derviative are determined by X’s units,
elasticity is used to standardize sensitivity across variables.
Elasticity is dY/dX \* (mean X/mean Y).

``` r
mean_response <- mean(sens_data_ex$TLAI)

mean_params <- sens_data_ex %>% 
  select(-TLAI) %>% 
  summarise_all(funs(mean)) %>% 
  gather(parameter, mean) %>% 
  mutate(elasticity_multiplier = mean / mean_response)

elasticity <- left_join(slopes, mean_params, by = c("term" = "parameter")) %>% 
  mutate(elasticity = sensitivity * elasticity_multiplier)
```

Elasticity values increasingly farther from zero mean change in x is
causing increasingly greater change in y. A change in x causes the same
change in y when elasticity is one.

``` r
ggplot(elasticity, aes(x = elasticity, y = term)) +
  geom_point() +
  geom_vline(xintercept = 0)
```

![](clm_sensitivity_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

#### 2\. Coefficient of Variation

CV is the normalized parameter variance of all the input parameters.

``` r
CVs <- sens_data_ex %>% 
  select(-TLAI) %>% 
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
  geom_vline(xintercept = 0) +
  xlab("CV (%)")
```

![](clm_sensitivity_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

#### 3\. Explained Standard Deviation

How much of the response variable uncertainty is explained by each of
the parameters. Incorporates both parameter variance and sensitivity.

``` r
SDs <- tidy(aov(TLAI ~ ., data = sens_data_ex)) %>% 
  mutate(sd = sqrt(sumsq)) %>% 
  select(term, sd)
```

``` r
ggplot(SDs, aes(x = sd, y = term)) +
  geom_point() +
  geom_vline(xintercept = 0)
```

![](clm_sensitivity_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

### Sensitivity Analysis for All Output Variables

``` r
#function that does all plots and puts together (Cowplot)
#test on TLAI

plot_sensitivity <- function(data){
  slopes <- tidy(lm(data = data, formula = TLAI ~ .)) %>% 
    rename(sensitivity = estimate) %>% 
    filter(term != "(Intercept)")
  mean_response <- mean(sens_data_ex$TLAI)
  mean_params <- sens_data_ex %>% 
    select(-TLAI) %>% 
    summarise_all(funs(mean)) %>% 
    gather(parameter, mean) %>% 
    mutate(elasticity_multiplier = mean / mean_response)
  elasticity <- left_join(slopes, mean_params, by = c("term" = "parameter")) %>% 
    mutate(elasticity = sensitivity * elasticity_multiplier)
  elasticity_plot <- ggplot(elasticity, aes(x = elasticity, y = term)) +
    geom_point() +
    geom_vline(xintercept = 0)
}
```

``` r
#remove other response vars first? 
#for loop over all reponse vars
```
