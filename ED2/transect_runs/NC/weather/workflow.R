# Load packages -----------------------------------------------------------
library(PEcAn.all)

# Load settings --------------------------------------------------------
settings <- read.settings("ED2/transect_runs/NC/weather/pecan.xml")

# Do conversions ----------------------------------------------------------
settings <- prepare.settings(settings, force = FALSE)
write.settings(settings, outputfile = "pecan_weather_checked.xml")
settings <- do_conversions(settings, overwrite.met = TRUE)


# Copy weather data to HPC ------------------------------------------------
# pull path name from settings and add trailing slash
driver_path_local <- paste0(dirname(settings[["run"]][["inputs"]][["met"]][["path"]][["path1"]]), "/")
driver_path_local

host <- "puma"

driver_path_hpc <- file.path(paste0(host, ":"), "groups/dlebauer/ed2_results/inputs/julianp/sites", basename(driver_path_local))
driver_path_hpc
system2("rsync", args = c(
  "-a", "-q", "--delete",
  driver_path_local,
  driver_path_hpc
))

