# Load packages -----------------------------------------------------------
library(PEcAn.all)

# Read in settings --------------------------------------------------------
inputfile <- "ED2/testoutput/PEcAn_test_data/pecan.xml"

#check that inputfile exists, because read.settings() doesn't do that!
if (file.exists(inputfile)) {
  settings <- PEcAn.settings::read.settings(inputfile)
} else {
  stop(inputfile, " doesn't exist")
}

#check outdir
settings$outdir

# Prepare settings --------------------------------------------------------
settings <- prepare.settings(settings, force = FALSE) 
write.settings(settings, outputdir = settings$outdir, outputfile = paste0("pecan_checked.xml"))
settings <- do_conversions(settings)

# Query trait database ----------------------------------------------------
settings <- runModule.get.trait.data(settings)

# Meta analysis -----------------------------------------------------------
runModule.run.meta.analysis(settings)

# Write model run configs -----------------------------------------------------
runModule.run.write.configs(settings)

# Start model runs --------------------------------------------------------
runModule_start_model_runs(settings, stop.on.error = FALSE)
