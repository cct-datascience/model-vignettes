controlchamber_weather <- data.frame(year = rep(2019, 8760), 
                                     doy = rep(1:365, each = 24), 
                                     hour = rep(seq(0, 23), 365), 
                                     SolarR = rep(c(rep(0, each = 8), rep(250, each = 12), rep(0, each = 4)), times = 365),
                                     Temp = rep(c(rep(22, each = 8), rep(31, each = 12), rep(22, each = 4)), times = 365),
                                     RH = rep(55.5 / 100,  times = 365 * 24), 
                                     WS = rep(0, times = 365 * 24), 
                                     precip = rep(c(0.000462963, rep(0, 23)), 365))

write.csv(controlchamber_weather, "temp_exps_inputs1/danforth-control-chamber.2019.csv", 
          row.names = FALSE)
