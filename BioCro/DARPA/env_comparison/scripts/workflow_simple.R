# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
# library(RCurl)

#Manually load, until PR is merged
# On patch branch
# devtools::install("~/pecan/base/utils")
# devtools::install("~/pecan/base/settings")
# devtools::install("~/pecan/base/workflow")
# devtools::install("~/pecan/modules/meta.analysis")
devtools::install("~/pecan/base/db")

# On mstmip branch
devtools::install("~/pecan/modules/uncertainty")

# library(PEcAn.utils)
# library(PEcAn.workflow)
# library(PEcAn.settings)
# library(PEcAn.MA)
library(PEcAn.DB)
library(PEcAn.uncertainty)
library(PEcAn.all)

devtools::load_all("~/pecan/base/all")
# or load_all?
# library(PEcAn.all)

# Add function for setting MA treatments
source("~/model-vignettes/BioCro/DARPA/set_MA_trt.R")
# Add function for plotting MA by treatment and trait
source("~/model-vignettes/BioCro/DARPA/plot_MA.R")
# ----------------------------------------------------------------------
# PEcAn Workflow
# ----------------------------------------------------------------------
treatments <- c("ch", "gh", "out")
for(trt in treatments){
  
  # Open, read in, and modify settings file for PEcAn run
  settings <- PEcAn.settings::read.settings(paste0("../inputs/pecan.", trt, ".xml")) 
  settings <- PEcAn.settings::prepare.settings(settings, force = FALSE)
  PEcAn.settings::write.settings(settings, outputfile = paste0("pecan.CHECKED.", trt, ".xml"))
  settings <- PEcAn.workflow::do_conversions(settings)
  
  # Query the trait database for data and priors
  settings <- PEcAn.workflow::runModule.get.trait.data(settings)
  
  # Run the PEcAn meta.analysis
  PEcAn.MA::runModule.run.meta.analysis(settings)
  
  # If treatment specific, set meta.analysis treatments and plot MA priors vs. posteriors
  set_MA_trt(settings)
  if (settings$meta.analysis$update == TRUE) {
    plot_MA(settings)
  }
  
  # Write model specific configs
  settings <- PEcAn.workflow::runModule.run.write.configs(settings)
  
  # Run ecosystem model (in folders 'run' and 'out')
  st <- proc.time()
  PEcAn.remote::runModule.start.model.runs(settings, stop.on.error = FALSE)
  en <- proc.time()
  dur <- (en - st)/60/60
  print(paste0(settings$ensemble$size, " ensembles completed in ", round(dur[3], 4), " hours"))
  
  # Get sensitivity and ensemble output of model runs
  runModule.get.results(settings)
  
  # Run ensemble analysis on model output.
  runModule.run.ensemble.analysis(settings, TRUE)
  
  # Run sensitivity analysis and variance decomposition on model output
  PEcAn.uncertainty::runModule.run.sensitivity.analysis(settings)
  
  print(paste0("---------- PEcAn Workflow Complete for ", trt, " ----------"))
}

