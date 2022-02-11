library(dplyr)
library(tidyr)
library(ggplot2)

days <- c(1:365)
timescale <- data.table::data.table(day = rep(days, each = 24), hour = 0:23)
timescale <- timescale[1:6600, ]

load("/data/tests/ed2_AK_recent_100ens_sa/ensemble.ts.NOENSEMBLEID.NPP.2019.2020.Rdata")
daily_npp <- data.frame(timescale, t(ensemble.ts[["NPP"]])) %>%
  gather(ensemble, npp, X1:X100) %>%
  filter(!is.na(npp), 
         hour == 23) %>%
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
         ucl_95 = udunits2::ud.convert(ucl_95, "kg/m2/s", "kg/m2/yr"), 
         date = as.Date(day, origin = "2019-03-31"))

npp_timeseries <- ggplot(data = daily_npp) +
  geom_line(aes(date, y = median)) +
  geom_ribbon(aes(date, ymin = lcl_95, ymax = ucl_95), alpha = 0.1) +
  geom_ribbon(aes(date, ymin = lcl_50, ymax = ucl_50), alpha = 0.1) +
  xlab("Date") +
  ylab("NPP (kg/m2/yr)") +
  theme_classic() +
  scale_x_date(date_breaks = "3 months", date_labels = "%b %Y")
