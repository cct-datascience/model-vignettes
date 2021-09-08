# Load required libraries
# ----------------------------------------------------------------------
library(readxl)
library(udunits2)
library(dplyr)
library(tidyr)
library(ggplot2)

if(!dir.exists(paste0("../plots/"))){
  dir.create(paste0("../plots/"), recursive = T)
}

# Organize 3 treatments into same figure
biomass_diff <- read.csv(paste0("/data/output/pecan_runs/env_comp_results/comparison_diff_AGB.csv")) %>%
  pivot_wider(names_from = percentile, values_from = c(ch_gh, out_ch, out_gh)) %>%
  pivot_longer(!day, names_to = c("first", "second", "level"), names_pattern = "(.*)_(.*)_(.*)",
               values_to = "percentile") %>%
  mutate(diff = paste0(first, "_", second)) %>%
  pivot_wider(names_from = level, values_from = percentile) %>%
  rename(p025 = "25",
         p05 = "50",
         p50 = "500",
         p095 = "950",
         p975 = "975")

trans_diff <- read.csv(paste0("/data/output/pecan_runs/env_comp_results/comparison_diff_TVeg.csv")) %>%
  pivot_wider(names_from = percentile, values_from = c(ch_gh, out_ch, out_gh)) %>%
  pivot_longer(!day, names_to = c("first", "second", "level"), names_pattern = "(.*)_(.*)_(.*)",
               values_to = "percentile") %>%
  mutate(diff = paste0(first, "_", second)) %>%
  pivot_wider(names_from = level, values_from = percentile) %>%
  rename(p025 = "25",
         p05 = "50",
         p50 = "500",
         p095 = "950",
         p975 = "975")

# Calculate when one-sided (.05) or two-sided (.025) t-test is significant
# Assumes that the difference is positive
biomass_diff$sig_05 <- ifelse(biomass_diff$p05 > 0, TRUE, FALSE)
biomass_diff$sig_025 <- ifelse(biomass_diff$p025 > 0, TRUE, FALSE)

trans_diff$sig_05 <- ifelse(trans_diff$p05 > 0, TRUE, FALSE)
trans_diff$sig_025 <- ifelse(trans_diff$p025 > 0, TRUE, FALSE)

# Plot biomass treatment differences through time
fig_biomass_diff <- ggplot() +
  geom_hline(yintercept = 0) +
  geom_line(data = biomass_diff, aes(day, y = p50, color = diff)) +
  geom_ribbon(data = biomass_diff, aes(day, ymin = p05, ymax = p095, fill = diff), alpha = 0.25) +
  geom_point(data = biomass_diff[biomass_diff$sig_05 == TRUE,], aes(day, y = p50, color = diff)) +
  scale_x_continuous("Day of Experiment") + 
  scale_y_continuous(expression(paste(Delta, " Total Biomass (kg ",  m^-2, ")"))) +
  theme_classic()

jpeg(filename = "../plots/biomass_diff.jpg", height = 5, width = 7, units = "in", res = 600)
print(fig_biomass_diff)
dev.off()

fig_trans_diff <- ggplot() +
  geom_hline(yintercept = 0) +
    geom_line(data = trans_diff, aes(day, y = p50, color = diff)) +
  geom_ribbon(data = trans_diff, aes(day, ymin = p05, ymax = p095, fill = diff), alpha = 0.25) +
  geom_point(data = trans_diff[trans_diff$sig_05 == TRUE,], aes(day, y = p50, color = diff)) +
  scale_x_continuous("Day of Experiment") + 
  scale_y_continuous(expression(paste(Delta, " Canopy Transpiration (kg ",  m^-2, " ", day^-1, ")"))) +
  theme_classic()

jpeg(filename = "../plots/trans_diff.jpg", height = 5, width = 7, units = "in", res = 600)
print(fig_trans_diff)
dev.off()
