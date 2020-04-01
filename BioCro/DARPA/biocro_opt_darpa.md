How to Optimze Biomass Estimation for DARPA Data Using BioCro Model
================
Kristina Riemer, University of Arizona

### Walkthrough for optimizing using `DEoptim`

Optimizing biomass coefficients so that biomass estimates from BioCro as
closely as possible match the measured biomass values. Parameters of
interest are phenoParms, with thermal times and rhizome coefficients
being fixed and leaf, stem, root, and grain coefficients being optimized
across. This returns values of biomass for each stage and plant part,
but the value being minimized is the difference between measured biomass
values and biomass estimated by BioCro. It seems like we can optimized
across all stages at once within our objective function.

First read in all the necessary input data:

  - BioCro config file
  - weather file created for biomass partitioning
  - biomass file from Setaria experiments

<!-- end list -->

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
rundir <- getwd()

OpBioGro_weather <- read.csv("biocro_opt_darpa_files/OpBioGro_weather.csv")
colnames(OpBioGro_weather) <- c("year", "doy", "hour", "Solar", "Temp", "RH", "WS", "precip")
readr::write_csv(OpBioGro_weather, path = file.path(rundir, 'SA-median.2019.csv'))
WetDat <- OpBioGro_weather

config <- PEcAn.BIOCRO::read.biocro.config(file.path(rundir, "biocro_opt_darpa_files/config.xml"))

lat <- as.numeric(config$location$latitude)
lon <- as.numeric(config$location$longitude)
config$run$start.date <- "2019/01/01"
config$run$end.date <- "2019/12/01"
start.date <- lubridate::date(config$run$start.date)
end.date   <- lubridate::date(config$run$end.date)
genus <- config$pft$type$genus
years <- lubridate::year(start.date):lubridate::year(end.date)
l2n <- function(x) lapply(x, as.numeric)
day1 <- 1
dayn <- 100

OpBioGro_biomass <- read.csv("biocro_opt_darpa_files/OpBioGro_biomass.csv")
```

We want biomass estimates from `BioGro` (i.e., ttt) to be as close to
the actual biomass values as possible (i.e., OpBioGro\_biomass). Will be
optimizing over the parameters, which are the biomass coefficients.

TODO:

  - ~~Remove thermal times from biomass tables~~
  - (later) figure out better metric for comparing biomass values
      - ~~sum of absolute value (because sign doesn’t matter, magnitude
        of difference does)~~
      - log transform
      - ~~(ttt - OpBioGro\_biomass) / OpBioGro\_biomass~~
  - ~~upper and lower bounds are, initially, each between 0 and 1~~
      - Can use more restricted bounds, base on BioCro defaults?
  - ~~additional param constraints: parameter values for each stage
    should sum to one (note: this MUST happen because `BioCro` will not
    use pheno params that do not equal one)~~
      - ~~fnMap argument is only for number of parameters constraints?~~
    
      - ~~include something like the below, see `?DEoptim` for another
        example~~ function(x){ if(x\[1:5\] == 1){ ifelse(x\[6:10\]){ … }
        }
    
      - ~~another option for this sum to one constraint is something
        like the following for each stage as the first part of `opfn`~~

<!-- end list -->

``` r
z <- c(0.1, 0.2, 0.15)
z[1:3]
sum(z[1:3])
z[1:3]/sum(z[1:3])
sum(z[1:3]/sum(z[1:3]))
```

  - ~~keep thermal times the same, can set them in the phenoControl
    line, and set rhizome values == 0~~

  - ~~phenoParms = vector of 25 values~~
    
      - ~~split up parameters into the ones that will vary and the ones
        that will not. op parms = 19 values, thermal = 6, rhizome = 6~~
      - ~~reassemble within opfn function~~

  - ~~Biomass measurements need to be in correct units (Mg/ha)~~

First create objective function `opfn`, and include parameter values to
test if this function by itself works.

``` r
library(BioCro)

opfn <- function(optimizingParms, thermaltimeParms, rhizomeParms){ 
  optimizingParms[1:3] <- optimizingParms[1:3]/sum(optimizingParms[1:3])
  optimizingParms[4:6] <- optimizingParms[4:6]/sum(optimizingParms[4:6])
  optimizingParms[7:9] <- optimizingParms[7:9]/sum(optimizingParms[7:9])
  optimizingParms[10:12] <- optimizingParms[10:12]/sum(optimizingParms[10:12])
  optimizingParms[13:15] <- optimizingParms[13:15]/sum(optimizingParms[13:15])
  optimizingParms[16:19] <- optimizingParms[16:19]/sum(optimizingParms[16:19])
  params_list <- phenoParms(tp1 = thermaltimeParms[1], 
                           tp2 = thermaltimeParms[2], 
                           tp3 = thermaltimeParms[3], 
                           tp4 = thermaltimeParms[4], 
                           tp5 = thermaltimeParms[5], 
                           tp6 = thermaltimeParms[6], 
                           kStem1 = optimizingParms[1], 
                           kStem2 = optimizingParms[4], 
                           kStem3 = optimizingParms[7], 
                           kStem4 = optimizingParms[10], 
                           kStem5 = optimizingParms[13], 
                           kStem6 = optimizingParms[16], 
                           kLeaf1 = optimizingParms[2], 
                           kLeaf2 = optimizingParms[5], 
                           kLeaf3 = optimizingParms[8], 
                           kLeaf4 = optimizingParms[11], 
                           kLeaf5 = optimizingParms[14], 
                           kLeaf6 = optimizingParms[17], 
                           kRoot1 = optimizingParms[3], 
                           kRoot2 = optimizingParms[6], 
                           kRoot3 = optimizingParms[9], 
                           kRoot4 = optimizingParms[12], 
                           kRoot5 = optimizingParms[15], 
                           kRoot6 = optimizingParms[18], 
                           kRhizome1 = rhizomeParms[1], 
                           kRhizome2 = rhizomeParms[2], 
                           kRhizome3 = rhizomeParms[3], 
                           kRhizome4 = rhizomeParms[4], 
                           kRhizome5 = rhizomeParms[5], 
                           kRhizome6 = rhizomeParms[6], 
                           kGrain6 = optimizingParms[19])
  
  t <- BioCro::BioGro(
    WetDat = WetDat,
    day1 = day1,
    dayn = dayn,
    iRhizome = 0.001, 
    iLeaf = 0.001, 
    iStem = 0.001, 
    iRoot = 0.001, 
    soilControl = l2n(config$pft$soilControl),
    canopyControl = l2n(config$pft$canopyControl),
    phenoControl = l2n(params_list),
    seneControl = l2n(config$pft$seneControl),
    photoControl = l2n(config$pft$photoParms))

  tt <- data.frame(ThermalT = t$ThermalT, 
                   Stem = t$Stem,
                   Leaf = t$Leaf,
                   Root = t$Root,
                   Rhizome = t$Rhizome,
                   Grain = t$Grain,
                   LAI = t$LAI)
  ttt <- tt %>% 
    filter(round(tt$ThermalT) %in% round(OpBioGro_biomass$ThermalT))
  bio_ests <- select(ttt, -ThermalT)
  bio_meas <- select(OpBioGro_biomass, -ThermalT)
  diff <- abs(bio_ests - bio_meas)
  
  # bio_meas_sum <- bio_meas %>% 
  #   mutate(stage = rownames(.)) %>% 
  #   rowwise() %>% 
  #   mutate(total_bio = sum(Stem:Grain)) %>% 
  #   select(stage, total_bio)
  # 
  # diff_norm <- diff %>% 
  #   mutate(stage = rownames(.)) %>% 
  #   left_join(., bio_meas_sum, by = c("stage")) %>% 
  #   mutate(Stem_norm = Stem / total_bio, 
  #        Leaf_norm = Leaf / total_bio, 
  #        Root_norm = Root / total_bio) %>% 
  #   select(Stem_norm, Leaf_norm, Root_norm, Rhizome, Grain, LAI) %>% 
  #   rename(Stem = Stem_norm, Leaf = Leaf_norm, Root = Root_norm)
  
  return(sum(diff))
}

# Check function itself by running with example parameter values
optimizingParms_check <- c(rep(c(0.2, 0.3, 0.5), 6), 0)
thermaltimeParms_check <- c(config$pft$phenoParms$tp1, config$pft$phenoParms$tp2,
                      config$pft$phenoParms$tp3, config$pft$phenoParms$tp4,
                      config$pft$phenoParms$tp5, config$pft$phenoParms$tp6)
rhizomeParms_check <- rep(0, 6)
opfn(optimizingParms_check, thermaltimeParms_check, rhizomeParms_check)
```

    ## [1] 6

    ## [1] 6.440337

Run objective function through optimization with `DEoptim`, setting the
upper and lower bounds for the varying parameters to 0 and 1 and
providing values for the non-varying parameters thermal time and rhizome
coefficients. Reducing itermax reduces time to run `DEoptim`, but the
resulting best value doesn’t change much.

``` r
library(DEoptim)

thermaltimevals <- c(config$pft$phenoParms$tp1, config$pft$phenoParms$tp2, 
                     config$pft$phenoParms$tp3, config$pft$phenoParms$tp4, 
                     config$pft$phenoParms$tp5, config$pft$phenoParms$tp6)
rhizomevals <- rep(0, 6)

opt_results <- DEoptim(fn = opfn, lower = rep(0, 19), upper = rep(1, 19), thermaltimeParms = thermaltimevals, rhizomeParms = rhizomevals, control = DEoptim.control(itermax = 2))
```

Test that the resulting parameter values produce the same biomass
estimates. `parms_results` are the actual parameters that we would use
because they’ve been adjusted for the sum to 1 constraint.

``` r
library(ggplot2)

parms_results <- as.vector(opt_results$optim$bestmem)
parms_results[1:3] <- parms_results[1:3]/sum(parms_results[1:3])
parms_results[4:6] <- parms_results[4:6]/sum(parms_results[4:6])
parms_results[7:9] <- parms_results[7:9]/sum(parms_results[7:9])
parms_results[10:12] <- parms_results[10:12]/sum(parms_results[10:12])
parms_results[13:15] <- parms_results[13:15]/sum(parms_results[13:15])
parms_results[16:19] <- parms_results[16:19]/sum(parms_results[16:19])
optimalParms <- phenoParms(tp1 = thermaltimevals[1], 
                                 tp2 = thermaltimevals[2], 
                                 tp3 = thermaltimevals[3], 
                                 tp4 = thermaltimevals[4], 
                                 tp5 = thermaltimevals[5], 
                                 tp6 = thermaltimevals[6], 
                                 kStem1 = parms_results[1], 
                                 kStem2 = parms_results[4], 
                                 kStem3 = parms_results[7], 
                                 kStem4 = parms_results[10], 
                                 kStem5 = parms_results[13], 
                                 kStem6 = parms_results[16], 
                                 kLeaf1 = parms_results[2], 
                                 kLeaf2 = parms_results[5], 
                                 kLeaf3 = parms_results[8], 
                                 kLeaf4 = parms_results[11], 
                                 kLeaf5 = parms_results[14], 
                                 kLeaf6 = parms_results[17], 
                                 kRoot1 = parms_results[3], 
                                 kRoot2 = parms_results[6], 
                                 kRoot3 = parms_results[9], 
                                 kRoot4 = parms_results[12], 
                                 kRoot5 = parms_results[15], 
                                 kRoot6 = parms_results[18], 
                                 kRhizome1 = rhizomevals[1], 
                                 kRhizome2 = rhizomevals[2], 
                                 kRhizome3 = rhizomevals[3], 
                                 kRhizome4 = rhizomevals[4], 
                                 kRhizome5 = rhizomevals[5], 
                                 kRhizome6 = rhizomevals[6], 
                                 kGrain6 = parms_results[19])

results_test <- BioCro::BioGro(
    WetDat = WetDat,
    day1 = day1,
    dayn = dayn,
    iRhizome = 0.001, 
    iLeaf = 0.001, 
    iStem = 0.001, 
    iRoot = 0.001, 
    soilControl = l2n(config$pft$soilControl),
    canopyControl = l2n(config$pft$canopyControl),
    phenoControl = l2n(optimalParms),
    seneControl = l2n(config$pft$seneControl),
    photoControl = l2n(config$pft$photoParms))
```

    ## [1] 6

``` r
results_test2 <- data.frame(ThermalT = results_test$ThermalT, 
                 Stem = results_test$Stem,
                 Leaf = results_test$Leaf,
                 Root = results_test$Root,
                 Rhizome = results_test$Rhizome,
                 Grain = results_test$Grain,
                 LAI = results_test$LAI)
results_test3 <- results_test2 %>% 
  filter(round(results_test2$ThermalT) %in% round(OpBioGro_biomass$ThermalT))
diff <- sum(abs(results_test3 - OpBioGro_biomass))

plot(results_test)
```

![](biocro_opt_darpa_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
biomass_meas_plot <- OpBioGro_biomass %>% 
  tidyr::pivot_longer(Stem:Grain) %>% 
  mutate(data = "measurements")
biomass_ests_plot <- results_test2 %>% 
  tidyr::pivot_longer(Stem:Grain) %>% 
  mutate(data = "estimates")
biomass_plot <- bind_rows(biomass_meas_plot, biomass_ests_plot)

ggplot() +
  geom_point(filter(biomass_plot, data == "measurements"), mapping = aes(x = ThermalT, y = value, color = name)) +
  geom_line(filter(biomass_plot, data == "estimates"), mapping = aes(x = ThermalT, y = value, color = name)) +
  xlim(c(0, 1800)) +
  labs(x = "Thermal Time", y = "Biomass (Ma/ha)", color = "Plant Part") +
  theme_classic() +
  facet_wrap(~name)
```

    ## Warning: Removed 5035 rows containing missing values (geom_path).

![](biocro_opt_darpa_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->
