# Manual rsync of weather data once only
#rsync '-a' '-q' '--delete' '/data/sites/MERRA_ED2_site_1-42/' 'kristinariemer@login.ocelote.hpc.arizona.edu:/groups/dlebauer/ed2_results/inputs/julianp/sites/MERRA_ED2_site_1-42'

# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
library(PEcAn.all)
library(PEcAn.utils)
library(RCurl)

# ----------------------------------------------------------------------
# PEcAn Workflow
# ----------------------------------------------------------------------
# Open, read in, and modify settings file for PEcAn run.
settings <- PEcAn.settings::read.settings("ED2/transect_runs/LW/run/pecan.xml") 
settings <- PEcAn.settings::prepare.settings(settings, force = FALSE)
PEcAn.settings::write.settings(settings, outputfile = "pecan.CHECKED.xml")
settings <- PEcAn.workflow::do_conversions(settings)

# Query the trait database for data and priors
settings <- PEcAn.workflow::runModule.get.trait.data(settings)

# Run the PEcAn meta.analysis
PEcAn.MA::runModule.run.meta.analysis(settings)

# Write model specific configs
settings <- PEcAn.workflow::runModule.run.write.configs(settings)

# Manual rsync of run folder to HPC, replacing DATE
# DATE = 2022-06-23-15-35-24
#rsync '-a' '-q' '--delete' '/data/tests/ed2_transect_LW/run' 'kristinariemer@login.ocelote.hpc.arizona.edu:/groups/dlebauer/ed2_results/pecan_remote/DATE'

# Start ecosystem model runs
PEcAn.remote::runModule.start.model.runs(settings, stop.on.error = FALSE)

# Manual rsync of out folder back to Welsch, replacing DATE
#rsync '-az' '-q' 'kristinariemer@login.ocelote.hpc.arizona.edu:/groups/dlebauer/ed2_results/pecan_remote/DATE/out' '/data/tests/ed2_transect_LW'

# Do results post-processing
for(folder in list.dirs("/data/tests/ed2_transect_LW/out", recursive = FALSE)){
  print(folder)
  model2netcdf.ED2(folder, settings$run$site$lat, settings$run$site$lon, settings$run$start.date, 
                   settings$run$end.date, settings$pfts)
}

# Get results of model runs
runModule.get.results(settings)

# Run ensemble analysis on model output.
runModule.run.ensemble.analysis(settings, TRUE)

# Run sensitivity analysis and variance decomposition on model output
runModule.run.sensitivity.analysis(settings)

print("---------- PEcAn Workflow Complete ----------")
