Using BioCro 1.0 on Setaria Data
================
Author: Kristina Riemer

### Switching between BioCro versions locally

Download repos for [BioCro 0.95](https://github.com/ebimodeling/biocro)
and
[BioCro 1.0](https://github.com/ebimodeling/biocro/tree/new-framework),
and place unzipped folders into this repo in `BioCro/DARPA`. Use the
code below to switch between these two versions when needs.

BioCro
0.95:

``` r
install.packages('biocro_0.95/biocro-master', repos = NULL, type = 'SOURCE')
```

BioCro
1.0:

``` r
install.packages('biocro_1.00/biocro-new-framework', repos = NULL, type = 'SOURCE')
```

Check version:

``` r
library(BioCro)
sessionInfo()
```

    ## R version 3.6.1 (2019-07-05)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Catalina 10.15.4
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] BioCro_1.00
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_3.6.1  magrittr_1.5    tools_3.6.1     htmltools_0.4.0
    ##  [5] yaml_2.2.1      Rcpp_1.0.4      stringi_1.4.6   rmarkdown_2.1  
    ##  [9] grid_3.6.1      knitr_1.28      stringr_1.4.0   xfun_0.12      
    ## [13] digest_0.6.25   rlang_0.4.5     lattice_0.20-38 evaluate_0.14

### Read in data

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
OpBioGro_weather <- read.csv("biocro_opt_darpa_files/OpBioGro_weather.csv") %>% 
  rename(solar = solarR, temp = DailyTemp.C, rh = RH, windspeed = WindSpeed)
 OpBioGro_biomass <- read.csv("biocro_opt_darpa_files/OpBioGro_biomass.csv")
```

### Set up parameters

The following code uses BioCro 1.0.

Set up the parameters for *Setaria* with these two lists,
`setaria_initial_state` and `setaria_parameters`.

``` r
setaria_initial_state <- with(list(), {
  datalines =
    "symbol value
    
    # BioCro arguments
    Rhizome 0.001
    Leaf 0.001
    Stem 0.001
    Root 0.001
    
    Grain 0
    soil_water_content 0.32
    LeafN 2
    TTc 0
    LeafLitter 0
    RootLitter 0
    RhizomeLitter 0
    StemLitter 0
    leaf_senescence_index 0
    stem_senescence_index 0
    root_senescence_index 0
    rhizome_senescence_index 0"
  
  data_frame = utils::read.table(textConnection(datalines), header=TRUE)
  values = as.list(data_frame$value)
  names(values) = data_frame$symbol
  values
})

setaria_parameters <- with(list(), {
  datalines =
    "symbol value
    acceleration_from_gravity 9.8
    
    # config$location$latitude
    lat 38.67459
    
    soil_clod_size 0.04
    soil_reflectance 0.2
    soil_transmission 0.01
    specific_heat 1010
    stefan_boltzman 5.67e-8
    iSp 1.7
    Sp_thermal_time_decay 0
    
    # canopyControl
    nlayers 10
    kd 0.1
    chil 1
    heightf 3
    leafwidth 0.04
    et_equation 0
    
    growth_respiration_fraction 0 # is this mResp?
    
    # seneControl
    seneLeaf 3000
    seneStem 3500
    seneRoot 4000
    seneRhizome 4000
    
    tbase 0
    
    # photoParms
    vmax1 29.7409235442261
    alpha1 0.04
    kparm 0.7
    theta 0.83
    beta 0.93
    Rd 1.33025819997024
    Catm 400
    b0 0.0138148692577794
    b1 5.7057446269736
    water_stress_approach 1
    upperT 37.5
    lowerT 3

    # soil control (only missing FieldC & WiltP)
    phi1 0.01
    phi2 10
    soil_depth 1
    soil_type_indicator 6
    soilLayers 1
    wsFun 0
    scsf 1
    transpRes 5000000
    leafPotTh -800
    hydrDist 0
    rfl 0.2
    rsec 0.2
    rsdf 0.44
    
    SC1 1
    SC2 1
    SC3 1
    SC4 1
    SC5 1
    SC6 1
    SC7 1
    SC8 1
    SC9 1
    LeafL.Ln 0.17
    StemL.Ln 0.17
    RootL.Ln 0.17
    RhizL.Ln 0.17
    LeafL.N 0.004
    StemL.N 0.004
    RootL.N 0.004
    RhizL.N 0.004
    iMinN 0
    
    # optimalParms
    tp1 150
    tp2 300
    tp3 450
    tp4 600
    tp5 750
    tp6 900
    kStem1 0.312482562
    kLeaf1 0.350204711
    kRoot1 0.337312727
    kRhizome1 0
    kGrain1 0
    kStem2 0.28215246
    kLeaf2 0.385131018
    kRoot2 0.332716522
    kRhizome2 0
    kGrain2 0
    kStem3 0.449611092
    kLeaf3 0.549167954
    kRoot3 0.001220954
    kRhizome3 0
    kGrain3 0
    kStem4 0.450730685
    kLeaf4 0.38210712
    kRoot4 0.167162195
    kRhizome4 0
    kGrain4 0
    kStem5 0.687613079
    kLeaf5 0.197814203
    kRoot5 0.114572719
    kRhizome5 0
    kGrain5 0
    kStem6 0.758825523
    kLeaf6 0.01127437
    kRoot6 0.143217809
    kRhizome6 0
    kGrain6 0.086682298
    
    LeafN_0 2
    kln 0.5
    vmax_n_intercept 0
    alphab1 0
    kpLN 0.2
    lnb0 -5
    lnb1 18
    lnfun 0
    nileafn 85
    nkln 0.5
    nvmaxb1 0.6938
    nvmaxb0 -16.25
    nalphab1 0.000488
    nalphab0 0.02367
    nRdb1 0.1247
    nRdb0 -4.5917
    nkpLN 0.17
    nlnb0 -5
    nlnb1 18
    timestep 1
    centTimestep 1
    doyNfert 0
    mrc1 0.02
    mrc2 0.03
    leaf_reflectance 0.2
    leaf_transmittance 0.2"
  
  data_frame = utils::read.table(textConnection(datalines), header=TRUE)
  values = as.list(data_frame$value)
  names(values) = data_frame$symbol
  values
})
```

Create the modules, which are currently developed for *Sorghum*.

``` r
sorghum_modules <- list(canopy_module_name='c4_canopy',
                       soil_module_name='one_layer_soil_profile',
                       growth_module_name='partitioning_growth',
                       senescence_module_name='thermal_time_senescence',
                       leaf_water_stress_module_name='leaf_water_stress_exponential',
                       stomata_water_stress_module_name='stomata_water_stress_linear')
```

Use these three inputs, along with a weather file included with the
package, to generate biomass values for **Setaria**.

``` r
setaria_result <- Gro(setaria_initial_state, 
                      setaria_parameters, 
                      get_growing_season_climate(OpBioGro_weather), 
                      sorghum_modules)
```

### Plot results with data

We are plotting the estimated biomass values from BioCro with the
measured values that were used to estimate the parameters, in order to
compare them.

``` r
setaria_result_plot <- setaria_result %>% 
  select(TTc, Stem, Leaf, Root, Rhizome, Grain) %>% 
  tidyr::pivot_longer(Stem:Grain) %>% 
  rename(ThermalT = TTc)

setaria_data_plot <- OpBioGro_biomass %>% 
  select(-LAI) %>% 
  tidyr::pivot_longer(Stem:Grain)

library(ggplot2)
ggplot() +
  geom_point(setaria_data_plot, mapping = aes(x = ThermalT, y = value, color = name)) +
  geom_line(setaria_result_plot, mapping = aes(x = ThermalT, y = value, color = name)) +
  xlim(c(0, 1800)) +
  labs(x = "Thermal Time", y = "Biomass (Ma/ha)", color = "Plant Part") +
  theme_classic() +
  facet_wrap(~name)
```

    ## Warning: Removed 21950 rows containing missing values (geom_path).

![](biocro_1.0_darpa_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->
