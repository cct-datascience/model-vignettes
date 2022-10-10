
# Load packages -----------------------------------------------------------
library(PEcAn.settings)
library(ncdf4)
library(lubridate)
library(tidyverse)
library(units)


# Load settings -----------------------------------------------------------
# Edit this path!
settings <- read.settings("ED2/testoutput/new_run/outdir/pecan_checked.xml")


# Pull in results ---------------------------------------------------------
nc_files <- list.files(settings$modeloutdir, "*.nc$", recursive = TRUE, full.names = TRUE)

nc_to_df <- function(nc, ensemble) {
  ncin <- nc_open(nc)
  npp_pft <- ncvar_get(ncin, "NPP_PFT")
  pft <- ncvar_get(ncin, "pft")
  ncvar_get(ncin, "PFT")
  colnames(npp_pft) <- 
    ncatt_get(ncin, "PFT", "long_name")$value %>% 
    strsplit(x = ., split = ",") %>% 
    unlist()
  dtime <- ncvar_get(ncin, "dtime")
  start_time <- ncatt_get(ncin, "dtime", "units")$value %>% ymd_hms()
  
  npp_pft %>% 
    as_tibble() %>% 
    mutate(datetime = (start_time + days(dtime))) %>% 
    pivot_longer(-datetime, names_to = "pft", values_to = "NPP") %>% 
    mutate(ensemble = basename(dirname(nc)))
}

npp_all <- 
  map_dfr(nc_files, nc_to_df) %>% 
  mutate(NPP = set_units(NPP, "kg m-2 s-1"))


# Summarize results -------------------------------------------------------
npp_monthly <- 
  npp_all %>% 
  group_by(datetime) %>%
  summarise(mean = mean(NPP, na.rm = TRUE),
            median = median(NPP, na.rm = TRUE),
            sd = sd(NPP, na.rm = TRUE),
            lcl_50 = quantile(NPP, probs = c(0.25), na.rm = TRUE),
            ucl_50 = quantile(NPP, probs = c(0.75), na.rm = TRUE),
            lcl_95 = quantile(NPP, probs = c(0.025), na.rm = TRUE),
            ucl_95 = quantile(NPP, probs = c(0.975), na.rm = TRUE)) %>% 
  mutate(across(
    c(mean, median, starts_with("lcl_"), starts_with("ucl_")),
    ~ units::set_units(., "kg/m2/yr")
  ))


# Plot results ------------------------------------------------------------
ggplot(npp_monthly, aes(x = datetime)) +
  geom_line(data = npp_all, aes(y = NPP, group = ensemble), alpha = 0.2) + 
  geom_ribbon(aes(ymin = lcl_95, ymax = ucl_95, fill = "95%"), alpha = 0.3) +
  geom_ribbon(aes(ymin = lcl_50, ymax = ucl_50, fill = "50%"), alpha = 0.3) +
  geom_line(aes(y = mean), size = 1) +
  facet_wrap(~pft) +
  scale_x_datetime(date_breaks = "1 month", date_labels = "%Y-%m") +
  scale_fill_discrete("CIs") +
  theme_classic()

ggsave(file.path(settings$outdir, "npp_by_pft.png"))
