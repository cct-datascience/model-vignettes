# This may take a long time to run.  Run as a background job if you don't want
# to tie up your R session.  In RStudio click the "Source" drop-down and choose
# "Source as Local Job"

# Load packages -----------------------------------------------------------
library(PEcAn.all)
library(furrr)
library(progressr)

# Read in settings --------------------------------------------------------
#TODO: check if pecan_checked.xml exists and skip this stuff if it does
#edit this path
inputfile <- "ED2/testoutput/two_pfts/pecan.xml"

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

# ## Convert and consolidate ED2 .h5 files to .nc files
# 
# ### use 2 cores to speed up
# plan(multisession, workers = 2)
# 
# dirs <- list.dirs(file.path(settings$outdir, "out"), recursive = FALSE)
# 
# with_progress({
#   p <- progressor(steps = length(dirs))
#   
#   future_walk(dirs, ~{
#     p() #progress bar
#     model2netcdf.ED2(
#       .x,
#       settings$run$site$lat,
#       settings$run$site$lon,
#       settings$run$start.date,
#       settings$run$end.date,
#       settings$pfts
#     )
#   })
# })
# 
# 
# ### Remove .h5 files
# # WAIT, this might be used in Kristina's plotting script
# #TODO: Figure out how to delete h5 files ONLY if model2netcdf.ED2 was successful
# # h5_rm <- list.files("outputs/out", pattern = "*.h5$", recursive = TRUE, full.names = TRUE)
# # file.remove(h5_rm)
# 
# 
# # Model analyses ----------------------------------------------------------
# 
# ## Get results of model runs
# get.results(settings)
# 
# ## Run ensemble analysis on model output
# runModule.run.ensemble.analysis(settings)
# 
# #The run.ensemble.analysis() step fails because whatever output the
# #ensemble.output...Rdata file didn't grab the ensemble ID correctly
# # run manually: 
# run.ensemble.analysis(settings, ensemble.id = "NOENSEMBLEID")
