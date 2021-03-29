# Script to plot weather parameters used in BioCro

# Load packages
library(dplyr)
library(ggplot2)

# Import and arrange data
rn <- read.csv("../inputs/weather.rn.2019.csv") %>%
  mutate(dt = as.POSIXct((doy-1)*24*60*60 + hour*60*60, origin = "2019-01-01"),
         trt = "rn")

hn <- read.csv("../inputs/weather.hn.2019.csv") %>%
  mutate(dt = as.POSIXct((doy-1)*24*60*60 + hour*60*60, origin = "2019-01-01"),
         trt = "hn")


all_wide <- rbind.data.frame(rn, hn) %>%
  relocate(trt, dt)
all_long <- all_wide %>%
  tidyr::pivot_longer(!c(trt, dt, year, doy, hour), names_to = "Variable", values_to = "Value")

fig_all_comb <- ggplot(all_wide, aes(x = dt)) +
  geom_point(aes(y = SolarR/100, color = "SolarR")) +
  geom_point(aes(y = Temp, color = "Temp")) +
  geom_point(aes(y = RH*100, color = "RH")) +
  # geom_point(aes(y = WS, color = "WS")) +
  geom_bar(aes(y = precip*10, color = "precip"), stat = "identity") +
  theme_bw(base_size = 12) +
  facet_wrap(~trt, nrow = 3)
print(fig_all_comb)

fig_all_panel <- ggplot(all_long, aes(x = dt, y = Value)) +
  geom_point(alpha = 0.25) +
  theme_bw(base_size = 12) +
  facet_grid(cols = vars(trt), rows = vars(Variable), scales = "free_y")
print(fig_all_panel)
