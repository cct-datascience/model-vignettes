# This may take a long time to run.  Run as a background job if you don't want
# to tie up your R session.  In RStudio click the "Source" drop-down and choose
# "Source as Local Job"

# Load packages -----------------------------------------------------------
library(PEcAn.all)
library(furrr)
library(progressr)

# Read in settings --------------------------------------------------------

#edit this path
inputfile <- "ED2/transect_runs/new_site/run/pecan.xml"

#check that inputfile exists, because read.settings() doesn't do that!
if (file.exists(inputfile)) {
  settings <- PEcAn.settings::read.settings(inputfile)
} else {
  stop(inputfile, " doesn't exist")
}

#check outdir
settings$outdir

# Prepare settings --------------------------------------------------------
#TODO: check that dates are sensible?
settings <- prepare.settings(settings, force = FALSE) 
write.settings(settings, outputfile = paste0("pecan_checked_", Sys.Date(), ".xml"))
settings <- do_conversions(settings)

# Query trait database ----------------------------------------------------
settings <- runModule.get.trait.data(settings)

# Meta analysis -----------------------------------------------------------
runModule.run.meta.analysis(settings)

# Write model run configs -----------------------------------------------------

# This will write config files locally and attempt to copy them to your HPC.  In
# my experience, this copying fails, but it doesn't matter because the next step
# ALSO attempts to copy the config files to the HPC.

runModule.run.write.configs(settings)

# Start model runs --------------------------------------------------------
runModule_start_model_runs(settings, stop.on.error = FALSE)

## If for some reason the above function tries to copy files back from HPC before
## runs are finished, this code will manually copy it back.
#  
# cmd <- 
#   paste0(
#     "rsync -az -q ",
#     "'", settings$host$name, ":", settings$host$outdir, "' ",
#     "'", settings$outdir, "'"
#   )
# 
# system(cmd)

# Results post-processing -------------------------------------------------

## Convert and consolidate ED2 .h5 files to .nc files NOTE: this is supposed to
## get run on the HPC but is currently broken and needs to be run manually on
## Welsch after .h5 files are copied over.


## use 2 cores to speed up
plan(multisession, workers = 2)

dirs <- list.dirs(file.path(settings$outdir, "out"), recursive = FALSE)

with_progress({
  p <- progressor(steps = length(dirs))

  future_walk(dirs, ~{
    p() #progress bar
    #TODO: args need updating, specifically pfts
    model2netcdf.ED2(
      .x,
      settings$run$site$lat,
      settings$run$site$lon,
      settings$run$start.date,
      settings$run$end.date,
      settings$pfts
    )
  })
})

### DON'T remove .h5 files.  The .nc files are currently malformed and you need
### the raw output for plotting.

# Model analyses ----------------------------------------------------------

## Get results of model runs
get.results(settings)

## Run ensemble analysis on model output
runModule.run.ensemble.analysis(settings)

#The run.ensemble.analysis() step fails because whatever output the
#ensemble.output...Rdata file didn't grab the ensemble ID correctly
# run manually: 
run.ensemble.analysis(settings, ensemble.id = "NOENSEMBLEID")
