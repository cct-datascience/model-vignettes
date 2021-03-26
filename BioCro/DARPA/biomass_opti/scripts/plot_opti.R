# Following optimization, create plot for report

library(dplyr)
library(ggplot2)
library(BioCro)
library(udunits2)

# Load results of optimization
load("opt_results.Rdata")

# Load weather
opt_weather <- read.csv("../inputs/ch_weather.csv")
colnames(opt_weather) <- c("year", "doy", "hour", "Solar", "Temp", "RH", "WS", "precip")

# Load biomass
opt_biomass <- read.csv("../inputs/ch_biomass.csv")

# Load model config files
config <- PEcAn.BIOCRO::read.biocro.config("../inputs/ch_config.xml")

# Load constants
day1 <- 1
dayn <- 50
rhizomevals <- rep(0.0001, 6)
thermaltimevals <- c(1, 2, 3, 490, 790, 990)

# Run function
l2n <- function(x) lapply(x, as.numeric)

# Adjust to sum to 1
parms_results <- as.vector(opt_results$optim$bestmem)

parms_results[1:3] <- parms_results[1:3]/sum(parms_results[1:3], rhizomevals[1])
parms_results[4:6] <- parms_results[4:6]/sum(parms_results[4:6], rhizomevals[2])
parms_results[7:9] <- parms_results[7:9]/sum(parms_results[7:9], rhizomevals[3])
parms_results[10:12] <- parms_results[10:12]/sum(parms_results[10:12], rhizomevals[4])
parms_results[13:15] <- parms_results[13:15]/sum(parms_results[13:15], rhizomevals[5])
parms_results[16:19] <- parms_results[16:19]/sum(parms_results[16:19], rhizomevals[6])
optimalParms <- phenoParms(tp1 = thermaltimevals[1], 
                           tp2 = thermaltimevals[2], 
                           tp3 = thermaltimevals[3], 
                           tp4 = thermaltimevals[4], 
                           tp5 = thermaltimevals[5], 
                           tp6 = thermaltimevals[6], 
                           
                           kStem1 = parms_results[1], 
                           kLeaf1 = parms_results[2], 
                           kRoot1 = parms_results[3], 
                           kRhizome1 = rhizomevals[1], 
                           
                           kStem2 = parms_results[4], 
                           kLeaf2 = parms_results[5], 
                           kRoot2 = parms_results[6], 
                           kRhizome2 = rhizomevals[2], 
                           
                           kStem3 = parms_results[7], 
                           kLeaf3 = parms_results[8], 
                           kRoot3 = parms_results[9],
                           kRhizome3 = rhizomevals[3], 
                           
                           kStem4 = parms_results[10], 
                           kLeaf4 = parms_results[11],  
                           kRoot4 = parms_results[12], 
                           kRhizome4 = rhizomevals[4], 
                           
                           
                           kStem5 = parms_results[13], 
                           kLeaf5 = parms_results[14], 
                           kRoot5 = parms_results[15], 
                           kRhizome5 = rhizomevals[5],
                           
                           kStem6 = parms_results[16],
                           kLeaf6 = parms_results[17],
                           kRoot6 = parms_results[18], 
                           kRhizome6 = rhizomevals[6],
                           kGrain6 = parms_results[19])

results_test <- BioCro::BioGro(
  WetDat = opt_weather,
  day1 = day1,
  dayn = dayn,
  iRhizome = 0.001, 
  iLeaf = 0.001, 
  iStem = 0.001, 
  iRoot = 0.001, 
  soilControl = l2n(config$pft$soilControl),
  canopyControl = l2n(config$pft$canopyControl),
  phenoControl = l2n(optimalParms),
  seneControl = l2n(config$pft$seneControl),
  photoControl = l2n(config$pft$photoParms))

results_test2 <- data.frame(ThermalT = results_test$ThermalT, 
                            Stem = results_test$Stem,
                            Leaf = results_test$Leaf,
                            Root = results_test$Root,
                            Rhizome = results_test$Rhizome,
                            Grain = results_test$Grain)
results_test3 <- results_test2 %>% 
  filter(round(results_test2$ThermalT) %in% round(opt_biomass$ThermalT))
diff <- sum(abs(results_test3 - opt_biomass)^2)

biomass_meas_plot <- opt_biomass %>% 
  tidyr::pivot_longer(Stem:Grain) %>% 
  mutate(data = "measurements")
biomass_ests_plot <- results_test2 %>% 
  tidyr::pivot_longer(Stem:Grain) %>% 
  mutate(data = "estimates")
biomass_plot <- bind_rows(biomass_meas_plot, biomass_ests_plot) %>%
  filter(name !="Rhizome") %>%
  mutate(biomass = ud.convert(value, "Mg/ha", "kg/m2"))


jpeg(filename = "../plots/Fig_opti.jpg", height = 4, width = 6, units = "in", res = 600)
ggplot() +
  # geom_vline(xintercept = thermaltimevals, alpha = 0.5) +
  geom_point(filter(biomass_plot, data == "measurements"), mapping = aes(x = ThermalT, y = biomass, color = name)) +
  geom_line(filter(biomass_plot, data == "estimates"), mapping = aes(x = ThermalT, y = biomass, color = name)) +
  xlim(c(0, max(biomass_meas_plot$ThermalT))) +
  labs(x = expression("Thermal time " (degree*Cd)), 
       y = expression(paste("Biomass (kg ", m^-2, ")")), 
       color = "Plant Part") +
  theme_bw(base_size = 12) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        strip.background = element_blank()) +
  facet_wrap(~name) +
  guides(color = FALSE)
dev.off()
