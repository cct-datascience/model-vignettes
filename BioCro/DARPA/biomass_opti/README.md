# Biomass optimization

This folder contains code used to optimize the BioCro biomass allocation parameters for *Setaria* growth. Plants from the second chamber experiment (31/31/430) were harvested 6 times and stem, leaf, root, and panicle biomass was recorded. 

## Contents:

* `inputs/` folder:
  1. `ch_config.xml`, *Setaria* constants for BioCro copied over from the SA-median output of the 'ch' run from 'env_comp_results', which uses physiological parameters from the 31/22/430 environment
  2. `ch_weather.csv` treatment-specific weather inputs to BioCro
  3. `ch_biomass.csv` Thermal time and biomass of Stem, Leaf, Root, Rhizome, and Grain for 6 harvest times

* `scripts/` folder:
  1. `generate_weather_config.R` generate weather for chamber 31/31/430 and copies the config file from 'env_comp_results/ch/run/SA-median/'
  2. `collate_biomass.R` prepares biomass data for validation and substitutes tp, seneControl, and k parameters based on Nielsen et al. 2016 and empirical rates of biomass allocation
  3. `optimize_biomass_coef.Rmd` main script to optimize k parameters
  4. `opt_results.Rdata*` output of optimization
  5. `modify_constants_file.R` update existing constants files in 'env_comparison' and 'temp_comparison'
  6. `plot_opti.R` plot observed and modeled biomass of root, leaf, stem, and grain