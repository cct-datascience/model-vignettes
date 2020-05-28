This repo contains vignettes and data files for running ecosystem crop models, including [BioCro](https://github.com/ebimodeling/biocro) and [ED2](https://github.com/EDmodel/ED2), within the [PEcAn Bayesian framework](https://pecanproject.github.io/). Some of these are specific to a project on plant sensing. 

### List of vignettes
To read and/or follow along with vignettes, use the .md version of files. To run locally or update, use .Rmd version. 

In `BioCro/DARPA` folder: 

- `explore_biomass_data` - cleans up and plots *Setaria* biomass data from 8 experiments
- `partitioned_biomass_data` - cleans up and organizes *Setaria* biomass by part data, along with accompanying weather data
- `pecan_runs` - demonstrates how to run BioCro in PEcAn on Welsch server for one and two *Setaria* cultivars
- `opt_0.95` - shows how to optimize across biomass coefficients for BioCro version 0.95
- `opt_1.0` - shows how to optimize across biomass coefficients for BioCro version 1.0
- `regional_runs` - shows how to generate a gif of biomass for a year across a part of Illinois, with biomass estimated using BioCro
- `temps_exps` - demonstrates how to run BioCro in PEcAn on Welsch server for two treatments of a temperature experiment on *Setaria* 
- `opts_inputs` - holds input files (`config.xml`, weather, biomass by part) for `opt_0.95` and `opt_1.0`
- `regional_runs_inputs` - holds input files for `regional_runs` 

