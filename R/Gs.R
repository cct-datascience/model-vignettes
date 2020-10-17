# Function to estimate stomatal parameters with 'plantecophys'
# Also produces estimates of A and gsw at standard conditions of PAR > 1200 umol/m^2/s and 390 ppm < CO2 > 410 ppm

Gs <- function(fileID){# input is ID column from the experiments dataframe
  
  # Required packages
  library(ggplot2)
  library(plantecophys)

  # Read in data
  aci <- read.csv(paste0("cleaned_data/ACi/A_Ci_curves_", fileID, ".csv"))
  aq <- read.csv(paste0("cleaned_data/AC/AQin_curves_", fileID, ".csv"))
  
  # Select standard conditions and combine
  aci <- subset(aci, CO2_s >= 390 & CO2_s <= 410 & gsw > 0)
  aq <- subset(aq, Qin >= 1200 & gsw > 0)
  
  df <- rbind.data.frame(aci, aq)
  
  # Use 'plantecophys' to estimate stomatal parameters for Ball-Berry and Medlyn models
  #First: fit Medlyn et al. (2011) equation
  gsfit  <- fitBB(df, varnames= list(ALEAF="A", GS= "gsw", VPD="VPDleaf", Ca="CO2_s", RH="RHcham"), 
                  gsmodel=c("BBOpti"), fitg0 = T) 
  g1M     <- summary(gsfit$fit)$parameters[1]				# save g1 from fitted model
  g0M     <- summary(gsfit$fit)$parameters[2]	      # save g0 from fitted model
  g1M_se  <- summary(gsfit$fit)$parameters[1,2]     # save standard error of g1
  g0M_se  <- summary(gsfit$fit)$parameters[2,2]     # save standard error of g0
  
  #Second: fit the Ball-Berry (1987) model    
  gsfit2  <- fitBB(df, varnames= list(ALEAF="A", GS= "gsw", VPD="VPDleaf", Ca="Ca", RH="RHcham"), 
                   gsmodel=c("BallBerry"), fitg0 = T) 
  g1BB     <- summary(gsfit2$fit)$parameters[1]				
  g0BB     <- summary(gsfit2$fit)$parameters[2]	
  g1BB_se  <- summary(gsfit2$fit)$parameters[1,2] 
  g0BB_se  <- summary(gsfit2$fit)$parameters[2,2]    
  
  # Location of output files
  loc <- paste0("outputs/stomatal/")
  
  # create vector of data for output file (site, species, g1, ci_low, ci_hig)
  out <- data.frame(ID = rep(fileID, 4),
                    rep = rep(NA, 4),
                    trait = c("g0M", "g1M", "g0BB", "g1BB"),
                    Value = c(g0M, g1M, g0BB, g1BB),
                    SE = c(g0M_se, g1M_se, g0BB_se, g1BB_se),
                    SD = rep(NA, 4),
                    Date.run = rep(as.Date(Sys.time()), 6))
  write.csv(out, file = paste0(loc, fileID, "_parameters.csv"), row.names = F)
  
  
  # Visualize across 2 replicates
  # create dataframe for plotting
  DF <- data.frame(gsw = rep(df$gsw, 2),
                   x = c(df$A*df$RHcham/df$Ca,
                         df$A/(df$Ca*sqrt(df$VPDleaf))),
                   type = c(rep("BB", nrow(df)), rep("M", nrow(df))))
  
  fig_stomatal <- ggplot(DF, aes(x=x, y=gsw))+
    geom_point(aes(col = rep))+
    facet_wrap(~type, ncol=2)+
    theme_bw()
  
  pdf(paste0(loc, "diagnostic/", fileID, "_stomatal_curves.pdf"))
  print(fig_stomatal)
  dev.off()

  
}
  
  

  