# Load required libraries
# ----------------------------------------------------------------------
library(readxl)
library(udunits2)
library(dplyr)
library(tidyr)

# Plot measured biomass against biomass estimates
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = median)) +
  geom_ribbon(aes(day, ymin = lcl_95, ymax = ucl_95), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl_50, ymax = ucl_50), alpha = 0.1) +
  xlab("Day of Year") + 
  ylab("Total Biomass (kg/m2)") +
  xlim(c(0, 50)) +
  theme_classic()



# Plot biomass results. Create a script called `plot_results3.R`, which will contain following code. This pulls in and cleans up the biomass data estimated from BioCro, then plots the data. 
# Select relevant biomass results from sentinel-detection repo
load("~/sentinel-detection/data/cleaned_data/biomass/chamber_biomass.Rdata")
load("~/sentinel-detection/data/cleaned_data/biomass/greenhouse_outdoor_biomass.Rdata")

# Filter
# Calculating age and total aboveground biomass
# Convert from milligrams to megagrams per hectare (each plant grown in pot with 103 cm2 area). 
bio_ch <- chamber_biomass %>%
  filter(genotype == "ME034V-1" & temp == "31/22" & light == 430) %>%
  mutate(trt = "ch",
         days_grown = difftime(harvest_date, sowing_date, units = "days"),
         biomass_mg = panicle_DW_mg + stem_DW_mg + leaf_DW_mg,
         biomass_Mgha = ud.convert(biomass_mg, "mg", "Mg")/ud.convert(103, "cm2", "ha"),
         biomass_kgm2 = ud.convert(biomass_Mgha, "Mg/ha", "kg/m2")) %>%
  filter(!is.na(biomass_mg)) %>%
  select(trt, days_grown, biomass_kgm2)

bio_gh <- greenhouse_outdoor_biomass %>%
  filter(genotype == "ME034V-1" & exp_site == "GH" & exp_number == 1 & treatment == "pot") %>%
  mutate(trt = "gh",
         days_grown = difftime(harvest_date, sowing_date, units = "days"),
         biomass_g = panicle_DW_g + stem_DW_g + leaf_DW_g,
         biomass_Mgha = ud.convert(biomass_g, "g", "Mg")/ud.convert(103, "cm2", "ha"),
         biomass_kgm2 = ud.convert(biomass_Mgha, "Mg/ha", "kg/m2")) %>%
  filter(!is.na(biomass_g)) %>%
  select(trt, days_grown, biomass_kgm2)

bio_out <- greenhouse_outdoor_biomass %>%
  filter(genotype == "ME034V-1" & exp_site == "Field" & exp_number == 2 & treatment == "field_pot") %>%
  mutate(trt = "out",
         days_grown = difftime(harvest_date, sowing_date, units = "days"),
         biomass_g = panicle_DW_g + stem_DW_g + leaf_DW_g,
         biomass_Mgha = ud.convert(biomass_g, "g", "Mg")/ud.convert(103, "cm2", "ha"),
         biomass_kgm2 = ud.convert(biomass_Mgha, "Mg/ha", "kg/m2")) %>%
  filter(!is.na(biomass_g)) %>%
  select(trt, days_grown, biomass_kgm2)

bio <- rbind(bio_ch, bio_gh, bio_out)

# Clean up biomass estimates
load('/data/output/pecan_runs/env_comp_results/gh/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results3/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata") #these data are in kg/m2 carbon
convert_biomass <- function(x) x / 0.4
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  mutate_at(vars(biomass), convert_biomass) %>% 
  filter(hour == 12) %>% 
  group_by(day) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl_50 = quantile(biomass, probs = c(0.25), na.rm = TRUE), 
            ucl_50 = quantile(biomass, probs = c(0.75), na.rm = TRUE),
            lcl_95 = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl_95 = quantile(biomass, probs = c(0.975), na.rm = TRUE))
write.csv(daily_biomass, "temp_exps_inputs3/biomass_ests3.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
plot_daily_biomass <- ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = median)) +
  geom_ribbon(aes(day, ymin = lcl_95, ymax = ucl_95), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl_50, ymax = ucl_50), alpha = 0.1) +
  geom_point(data = highnight_biomass, aes(x = days_grown, y = total_biomass_kgm2)) +
  xlim(x = c(0, 50)) +
  xlab("") + 
  ylab("Total Biomass (kg/m2)") +
  theme_classic() +
  theme(axis.text.x = element_blank(), 
        axis.ticks.x = element_blank(), 
        plot.margin=unit(c(1, 1, 0, 1), "cm"))



# Plot transpiration results.


# Clean up transpiration estimates
load('temp_exps_results/temp_exps_results3/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results3/ensemble.ts.NOENSEMBLEID.TVeg.2019.2019.Rdata")

daily_transp <- data.frame(timescale, t(ensemble.ts[["TVeg"]])) %>% 
  gather(ensemble, transpiration, X1:X100) %>% 
  mutate_at(vars(transpiration), convert_transp) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(transpiration, na.rm = TRUE), 
            median = median(transpiration, na.rm = TRUE), 
            sd = sd(transpiration, na.rm = TRUE), 
            lcl_50 = quantile(transpiration, probs = c(0.25), na.rm = TRUE), 
            ucl_50 = quantile(transpiration, probs = c(0.75), na.rm = TRUE),
            lcl_95 = quantile(transpiration, probs = c(0.025), na.rm = TRUE), 
            ucl_95 = quantile(transpiration, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl_50 = sum(lcl_50), 
            ucl_50 = sum(ucl_50), 
            lcl_95 = sum(lcl_95), 
            ucl_95 = sum(ucl_95))
write.csv(daily_transp, "temp_exps_inputs3/transpiration_ests3.csv")
rm(ensemble.ts)

# Plot transpiration estimates
plot_daily_transp <- ggplot(data = daily_transp) + 
  geom_line(aes(day, y = median)) +
  geom_ribbon(aes(day, ymin = lcl_95, ymax = ucl_95), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl_50, ymax = ucl_50), alpha = 0.1) +
  xlim(x = c(0, 50)) +
  xlab("Day of Experiment") + 
  ylab("Transpiration (kg/m2/day)") +
  theme_classic() + 
  scale_y_continuous(labels = scales::number_format(accuracy = 0.01)) +
  theme(plot.margin=unit(c(-0.5, 1, 1, 1), "cm"))


# Plot biomass and transpiration together. 


# Sensitivity analysis and variance decomposition plots for high night temperature biomass results. 

load("temp_exps_results/temp_exps_results3/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")

sa_df1 <- sensitivity.results[["SetariaWT_ME034"]]$variance.decomposition.output
sa_df2 <- data.frame(trait = names(sa_df1$coef.vars), data.frame(sa_df1))
sa_df3 <- sa_df2 %>% 
  mutate(trait.labels = factor(as.character(PEcAn.utils::trait.lookup(trait)$figid)),
         units = PEcAn.utils::trait.lookup(trait)$units, 
         coef.vars = coef.vars * 100, 
         sd = sqrt(variances)) %>% 
  mutate_at(vars(sd), convert_biomass)
rm(sensitivity.results)

fontsize = list(title = 18, axis = 14)
theme_set(theme_minimal() + 
            theme(axis.text.x = 
                    element_text(
                      size = fontsize$axis, 
                      vjust = -1), 
                  axis.text.y = element_blank(),
                  axis.ticks = element_blank(), 
                  axis.line = element_blank(), 
                  axis.title.x = element_blank(), 
                  axis.title.y = element_blank(), 
                  panel.grid.minor = element_blank(), 
                  panel.border = element_blank()))

cv <- ggplot(data = sa_df3) +
  geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("CV %") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(axis.text.y = element_text(color = 'black', hjust = 1, size = fontsize$axis))

el <- ggplot(data = sa_df3) +
  geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Elasticity") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(plot.title = element_text(hjust = 0.5))

vd <- ggplot(data = sa_df3) +
  geom_pointrange(aes(x = trait.labels, y = sd, ymin = 0, ymax = sd), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Variance Explained (kg/m2)") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  scale_y_continuous(breaks = pretty(sa_df3$sd, n = 3))

cowplot::plot_grid(cv, el, vd, nrow = 1, rel_widths = c(2, 1, 1))


# Sensitivity analysis and variance decomposition plots for high night temperature transpiration results. 

load("temp_exps_results/temp_exps_results3/sensitivity.results.NOENSEMBLEID.TVeg.2019.2019.Rdata")

sa_df1 <- sensitivity.results[["SetariaWT_ME034"]]$variance.decomposition.output
sa_df2 <- data.frame(trait = names(sa_df1$coef.vars), data.frame(sa_df1))
convert_transp_sd <- function(x) ud.convert(x, "kg/m2/s", "kg/m2/d")
sa_df3 <- sa_df2 %>% 
  mutate(trait.labels = factor(as.character(PEcAn.utils::trait.lookup(trait)$figid)),
         units = PEcAn.utils::trait.lookup(trait)$units, 
         coef.vars = coef.vars * 100, 
         sd = sqrt(variances)) %>% 
  mutate_at(vars(sd), convert_transp_sd)
rm(sensitivity.results)

fontsize = list(title = 18, axis = 14)
theme_set(theme_minimal() + 
            theme(axis.text.x = 
                    element_text(
                      size = fontsize$axis, 
                      vjust = -1), 
                  axis.text.y = element_blank(),
                  axis.ticks = element_blank(), 
                  axis.line = element_blank(), 
                  axis.title.x = element_blank(), 
                  axis.title.y = element_blank(), 
                  panel.grid.minor = element_blank(), 
                  panel.border = element_blank()))

cv <- ggplot(data = sa_df3) +
  geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("CV %") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(axis.text.y = element_text(color = 'black', hjust = 1, size = fontsize$axis))

el <- ggplot(data = sa_df3) +
  geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Elasticity") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(plot.title = element_text(hjust = 0.5))

vd <- ggplot(data = sa_df3) +
  geom_pointrange(aes(x = trait.labels, y = sd, ymin = 0, ymax = sd), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Variance Explained (kg/m2/d)") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  scale_y_continuous(breaks = pretty(sa_df3$sd, n = 3))

cowplot::plot_grid(cv, el, vd, nrow = 1, rel_widths = c(2, 1, 1))


# Section 5: Plot Three Runs

# Code to plot the biomass estimates from the first two runs together, along with the control data. 


# Read in and combine biomass measurements data
biomass_meas_highnight <- read.csv("temp_exps_inputs3/highnight_biomass_meas.csv") %>% 
  mutate(txt = "highnight") %>% 
  select(days_grown, total_biomass_kgm2, txt)

# Read in and combine biomass estimates data
biomass_ests1 <- read.csv("temp_exps_inputs1/biomass_ests1.csv") %>% 
  mutate(run = 1)
biomass_ests2 <- read.csv("temp_exps_inputs2/biomass_ests2.csv") %>% 
  mutate(run = 2)
biomass_ests3 <- read.csv("temp_exps_inputs3/biomass_ests3.csv") %>% 
  mutate(run = 3)

biomass_ests <- bind_rows(biomass_ests1, biomass_ests2, biomass_ests3) %>% 
  mutate(run = as.factor(run), 
         `Inputs: parameters / weather` = case_when(run == "1" ~ "control / control", 
                                                    run == "2" ~ "control / high night temp", 
                                                    run == "3" ~ "high night temp / high night temp"))

# Plot measured biomass against biomass estimates
sd_scale <- 5

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  scale_color_manual(values=c("red", "black", "blue")) +
  lims(x = c(0, 60), y = c(0, 0.2)) +
  xlab("Day of Year") + 
  ylab("Total Biomass (kg/m2)") +
  theme_classic()

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd, fill = run), alpha = 0.1) +
  scale_color_manual(values=c("red", "black", "blue", "red", "black", "blue")) +
  lims(x = c(0, 60), y = c(0, 0.2)) +
  xlab("Day of Year") + 
  ylab("Total Biomass (kg/m2)") +
  theme_classic()

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  geom_point(data = biomass_meas_highnight, aes(x = days_grown, y = total_biomass_kgm2, color = txt)) +
  scale_color_manual(values=c("red", "black", "blue", "red", "blue")) +
  lims(x = c(0, 60), y = c(0, 0.15)) +
  xlab("Day of Year") + 
  ylab("Total Biomass (kg/m2)") +
  theme_classic()

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = `Inputs: parameters / weather`)) +
  geom_ribbon(aes(day, ymin = lcl_50, ymax = ucl_50, fill = `Inputs: parameters / weather`), alpha = 0.1) +
  scale_color_manual(values=c("red", "purple", "orange", "red", "purple", "orange")) +
  scale_fill_manual(values=c("red", "purple", "orange", "red", "purple", "orange")) +
  lims(x = c(0, 60), y = c(0, 0.15)) +
  xlab("Day of Year") + 
  ylab("Total Biomass (kg/m2)") +
  theme_classic()


# Figure for comparing sensitivity analysis and variance decomposition results for all three runs. 


sa_dfs <- data.frame()
for(run in 1:3){
  load(paste0("temp_exps_results/temp_exps_results", run, "/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata"))
  sa_df1 <- sensitivity.results[["SetariaWT_ME034"]]$variance.decomposition.output
  sa_df2 <- data.frame(trait = names(sa_df1$coef.vars), 
                       data.frame(sa_df1))
  sa_df3 <- sa_df2 %>% 
    mutate(trait.labels = factor(as.character(PEcAn.utils::trait.lookup(trait)$figid)), 
           
           units = PEcAn.utils::trait.lookup(trait)$units, 
           coef.vars = coef.vars * 100, 
           sd = sqrt(variances), 
           run = run)
  rm(sensitivity.results)
  sa_dfs <- bind_rows(sa_dfs, sa_df3)
}
sa_dfs$run <- as.factor(sa_dfs$run)

fontsize = list(title = 18, axis = 14)
theme_set(theme_minimal() + 
            theme(axis.text.x = 
                    element_text(
                      size = fontsize$axis, 
                      vjust = -1), 
                  axis.text.y = element_blank(),
                  axis.ticks = element_blank(), 
                  axis.line = element_blank(), 
                  axis.title.x = element_blank(), 
                  axis.title.y = element_blank(), 
                  panel.grid.minor = element_blank(), 
                  panel.border = element_blank()))

cv <- ggplot(data = sa_dfs) +
  geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars, color = run), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("CV %") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(axis.text.y = element_text(color = 'black', hjust = 1, size = fontsize$axis))

el <- ggplot(data = sa_dfs) +
  geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities, color = run), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Elasticity") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(plot.title = element_text(hjust = 0.5))

vd <- ggplot(data = sa_dfs) +
  geom_pointrange(aes(x = trait.labels, y = sd, ymin = 0, ymax = sd, color = run), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Variance Explained (SD Units)") +
  geom_hline(aes(yintercept = 0), size = 0.1)

gridExtra::grid.arrange(cv, el, vd, ncol = 3)

