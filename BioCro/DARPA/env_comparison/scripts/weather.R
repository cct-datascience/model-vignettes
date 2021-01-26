library(readxl)
library(dplyr)
library(udunits2)
library(ggplot2)

# Generate weather for 2020 (leap year)
# Chamber data is generated for 365 days
# Greenhouse data is partially generated, relying on nearby weather station for SolarR, for 365 days
# Outdoor data is weather station data + irrigation, for 366 days

# Generate chamber (31_22_450) weather data 
ch_weather <- data.frame(year = rep(2020, 365*24),
                         doy = rep(1:365, each = 24),
                         hour = rep(seq(0, 23), 365), 
                         SolarR = rep(c(rep(0, each = 8), rep(430, each = 12), rep(0, each = 4)), times = 365),
                         Temp = rep(c(rep(22, each = 8), rep(31, each = 12), rep(22, each = 4)), times = 365),
                         RH = rep(55.5 / 100,  times = 365*24), 
                         WS = rep(0, times = 365*24), 
                         precip = rep(c(0.000462963, rep(0, 23)), 365))

# Import actual data
data_path <- "~/sentinel-detection/data/raw_data/biomass/field_and_greenhouse_experiments.xlsx"
sheets_names <- excel_sheets(data_path)

# Outdoor weather data near Cella Farms, plus watering at 9 am 5 mm/day every day except Sundays
# Source: Moscow Mills, Missouri Historical Agricultural Weather Database
out_weather <- read_excel(data_path, sheets_names[13], range = cell_cols("A:J")) %>%
  mutate(mon = as.character(as.Date(paste0(YEAR, "-", MONTH, "-01"))),
         dt = as.POSIXct((`HOUR  AVG`+6)*60*60 + (DAY-1)*24*60*60, origin = mon, tz = "America/Chicago")) %>%
  rename(year = YEAR,
         hour = `HOUR  AVG`,
         SolarR = `SOLAR RAD. WATTS/M²`,
         Temp = `TEMP °C`,
         RH = `HR %`,
         WS = `WIND SPEED M/S`,
         Precip = `PRECIP MM`) %>%
  mutate(doy = rep(1:366, each = 24), 
         RH = RH/100,
         SolarR = SolarR/2.35e5*1e6) %>%
  mutate(irrigation = c(rep(c(rep(c(rep(0, 9), 5, rep(0, 14)), 4),
                              rep(0, 24),
                              rep(c(rep(0, 9), 5, rep(0, 14)), 2)), 52),
                        rep(c(rep(0, 9), 5, rep(0, 14)), 2)),
         precip = Precip + irrigation)%>%
  select(year, doy, hour, SolarR, Temp, RH, WS, precip)

# Outdoor weather data near Danforth
# Source: St. Louis Science Center, Missouri Historical Agricultural Weather Database
sc_raw <- read.csv("~/sentinel-detection/data/raw_data/env/StLouisScienceCenter_2020_hourly.csv")

sc <- sc_raw %>%
  mutate(doy = rep(1:366, each = 24), 
         hour = hour/100,
         mon = as.character(as.Date(paste0(year, "-", month, "-01"))),
         dt = as.POSIXct((`hour`+6)*60*60 + (day-1)*24*60*60, origin = mon, tz = "America/Chicago"), 
         RH = RH/100, 
         SolarR = SolarR/2.35e5*1e6) %>%
  select(dt, year, doy, hour, SolarR, Temp, RH, WS, precip)
  
  
# Generate greenhouse (1st experiment) weather data from measured data
# Greenhouse plants watered 3mm/day, 1.5 mm at 10 am and 3 pm
# gh_light <- read_excel(data_path, sheets_names[22], range = "F1:J17") %>%
#   rename(dt = `date/time`,
#          light_1 = `manual_measure_light_intensity_umol/m2/s...4`,
#          light_2 = `manual_measure_light_intensity_umol/m2/s...5`) %>%
#   tidyr::pivot_longer(cols = c("light_1", "light_2"), names_to = "rep", values_to = "light")
# 
# ggplot(gh_light, aes(x = dt))+
#   geom_point(aes(y = light, color = treatment)) +
#   theme_bw()

# Match to outdoor data
# gh_match <- gh_light %>%
#   mutate(dt_round = round(dt, "hour")) %>%
#   left_join(sc[,c("dt", "SolarR")], by = c("dt_round" = "dt"))
# 
# ggplot(gh_match, aes(x = SolarR))+
#   geom_abline(slope = 1, intercept = 0) +
#   geom_point(aes(y = light, color = as.factor(dt))) +
#   theme_bw()


gh_env <- read_excel(data_path, sheets_names[22], range = "A1:D1429") %>% 
  mutate(dt = as.POSIXct(`date/time`, format = "%Y/%m/%d, %H:%M:%S", tz = "America/Chicago")) %>%
  select(-`date/time`) %>%
  relocate(dt) %>%
  rename(temp_C = sensor_temperature_readings_celsius,
         RH = `sensor_relative_humidity_readings_%`)

# ggplot(gh_env, aes(x = dt)) +
#   geom_point(aes(y = temp_C, color = "Temp")) + 
#   geom_point(aes(y = RH/2, color = "RH")) + 
#   # scale_x_datetime(limits = c(as.POSIXct("2020-03-01"), as.POSIXct("2020-03-07")))+
#   theme_bw()

# Greenhouse 
gh_weather <- data.frame(year = rep(2020, 365*24),
                         doy = rep(1:365, each = 24),
                         hour = rep(seq(0, 23), 365), 
                         SolarR = sc$SolarR[1:(365*24)],
                         Temp = rep(gh_env$temp_C, length.out = 365*24),
                         RH = rep(gh_env$RH/100, length.out = 365*24),
                         WS = rep(0, times = 365*24), 
                         precip = rep(c(rep(0, 10), 1.5, rep(0, 4), 1.5, rep(0, 8)), 365))

# Write out weather files as csv
write.csv(ch_weather, 
          file = "~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.ch.2020.csv", 
          row.names = FALSE)

write.csv(gh_weather, 
          file = "~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.gh.2020.csv", 
          row.names = FALSE)

write.csv(out_weather, 
          file = "~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.out.2020.csv", 
          row.names = FALSE)
