
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


#TODO: maybe move extract and convert code to workflow.R since that's where it's
#supposed to happen anyways

# Extract data ------------------------------------------------------------

## Ideally this should be done with the .nc files output by the workflow.R
## script.  However, these .nc files have most variables aggregated to combine
## all PFTs making them not super useful for our case.  The .h5 files have
## variables split up by PFT, but none of the weighting or conversions are done
## (i.e. outputs may be in units **per plant**)

## Workaround with .h5 files:

#TODO: not sure which level parallelization happens at when there are only two
#cores. Might be better for the inner "loop" to be parallelized than the outer
#one.

with_progress({
  #sets up progress bar
  p <- progressor(steps = length(ensembles))
  all_npp <- 
    future_map_dfr(ensembles, ~{
      #with a single ensemble, `.x`:
      
      p() #increment progress bar
      
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
        
        #NPP may need to be weighted by plant density. Some ED2 outputs
        #are per plant. Relevant code at line 1023 of model2netcdf.ED2
        tibble(
          date = date,
          pft = as.character(ncvar_get(x, "PFT")), #PFTs of each cohort
          plant_dens = ncvar_get(x, "NPLANT"), #plant density
          patch_area = rep(ncvar_get(x, "AREA"), ncvar_get(x, "PACO_N")), #patch area, repped out to one entry per cohort
          npp = ncvar_get(x, "MMEAN_NPP_CO"), # monthly mean NPP by cohort
          nplant = plant_dens * patch_area
        ) %>% 
          group_by(date, pft) %>% 
          #TODO: test this with output that has multiple cohorts per PFT
          # sum over cohorts if there are multiple cohorts per PFT
          summarise(
            across(c(plant_dens, patch_area, npp, nplant), sum),
            .groups = "drop"
          ) %>%
          #TODO: maybe this has to happen before summing cohorts?
          # mean NPP weighted by nplant
          mutate(
            sum_nplant = sum(nplant),
            npp_pft = npp * nplant / sum(nplant)
          )
          
      }) %>% 
        mutate(ensemble = basename(.x))
    })
})

# save converted data
write_csv(all_npp, file.path(settings$outdir, "npp_out.csv"))


# Tidy data ---------------------------------------------------------------

#get pft names from settings
pft_mappings <- 
  tibble(pft = map_chr(settings$pfts, "ed2_pft_number"),
         pft_name = map_chr(settings$pfts,"name"))

all_npp <- 
  all_npp %>% 
  #set units for output
  mutate(npp_pft = set_units(npp_pft, "kg/m^2/yr")) %>% 
  #TODO units are actually "kgC/pl/yr" in the .h5 file attributes.  I'm guessing
  #     that's kg carbon/ polygon/yr.  Not sure if a polygon is 1 m^2 always 
  #join to pft name
  right_join(pft_mappings, by = "pft")

# Summarize data ----------------------------------------------------------

#How many ensembles made it all the way?

all_npp %>%
  group_by(ensemble, pft_name) %>% 
  summarize(end = max(date)) %>% 
  ggplot(aes(end)) + geom_histogram() + facet_wrap(~pft_name)
ggsave(file.path(outdir, "end_date_hist.png"))

npp_summary <- 
  all_npp %>% 
  group_by(date, pft_name) %>% 
  summarize(npp_mean = mean(npp_pft, na.rm = TRUE),
            npp_sd = sd(npp_pft, na.rm = TRUE),
            lcl_95 = quantile(npp_pft, 0.025, na.rm = TRUE),
            ucl_95 = quantile(npp_pft, 0.975, na.rm = TRUE))

# Plot data ---------------------------------------------------------------

# Ensembles.
# You can see really well where some ensembles error and just end here
ggplot(all_npp, aes(x = date, y = npp_pft, group = ensemble)) +
  geom_line(alpha = 0.4) +
  facet_wrap(~pft_name)
ggsave(file.path(outdir, "npp_ensembles.png"))

# Multi-ensemble mean ± CI
ggplot(npp_summary, aes(x = date, y = npp_mean)) +
  geom_ribbon(aes(ymin = lcl_95, ymax = ucl_95, fill = pft_name), alpha = 0.3) +
  geom_line(aes(color = pft_name)) +
  scale_x_date(date_breaks = "year", date_labels = "%Y") +
  scale_fill_viridis_d(option = "D", end = 0.8, aesthetics = c("color", "fill")) +
  labs(
    title = settings$info$notes,
    x = "Date",
    y = "NPP",
    fill = "PFT",
    color = "PFT",
    caption = "multi-ensemble means ± 95% CI"
  ) + 
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(outdir, "npp_mean.png"))
