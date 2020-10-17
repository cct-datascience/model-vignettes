# Control script for the sentinel-detection parameter processing pipeline

#libraries
library(dplyr)
# Source the functions
source("R/C4_Collatz.R")
source("R/LRC.R")
source("R/Gs.R")

# Read in list of experiments
# Metadata describing Date (unique), Genotype, and Treatment
# A_Ci and A_Qin data are available
expDF <- read.csv("cleaned_data/experiments.csv",
                  colClasses = c("character", "numeric", rep("character",2), rep("numeric",2)))

# Check date of previous run
params <- read.csv("outputs/parameters_data.csv")
max(params$Date)

# Step 1: Run C4_Collatz.R model on ACi data
aci_ID <- expDF$ID[which(expDF$A_Ci == 1 # A_Ci data is present
                         & expDF$Date > max(params$Date)# experiment date is more recent than last estimation run date
                         )] 
for(i in 1:length(aci_ID)){
  C4_Collatz(fileID = aci_ID[i])
  print(paste0(aci_ID[i], " completed"))
}


# Step 2: Run LRC.R routine on AQ data
aq_ID <- expDF$ID[which(expDF$A_Qin == 1 # A_Qin data is present
                        & expDF$Date > max(params$Date)# experiment date is more recent than last estimation run date
                        )]
for(i in 1:length(aq_ID)){
  LRC(fileID = aq_ID[i])
  print(paste0(aq_ID[i], " completed"))
}

# Step 3: Run the Gs.R routine on subest of both ACi and AQ data
ID <- expDF$ID[which(expDF$Date > max(params$Date)# experiment date is more recent than last estimation run date
              )]
for(i in 1:length(ID)){
  Gs(fileID = ID[i])
  print(paste0(ID[i], " completed"))
}


# Step 4: Collate the parameters
aci <- list.files("outputs/ACi", pattern = "csv")
params <- data.frame()
for(i in 1:length(aci)){
  temp <- read.csv(paste0("outputs/ACi/", aci[i]),
                   colClasses = c(rep("character", 3), rep("numeric",3), "character"))
  params <- rbind.data.frame(params, temp)
}
aq <- list.files("outputs/AQ", pattern = "csv")
for(i in 1:length(aq)){
  temp <- read.csv(paste0("outputs/AQ/", aq[i]),
                   colClasses = c(rep("character", 3), rep("numeric",3), "character"))
  params <- rbind.data.frame(params, temp)
}

st <- list.files("outputs/stomatal", pattern = "csv")
for(i in 1:length(st)){
  temp <- read.csv(paste0("outputs/stomatal/", st[i]),
                   colClasses = c(rep("character", 3), rep("numeric",3), "character"))
  params <- rbind.data.frame(params, temp)
}

params2 <- left_join(params, expDF, by = "ID")

write.csv(params2, file = "outputs/parameters_data.csv", row.names = F)
