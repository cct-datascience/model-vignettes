library(dplyr)
library(tidyr)
library(ggplot2)

days <- c(1:365)
timescale <- data.table::data.table(day = rep(days, each = 24), hour = 0:23)
timescale <- timescale[1:1440, ]

load("/data/tests/ed2_SR_2004_run/ensemble.ts.NOENSEMBLEID.NPP.2004.2004.Rdata")
daily_npp <- data.frame(timescale, t(ensemble.ts[["NPP"]])) %>%
  gather(ensemble, npp, X1:X3) %>%
  filter(hour == 23) %>%
  group_by(day) %>%
  summarise(mean = mean(npp, na.rm = TRUE),
            median = median(npp, na.rm = TRUE),
            sd = sd(npp, na.rm = TRUE),
            lcl_50 = quantile(npp, probs = c(0.25), na.rm = TRUE),
            ucl_50 = quantile(npp, probs = c(0.75), na.rm = TRUE),
            lcl_95 = quantile(npp, probs = c(0.025), na.rm = TRUE),
            ucl_95 = quantile(npp, probs = c(0.975), na.rm = TRUE)) %>% 
  mutate(median = udunits2::ud.convert(median, "kg/m2/s", "kg/m2/yr"), 
         lcl_50 = udunits2::ud.convert(lcl_50, "kg/m2/s", "kg/m2/yr"), 
         ucl_50 = udunits2::ud.convert(ucl_50, "kg/m2/s", "kg/m2/yr"), 
         lcl_95 = udunits2::ud.convert(lcl_95, "kg/m2/s", "kg/m2/yr"), 
         ucl_95 = udunits2::ud.convert(ucl_95, "kg/m2/s", "kg/m2/yr"))

npp_timeseries <- ggplot(data = daily_npp) +
  geom_line(aes(day, y = median)) +
  geom_ribbon(aes(day, ymin = lcl_95, ymax = ucl_95), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl_50, ymax = ucl_50), alpha = 0.1) +
  #xlim(c(0, 100)) +
  #ylim(c(0, 5)) +
  xlab("Day") +
  ylab("NPP (kg/m2/yr)") +
  theme_classic()
