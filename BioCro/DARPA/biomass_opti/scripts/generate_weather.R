# Generate chamber weather data based on experiment 2, 31/31 treatment. 

ch_weather <- data.frame(year = rep(2019, 8760), 
                          doy = rep(1:365, each = 24), 
                          hour = rep(seq(0, 23), 365), 
                          solarR = rep(c(rep(0, each = 8), rep(430, each = 12), rep(0, each = 4)), times = 365),
                          Temp = rep(31, times = 365 * 24), 
                          RH = rep(55.5 / 100,  times = 365 * 24), 
                          WS = rep(0, times = 365 * 24), 
                          precip = rep(c(0.000462963, rep(0, 23)), 365))

write.csv(ch_weather, "../inputs/ch_weather.csv", row.names = FALSE)
