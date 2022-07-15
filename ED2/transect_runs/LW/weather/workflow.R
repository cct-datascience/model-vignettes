# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
library(PEcAn.all)
library(PEcAn.utils)
library(RCurl)

# Open, read in, and modify settings file for PEcAn run.
settings <- PEcAn.settings::read.settings("ED2/transect_runs/LW/weather/pecan.xml") 
settings <- PEcAn.settings::prepare.settings(settings, force = FALSE)
PEcAn.settings::write.settings(settings, outputfile = "pecan.CHECKED.xml")
settings <- PEcAn.workflow::do_conversions(settings, overwrite.met = TRUE)

# Manual rsync of weather data once only
#rsync '-a' '-q' '--delete' '/data/sites/MERRA_ED2_site_1-42/' 'kristinariemer@login.ocelote.hpc.arizona.edu:/groups/dlebauer/ed2_results/inputs/julianp/sites/MERRA_ED2_site_1-42'
