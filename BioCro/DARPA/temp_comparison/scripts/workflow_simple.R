# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
# library(RCurl)

# Use install functions below the first time
# devtools::install("~/pecan/base/db")
# devtools::install("~/pecan/modules/uncertainty")
# devtools::install("~/biocro")
# devtools::install("~/pecan/base/settings")
# devtools::install("~/pecan/models/biocro")
library(PEcAn.DB)
library(PEcAn.uncertainty)
library(BioCro)
library(PEcAn.settings)
library(PEcAn.BIOCRO)
library(PEcAn.all)

# Add function for setting MA treatments
source("~/model-vignettes/BioCro/DARPA/set_MA_trt.R")
# Add function for plotting MA by treatment and trait
source("~/model-vignettes/BioCro/DARPA/plot_MA.R")
# ----------------------------------------------------------------------
# PEcAn Workflow
# ----------------------------------------------------------------------
treatments <- c("rn", "hn")
for(trt in treatments){
  
  # Open, read in, and modify settings file for PEcAn run
  settings_file <- normalizePath(paste0("../inputs/pecan.", trt, ".xml"))
  settings <- PEcAn.settings::read.settings(settings_file) 
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
  
  # Write model specific configs - if update is false, set posteriorid to NULL so that local version of 
  # trait.mcmc.Rdata is used to create samples.Rdata, then restore posteriorid afterward
  if(settings$meta.analysis$update == FALSE) {
    pid <- settings$pfts$pft$posteriorid
    settings$pfts$pft$posteriorid <- NULL
  }
  
  settings <- PEcAn.workflow::runModule.run.write.configs(settings)
  
  if(settings$meta.analysis$update == FALSE) {
    settings$pfts$pft$posteriorid <- pid
  }
  
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

