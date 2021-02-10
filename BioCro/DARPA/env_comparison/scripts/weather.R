library(readxl)
library(dplyr)
library(udunits2)
library(ggplot2)

# Generate weather for 2020 (leap year), but cut to 365 days to meet BioCro requirements
# Chamber data is generated from settings
# Greenhouse data is partially generated from T and RH time series, also relies on greenhouse roof weather station for SolarR
# Outdoor data is weather station data + irrigation

# Generate chamber (31_22_450) weather data 
ch_weather <- data.frame(year = rep(2020, 100*24),
                         doy = rep(1:100, each = 24),
                         hour = rep(seq(0, 23), 100), 
                         SolarR = rep(c(rep(0, each = 8), rep(430, each = 12), rep(0, each = 4)), times = 100),
                         Temp = rep(c(rep(22, each = 8), rep(31, each = 12), rep(22, each = 4)), times = 100),
                         RH = rep(55.5 / 100,  times = 100*24), 
                         WS = rep(0, times = 100*24), 
                         precip = rep(c(0.000462963, rep(0, 23)), 100))

# Greenhouse and outdoor data started with 7 days in the growth chamber
# Retrieve GH and Field sowing and transplant dates
load("~/sentinel-detection/data/cleaned_data/biomass/greenhouse_outdoor_biomass.Rdata")
exp_dates <- greenhouse_outdoor_biomass %>%
  filter(exp_site == "GH"  & exp_number == 1 |
           exp_site == "Field"  & exp_number == 2) %>%
  group_by(exp_site) %>%
  summarize(sowing = unique(sowing_date),
            transplant = unique(transplant_date)) %>%
  mutate(chamber_dur = difftime(transplant, sowing, units = "days"))


# Refer to weather files in sentinel-detection repo
data_path <- "~/sentinel-detection/data/raw_data/biomass/field_and_greenhouse_experiments.xlsx"
sheets_names <- excel_sheets(data_path)

# Outdoor weather data on top of B greenhouses at Danforth
gh_out <- read_excel(data_path, sheets_names[15], range = "K1:N8784") %>% 
  rename(dt = "Date/Time",
         temp_C = "WS1:Outdoor Temp.(°C)",
         light_w_m2 = "WS1:Outdoor Light(W/m²)",
         wind_km_h = "WS1:Wind Speed(km/h)") %>%
  mutate(SolarR = light_w_m2/2.35e5*1e6) %>%
  # Gapfilling 1 missing value with average of previous and subsequent hour
  mutate(SolarR_lag = lag(SolarR),
         SolarR_lead = lead(SolarR),
         SolarR  = ifelse(is.na(SolarR), (SolarR_lag + SolarR_lead)/2, SolarR))

# Indoor temp and relative humidity
gh_in <- read_excel(data_path, sheets_names[15], range = "A1:I8784") %>% 
  select(1,2,7) %>%
  rename(dt = "Date/Time",
         temp_C = "GH2B_Climate_Temperature_°C",
         RH = "GH2B_Climate_Humidity_%Rh") %>%
  # Gapfilling 1 missing value with average of previous and subsequent hour
  mutate(temp_C_lag = lag(temp_C),
         temp_C_lead = lead(temp_C),
         RH_lag = lag(RH),
         RH_lead = lead(RH),
         temp_C  = ifelse(is.na(temp_C), (temp_C_lag + temp_C_lead)/2, temp_C),
         RH  = ifelse(is.na(RH), (RH_lag + RH_lead)/2, RH))

# Greenhouse, with irrigation 3 mm/day divided into 10 am and 3 pm watering
# Use only 93 days starting from transplant date
ind <- which(gh_in$dt == exp_dates$transplant[exp_dates$exp_site == "GH"])
gh_comb <- data.frame(year = rep(2020, 93*24),
                         doy = rep(8:100, each = 24),
                         hour = rep(seq(0, 23), 93), 
                         SolarR = gh_out$SolarR[ind:(ind + 93*24 - 1)],
                         Temp = gh_in$temp_C[ind:(ind + 93*24 - 1)],
                         RH = gh_in$RH[ind:(ind + 93*24 - 1)]/100,
                         WS = rep(0, times = 93*24), 
                         precip = rep(c(rep(0, 10), 1.5, rep(0, 4), 1.5, rep(0, 8)), 93))

# Add 7 days from ch_weather
gh_weather <- rbind.data.frame(ch_weather[1:(7*24), ], gh_comb)


# Outdoor weather data near Cella Farms, plus watering at 9 am 5 mm/day every day except Sundays
# Source: Moscow Mills, Missouri Historical Agricultural Weather Database
out_cella<- read_excel(data_path, sheets_names[13], range = cell_cols("A:J")) %>%
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
         SolarR = SolarR/2.35e5*1e6) %>% # convert from W/m2 to PAR
  mutate(irrigation = c(rep(c(rep(c(rep(0, 9), 5, rep(0, 14)), 4),
                              rep(0, 24),
                              rep(c(rep(0, 9), 5, rep(0, 14)), 2)), 52),
                        rep(c(rep(0, 9), 5, rep(0, 14)), 2)),
         precip = Precip + irrigation)%>%
  select(year, doy, hour, SolarR, Temp, RH, WS, precip) %>%
  filter(doy != 366)

# Use only 93 days from transplanting
ind <- which(gh_in$dt == exp_dates$transplant[exp_dates$exp_site == "Field"])
out_comb <- data.frame(year = rep(2020, 93*24),
                      doy = rep(8:100, each = 24),
                      hour = rep(seq(0, 23), 93), 
                      SolarR = out_cella$SolarR[ind:(ind + 93*24 - 1)],
                      Temp = out_cella$Temp[ind:(ind + 93*24 - 1)],
                      RH = out_cella$RH[ind:(ind + 93*24 - 1)]/100,
                      WS = out_cella$WS[ind:(ind + 93*24 - 1)], 
                      precip = out_cella$precip[ind:(ind + 93*24 - 1)])

# Add 7 days from ch_weather
out_weather <- rbind.data.frame(ch_weather[1:(7*24), ], out_comb)

# Check for completeness
sum(!complete.cases(ch_weather))
sum(!complete.cases(gh_weather))
sum(!complete.cases(out_weather))

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
