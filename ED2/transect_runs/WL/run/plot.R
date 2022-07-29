
# Load packages -----------------------------------------------------------
library(tidyverse)
library(lubridate)
library(PEcAn.settings)
library(units)
library(ncdf4)
library(furrr)
library(progressr)

# set up parallelization --------------------------------------------------
# only 2 cores because few available on Welsch
plan(multisession, workers = 2)


# Get filepaths -----------------------------------------------------------

#edit this path
inputdir <- "ED2/transect_runs/WL/run"
inputfile <- file.path(inputdir, "pecan_checked.xml")
settings <- read.settings(inputfile)
outdir <- settings$outdir


ensembles <- list.dirs(file.path(outdir, "out"), recursive = FALSE)


# Extract data ------------------------------------------------------------

with_progress({
  #sets up progress bar
  p <- progressor(steps = length(ensembles))
  all_npp <- 
    future_map_dfr(ensembles, ~{
      p() #increment progress bar
      
      #with a single ensemble, `.x`:
      
      ens_filepaths <- Sys.glob(file.path(.x, c("analysis-E-*", ".*h5")))
      #this will automatically drop any ensembles with no output because
      #ens_filepaths will be length 0 and the next map_df doesn't get run
      
      
      future_map_dfr(ens_filepaths, ~{
        #with a single .h5 file, `.x`:
        x <- nc_open(.x)
        withr::defer(nc_close(x))
        #parse date from filename
        
        date <-
          basename(.x) %>%
          str_extract("\\d{4}-\\d{2}-\\d{2}") %>% 
          #day is 00, which is invalid
          str_replace("\\d$", "1") %>% 
          lubridate::ymd()
        
        tibble(
          date = date,
          pft = as.character(ncvar_get(x, "PFT")),
          npp = ncvar_get(x, "MMEAN_NPP_CO") #I guess "cohort" (_CO) is the same as PFT??  I wouldn't think so.
        )
      }) %>% 
        mutate(ensemble = basename(.x))
    })
})



# Tidy data ---------------------------------------------------------------

#get pft names from settings
pft_mappings <- 
  tibble(pft = map_chr(settings$pfts, "ed2_pft_number"),
         pft_name = map_chr(settings$pfts,"name"))

all_npp <- 
  all_npp %>% 
  #set units for output
  mutate(npp = set_units(npp, "kg/m^2/yr")) %>% 
  #TODO units are actually "kgC/pl/yr" in the .h5 file attributes.  I'm guessing
  #     that's kg carbon/ polygon/yr.  Not sure if a polygon is 1 m^2 always 
  #join to pft name
  right_join(pft_mappings, by = "pft")

# Summarize data ----------------------------------------------------------

npp_summary <- 
  all_npp %>% 
  group_by(date, pft_name) %>% 
  summarize(npp_mean = mean(npp, na.rm = TRUE),
            npp_sd = sd(npp, na.rm = TRUE),
            lcl_95 = quantile(npp, 0.025, na.rm = TRUE),
            ucl_95 = quantile(npp, 0.975, na.rm = TRUE))


# Plot data ---------------------------------------------------------------

ggplot(npp_summary, aes(x = date, y = npp_mean)) +
  geom_ribbon(aes(ymin = lcl_95, ymax = ucl_95, fill = pft_name), alpha = 0.3) +
  geom_line(aes(color = pft_name)) +
  scale_x_date(date_labels = "%Y-%m") +
  labs(
    title = settings$info$notes,
    x = "Date",
    y = "NPP",
    fill = "PFT",
    color = "PFT",
    caption = "multi-ensemble means ± 95% CI"
  )

ggsave(file.path(outdir, "npp.png"))
