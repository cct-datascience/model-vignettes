# Variance decomposition plots for high night temperature biomass results. 

library(ggplot2)
library(cowplot)

plot_dir <- "BioCro/DARPA/temp_comparison/plots/"

# Plot variance decomposition of biomass
load("/data/output/pecan_runs/temp_comp_results/var_decomp_AGB.Rdata")

cv.b <- ggplot(data = vd) +
  geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars, 
                      col = treatment), 
                  alpha = 0.5, size = 1, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("CV %") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme_classic(base_size = 10) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank()) +
  guides(col = FALSE)

el.b <- ggplot(data = vd) +
  geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities, 
                      col = treatment), 
                  alpha = 0.5, size = 1, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Elasticity") +
  geom_hline(aes(yintercept = 0), size = 0.1)  +
  theme_classic(base_size = 10) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), 
        axis.text.y=element_blank()) +
  guides(col = FALSE)

vdecomp.b <- ggplot(data = vd) +
  geom_pointrange(aes(x = trait.labels, y = sd_convert, ymin = 0, ymax = sd_convert, 
                      col = treatment), 
                  alpha = 0.5, size = 1, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Variance Explained (kg/m2)") +
  geom_hline(aes(yintercept = 0), size = 0.1)  +
  scale_y_continuous(breaks = pretty(vd$sd_convert, n = 3)) +
  theme_classic(base_size = 10) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), 
        axis.text.y=element_blank(), 
        legend.position = c(0.8, 0.5))

fig_biomass_vd <- cowplot::plot_grid(cv.b, el.b, vdecomp.b, nrow = 1, rel_widths = c(1.5, 1, 1))
ggsave(paste0(plot_dir, "biomass_vd.jpg"), fig_biomass_vd, 
       height = 5, width = 7, units = "in", dpi = 600)
fig_biomass_vd


# Plot variance decomposition of transpiration
load("/data/output/pecan_runs/temp_comp_results/var_decomp_TVeg.Rdata")

cv.t <- ggplot(data = vd) +
  geom_pointrange(aes(x = trait.labels, y = coef.vars, ymin = 0, ymax = coef.vars, 
                      col = treatment), 
                  alpha = 0.5, size = 1, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("CV %") +
  geom_hline(aes(yintercept = 0), size = 0.1) +
  theme_classic(base_size = 10) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank()) +
  guides(col = FALSE)

el.t <- ggplot(data = vd) +
  geom_pointrange(aes(x = trait.labels, y = elasticities, ymin = 0, ymax = elasticities, 
                      col = treatment), 
                  alpha = 0.5, size = 1, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle("Elasticity") +
  geom_hline(aes(yintercept = 0), size = 0.1)  +
  theme_classic(base_size = 10) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), 
        axis.text.y=element_blank()) +
  guides(col = FALSE)

vdecomp.t <- ggplot(data = vd) +
  geom_pointrange(aes(x = trait.labels, y = sd_convert, ymin = 0, ymax = sd_convert, 
                      col = treatment), 
                  alpha = 0.5, size = 1, position = position_dodge(width = c(-0.4))) +
  coord_flip() +
  ggtitle(expression(paste("Variance Explained (kg ", m^2, " ", day^-1, ")"))) +
  geom_hline(aes(yintercept = 0), size = 0.1)  +
  scale_y_continuous(breaks = pretty(vd$sd_convert, n = 3)) +
  theme_classic(base_size = 10) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), 
        axis.text.y=element_blank(), 
        legend.position = c(0.8, 0.5))

fig_trans_vd <- cowplot::plot_grid(cv.t, el.t, vdecomp.t, nrow = 1, rel_widths = c(1.5, 1, 1))

ggsave(paste0(plot_dir, "trans_vd.jpg"),
       fig_trans_vd,
       height = 5, width = 7, units = "in", dpi = 600)
fig_trans_vd
