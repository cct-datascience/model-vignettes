library(readxl)
library(dplyr)
library(udunits2)

# Generate chamber (31_22_450) weather data for 2020
ch_weather <- data.frame(year = rep(2020, 8760),
                         doy = rep(1:365, each = 24),
                         hour = rep(seq(0, 23), 365), 
                         SolarR = rep(c(rep(0, each = 8), rep(430, each = 12), rep(0, each = 4)), times = 365),
                         Temp = rep(c(rep(22, each = 8), rep(31, each = 12), rep(22, each = 4)), times = 365),
                         WS = rep(0, times = 365 * 24), 
                         precip = rep(c(0.000462963, rep(0, 23)), 365))

# Generate greenhouse (1st experiment) weather data
# Import actual greenhouse data
data_path <- "~/sentinel-detection/data/raw_data/biomass/field_and_greenhouse_experiments.xlsx"
sheets_names <- excel_sheets(data_path)

gh_light <- read_excel(data_path, sheets_names[22], range = "F1:J17")
gh_env <- read_excel(data_path, sheets_names[22], range = "A1:D1429") %>% 
  mutate(dt = as.POSIXct(`date/time`, format = "%Y/%m/%d, %H:%M:%S", tz = "America/Chicago")) %>%
  select(-`date/time`) %>%
  relocate(dt) %>%
  rename(temp_C = sensor_temperature_readings_celsius,
         RH = `sensor_relative_humidity_readings_%`)
 
ggplot(gh_env, aes(x = dt, y = temp_C)) +
  geom_point() + 
  scale_x_datetime(limits = c(as.POSIXct("2020-03-01"), as.POSIXct("2020-03-07")))+
  theme_bw()

# Greenhouse plants watered 3mm/day
  
# Generate outdoor weather data
out <- read_excel(data_path, sheets_names[13], range = cell_cols("A:J")) %>%
  mutate(mon = as.character(as.Date(paste0(YEAR, "-", MONTH, "-01"))),
         dt = as.POSIXct(HOUR*60*60 + DAY*24*60*60, origin = mon, tz = "America/Chicago"))


write.csv(ch_weather, 
          file = "~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.ch.2020.csv", 
          row.names = FALSE)
