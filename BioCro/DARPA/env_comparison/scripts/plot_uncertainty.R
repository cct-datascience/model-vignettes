
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

