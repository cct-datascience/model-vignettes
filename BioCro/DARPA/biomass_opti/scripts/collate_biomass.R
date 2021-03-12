### Organize biomass for two sets of biomass optimization runs
library(dplyr)
library(udunits2)
library(ggplot2)
library(BioCro)

load("~/sentinel-detection/data/cleaned_data/biomass/chamber_biomass.Rdata")
load("~/sentinel-detection/data/cleaned_data/biomass/greenhouse_outdoor_biomass.Rdata")
ch_weather <- read.csv("../inputs/ch_weather.csv")

# Ascertain the number of total vs. aboveground biomass by treatment 
ch.count <- chamber_biomass %>%
  filter(genotype == "ME034V-1",treatment %in% c(NA, "control")) %>%
  mutate(day = as.numeric(difftime(harvest_date, sowing_date, "days")),
         biomassTot = (leaf_DW_mg + stem_DW_mg + panicle_DW_mg + root_DW_mg) / 1000,
         biomassAbv = (leaf_DW_mg + stem_DW_mg + panicle_DW_mg) / 1000,
         trt = case_when(temp == "31/22" & light == "250" ~ "regular night T",
                         temp == "31/31" & light == "250" ~ "high night T",
                         temp == "31/22" & light == "430" ~ "high light")) %>%
  group_by(trt) %>%
  summarize(n_Tot = sum(!is.na(biomassTot)),
            n_Abv = sum(!is.na(biomassAbv)))
# Find outdoor and gh jolly G pots
out.count <- greenhouse_outdoor_biomass %>%
  filter(genotype == "ME034V-1") %>%
  mutate(day = as.numeric(difftime(harvest_date, sowing_date, "days")),
         biomassTot = (leaf_DW_g + stem_DW_g + panicle_DW_g + root_DW_g) / 1000,
         biomassAbv = (leaf_DW_g + stem_DW_g + panicle_DW_g) / 1000,
         trt = case_when(treatment == "pot" & exp_site == "GH" ~ "greenhouse",
                         treatment == "jolly_pot" & exp_site == "Field" ~ "outdoor")) %>%
  group_by(trt) %>%
  summarize(n_Tot = sum(!is.na(biomassTot)),
            n_Abv = sum(!is.na(biomassAbv)))

# Use the 22/22 treatment from experiment two, convert output to Mg/ha to match units from BioCro
ch.raw <- chamber_biomass %>%
  filter(genotype == "ME034V-1" & treatment %in% c(NA, "control") & exp_number == "2" & temp == "22/22") %>%
  mutate(day = as.numeric(difftime(harvest_date, sowing_date, "days")),
         biomass_mg = (leaf_DW_mg + stem_DW_mg + panicle_DW_mg + root_DW_mg),
         biomassTot = ud.convert(biomass_mg/103, "mg/cm2", "Mg/ha"))

ch.sum <- ch.raw %>% 
  group_by(day) %>% 
  summarize(biom_mean = mean(biomassTot),
            biom_median = median(biomassTot), 
            biom_sd = sd(biomassTot)) %>% 
  mutate(sd_high = biom_mean + biom_sd, 
         sd_low = biom_mean - biom_sd)

# Plot raw and summarized totals
ggplot(ch.raw, aes(x = day, y = biomassTot)) +
  geom_point() +
  scale_y_continuous("Total biomass (Mg/ha)") +
  theme_bw()
ggplot(ch.sum, aes(x = day, y = biom_mean)) +
  geom_point() +
  geom_errorbar(aes(ymin = sd_low, ymax = sd_high), width = 0) +
  scale_y_continuous("Mean biomass (Mg/ha)") +
  theme_bw()

# Calculate gdd or thermaltime
ThermalT.df <- as.data.frame(unclass(BioGro(ch_weather, day1 = 1, dayn = 365))[1:11]) %>%
  select(Hour, DayofYear, ThermalT) %>% 
  filter(Hour == 0, 
         DayofYear %in% ch.organ$day) %>% 
  rename(day = DayofYear) %>%
  select(day, ThermalT)

# Summarize by organ
ch.organ <- ch.raw %>%
  select(day, stem_DW_mg, leaf_DW_mg, root_DW_mg, panicle_DW_mg) %>%
  mutate(Stem = ud.convert(stem_DW_mg/103, "mg/cm2", "Mg/ha"),
         Leaf = ud.convert(leaf_DW_mg/103, "mg/cm2", "Mg/ha"),
         Root = ud.convert(root_DW_mg/103, "mg/cm2", "Mg/ha"),
         Rhizome = 0,
         Grain = ud.convert(panicle_DW_mg/103, "mg/cm2", "Mg/ha")) %>%
  group_by(day) %>%
  summarize_at(vars(Stem:Grain), median) %>%
  left_join(ThermalT.df) %>%
  # mutate(Grain = ifelse(day < 47, 0, Grain)) %>%
  select(-day) %>%
  relocate(ThermalT)

# Plot and save out
ch.organ.plot <- ch.organ %>% 
  tidyr::pivot_longer(Stem:Grain) %>%
  mutate(name = factor(name, levels = c("Grain", "Leaf", "Stem", "Root", "Rhizome"))) %>%
  ggplot() +
  geom_bar(aes(x = ThermalT, y = value, fill = name), position = "fill", stat = "identity") +
  ylab("Total biomass (Mg/ha)") +
  theme_bw()
print(ch.organ.plot)

write.csv(ch.organ, "../inputs/ch_biomass.csv", row.names = FALSE)

