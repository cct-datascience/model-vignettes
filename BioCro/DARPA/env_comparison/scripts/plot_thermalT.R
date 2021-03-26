# Test thermal T accumulation for env_comparison
library(dplyr)
library(BioCro)
library(ggplot2)

# Read in weather data
ch <- read.csv("~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.ch.2020.csv")
gh <- read.csv("~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.gh.2020.csv")
out <- read.csv("~/model-vignettes/BioCro/DARPA/env_comparison/inputs/weather.out.2020.csv")

tt_ch <- as.data.frame(unclass(BioGro(ch, day1 = 1, dayn = 80))[1:11]) %>%
  select(Hour, DayofYear, ThermalT) %>%
  mutate(trt = "ch")
tt_gh <- as.data.frame(unclass(BioGro(gh, day1 = 1, dayn = 80))[1:11]) %>%
  select(Hour, DayofYear, ThermalT) %>%
  mutate(trt = "gh")
tt_out <- as.data.frame(unclass(BioGro(out, day1 = 1, dayn = 80))[1:11]) %>%
  select(Hour, DayofYear, ThermalT) %>%
  mutate(trt = "out")

tt <- rbind.data.frame(tt_ch, tt_gh, tt_out)

ggplot(tt, aes(x = DayofYear, y = ThermalT, color = trt)) +
  geom_hline(aes(yintercept = 1, linetype = "new")) +
  geom_hline(aes(yintercept = 2, linetype = "new")) +
  geom_hline(aes(yintercept = 3, linetype = "new")) +
  geom_hline(aes(yintercept = 490, linetype = "new")) +
  geom_hline(aes(yintercept = 790, linetype = "new")) +
  geom_hline(aes(yintercept = 990, linetype = "new")) +
  geom_hline(aes(yintercept = 150, linetype = "old")) +
  geom_hline(aes(yintercept = 300, linetype = "old")) +
  geom_hline(aes(yintercept = 450, linetype = "old")) +
  geom_hline(aes(yintercept = 600, linetype = "old")) +
  geom_hline(aes(yintercept = 750, linetype = "old")) +
  geom_hline(aes(yintercept = 900, linetype = "old")) +
  geom_point() +
  scale_x_continuous(limits = c(0, 60))
