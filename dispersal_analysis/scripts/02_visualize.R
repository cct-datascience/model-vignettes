# Plot dispersal, germination, and seed mass for 3 genotypes

library(dplyr)
library(ggplot2)

# Read in data
d_all <- read.csv("dispersal_analysis/data_clean/dispersal.csv")
seed <- read.csv("dispersal_analysis/data_clean/mass.csv")
g_all <- read.csv("dispersal_analysis/data_clean/germination.csv")

#### Dispersal ####

# Plot raw (not summarized) values
fig_disp <- ggplot(d_all, aes(x = distance_cm, y = germinated)) +
  geom_point(aes(color = as.factor(rep)),
             alpha = 0.75) +
  facet_grid(cols = vars(genotype),
             rows = vars(week)) +
  theme_bw(base_size = 12)+
  guides(color = "none")

ggsave("dispersal_analysis/plots/dispersal.png",
       plot= fig_disp,
       height = 4, 
       width = 6, 
       units = "in")

#### Seed mass ####

seed_sum <- seed %>%
  group_by(genotype) %>%
  summarize(mean = mean(mass),
            sd = sd(mass))

fig_mass <- ggplot() +
  geom_jitter(data = seed, 
             aes(x = genotype,
                 y = mass,
                 color = as.factor(rep)),
             alpha = 0.5,
             width = 0.2) +
  geom_pointrange(data = seed_sum,
                  aes(x = genotype,
                      y = mean,
                      ymin = mean - sd,
                      ymax = mean + sd)) +
  theme_bw(base_size = 12) +
  guides(color = "none")

ggsave("dispersal_analysis/plots/mass.png",
       plot= fig_mass,
       height = 3, 
       width = 3, 
       units = "in")

#### Germination ####

# Plot raw
fig_germ <- ggplot(g_all, 
       aes(x = hours_since_sowing,
           y = percent_germinated,
           color = as.factor(rep)),
       alpha = 0.75) +
  geom_point() +
  facet_grid(cols = vars(genotype),
             rows = vars(experiment)) +
  theme_bw(base_size = 12)+
  guides(color = "none")

ggsave("dispersal_analysis/plots/germination.png",
       plot= fig_germ,
       height = 3, 
       width = 5, 
       units = "in")
