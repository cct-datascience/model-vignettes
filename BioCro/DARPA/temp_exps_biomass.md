How to Reproduce BioCro Results for Night Time Temperature Experiments
================
Kristina Riemer, University of Arizona

For these experiments, **Setaria** were grown under two experimental treatments. The control plants were at 31C during the day and 22C at night, while high night time temp treatment was 31C at all times.

Biomass for these two treatments are estimated using BioCro version 0.95.

Section 1: BioCro Run for Control Parameters & Weather
======================================================

In `model-vignettes/BioCro/DARPA/`, there is a folder called `temp_exps_inputs1`.

Within that folder is a PEcAn Settings file called `temp.exps1.xml`. To learn more about the pecan settings file, see the [PEcAn Documentation](https://pecanproject.github.io/pecan-documentation/master/pecanXML.html#). There is also the R script that runs PEcAn and BioCro called `workflow.R`.

The Setaria constants are in the file `setaria.constants.xml`. This has biomass coefficients and starting biomass values. The same will be used for all runs. These parameters are defined in the `BioCro::BioGro` function documentation.

Generate control weather data file `danforth-control-chamber.2019.csv` with the R script `generate_control_weather.R` as shown below.

``` r
source("temp_exps_inputs1/generate_control_weather.R")
```

Then run the model for the treatment control.

``` bash
if [ ! -f temp_exps_results/temp_exps_results1/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata ]
then
  temp_exps_inputs1/workflow.R --settings temp_exps_inputs1/temp.exps1.xml
else
  echo "run 1 done"
fi
```

    ## run 1 done

``` r
if(!file.exists("temp_exps_results/temp_exps_results1/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")){
  dir.create("temp_exps_results")
  file.copy("temp_exps_results1/", "temp_exps_results/", recursive = TRUE)
  unlink("temp_exps_results1/", recursive = TRUE)
  file.copy("~/temp_exps_results1/dbfiles/", "temp_exps_results/temp_exps_results1/", recursive = TRUE)
  unlink("~/temp_exps_results1/", recursive = TRUE)
}
```

Plot results against measured biomass. Control data are downloaded from [the project's private data repo](https://github.com/cct-datascience/model-vignettes-data) and should be in `model-vignettes-data` in your home directory. The following code cleans up that biomass data, calculating number of days between treatment starting and biomass harvest, and converts biomass units from milligrams to megagrams per hectare (each plant grown in pot with 103 cm2 area).

This also pulls in and cleans up the biomass data estimated from BioCro, then plots biomass measurements against this.

``` r
# Libraries
library(readxl)
library(udunits2)
```

    ## udunits system database read

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(data.table)
```

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

``` r
library(tidyr)
library(ggplot2)

# Clean up biomass data
data_path <- "../../../model-vignettes-data/manual-measurements-Darpa_setaria_chambers_experiments.xlsx"
sheets_names <- excel_sheets(data_path)
area_cm2 <- 103
area_ha <- ud.convert(area_cm2, "cm2", "ha")

control_biomass <- read_excel(data_path, sheets_names[6]) %>% 
  rename(temperature...C..day.night = 6, 
         biomass.harvested = 11, 
         treatment.started = 9) %>% 
  filter(genotype == "ME034V-1", temperature...C..day.night == "31/22", 
         sample_for == "biomass") %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomass.harvested), format = "%Y-%m-%d") - 
                                   as.integer(as.Date(as.character(treatment.started), format = "%Y-%m-%d"))), 
         total_biomass_mg = panicle_DW_mg + stem_DW_mg + leaf_DW_mg + roots_DW_mg, 
         total_biomass_Mgha = ud.convert(total_biomass_mg, "mg", "Mg") / area_ha) %>% 
  filter(!is.na(total_biomass_Mgha))
write.csv(control_biomass, "temp_exps_inputs1/control_biomass_meas.csv")

# Clean up biomass estimates
load('temp_exps_results/temp_exps_results1/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results1/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl = quantile(biomass, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl = sum(lcl), 
            ucl = sum(ucl))
write.csv(daily_biomass, "temp_exps_inputs1/biomass_ests1.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
sd_scale <- 5
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = mean)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl, ymax = ucl), alpha = 0.1) +
  #geom_point(data = control_biomass, aes(x = days_grown, y = total_biomass_Mgha)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-4-1.png)

Section 2: BioCro Run for Control Parameters & High Night Temperature Weather
=============================================================================

Similar to section 1, you will use the following files in the `temp_exps_inputs2` folder for this run: `temp.exps2.xml`, `workflow.R`, `setaria.constants.xml`.

Generate high night temp weather data file `danforth-highnight-chamber.2019.csv` with the R script `generate_highnight_weather.R` as shown below.

``` r
source("temp_exps_inputs2/generate_highnight_weather.R")
```

Then run the model for this experimental setup.

``` bash
if [ ! -f temp_exps_results/temp_exps_results2/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata ]
then
  temp_exps_inputs2/workflow.R --settings temp_exps_inputs2/temp.exps2.xml
else
  echo "run 2 done"
fi
```

    ## run 2 done

``` r
if(!file.exists("temp_exps_results/temp_exps_results2/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")){
  file.copy("temp_exps_results2/", "temp_exps_results/", recursive = TRUE)
  unlink("temp_exps_results2/", recursive = TRUE)
  file.copy("~/temp_exps_results2/dbfiles/", "temp_exps_results/temp_exps_results2/", recursive = TRUE)
  unlink("~/temp_exps_results2/", recursive = TRUE)
}
```

Plot biomass results. This pulls in and cleans up the biomass data estimated from BioCro, then plots the data.

``` r
# Clean up biomass estimates
load('temp_exps_results/temp_exps_results2/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results2/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl = quantile(biomass, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl = sum(lcl), 
            ucl = sum(ucl))
write.csv(daily_biomass, "temp_exps_inputs2/biomass_ests2.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
sd_scale <- 5
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = mean)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl, ymax = ucl), alpha = 0.1) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-8-1.png)

Section 3: BioCro Run for High Night Temperature Parameters & Weather
=====================================================================

Similar to section 1, you will use the following files in the `temp_exps_inputs3` folder for this run: `temp.exps3.xml`, `workflow.R`, `setaria.constants.xml`.

Generate high night temp weather data file `danforth-highnight-chamber.2019.csv` with the R script `generate_highnight_weather.R` as shown below.

``` r
source("temp_exps_inputs3/generate_highnight_weather.R")
```

Then run the model for the high night temperature treatment.

``` bash
if [ ! -f temp_exps_results/temp_exps_results3/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata ]
then
  temp_exps_inputs3/workflow.R --settings temp_exps_inputs3/temp.exps3.xml
else
  echo "run 3 done"
fi
```

    ## run 3 done

``` r
if(!file.exists("temp_exps_results/temp_exps_results3/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")){
  file.copy("temp_exps_results3/", "temp_exps_results/", recursive = TRUE)
  unlink("temp_exps_results3/", recursive = TRUE)
  file.copy("~/temp_exps_results3/dbfiles/", "temp_exps_results/temp_exps_results3/", recursive = TRUE)
  unlink("~/temp_exps_results3/", recursive = TRUE)
}
```

Plot biomass results. Create a script called `plot_results3.R`, which will contain following code. This pulls in and cleans up the biomass data estimated from BioCro, then plots the data.

``` r
# Clean up biomass data
data_path <- "../../../model-vignettes-data/manual-measurements-Darpa_setaria_chambers_experiments.xlsx"
sheets_names <- excel_sheets(data_path)
area_cm2 <- 103
area_ha <- ud.convert(area_cm2, "cm2", "ha")

highnight_biomass <- read_excel(data_path, sheets_names[10]) %>% 
      rename(temperature...C..day.night = 6, 
         biomass.harvested = 12, 
         panicles.DW..mg. = 21, 
         stemDW.mg. = 18,
         leaf.DW.mg. = 19, 
         roots.DW..mg. = 20) %>% 
  filter(genotype == "ME034V-1", temperature...C..day.night == 31, 
         treatment == "control", sample_for == "biomass") %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomass.harvested), format = "%Y-%m-%d") - 
                                   as.integer(as.Date(as.character(temperature_treatment_started), 
                                                      format = "%Y-%m-%d"))), 
         total_biomass_mg = panicles.DW..mg. + stemDW.mg. + leaf.DW.mg. + roots.DW..mg., 
         total_biomass_Mgha = ud.convert(total_biomass_mg, "mg", "Mg") / area_ha) %>% 
  filter(!is.na(total_biomass_Mgha))
write.csv(highnight_biomass, "temp_exps_inputs3/highnight_biomass_meas.csv")

# Clean up biomass estimates
load('temp_exps_results/temp_exps_results3/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results3/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl = quantile(biomass, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl = sum(lcl), 
            ucl = sum(ucl))
write.csv(daily_biomass, "temp_exps_inputs3/biomass_ests3.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
sd_scale <- 5
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = mean)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl, ymax = ucl), alpha = 0.1) +
  #geom_point(data = highnight_biomass, aes(x = days_grown, y = total_biomass_Mgha)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-12-1.png)

Section 4: Plot Three Runs
==========================

Code to plot the biomass estimates from the first two runs together, along with the control data.

``` r
# Read in and combine biomass measurements data
biomass_meas_control <- read.csv("temp_exps_inputs1/control_biomass_meas.csv") %>% 
  mutate(txt = "control") %>% 
  select(days_grown, total_biomass_Mgha, txt)
biomass_meas_highnight <- read.csv("temp_exps_inputs3/highnight_biomass_meas.csv") %>% 
  mutate(txt = "highnight") %>% 
  select(days_grown, total_biomass_Mgha, txt)

biomass_meas <- bind_rows(biomass_meas_control, biomass_meas_highnight)

# Read in and combine biomass estimates data
biomass_ests1 <- read.csv("temp_exps_inputs1/biomass_ests1.csv") %>% 
  mutate(run = 1)
biomass_ests2 <- read.csv("temp_exps_inputs2/biomass_ests2.csv") %>% 
  mutate(run = 2)
biomass_ests3 <- read.csv("temp_exps_inputs3/biomass_ests3.csv") %>% 
  mutate(run = 3)

biomass_ests <- bind_rows(biomass_ests1, biomass_ests2, biomass_ests3) %>% 
  mutate(run = as.factor(run))

# Plot measured biomass against biomass estimates
sd_scale <- 5

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  scale_color_manual(values=c("red", "black", "blue")) +
  xlim(x = c(0, 60)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

    ## Warning: Removed 912 rows containing missing values (geom_path).

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-13-1.png)

``` r
ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd, fill = run), alpha = 0.1) +
  scale_color_manual(values=c("red", "black", "blue", "red", "black", "blue")) +
  xlim(x = c(0, 60)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

    ## Warning: Removed 912 rows containing missing values (geom_path).

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-13-2.png)

``` r
ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  geom_point(data = biomass_meas, aes(x = days_grown, y = total_biomass_Mgha, color = txt)) +
  scale_color_manual(values=c("red", "black", "blue", "red", "blue")) +
  xlim(x = c(0, 60)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

    ## Warning: Removed 912 rows containing missing values (geom_path).

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-13-3.png)

Figure for comparing sensitivity analysis and variance decomposition results for all three runs.

``` r
sa_dfs <- data.frame()
for(run in 1:3){
  load(paste0("temp_exps_results/temp_exps_results", run, "/sensitivity.results.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata"))
  sa_df1 <- sensitivity.results[["SetariaWT_ME034"]]$variance.decomposition.output
  sa_df2 <- data.frame(trait = names(sa_df1$coef.vars), 
                             data.frame(sa_df1))
  sa_df3 <- sa_df2 %>% 
    mutate(trait.labels = factor(as.character(PEcAn.utils::trait.lookup(trait)$figid)), 
         
           units = PEcAn.utils::trait.lookup(trait)$units, 
           coef.vars = coef.vars * 100, 
           sd = sqrt(variances), 
           run = run)
  rm(sensitivity.results)
  sa_dfs <- bind_rows(sa_dfs, sa_df3)
}
sa_dfs$run <- as.factor(sa_dfs$run)

fontsize = list(title = 18, axis = 14)
theme_set(theme_minimal() + 
            theme(axis.text.x = 
                    element_text(
                      size = fontsize$axis, 
                                 vjust = -1), 
                  axis.text.y = element_blank(),
                  axis.ticks = element_blank(), 
                  axis.line = element_blank(), 
                  axis.title.x = element_blank(), 
                  axis.title.y = element_blank(), 
                  panel.grid.minor = element_blank(), 
                  panel.border = element_blank()))

cv <- ggplot(data = sa_dfs) +
  geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars, color = run), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("CV %") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(axis.text.y = element_text(color = 'black', hjust = 1, size = fontsize$axis))

el <- ggplot(data = sa_dfs) +
  geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities, color = run), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Elasticity") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme(plot.title = element_text(hjust = 0.5))

vd <- ggplot(data = sa_dfs) +
  geom_pointrange(aes(x = trait.labels, y = sd, ymin = 0, ymax = sd, color = run), alpha = 0.5, size = 1.25, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Variance Explained (SD Units)") +
  geom_hline(aes(yintercept = 0), size = 0.1)

gridExtra::grid.arrange(cv, el, vd, ncol = 3)
```

    ## Warning: position_dodge requires non-overlapping x intervals

    ## Warning: position_dodge requires non-overlapping x intervals

    ## Warning: position_dodge requires non-overlapping x intervals

![](temp_exps_biomass_files/figure-markdown_github/unnamed-chunk-14-1.png)
