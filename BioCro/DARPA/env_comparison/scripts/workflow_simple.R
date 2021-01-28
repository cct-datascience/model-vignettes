# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
library(PEcAn.all)
library(PEcAn.utils)
library(RCurl)

#Manually load, until PR is merged
devtools::load_all("~/pecan/base/utils")
devtools::load_all("~/pecan/base/db")
devtools::load_all("~/pecan/base/workflow")
devtools::load_all("~/pecan/base/settings")
devtools::load_all("~/pecan/modules/meta.analysis")
devtools::load_all("~/pecan/modules/uncertainty")
# or load_all?

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
  plot_MA(settings)
  
  # Write model specific configs
  settings <- PEcAn.workflow::runModule.run.write.configs(settings)
  
  # Start ecosystem model runs
  PEcAn.remote::runModule.start.model.runs(settings, stop.on.error = FALSE)
  
  # Get results of model runs
  runModule.get.results(settings)
  
  # Run ensemble analysis on model output.
  runModule.run.ensemble.analysis(settings, TRUE)
  
  # Run sensitivity analysis and variance decomposition on model output
  runModule.run.sensitivity.analysis(settings)
  
  print(paste0("---------- PEcAn Workflow Complete for ", trt, " ----------"))
}

