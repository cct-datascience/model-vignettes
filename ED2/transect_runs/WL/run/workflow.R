# This may take a long time to run.  Run as a background job if you don't want
# to tie up your R session.  In RStudio click the "Source" drop-down and choose
# "Source as Local Job"

# Load packages -----------------------------------------------------------
library(PEcAn.all)
library(furrr)
library(progressr)

# Read in settings --------------------------------------------------------

#this is the directory that has pecan.xml in it
inputdir <- "ED2/transect_runs/WL/run"
inputfile <- file.path(inputdir, "pecan.xml")

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

#write the parsed pecan.xml out
write.settings(settings, outputfile = "pecan_checked.xml", outputdir = inputdir)
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
#TODO: check if .nc files already exist.  model2netcdf.ED2 is supposed to be run
#on the HPC.  Probably won't happen until PEcAn container on HPC gets updated though.

## Convert and consolidate ED2 .h5 files to .nc files

### use 2 cores to speed up
plan(multisession, workers = 2)

dirs <- list.dirs(file.path(settings$outdir, "out"), recursive = FALSE)

with_progress({
  p <- progressor(steps = length(dirs))
  
  future_walk(dirs, ~{
    p() #progress bar
    model2netcdf.ED2(
      .x,
      settings$run$site$lat,
      settings$run$site$lon,
      settings$run$start.date,
      settings$run$end.date,
      settings$pfts 
      # TODO: looks like possibly not all PFTs make it into the .nc file??  In
      # line 954 of model2netcdf.ED2.R it looks like it only takes the first PFT
      # instead of pulling all the PFTs.  Should be something like `pft_names <-
      # pfts %>% map(~.x[["name"]])` instead
    )
  })
})

### Remove .h5 files

#TODO: Figure out how to delete h5 files ONLY if model2netcdf.ED2 was successful
# h5_rm <- list.files("outputs/out", pattern = "*.h5$", recursive = TRUE, full.names = TRUE)
# file.remove(h5_rm)


# Model analyses ----------------------------------------------------------

## Get results of model runs
get.results(settings)

## Run ensemble analysis on model output
runModule.run.ensemble.analysis(settings)
