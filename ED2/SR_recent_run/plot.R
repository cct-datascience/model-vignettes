library(dplyr)
library(tidyr)
library(ggplot2)

days <- c(1:365)
timescale <- data.table::data.table(day = rep(days, each = 24), hour = 0:23)

# Read in and clean 100 ensembles data
#TODO: Automate getting years and variable name in path
load("/data/tests/ed2_SR_recent_100ens_sa/ensemble.ts.NOENSEMBLEID.NPP.2020.2021.Rdata")
timescale_final <- timescale[1:ncol(ensemble.ts$NPP), ]

daily_npp_100 <- data.frame(timescale_final, t(ensemble.ts[["NPP"]])) %>%
  gather(ensemble, npp, X1:X100) %>% #todo: automate for final column
  filter(hour == 23) %>%
  mutate(date = as.Date("2020-02-29") + day) %>% #todo: automate date from pecan xml
  group_by(date) %>%
  summarise(mean = mean(npp, na.rm = TRUE),
            median = median(npp, na.rm = TRUE),
            sd = sd(npp, na.rm = TRUE),
            lcl_50 = quantile(npp, probs = c(0.25), na.rm = TRUE),
            ucl_50 = quantile(npp, probs = c(0.75), na.rm = TRUE),
            lcl_95 = quantile(npp, probs = c(0.025), na.rm = TRUE),
            ucl_95 = quantile(npp, probs = c(0.975), na.rm = TRUE)) %>% 
  mutate(median = udunits2::ud.convert(median, "kg/m2/s", "kg/m2/yr"), 
         lcl_50 = udunits2::ud.convert(lcl_50, "kg/m2/s", "kg/m2/yr"), 
         ucl_50 = udunits2::ud.convert(ucl_50, "kg/m2/s", "kg/m2/yr"), 
         lcl_95 = udunits2::ud.convert(lcl_95, "kg/m2/s", "kg/m2/yr"), 
         ucl_95 = udunits2::ud.convert(ucl_95, "kg/m2/s", "kg/m2/yr"))

ensembles_100 <- data.frame(timescale_final, t(ensemble.ts[["NPP"]])) %>%
  gather(ensemble, npp, X1:X100) %>%
  filter(hour == 23)

# Read in and clean 500 ensembles data
load("/data/tests/ed2_SR_recent_500ens_sa/ensemble.ts.NOENSEMBLEID.NPP.2020.2021.Rdata")

daily_npp_500 <- data.frame(timescale_final, t(ensemble.ts[["NPP"]])) %>%
  gather(ensemble, npp, X1:X500) %>% #todo: automate for final column
  filter(hour == 23) %>%
  mutate(date = as.Date("2020-02-29") + day) %>% #todo: automate date from pecan xml
  group_by(date) %>%
  summarise(mean = mean(npp, na.rm = TRUE),
            median = median(npp, na.rm = TRUE),
            sd = sd(npp, na.rm = TRUE),
            lcl_50 = quantile(npp, probs = c(0.25), na.rm = TRUE),
            ucl_50 = quantile(npp, probs = c(0.75), na.rm = TRUE),
            lcl_95 = quantile(npp, probs = c(0.025), na.rm = TRUE),
            ucl_95 = quantile(npp, probs = c(0.975), na.rm = TRUE)) %>% 
  mutate(median = udunits2::ud.convert(median, "kg/m2/s", "kg/m2/yr"), 
         lcl_50 = udunits2::ud.convert(lcl_50, "kg/m2/s", "kg/m2/yr"), 
         ucl_50 = udunits2::ud.convert(ucl_50, "kg/m2/s", "kg/m2/yr"), 
         lcl_95 = udunits2::ud.convert(lcl_95, "kg/m2/s", "kg/m2/yr"), 
         ucl_95 = udunits2::ud.convert(ucl_95, "kg/m2/s", "kg/m2/yr"))

ensembles_500 <- data.frame(timescale_final, t(ensemble.ts[["NPP"]])) %>%
  gather(ensemble, npp, X1:X500) %>%
  filter(hour == 23)

# Plot 100 and 500 ensembles data
npp_timeseries <- ggplot() +
  geom_line(data = daily_npp_100, aes(date, y = median, color = "red")) +
  geom_ribbon(data = daily_npp_100, aes(date, ymin = lcl_95, ymax = ucl_95, fill = "red"), alpha = 0.1) +
  geom_ribbon(data = daily_npp_100, aes(date, ymin = lcl_50, ymax = ucl_50, fill = "red"), alpha = 0.1) +
  geom_line(data = daily_npp_500, aes(date, y = median, color = "blue")) +
  geom_ribbon(data = daily_npp_500, aes(date, ymin = lcl_95, ymax = ucl_95, fill = "blue"), alpha = 0.1) +
  geom_ribbon(data = daily_npp_500, aes(date, ymin = lcl_50, ymax = ucl_50, fill = "blue"), alpha = 0.1) +
  xlab("Day") +
  ylab("NPP (kg/m2/yr)") +
  labs(fill = "50% & 95% CIs", color = "Ensemble mean") +
  scale_fill_discrete(labels = c("100 ensembles", "500 ensembles")) +
  scale_color_discrete(labels = c("100 ensembles", "500 ensembles")) +
  theme_classic() +
  theme(legend.position = "right")

npp_ensembles <- ggplot() +
  geom_line(data = ensembles_500, aes(x = day, y = npp), alpha = 0.1, color = "red") +
  geom_line(data = ensembles_100, aes(x = day, y = npp), alpha = 0.1) +
  theme(legend.position = "none")

# Plot SA results for 100 ensembles
load("/data/tests/ed2_SR_recent_100ens_sa/sensitivity.results.NOENSEMBLEID.NPP.2020.2021.Rdata")
for(pft in names(sensitivity.results)){
  sa_df1_100 <- sensitivity.results[[pft]]$variance.decomposition.output
  sa_df2_100 <- data.frame(trait = names(sa_df1_100$coef.vars), data.frame(sa_df1_100))
  sa_df3_100 <- sa_df2_100 %>%
    mutate(trait.labels = factor(as.character(PEcAn.utils::trait.lookup(trait)$figid)),
           units = PEcAn.utils::trait.lookup(trait)$units,
           coef.vars = coef.vars * 100,
           sd = sqrt(variances)) %>% 
    filter(trait != "water_conductance")
  
  fontsize = list(title = 18, axis = 14)
  theme_set(theme_minimal() +
              theme(axis.text.x = element_text(size = fontsize$axis,
                                               vjust = -1),
                    axis.text.y = element_blank(),
                    axis.ticks = element_blank(),
                    axis.line = element_blank(),
                    axis.title.x = element_blank(),
                    axis.title.y = element_blank(),
                    panel.grid.minor = element_blank(),
                    panel.border = element_blank()))
  
  cv_100 <- ggplot(data = sa_df3_100) +
    geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
    coord_flip() +
    ggtitle("CV %") +
    geom_hline(aes(yintercept = 0), size = 0.1) +
    theme(axis.text.y = element_text(color = 'black', hjust = 1, size = fontsize$axis))
  
  el_100 <- ggplot(data = sa_df3_100) +
    geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
    coord_flip() +
    ggtitle("Elasticity") +
    geom_hline(aes(yintercept = 0), size = 0.1) +
    theme(plot.title = element_text(hjust = 0.5))
  
  vd_100 <- ggplot(data = sa_df3_100) +
    geom_pointrange(aes(x = trait.labels, y = sd, ymin = 0, ymax = sd), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
    coord_flip() +
    ggtitle("Variance Explained") +
    geom_hline(aes(yintercept = 0), size = 0.1) +
    scale_y_continuous(breaks = pretty(sa_df3_100$sd, n = 3))
  
  npp_savd_100 <- cowplot::plot_grid(cv_100, el_100, vd_100, nrow = 1, rel_widths = c(2, 1, 1))
}

# Plot SA results for 500 ensembles
load("/data/tests/ed2_SR_recent_500ens_sa/sensitivity.results.NOENSEMBLEID.NPP.2020.2021.Rdata")
for(pft in names(sensitivity.results)){
  sa_df1_500 <- sensitivity.results[[pft]]$variance.decomposition.output
  sa_df2_500 <- data.frame(trait = names(sa_df1_500$coef.vars), data.frame(sa_df1_500))
  sa_df3_500 <- sa_df2_500 %>%
    mutate(trait.labels = factor(as.character(PEcAn.utils::trait.lookup(trait)$figid)),
           units = PEcAn.utils::trait.lookup(trait)$units,
           coef.vars = coef.vars * 100,
           sd = sqrt(variances)) %>% 
    filter(trait != "water_conductance")
  
  fontsize = list(title = 18, axis = 14)
  theme_set(theme_minimal() +
              theme(axis.text.x = element_text(size = fontsize$axis,
                                               vjust = -1),
                    axis.text.y = element_blank(),
                    axis.ticks = element_blank(),
                    axis.line = element_blank(),
                    axis.title.x = element_blank(),
                    axis.title.y = element_blank(),
                    panel.grid.minor = element_blank(),
                    panel.border = element_blank()))
  
  cv_500 <- ggplot(data = sa_df3_500) +
    geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
    coord_flip() +
    ggtitle("CV %") +
    geom_hline(aes(yintercept = 0), size = 0.1) +
    theme(axis.text.y = element_text(color = 'black', hjust = 1, size = fontsize$axis))
  
  el_500 <- ggplot(data = sa_df3_500) +
    geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
    coord_flip() +
    ggtitle("Elasticity") +
    geom_hline(aes(yintercept = 0), size = 0.1) +
    theme(plot.title = element_text(hjust = 0.5))
  
  vd_500 <- ggplot(data = sa_df3_500) +
    geom_pointrange(aes(x = trait.labels, y = sd, ymin = 0, ymax = sd), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
    coord_flip() +
    ggtitle("Variance Explained") +
    geom_hline(aes(yintercept = 0), size = 0.1) +
    scale_y_continuous(breaks = pretty(sa_df3_500$sd, n = 3))
  
  npp_savd_500 <- cowplot::plot_grid(cv_500, el_500, vd_500, nrow = 1, rel_widths = c(2, 1, 1))
}
