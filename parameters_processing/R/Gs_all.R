# Function to estimate stomatal parameters with 'plantecophys'
# Uses both ACi and AQ data across entire range of CO2 and PAR conditions

Gs_all <- function(fileID){# input is ID column from the experiments dataframe
  
  # Required packages
  library(ggplot2)
  library(plantecophys)
  library(dplyr)

  # Read in data
  fileNames <- dir("cleaned_data/", pattern = as.character(fileID), recursive = T)
  df <- data.frame()
  for(i in 1:length(fileNames)){
    # Read in csv
    temp <- read.csv(paste0("cleaned_data/", fileNames[i]))
    
    # Select relevant columns
    temp2 <- subset(temp, select = c(species, rep, obs, time, date, hhmmss, 
                                     CO2_s, Qin, A, gsw, VPDleaf, RHcham, Ca))
    
    # Combine
    df <- rbind.data.frame(df, temp2)
  }
  
  # Use 'plantecophys' to estimate stomatal parameters for Ball-Berry and Medlyn models
  #First: fit Medlyn et al. (2011) equation
  gsfit  <- fitBB(df, varnames= list(ALEAF="A", GS= "gsw", VPD="VPDleaf", Ca="Ca", RH="RHcham"), 
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
  if(dir.exists("outputs/stomatal/all") == F){
    dir.create("outputs/stomatal/all", recursive = TRUE)
  }
  loc <- paste0("outputs/stomatal/all/")
  

  # create vector of data for output file (site, species, g1, ci_low, ci_hig)
  out <- data.frame(ID = rep(fileID, 4),
                    rep = rep(NA, 4),
                    trait = c("g0M", "g1M", "g0BB", "g1BB"),
                    Value = c(g0M, g1M, g0BB, g1BB),
                    SE = c(g0M_se, g1M_se, g0BB_se, g1BB_se),
                    SD = rep(NA, 4),
                    Date.run = rep(as.Date(Sys.time()), 4))
  write.csv(out, file = paste0(loc, fileID, "_parameters_all.csv"), row.names = F)
  
  
  # Visualize across 2 replicates
  # create dataframe for plotting
  DF <- data.frame(gsw = rep(df$gsw, 2),
                   x = c(df$A*df$RHcham/df$Ca/100, #divide RH/100
                         df$A/(df$CO2_s*sqrt(df$VPDleaf))),
                   type = c(rep("BB", nrow(df)), rep("M", nrow(df))))
  params <- data.frame(type = c("BB", "M"),
                       slope = c(g1BB, g1M),
                       int = c(g0BB, g0M))
  
  # Medlyn model is not strictly linear, therefore no line shows up
  
  fig_stomatal <- ggplot()+
    geom_point(data = DF, aes(x = x, y = gsw))+
    geom_abline(data = params, aes(slope = slope, intercept = int))+
    facet_wrap(~type, ncol=2, scales = "free")+
    scale_y_continuous(expression(paste(g[sw])))+
    theme_bw()
  
  pdf(paste0(loc, "diagnostic/", fileID, "_stomatal_curves.pdf"), width = 6, height = 3)
  print(fig_stomatal)
  dev.off()
  
}
  
  

  