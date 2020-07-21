## Model vignettes
Includes vignettes for running several different models in PEcAn

### `BioCro/DARPA/` folder 
This location has all of the vignettes for running BioCro on *Setaria* data for the Sentinel project. 

Do the following tasks before knitting vignettes. 
* Access RStudio in a browser by navigating to [welsch.cyverse.org:8787/](welsch.cyverse.org:8787/). Log in using your username and password. 
* In the home directory, clone both the analysis and data repos: 
```
git clone https://github.com/az-digitalag/model-vignettes.git
git clone https://github.com/az-digitalag/model-vignettes-data.git
```

Vignettes and inputs/outputs: 
1. `partitioned_biomass_data`gets data prepared for estimating biomass coefficients from BioCro (see 2 & 3) 
	* Inputs: [biomass data](https://github.com/az-digitalag/model-vignettes-data/blob/master/2019-01-me034-mutant-biomass.csv) from private data repo
	* Outputs: `opt_biomass.csv` and `opt_weather.csv` in `opt_inputs` 
2. `biomass_coeffs_0.95` estimates biomass coefficients using BioCro version 0.95
	* Inputs: `opt_biomass.csv` and `opt_weather.csv`
	* Outputs: biomass coefficients (these aren't saved anywhere)
3. `biomass_coeffs_1.0` estimates biomass coefficients using BioCro version 1.0
	* Inputs: `opt_biomass.csv`, `opt_weather.csv`, `setaria_initial_state.RData`, and `setaria_parameters.RData` (latter two generated by `create_params.R`)
	* Outputs: biomass coefficients (these aren't saved anywhere)
4. `plot_biomass_meas` plots biomass data from all seven experiments
	* Inputs: [biomass data](https://github.com/az-digitalag/model-vignettes-data/blob/master/manual-measurements-Darpa_setaria_chambers_experiments.xlsx) from private data repo
5. `temp_exps_biomass` does three runs of BioCro and creates plots of biomass estimates against measured biomass values
	* Inputs: for each run in `temp_exps_inputs*` folder, there are `temp_exps*.xml`, `workflow.R`, `setaria.constants.xml`, and `generate_*_weather.R`
	* Outputs: BioCro results are all in `temp_exps_results` folder, and outputs in `temp_exps_inputs*` folder are `danforth-*-chamber.2019.csv`, `biomass_ests*.csv`, and `*_biomass_measu.csv`
6. (needs to be updated) `pecan_runs` shows how to do BioCro runs for two *Setaria* cultivars
7. (needs to be updated) `regional_runs` creates gif of BiCro runs across a large regional extent
