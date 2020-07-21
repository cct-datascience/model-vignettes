Getting Setaria Biomass Coefficients from BioCro v0.95
================
Kristina Riemer, University of Arizona

### Walkthrough for optimizing using `DEoptim`

Optimizing biomass coefficients so that biomass estimates from BioCro as closely as possible match the measured biomass values. Parameters of interest are phenoParms, with thermal times and rhizome coefficients being fixed and leaf, stem, root, and grain coefficients being optimized across. This returns values of biomass for each stage and plant part, but the value being minimized is the difference between measured biomass values and biomass estimated by BioCro. It seems like we can optimized across all stages at once within our objective function.

First read in all the necessary input data:

-   BioCro config file
-   weather file created for biomass partitioning in [partitioned\_biomass\_data.Rmd](https://github.com/az-digitalag/model-vignettes/blob/master/BioCro/DARPA/partitioned_biomass_data.md)
-   biomass file from Setaria experiments in [partitioned\_biomass\_data.Rmd](https://github.com/az-digitalag/model-vignettes/blob/master/BioCro/DARPA/partitioned_biomass_data.md)

``` r
library(dplyr)

rundir <- getwd()

opt_weather <- read.csv("opt_inputs/opt_weather.csv")
colnames(opt_weather) <- c("year", "doy", "hour", "Solar", "Temp", "RH", "WS", "precip")

config <- PEcAn.BIOCRO::read.biocro.config(file.path(rundir, "opt_inputs/config.xml"))

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
dayn <- 50

opt_biomass <- read.csv("opt_inputs/opt_biomass.csv") %>% 
  select(-LAI)
```

We want biomass estimates from `BioGro` (i.e., ttt) to be as close to the actual biomass values as possible (i.e., opt\_biomass). Will be optimizing over the parameters, which are the biomass coefficients.

First create objective function `opfn`, and include parameter values to test if this function by itself works.

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
    WetDat = opt_weather,
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
                   Grain = t$Grain)
  ttt <- tt %>% 
    filter(round(tt$ThermalT) %in% round(opt_biomass$ThermalT))
  bio_ests <- select(ttt, -ThermalT)
  bio_meas <- select(opt_biomass, -ThermalT)
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
  #   select(Stem_norm, Leaf_norm, Root_norm, Rhizome, Grain) %>% 
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

    ## [1] 4.960294

Run objective function through optimization with `DEoptim`, setting the upper and lower bounds for the varying parameters to 0 and 1 and providing values for the non-varying parameters thermal time and rhizome coefficients. Reducing itermax reduces time to run `DEoptim`, but the resulting best value doesn't change much.

``` r
library(DEoptim)

thermaltimevals <- c(config$pft$phenoParms$tp1, config$pft$phenoParms$tp2, 
                     config$pft$phenoParms$tp3, config$pft$phenoParms$tp4, 
                     config$pft$phenoParms$tp5, config$pft$phenoParms$tp6)
rhizomevals <- rep(0, 6)

opt_results <- DEoptim(fn = opfn, lower = c(rep(0, 2), rep(0.6, 4), 0.3, 0.1, rep(0, 11)), upper = c(rep(1, 8), rep(0.1, 4), rep(1, 7)), thermaltimeParms = thermaltimevals, rhizomeParms = rhizomevals, control = DEoptim.control(itermax = 20))
```

Test that the resulting parameter values produce the same biomass estimates. `parms_results` are the actual parameters that we would use because they've been adjusted for the sum to 1 constraint.

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
    WetDat = opt_weather,
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
                 Grain = results_test$Grain)
results_test3 <- results_test2 %>% 
  filter(round(results_test2$ThermalT) %in% round(opt_biomass$ThermalT))
diff <- sum(abs(results_test3 - opt_biomass))

biomass_meas_plot <- opt_biomass %>% 
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

![](biomass_coeffs_0.95_files/figure-markdown_github/unnamed-chunk-4-1.png)
