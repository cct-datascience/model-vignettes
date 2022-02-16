library(dplyr)
library(tidyr)
library(ggplot2)

# use this for plotting by PFT: https://github.com/az-digitalag/model-vignettes/blob/master/ED2/plot_ed2_results.Rmd
ensembles_npps <- c()
for(ensemble in 1:100){ 
  if(ensemble < 10){
    ens_num <- paste0("00", ensemble)
  } else if(ensemble >= 10 & ensemble < 100){
    ens_num <- paste0("0", ensemble)
  } else {
    ens_num <- ensemble
  }
  ens_path <- paste0("/data/tests/ed2_AK_recent_100ens_2pfts/out/ENS-00", ens_num, "-1000004897")
  #ens_path <- paste0(results_path, "/ed2/out/ENS-00", ens_num, "-76")
  print(ens_path)
  ens_e_files <- Sys.glob(file.path(ens_path, c("analysis-E-*", ".*h5")))
  ensemble_npp <- c()
  for(file in ens_e_files){
    ens_month_file <- ncdf4::nc_open(file)
    ens_month_npp <- ncdf4::ncvar_get(ens_month_file, "MMEAN_NPP_CO")
    ens_month_nplant <- ncdf4::ncvar_get(ens_month_file, "NPLANT")
    ens_month_total_npp <- ens_month_npp * ens_month_nplant
    ens_month_pft <- ncdf4::ncvar_get(ens_month_file, "PFT")
    ens_month_df <- data.frame(npp = ens_month_total_npp, pft = ens_month_pft) %>%
      group_by(pft) %>%
      summarize(npp = mean(npp)) %>%
      mutate(date = substr(file, 76, 82),
             ensemble = ensemble)
    ensemble_npp <- bind_rows(ensemble_npp, ens_month_df)
    ncdf4::nc_close(ens_month_file)
  }
  ensembles_npps <- bind_rows(ensembles_npps, ensemble_npp)
}

npp_summary <- ensembles_npps %>% 
  mutate(date = as.POSIXct(as.Date(paste0(date, "-01"))), 
         pft = case_when(pft == 1 ~ "Setaria", 
                         pft == 5 ~ "tundra grass"), 
         pft = as.factor(pft)) %>% 
  group_by(pft, date) %>% 
  summarize(mean = mean(npp, na.rm = TRUE),
            median = median(npp, na.rm = TRUE),
            sd = sd(npp, na.rm = TRUE),
            lcl_50 = quantile(npp, probs = c(0.25), 
                              na.rm = TRUE, names = FALSE),
            ucl_50 = quantile(npp, probs = c(0.75), 
                              na.rm = TRUE, names = FALSE),
            lcl_95 = quantile(npp, probs = c(0.025), 
                              na.rm = TRUE, names = FALSE),
            ucl_95 = quantile(npp, probs = c(0.975), 
                              na.rm = TRUE, names = FALSE)) %>% 
  rename(Species = pft)

npp_summary$Species <- factor(npp_summary$Species, levels = c("tundra grass", "Setaria"))
ggplot(data = npp_summary) +
  geom_line(aes(x = date, y = median, color = Species)) +
  geom_ribbon(aes(date, ymin = lcl_50, ymax = ucl_50, fill = Species), alpha = 0.4) +
  scale_x_datetime(labels = scales::date_format("%b")) +
  xlab("Month") +
  ylab("NPP (kgC/m2/yr)") +
  theme_classic()


nonsetaria_only <- npp_summary %>% 
  filter(Species == "tundra grass")
ggplot(data = nonsetaria_only) +
  geom_line(aes(x = date, y = median, color = Species)) +
  geom_ribbon(aes(date, ymin = lcl_50, ymax = ucl_50, fill = Species), alpha = 0.4) +
  scale_x_datetime(labels = scales::date_format("%b")) +
  xlab("Month") +
  ylab("NPP (kgC/m2/yr)") +
  theme_classic()
