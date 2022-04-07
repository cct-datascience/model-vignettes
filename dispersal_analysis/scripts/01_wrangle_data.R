# Script to collate and tidy raw data into cleaned data

library(readr)
library(dplyr)

#### Dispersal ####
d1 <- read.table("dispersal_analysis/data_raw/week4_seed_dispursal.txt") %>%
  mutate(week = 4)
d2 <- read.table("dispersal_analysis/data_raw/week5_seed_dispursal.txt")%>%
  mutate(week = 5)
d3 <- read.table("dispersal_analysis/data_raw/week6_seed_dispursal.txt")%>%
  mutate(week = 6)
d4 <- read.table("dispersal_analysis/data_raw/week7_seed_dispursal.txt",
                 sep = "\t",
                 header = TRUE) %>%
  select(-1) %>%
  mutate(week = 7)
  
# Check all column names match
unique(c(colnames(d1), colnames(d2), colnames(d3), colnames(d4)))

# Bind together, tidy into long format, add column for replicate 1:4
d_all <- rbind.data.frame(d1, d2, d3, d4) %>%
  tidyr::pivot_longer(2:13,
                      names_to = "name",
                      values_to = "germinated") %>%
  mutate(genotype = sub("\\..", "", name),
         genotype = sub("\\..", "", genotype),
         rep = rep(1:4, 276)) %>%
  rename(distance_cm = Dispersal.Distance..cm.) %>%
  relocate(week, genotype, rep, distance_cm, germinated, name) %>%
  arrange(week, genotype, rep, distance_cm)

# Write out
write.csv(d_all, "dispersal_analysis/data_clean/dispersal.csv")

#### Seed mass ####

seed <- read.csv("dispersal_analysis/data_raw/Seed_weight_.csv") %>%
  select(-1) %>%
  rename(rep = Replicate..,
         ME034V = ME034V.1) %>%
  tidyr::pivot_longer(-1, 
                      names_to = "genotype",
                      values_to = "mass") %>%
  relocate(genotype, rep, mass) %>%
  arrange(genotype, rep)

# Write out
write.csv(seed, "dispersal_analysis/data_clean/mass.csv")

#### Germination ####

g1 <- read_csv("dispersal_analysis/data_raw/Germination assay_All_reps_experiment_2.csv") %>%
  mutate(experiment = 2)

g2 <- read_csv("dispersal_analysis/data_raw/Germination_Experiment_3_average from each .csv") %>%
  mutate(experiment = 3)

# Check all column names match
unique(c(colnames(g1), colnames(g2)))

# Bind together, tidy into long format, add column for replicates 1:3
g_all <- rbind.data.frame(g1, g2) %>%
  tidyr::pivot_longer(2:10,
                      names_to = "name",
                      values_to = "percent_germinated") %>%
  mutate(genotype = sub("_.", "", name),
         genotype = sub("-.", "", genotype),
         rep = rep(1:3, 36),
         percent_germinated = round(percent_germinated, 2)) %>%
  rename(hours_since_sowing = "Hours post sowing") %>%
  relocate(experiment, genotype, rep, hours_since_sowing, percent_germinated, name) %>%
  arrange(experiment, genotype, rep)

# Write out
write.csv(g_all, "dispersal_analysis/data_clean/germination.csv")

         