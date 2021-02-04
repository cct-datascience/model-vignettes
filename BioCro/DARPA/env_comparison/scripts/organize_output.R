# ----------------------------------------------------------------------
# Load required libraries
# ----------------------------------------------------------------------
library(readxl)
library(udunits2)
library(dplyr)
library(tidyr)

# Summarize (mn, md, sd, CI_50, and CI_95) across ensembles for all 3 treatments and 2 variables

treatments <- c("ch", "gh", "out")
variables <- c("TotLivBiom", "TVeg")

# Functions for conversion of biomass and transpiration units
convert_units <- function(x, variable) {
  if (variable == "TotLivBiom") {
    y = x / 0.4 # undo  biomass to C conversion in PEcAn
    # Still have to convert from Mg/ha to kg/m2
    return(ud.convert(y, "Mg/ha", "kg/m2"))
  } else if (variable == "TVeg") {
    return(ud.convert(x, "kg/m2/s", "kg/m2/h"))
  }
}

for(trt in treatments){
  
  # Load in daily summary of median biocro output, to obtain correct timestamps
  load(paste0("/data/output/pecan_runs/env_comp_results/", trt, 
              "/out/SA-median/biocro_output.RData"))
  timescale <- data.frame(day = rep(biocro_result$doy, each = 24), hour = 0:23)
  rm(biocro_result)
  
  for(v in variables){
    
    # Load in wide format of ensemble outputs
    load(paste0("/data/output/pecan_runs/env_comp_results/", trt, 
                "/ensemble.ts.NOENSEMBLEID.", v, ".2020.2020.Rdata"))
    
    # Rearrange to long format and summarize across ensembles
    if (v == "TotLivBiom") { # Take midday values only
      daily <- data.frame(timescale, t(ensemble.ts[[v]])) %>% 
        pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                     names_prefix = "X", values_to = "output") %>% 
        mutate(output = convert_units(output, variable = v)) %>% 
        filter(hour == 12) %>% 
        group_by(day) %>% 
        summarise(mean = mean(output, na.rm = TRUE), 
                  median = median(output, na.rm = TRUE), 
                  sd = sd(output, na.rm = TRUE), 
                  lcl_50 = quantile(output, probs = c(0.25), na.rm = TRUE), 
                  ucl_50 = quantile(output, probs = c(0.75), na.rm = TRUE),
                  lcl_95 = quantile(output, probs = c(0.025), na.rm = TRUE), 
                  ucl_95 = quantile(output, probs = c(0.975), na.rm = TRUE))
    } else if (v == "TVeg") { # Take daily sums first
      daily <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
        pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                     names_prefix = "X", values_to = "output") %>%
        mutate(output = convert_units(output, variable = v),
               ensemble = as.numeric(ensemble)) %>%
        group_by(day, ensemble) %>%
        summarise(output = sum(output)) %>%
        group_by(day) %>%
        summarise(mean = mean(output, na.rm = TRUE), 
                  median = median(output, na.rm = TRUE), 
                  sd = sd(output, na.rm = TRUE), 
                  lcl_50 = quantile(output, probs = c(0.25), na.rm = TRUE), 
                  ucl_50 = quantile(output, probs = c(0.75), na.rm = TRUE),
                  lcl_95 = quantile(output, probs = c(0.025), na.rm = TRUE), 
                  ucl_95 = quantile(output, probs = c(0.975), na.rm = TRUE))
    }
    
    write.csv(daily, 
              paste0("/data/output/pecan_runs/env_comp_results/", trt, 
                     "/ensemble_ts_summary_", v, ".csv"),
              row.names = F)
    rm(ensemble.ts)
  }
}


# Summarize pair-wise differences across treatments, by ensemble

for(v in variables){
  
  # Load in daily summary of median biocro output, to obtain correct timestamps
  load(paste0("/data/output/pecan_runs/env_comp_results/ch/out/SA-median/biocro_output.RData"))
  timescale <- data.frame(day = rep(biocro_result$doy, each = 24), hour = 0:23)
  rm(biocro_result)
  
  # Load all 3 treatments, summarize to daily depending on variable
  load(paste0("/data/output/pecan_runs/env_comp_results/ch/ensemble.ts.NOENSEMBLEID.", 
              v, ".2020.2020.Rdata"))
  if (v == "TotLivBiom") {
    ch <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
      pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                   names_prefix = "X", values_to = "output") %>% 
      mutate(output = convert_units(output, variable = v),
             ensemble = as.numeric(ensemble)) %>%
      filter(hour == 12) %>% 
      group_by(day, ensemble)%>%
      select(-hour)
  } else if (v == "TVeg") {
    ch <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
      pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                   names_prefix = "X", values_to = "output") %>%
      mutate(output = convert_units(output, variable = v),
             ensemble = as.numeric(ensemble)) %>%
      group_by(day, ensemble) %>%
      summarise(output = sum(output))
  }
  rm(ensemble.ts)
  
  load(paste0("/data/output/pecan_runs/env_comp_results/gh/ensemble.ts.NOENSEMBLEID.", 
              v, ".2020.2020.Rdata"))
  if (v == "TotLivBiom") {
    gh <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
      pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                   names_prefix = "X", values_to = "output") %>% 
      mutate(output = convert_units(output, variable = v),
             ensemble = as.numeric(ensemble)) %>%
      filter(hour == 12) %>% 
      group_by(day, ensemble)%>%
      select(-hour)
  } else if (v == "TVeg") {
    gh <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
      pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                   names_prefix = "X", values_to = "output") %>%
      mutate(output = convert_units(output, variable = v),
             ensemble = as.numeric(ensemble)) %>%
      group_by(day, ensemble) %>%
      summarise(output = sum(output))
  }
  
  load(paste0("/data/output/pecan_runs/env_comp_results/out/ensemble.ts.NOENSEMBLEID.", 
              v, ".2020.2020.Rdata"))
  if (v == "TotLivBiom") {
    out <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
      pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                   names_prefix = "X", values_to = "output") %>% 
      mutate(output = convert_units(output, variable = v),
             ensemble = as.numeric(ensemble)) %>%
      filter(hour == 12) %>% 
      group_by(day, ensemble) %>%
      select(-hour)
  } else if (v == "TVeg") {
    out <- data.frame(timescale, t(ensemble.ts[[v]])) %>%
      pivot_longer(cols = starts_with("X"), names_to = "ensemble",
                   names_prefix = "X", values_to = "output") %>%
      mutate(output = convert_units(output, variable = v),
             ensemble = as.numeric(ensemble)) %>%
      group_by(day, ensemble) %>%
      summarise(output = sum(output))
  }
  rm(ensemble.ts)
  
  # Combine to single df and calculate differences across treatments
  all <- bind_cols(ch, gh["output"], out["output"]) %>%
    rename(ch = 3,
           gh = 4,
           out = 5) %>%
    # One-sided t-tests predictions
    mutate(gh_ch = gh - ch,
           out_ch = out - ch,
           gh_out = gh - out)
  
  # Summarize whether across ensembles, the differences are significant each day
  diff_stat <- all %>%
    select(-gh, -ch, -out) %>%
    group_by(day) %>%
    # Reports the 2.5, 5, 50, 95, and 97.5th percentile of each set of differences
    summarize(gh_ch = quantile(gh_ch, probs = c(0.025, 0.05, 0.5, 0.95, 0.975)),
              out_ch = quantile(out_ch, probs = c(0.025, 0.05, 0.5, 0.95, 0.975)),
              gh_out = quantile(gh_out, probs = c(0.025, 0.05, 0.5, 0.95, 0.975))) %>%
    mutate(percentile = c("025", "050", "500", "950", "975")) %>%
    relocate(day, percentile)
  
  write.csv(diff_stat, 
            paste0("/data/output/pecan_runs/env_comp_results/comparison_diff_", v, ".csv"),
            row.names = F)
}
