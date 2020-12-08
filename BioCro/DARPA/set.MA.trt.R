## Function that creates a link table between treatments and their RE indices 
## And produces a list of mcmc.list objects for only the treatment-level posteriors
## Target site/treatment is re-labeled "beta.o" so additional PEcAn functions will work 


set.MA.trt <- function(settings){
  
  library(coda)
  
  #load jagged.data and trait.mcmc
  load(paste0(settings$outdir, "pft/SetariaWT_ME034/jagged.data.Rdata"))
  load(paste0(settings$outdir, "pft/SetariaWT_ME034/trait.mcmc.Rdata"))

  #convert jagged.data into match table, only return traits for which there is an associated mcmc output
  trt.match <- lapply(jagged.data, collapse)[names(trait.mcmc)]
  
  #save trt.match
  save(trt.match, file = paste0(settings$outdir, "pft/SetariaWT_ME034/trt.match.Rdata"))
  
  #save existing trait.mcmc
  save(trait.mcmc, file = paste0(settings$outdir, "pft/SetariaWT_ME034/trait.mcmc.original.Rdata"))
  
  #create new trait.mcmc of combined random effects
  new.trait.mcmc <- mapply(FUN = RE.combine, mc = trait.mcmc, trt = trt.match, 
                           SIMPLIFY = F)
  
  #identify target site and treatment
  target.site <- settings$run$site$id
  target.trt <- settings$meta.analysis$treatment

  #label target site/treatment "beta.o"
  final.trait.mcmc <- mapply(FUN = rename.cols, trait.mcmc = new.trait.mcmc, trt = trt.match,
                             MoreArgs = list(target.site = target.site, target.trt = target.trt),
                             SIMPLIFY = F)
  
  #rename as trait.mcmc and save as "trait.mcmc.Rdata"
  trait.mcmc <- final.trait.mcmc
  save(trait.mcmc, file = paste0(settings$outdir, "pft/SetariaWT_ME034/trait.mcmc.Rdata"))
}

#Returns unique combination of site, trt, and ghs for matching purposes
collapse <- function(jagged){
  match <- unique(jagged[,c("site", "trt", "ghs", 
                          "site_id", "treatment_id", "greenhouse", 
                          "trt_name", "trt_num")])
  colnames(match)[colnames(match) %in% c("trt", "trt_num")] <- c("trt_control", "trt")
  row.names(match) <- NULL
  return(match)
}


#Combines correct columns of RE for each treatment
RE.combine <- function(mc, trt){
  #create table of relevant RE for each treatment (row)
  trt <- trt[, c("ghs", "site", "trt")]
  col_ind <- matrix(NA, nrow = nrow(trt), ncol = ncol(trt))
  cnames <- colnames(mc[[1]])
  for(i in 1:nrow(trt)){
    for(j in 1:ncol(trt)){
      col_ind[i,j] <- if(length(which(cnames == paste0("beta.", colnames(trt)[j], "[", trt[i,j], "]"))) == 1){
        which(cnames == paste0("beta.", colnames(trt)[j], "[", trt[i,j], "]"))
      } else {
          NA
        }
    }
  }
  col_ind <- cbind(col_ind, rep(which(cnames == "beta.o"), nrow(col_ind)))
  
  chain <- list(mcmc(matrix(NA, nrow = nrow(mc[[1]]), ncol = nrow(trt))))
  out <- rep(chain, length(mc))
  for(c in 1:length(mc)){
    for(t in 1:nrow(trt)){ # number of treatments
      out[[c]][,t] <- rowSums(mc[[c]][ ,col_ind[t,]], na.rm = T)
    }
  }
  return(mcmc.list(out))
}

#Renames target treatment column with "beta.o"
rename.cols <- function(trait.mcmc, trt, target.site, target.trt){
  #index of target treatment
  ind <- which(trt$site_id == target.site & trt$trt_name == target.trt)
  
  for(c in 1:length(trait.mcmc)){
    colnames(trait.mcmc[[c]]) <- trt$trt_name
    colnames(trait.mcmc[[c]])[ind] <- "beta.o"
  }
  
  return(trait.mcmc)
}
