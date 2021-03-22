### Generate weather for 2019 for 80 days

# set number of days
n = 80

rn_weather <- data.frame(year = rep(2019, n*24),
                         doy = rep(1:n, each = 24),
                         hour = rep(seq(0, 23), n),
                         SolarR = rep(c(rep(0, each = 8), rep(250, each = 12), rep(0, each = 4)), times = n),
                         Temp = rep(c(rep(22, each = 8), rep(31, each = 12), rep(22, each = 4)), times = n),
                         RH = rep(55.5 / 100,  times = n * 24),
                         WS = rep(0, times = n * 24),
                         precip = rep(c(0.000462963, rep(0, 23)), n))

hn_weather <- data.frame(year = rep(2019, n*24),
                         doy = rep(1:n, each = 24),
                         hour = rep(seq(0, 23), n),
                         SolarR = rep(c(rep(0, each = 8), rep(250, each = 12), rep(0, each = 4)), times = n),
                         Temp = rep(31, times = n * 24),
                         RH = rep(55.5 / 100,  times = n * 24),
                         WS = rep(0, times = n * 24),
                         precip = rep(c(0.000462963, rep(0, 23)), n))

write.csv(rn_weather, "../inputs/weather.rn.2019.csv", 
          row.names = FALSE)

write.csv(hn_weather, "../inputs/weather.hn.2019.csv", 
          row.names = FALSE)
