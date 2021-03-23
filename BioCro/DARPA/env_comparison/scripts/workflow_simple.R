# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
# library(RCurl)

devtools::load_all('~/pecan/base/db/')
devtools::load_all('~/pecan/modules/uncertainty/')
devtools::load_all('~/pecan/base/all/')
#library(PEcAn.DB)
#library(PEcAn.uncertainty)
#library(PEcAn.all)
library(BioCro)

# Add function for setting MA treatments
source("BioCro/DARPA/set_MA_trt.R")
# Add function for plotting MA by treatment and trait
source("BioCro/DARPA/plot_MA.R")
# ----------------------------------------------------------------------
# PEcAn Workflow
# ----------------------------------------------------------------------
treatments <- c("ch", "gh", "out")

for(trt in treatments){
  
  #settings_template <- 'BioCro/DARPA/env_comparison/inputs/pecan.template.xml'
  #settings_template <- PEcAn.settings::read.settings(settings_file)
  # need to set run$site$id, metaanalysis$treatment

  # Open, read in, and modify settings file for PEcAn run
  settings_file <- normalizePath(paste0("BioCro/DARPA/env_comparison/inputs/pecan.", trt, ".xml"))
  settings <- PEcAn.settings::read.settings(settings_file)
  settings$outdir <- file.path('/tmp', 'env_comp', trt)
  settings$ensemble$size <- 10
  settings$database$dbfiles <- file.path(settings$outdir, 'dbfiles')
  settings$pfts$pft$outdir <- file.path(settings$outdir, 'pft', settings$pfts$pft$name)
  settings$ensemble$samplingspace$parameters$method <- 'lhc'
  # can met go in /data/dbfiles?
  settings$run$inputs$met <- paste0(
    normalizePath("~/model-vignettes/BioCro/DARPA/env_comparison/inputs/"),
    "weather.", trt)

  settings$pfts$pft$constants$file <- normalizePath(
    "BioCro/DARPA/env_comparison/inputs/setaria.constants.xml"
    )
  
  # TODO after moving to template: 
  # PEcAn.settings::write.settings(settings_file)

  dir.create(settings$pfts$pft$outdir, recursive = TRUE, showWarnings = FALSE)
  dir.create(settings$database$dbfiles, recursive = TRUE, showWarnings = FALSE)

  #settings <- PEcAn.settings::prepare.settings(settings, force = TRUE)
  PEcAn.settings::write.settings(settings, outputfile = paste0("pecan.CHECKED.", trt, ".xml"))
  # settings <- PEcAn.workflow::do_conversions(settings)
  
  # Query the trait database for data and priors
  #settings <- PEcAn.workflow::runModule.get.trait.data(settings)
  
  # Run the PEcAn meta.analysis
  #PEcAn.MA::runModule.run.meta.analysis(settings)
  
  # If treatment specific, set meta.analysis treatments and plot MA priors vs. posteriors
  set_MA_trt(settings)
  if (settings$meta.analysis$update == TRUE) {
    plot_MA(settings)
  }
  settings$pfts$pft$posteriorid <- NULL
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

