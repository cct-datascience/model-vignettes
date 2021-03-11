### Organize biomass for two sets of biomass optimization runs

load("~/sentinel-detection/data/cleaned_data/biomass/chamber_biomass.Rdata")
load("~/sentinel-detection/data/cleaned_data/biomass/greenhouse_outdoor_biomass.Rdata")

# Find chamber treatment with most measurements over time
ch <- chamber_biomass %>%
  filter(genotype == "ME034V-1") %>%
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
out <- greenhouse_outdoor_biomass %>%
  filter(genotype == "ME034V-1") %>%
  mutate(day = as.numeric(difftime(harvest_date, sowing_date, "days")),
         biomassTot = (leaf_DW_g + stem_DW_g + panicle_DW_g + root_DW_g) / 1000,
         biomassAbv = (leaf_DW_g + stem_DW_g + panicle_DW_g) / 1000,
         trt = case_when(treatment == "pot" & exp_site == "GH" ~ "greenhouse",
                         treatment == "jolly_pot" & exp_site == "Field" ~ "outdoor")) %>%
  group_by(trt) %>%
  summarize(n_Tot = sum(!is.na(biomassTot)),
            n_Abv = sum(!is.na(biomassAbv)))



#biomass includes all 4 organs - missing root_DW_mg yields an NA for biomass

ggplot(ch, aes(x = day, y = biomass, col = as.factor(light))) +
  geom_point() +
  scale_y_continuous("Total biomass (g)") +
  facet_wrap(~temp, ncol = 2, scales = "free") +
  theme_bw()

ggplot(ch, aes(x = day, y = biomass, col = as.factor(temp))) +
  geom_point() +
  scale_y_continuous("Total biomass (g)") +
  facet_wrap(~as.factor(light), ncol = 2, scales = "free") +
  theme_bw()

ggplot(ch[ch$exp_number == 2,], aes(x = day, y = biomass, col = as.factor(temp))) +
  geom_point() +
  scale_y_continuous("Total biomass (g)") +
  theme_bw()

ggplot(ch[ch$temp == "22/22",], aes(x = day, y = biomass, col = as.factor(exp_number))) +
  geom_point() +
  scale_y_continuous("Total biomass (g)") +
  theme_bw()



