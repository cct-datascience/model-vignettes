# Generate chamber weather data based on experiment 2, 31/31 treatment. 

ch_weather <- data.frame(year = rep(2019, 8760), 
                          doy = rep(1:365, each = 24), 
                          hour = rep(seq(0, 23), 365), 
                          solarR = rep(c(rep(0, each = 8), rep(430, each = 12), rep(0, each = 4)), times = 365),
                          Temp = rep(31, times = 365 * 24), 
                          RH = rep(55.5 / 100,  times = 365 * 24), 
                          WS = rep(0, times = 365 * 24), 
                          precip = rep(c(0.000462963, rep(0, 23)), 365))

write.csv(ch_weather, "../inputs/ch_weather.csv", row.names = FALSE)

# Copy the BioCro config for the most matching treatment to the biomass_opti/inputs folder
from_path <- "~/../../data/output/pecan_runs/env_comp_results/ch/run/SA-median/config.xml"
to_path <- "~/model-vignettes/BioCro/DARPA/biomass_opti/inputs/ch_config.xml"
file.copy(from_path, to_path, overwrite = TRUE)
