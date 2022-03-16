library(dplyr)
library(tidyr)
library(ggplot2)

### Multiple PFTs

ensembles_npps <- c()
for(ensemble in 1:10){ 
  if(ensemble < 10){
    ens_num <- paste0("00", ensemble)
  } else if(ensemble >= 10 & ensemble < 100){
    ens_num <- paste0("0", ensemble)
  } else {
    ens_num <- ensemble
  }
  ens_path <- paste0("/data/tests/ed2_SR_recent_patches/out/ENS-00", ens_num, "-1000000111")
  ens_filepaths <- Sys.glob(file.path(ens_path, c("analysis-E-*", ".*h5")))
  ensemble_npp <- c()
  for(month_filepath in ens_filepaths){
    month_file <- ncdf4::nc_open(month_filepath)
    all_month_npps <- data.frame(pft = ncdf4::ncvar_get(month_file, "PFT"), 
                           npp = ncdf4::ncvar_get(month_file, "MMEAN_NPP_CO"), 
                           patch = c(rep(2, ncdf4::ncvar_get(month_file, "PACO_N")[1]), 
                                     rep(1, ncdf4::ncvar_get(month_file, "PACO_N")[2])))
    summed_month_npps <- all_month_npps %>% 
      group_by(patch, pft) %>% 
      summarise(pft_npp = sum(npp)) %>% 
      mutate(date = substr(month_filepath, 71, 77), 
             ensemble = ensemble)
    ensemble_npp <- bind_rows(ensemble_npp, summed_month_npps)
    ncdf4::nc_close(month_file)
  }
  ensembles_npps <- bind_rows(ensembles_npps, ensemble_npp)
}

npp_summary <- ensembles_npps %>% 
  mutate(date = as.POSIXct(as.Date(paste0(date, "-01"))),
         pft = case_when(pft == 1 ~ "Setaria",
                         pft == 5 ~ "C3 grass",
                         pft == 9 ~ "Hardwood trees"),
         pft = as.factor(pft)) %>%
  group_by(patch, pft, date) %>% 
  summarize(mean = mean(pft_npp, na.rm = TRUE),
            median = median(pft_npp, na.rm = TRUE),
            sd = sd(pft_npp, na.rm = TRUE),
            lcl_50 = quantile(pft_npp, probs = c(0.25), 
                              na.rm = TRUE, names = FALSE),
            ucl_50 = quantile(pft_npp, probs = c(0.75), 
                              na.rm = TRUE, names = FALSE),
            lcl_95 = quantile(pft_npp, probs = c(0.025), 
                              na.rm = TRUE, names = FALSE),
            ucl_95 = quantile(pft_npp, probs = c(0.975), 
                              na.rm = TRUE, names = FALSE)) %>% 
  rename(Species = pft)

ggplot(data = npp_summary) +
  geom_line(aes(x = date, y = median, color = Species)) +
  geom_ribbon(aes(x = date, ymin = lcl_50, ymax = ucl_50, fill = Species), alpha = 0.4) +
  facet_grid(rows = vars(patch)) +
  scale_x_datetime(labels = scales::date_format("%b")) +
  xlab("Month") +
  ylab("NPP (kgC/m2/yr)") +
  theme_classic()
