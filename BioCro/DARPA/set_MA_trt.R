## Function that creates a link table between treatments and their RE indices 
## And produces a list of mcmc.list objects for only the treatment-level posteriors
## Target site/treatment is re-labeled "beta.o" so additional PEcAn functions will work 


set_MA_trt <- function(settings){
  
  library(coda)
  
  #obtain dbfiles path
  con <- PEcAn.DB::db.open(settings$database$bety)
  postid <- settings$pfts$pft$posteriorid
  fname <- PEcAn.DB::dbfile.file(type = "Posterior", id = postid, con = con)
  fpath <- gsub(paste0(postid, "\\/.*"), postid, fname)
  
  #load jagged.data and trait.mcmc
  load(file.path(fpath, "jagged.data.Rdata"))
  load(file.path(fpath, "trait.mcmc.Rdata"))
  
  
  #convert jagged.data into match table, only return traits for which there is an associated mcmc output
  trt.match <- lapply(jagged.data, collapse)[names(trait.mcmc)]
  
  #save trt.match, 2 places
  # if(settings$meta.analysis$update == TRUE) {
  #   save(trt.match, file = file.path(settings$database$dbfiles, "posterior", postid, "trt.match.Rdata"))
  # }
  save(trt.match, file = file.path(settings$pfts$pft$outdir, "trt.match.Rdata"))
  
  
  #save existing trait.mcmc with different name, 2 places
  # if(settings$meta.analysis$update == TRUE) {
  #   save(trait.mcmc, file = file.path(settings$database$dbfiles, "posterior", postid, "trait.mcmc.original.Rdata"))
  # }
  save(trait.mcmc, file = file.path(settings$pfts$pft$outdir, "trait.mcmc.original.Rdata"))
  
  #create new trait.mcmc of combined random effects
  new.trait.mcmc <- mapply(FUN = RE_combine, mc = trait.mcmc, trt = trt.match, 
                           SIMPLIFY = FALSE)
  
  #identify target site and treatment
  target.site <- settings$run$site$id
  target.trt <- settings$meta.analysis$treatment
  
  #label target site/treatment "beta.o"
  final.trait.mcmc <- mapply(FUN = rename_cols, trait.mcmc = new.trait.mcmc, trt = trt.match,
                             MoreArgs = list(target.site = target.site, target.trt = target.trt),
                             SIMPLIFY = FALSE)
  
  #rename as trait.mcmc and save as "trait.mcmc.Rdata", 2 places
  trait.mcmc <- final.trait.mcmc
  # if(settings$meta.analysis$update == TRUE) {
  #   save(trait.mcmc, file = file.path(settings$database$dbfiles, "posterior", postid, "trait.mcmc.Rdata"))
  # }
  save(trait.mcmc, file = file.path(settings$pfts$pft$outdir, "trait.mcmc.Rdata"))
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
RE_combine <- function(mc, trt){
  #create table of relevant RE for each treatment (row)
  trt <- trt[, c("ghs", "site", "trt")]
  #empty matrix of column indices for matching column names
  col_ind <- matrix(NA, nrow = nrow(trt), ncol = ncol(trt))
  #existing column names
  cnames <- colnames(mc[[1]])
  #fill col_ind with the column index of the matching column names
  for(i in 1:nrow(trt)){
    for(j in 1:ncol(trt)){
      index <- which(cnames == paste0("beta.", colnames(trt)[j], "[", trt[i,j], "]"))
      col_ind[i,j] <- if(length(index) == 1){
        index
      } else {
        NA
      }
    }
  }
  #add index for "beta.o", which is universal across treatments
  col_ind <- cbind(col_ind, rep(which(cnames == "beta.o"), nrow(col_ind)))
  
  #add index for only "beta.o", to preserve the global treatment
  col_ind <- rbind(c(NA, NA, NA, which(cnames == "beta.o")), col_ind)
  
  #create empty mcmc.list object
  chain <- list(mcmc(matrix(NA, nrow = nrow(mc[[1]]), ncol = nrow(col_ind))))
  out <- rep(chain, length(mc))
  #for each chain and treatment, combine the relevant posterior RE from trait.mcmc
  for(c in 1:length(mc)){
    for(t in 1:nrow(col_ind)){ # number of treatments + 1
      out[[c]][,t] <- rowSums(mc[[c]][ ,col_ind[t,]], na.rm = T)
    }
  }
  return(mcmc.list(out))
}

#Renames target treatment column with "beta.o"
rename_cols <- function(trait.mcmc, trt, target.site, target.trt){
  #index of target treatment
  if (any(trt$trt_name %in% target.trt)) {
    ind <- which(trt$site_id == target.site & trt$trt_name == target.trt) + 1 # specific to site and treatment
  } else if (any(trt$site_id == target.site)){
    ind <- which(trt$site_id == target.site & trt$trt_control == "control") + 1 # specific to site (control treatment)
  } else {
    ind <- 1 # no site or treatment, using global beta.o
  }
  #for each chain, add treatment names as column names; then sub out the target treatment column name with "beta.o"
  for(c in 1:length(trait.mcmc)){
    colnames(trait.mcmc[[c]]) <- c("global", trt$trt_name)
    colnames(trait.mcmc[[c]])[ind] <- "beta.o"
  }
  
  return(trait.mcmc)
}
