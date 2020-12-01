# model-vignettes/parameters_pipeline

Parameter processing pipeline for the DARPA Sentinel project

## Overview

This public repo contains analysis code for the model runs associated with the DARPA Sentinel project. As a first step, the parameters_pipeline folder contains code that estimates physiological traits that are needed as inputs for crop and ecosystem models.


### Parameter estimation: 'parameters_pipeline'

Three numbered .Rmd files are used to run the pipleine. Data inputs and outputs are located in [sentinel-detection/data](https://github.com/danforthcenter/sentinel-detection/tree/master/data). 

Experiment metadata is summarized in "data/cleaned_data/experiments.csv" and is uniquely identified by the "ID" column, which links input and output file names across data types.

#### '01_parameter_estimation.Rmd' 

* Input files: "cleaned_data/experiments.csv", "derived_data/parameters_data.csv", "cleaned_data/ACi/A_Ci_curves_\*.csv", "cleaned_data/AQ/AQin_curves_\*.csv", "cleaned_data/Rd/Rd_\*.csv"
* Output files: "derived_data/parameters_data.csv", "derived_data/ACi/\*_parameters.csv", "derived_data/ACi/diagnostic/\*_fit.pdf", "derived_data/ACi/diagnostic/\*_gelman.pdf", "derived_data/AQ/\*_parameters.csv", "derived_data/AQ/diagnostic/\*_LRC.pdf", "derived_data/Rd/\*_parameters.csv", "derived_data/stomatal/\*_parameters.csv", "derived_data/stomatal/diagnostic/\*_stomatal_curves.pdf"
* Methods: Uses functions "R/C4_Collatz.R", "R/LRC.R", "R/Gs2.R", "R/Rd.R" to estimate all photosynthetic and stomatal parameters as described in the [README.md](https://github.com/danforthcenter/sentinel-detection/blob/master/README.md) for the sentinel-detection repo. Two changes are made: 
  * Notes:
      1. Gs2.R uses all ACi and AQ curve data except extremely low values (PAR < LCPT and CO2  < 45 ppm)
      2. Full AQ curves could not be taken on the outdoor plants at Danforth. Therefore, Rd was measured via the foil method on two leaf replicates per plant. Rd.R calculates the sample mean, standard error, and standard deviation at the treatment level. 
  
#### '02_parameter_upload.Rmd' 

* Input files: "derived_data/parameters_data.csv", "raw_data/biomass/manual-measurements-Darpa_setaria_chambers_experiments.xlsx", "raw_data/biomass/field_and_greenhouse_experiments.xlsx"
* Output files: "upload/phys_params", "upload/SLA"
* Methods: Physiological parameters and SLA are prepared separately. The first section formats and uploads the physiological parameter output from 01_parameter_estimation to BETYdb via the API. The second section calculates and uploads SLA from the raw biomass data to BETYdb via the API. 

#### '03_parameter_comparison.Rmd'
* Input files: "derived_data/parameters_data.csv", "derived_data/BETY/\*.csv"
* Output files: none
* Methods: Traits uploaded to and downloaded from BETYdb are compared to prevent accidental deletion or duplication. 

#### "compare_Gs_methods.Rmd"

* Input files: "cleaned_data/experiments.csv", "cleaned_data"
* Output files: "derived_data/stomatal/all\*"
* Methods: This script tests different approaches to stomatal parameter estimation functions (see table below) and visualizes the comparisons. 

Function name  | Description
------------- | -------------
GS_all.R  | All ACi and AQ data, population level
GS_all_byplant.R   | All ACi and AQ data, plant replicate level
GS_all_byplant_50.R |All ACi and AQ data where CO2 > 45 ppm, plant replicate level
GS_all_byplant_50_LCPT.R |All ACi and AQ data where CO2 > 45 ppm and PAR > LCPT, plant replicate level


#### "plots.Rmd"

* Input files: "derived_data/parameters_data.csv",
* Output files: none saved
* Methods: Visualizes parameters uploaded to BETYdb and utilized by Biocro by treatement. Simple ANOVA and TukeyHSD are run to create labels distinguishing significant differences. 

#### "Bayesian_parameter_estimation.Rmd"

* Input files: "cleaned_data/ACi/A_Ci_curves_\*.csv", "cleaned_data/AQ/AQin_curves_\*.csv"
* Output files: none saved
* Methods: Tests modified version of fitA.R from the PEcAn photosynthesis module that includes C4 photosynthesis on combined ACi and AQ data. WIP

