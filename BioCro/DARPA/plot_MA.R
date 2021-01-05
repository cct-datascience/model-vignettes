##  Function to make figures

plot_MA <- function(settings){
  
  library(ggplot2)
  library(tidyr)
  library(dplyr)

  #load prior.distns, jagged.data, trait.mcmc (new), and trt.match
  load(file.path(settings$pfts$pft$outdir, "prior.distns.Rdata"))
  load(file.path(settings$pfts$pft$outdir, "jagged.data.Rdata"))
  load(file.path(settings$pfts$pft$outdir, "trait.mcmc.Rdata"))
  load(file.path(settings$pfts$pft$outdir, "trt.match.Rdata"))
  
  #turn all into lists of length n objects so plot_prior_posterior() will run evenly
  traits <- names(trt.match) # not all jagged data was processed
  
  #convert prior.distns
  priors <- split(prior.distns, f = row.names(prior.distns))
  priors <- priors[traits]#select only relevant traits
  
  #convert jagged.data
  jagged <- jagged.data[traits]
  

  #apply  across set of list objects
  MAfigs <- mapply(FUN = plot_prior_posterior, 
                   prior = priors, 
                   jag = jagged,
                   mc = trait.mcmc,
                   trt = trt.match,
                   SIMPLIFY = F)
  
  #print out each plot
  lapply(names(MAfigs), function(x) ggsave(filename = file.path(settings$pfts$pft$outdir, paste0(x, ".jpg")),
                                    plot = MAfigs[[x]]))

}

#Plot comparing prior, data, and posterior by treatment; function can be included in mapply()
plot_prior_posterior <- function(prior, jag, mc, trt){
  
  library(tidyr)
  library(RColorBrewer)
  
  #convert mcmc.list into dataframe for plotting
  dat <- data.frame(do.call(rbind, mc)) 
  #remove global
  dat <- dat[,which(colnames(dat) != "global")]
  colnames(dat) <- trt$treatment_id
  level <- as.character(trt$trt_name[order(trt$site_id, trt$treatment_id)])
  mc.out <- dat %>% 
    pivot_longer(cols = everything(), names_to = c("treatment_id")) %>%
    mutate(treatment_id = as.numeric(treatment_id)) %>%
    left_join(x = ., y = trt, by = "treatment_id") %>%
    mutate(trt_name = factor(trt_name, levels = level))
  
  #add prior
  mc.out$prior <- rep(do.call(paste0("r", prior$distn), list(nrow(dat), prior$parama, prior$paramb)),
                      ncol(dat))
  #calculate central 95% of prior
  ci <- quantile(mc.out$prior, probs = c(0.025, 0.975))
  #calculate central 95% of each posterior
  cis <- tapply(mc.out$value, mc.out$trt_name, FUN = quantile, probs = c(0.025, 0.975))
  #upper limit, max of 0.975 percentile across prior and posteriors AND max of data
  upper <- max(max(max(unlist(lapply(cis, max))),ci[2]), max(jag$Y))
  
  #add factor with levels to jag
  jag$trt_name <- factor(jag$trt_name, levels = level)
  
  cols <- brewer.pal(3, name = "Dark2")
  fig <- ggplot() +
    stat_density(data = mc.out, aes(x = value, color = "posterior"), geom = "line") +
    stat_density(data = mc.out, aes(x = prior, color = "prior"), geom = "line") +
    geom_rug(data = jag, aes(x = Y), color = "red", length = unit(0.07, "npc")) +
    scale_x_continuous(limits = c(0, upper)) +
    facet_wrap(~trt_name, ncol = 1, scales = "free_y") +
    theme_bw(base_size = 10) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank()) +
    scale_color_manual(values = cols[1:2]) +
    guides(color = FALSE)
  
  return(fig)
}
