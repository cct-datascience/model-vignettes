library(tidyverse)
library(ncdf4)
library(lubridate)

#edit this path
#TODO: get this from pecan.xml
outdir_name <- "/data/tests/ed2_transect_WB/"

#TODO: refactor this to parallelize as it is quite slow
# Also, shouldn't use .h5 files since we already summarized into .nc files, right?
# If .h5 are necessary, can I use `stars` to open them as a raster stack or something?

#Function to read in .nc files for a single ensemble and a single year as a data frame
ens_nc_to_df <- function(ens_file) {
  year_file <- ncdf4::nc_open(ens_file, readunlim = FALSE)
  npp <- tibble(pft = ncdf4::ncvar_get(year_file, "PFT"),
                npp = ncdf4::ncvar_get(year_file, "NPP"),
                time = ncdf4::ncvar_get(year_file, "time"))
  #convert time variable to ymd hms
  time_units <- ncatt_get(year_file, "time")$units
  ncdf4::nc_close(year_file)
  npp <- npp %>% mutate(time = ymd_hms(time_units) + minutes(time*24*60)) 
}

dirs <- list.dirs(paste0(outdir_name, "out"), recursive = FALSE)

ensembles_npps <- 
  # for all ensembles...
  map_df(dirs, ~{
    # get a list of filepaths, one .nc file per year
    ens_filepaths <- Sys.glob(file.path(.x, "*.nc")) 
    # extract the ensemble number
    ens_num <- str_remove(word(.x, -2, sep = "-"), "^0+")
    
    npp <- ens_filepaths %>% 
      # apply the wrangling function to all years of .nc files
      map_df(ens_nc_to_df) %>% 
      # wrangle dates into useful format
      mutate(year = year(time), month = month(time)) %>% 
      # summarize monthly
      group_by(pft, year, month) %>% 
      summarize(npp = sum(npp), .groups = "drop") %>% 
      #re-build date as last day of the month since NPP is summarized as cumulative for the month
      mutate(date = ceiling_date(make_date(year, month, 01), "month") - 1) %>% 
      #add the ensemble number
      add_column(ensemble = ens_num, .before = "pft")
  } )


ggplot(ensembles_npps, aes(x = date, y = npp, group = ensemble, alpha = 0.2)) + 
  geom_line() + 
  facet_grid(~pft)

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
  #facet_grid(rows = vars(patch)) +
  scale_x_datetime(labels = scales::date_format("%Y")) +
  xlab("Year") +
  ylab("NPP (kgC/m2/yr)") +
  theme_classic()
