# Load packages -----------------------------------------------------------
library(PEcAn.all)

# Read in settings --------------------------------------------------------
inputfile <- "ED2/testoutput/ED2_dev_ensemble/pecan.xml"

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
write.settings(settings, outputdir = settings$outdir, outputfile = "pecan_checked.xml")
settings <- do_conversions(settings)

# Query trait database ----------------------------------------------------
settings <- runModule.get.trait.data(settings)

# Meta analysis -----------------------------------------------------------
runModule.run.meta.analysis(settings)

# Write model run configs -----------------------------------------------------
runModule.run.write.configs(settings)

# Modify job.sh to run R inside singularity container

job_scripts <- list.files(settings$rundir, "job.sh", recursive = TRUE, full.names = TRUE)
#TODO: could get this from settings under the assumption that the .sh "ED binary" has same naming convention as .sif file
container_path <- "/groups/dlebauer/ed2_results/global_inputs/pecan-dev_ed2-dev.sif"

purrr::walk(job_scripts, function(x) {
  job_sh <- readLines(x)
  cmd <- paste0("singularity run ", container_path, " /usr/local/bin/Rscript")
  job_sh_mod <- stringr::str_replace(job_sh, "Rscript", cmd)
  writeLines(job_sh_mod, x)
})

# Start model runs --------------------------------------------------------
runModule_start_model_runs(settings, stop.on.error = FALSE)

#sometimes outdir/out still doesn't get copied over on the first try.  Not sure why...

# Model analyses ----------------------------------------------------------

## Get results of model runs
get.results(settings)

## Run ensemble analysis on model output
runModule.run.ensemble.analysis(settings)
