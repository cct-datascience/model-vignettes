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
         DayofYear %in% ch.raw$day) %>% 
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

# Plot proportions of biomass
ch.organ.prop <- ch.organ %>% 
  tidyr::pivot_longer(Stem:Grain) %>%
  mutate(name = factor(name, levels = c("Grain", "Leaf", "Stem", "Root", "Rhizome"))) %>%
  ggplot() +
  geom_bar(aes(x = ThermalT, y = value, fill = name), position = "fill", stat = "identity") +
  ylab("Total biomass (Mg/ha)") +
  theme_bw()
print(ch.organ.prop)

# Assign 75% of panicle biomass to stem and 25% to leaf but only for first 3 time points
# Then take the former Grain amount at 3rd time point and redistribute similarly for time points 4-6
# Or, not
ch.reassign <- ch.organ %>%
  mutate(Leaf = ifelse(ThermalT < 800, Leaf + 0.25 * Grain, Leaf),
         Stem = ifelse(ThermalT < 800, Stem + 0.75 * Grain, Stem),
         Grain2 = ifelse(ThermalT < 800, 0, Grain)) %>%
  mutate(Grain3 = ifelse(ThermalT > 800, Grain2 - Grain[3], Grain2),
         Leaf = ifelse(ThermalT > 800, Leaf + 0.25 * Grain[3], Leaf),
         Stem = ifelse(ThermalT > 800, Stem + 0.75 * Grain[3], Stem)) %>%
  select(-Grain, -Grain2) %>%
  rename(Grain = Grain3) 
  # select(-Grain, ) %>%
  # rename(Grain = Grain2) 

# Write out biomass values for optimization routine, with Grain reassigned as above
write.csv(ch.reassign, "../inputs/ch_biomass.csv", row.names = FALSE)

# Plot proportions of derivatives
fig.d.ch.organ.prop <- ch.reassign %>%
  mutate(dStem = Stem - lag(Stem, n = 1),
         dLeaf = Leaf - lag(Leaf, n = 1),
         dRoot = Root - lag(Root, n = 1),
         dGrain = Grain - lag(Grain, n = 1)) %>%
  tidyr::pivot_longer(dStem:dGrain) %>%
  mutate(name = factor(name, levels = c("dGrain", "dLeaf", "dStem", "dRoot"))) %>%
  ggplot() +
  geom_bar(aes(x = ThermalT, y = value, fill = name), position = "stack", stat = "identity") +
  scale_y_continuous(expression(paste(Delta, " biomass"))) +
  theme_bw()
print(fig.d.ch.organ.prop)

# Calculate starting values for kLeaf, kStem, kRoot, kGrain, and kRhizome
# Only use first 4 biomass values, due to tp6 = 900 now
# Setting kRhizome to a very small number
kRhizome <- 0.0001

d.ch.organ.prop <- ch.reassign[1:4,] %>%
  mutate(dStem = Stem - lag(Stem, n = 1),
         dLeaf = Leaf - lag(Leaf, n = 1),
         dRoot = Root - lag(Root, n = 1),
         dGrain = Grain - lag(Grain, n = 1)) %>%
  select(ThermalT, dStem:dGrain) %>%
  slice(-1) %>%
  mutate(Tot = dStem + dLeaf + dRoot + dGrain,
         pStem = round(dStem / Tot, 3),
         pLeaf = round(dLeaf / Tot, 3),
         pRoot = round(dRoot / Tot, 3),
         pGrain = round(dGrain / Tot, 3),
         pRhizome = kRhizome, 
         Sum = pStem + pLeaf + pRoot + pGrain + pRhizome, 
         Diff = 1 - Sum,
         pStem2 = pStem + Diff,
         Sum2 = pStem2 + pLeaf + pRoot + pGrain + pRhizome) %>%
  slice(rep(1, each = 4), rep(2:n(), each = 1))

# Changing config.xml from biomass_opti/inputs folder
# First, adjust time points based on McMaster et al. 2013, Applied Engineering in Agriculture, Fig. 2b
# Hay millet phenological stages (S. italica, the domesticated version of S. viridis)
# 150 Leaf Growth initiation
# 310 Tiller Bud Growth initiation
# 490 Rachis elongation initiation
# 640 Internode Elongation initiation
# 790 Flag leaf initiation
# Floret Primordium Initiation
# 990 Flag leaf end
# 1400 Rachis elongation end

# Read in xml
config <- XML::xmlToList(XML::xmlParse("~/model-vignettes/BioCro/DARPA/biomass_opti/inputs/ch_config.xml"))

config$pft$phenoParms[grep("tp", names(config$pft$phenoParms))] <- c("1",
                                                                     "2", 
                                                                     "3",
                                                                     "490",
                                                                     "790",
                                                                     "990")

# Second, set seneParms starting with leaf senescence just after physiological maturity (2340 gdds)
# equivalent to 500 less than the default
config$pft$seneControl[grep("sen", names(config$pft$seneControl))]  <- c("2500",
                                                                         "3000",
                                                                         "3500",
                                                                         "3500")

# Third, adjust the k Parms as indicated by biomass data
config$pft$phenoParms[grep("kLeaf", names(config$pft$phenoParms))] <- as.character(d.ch.organ.prop$pLeaf)
config$pft$phenoParms[grep("kStem", names(config$pft$phenoParms))] <- as.character(d.ch.organ.prop$pStem2)
config$pft$phenoParms[grep("kRoot", names(config$pft$phenoParms))] <- as.character(d.ch.organ.prop$pRoot)
config$pft$phenoParms[grep("kRhizome", names(config$pft$phenoParms))] <- as.character(d.ch.organ.prop$pRhizome)
config$pft$phenoParms["kGrain6"] <- as.character(d.ch.organ.prop$pGrain[6])

# # Add 5 additional kGrain values
# config$pft$phenoParms$kGrain6 <- NULL
# for(i in 1:6){
#   config$pft$phenoParms$foo <- NA
#   names(config$pft$phenoParms)[length(names(config$pft$phenoParms))] <- paste0("kGrain", i)
# }
# config$pft$phenoParms[grep("kGrain", names(config$pft$phenoParms))] <- as.character(d.ch.organ.prop$pGrain)

# Write out to xml file
config.xml <- PEcAn.settings::listToXml(config, "config")
XML::saveXML(config.xml, file = "~/model-vignettes/BioCro/DARPA/biomass_opti/inputs/ch_config.xml", 
             indent = TRUE)

