# test code to simulate p-model responses across elevation for Astrid's herbarium project
# originally put together by Nick

# load libraries
library(ggplot2)

## source optimal Vcmax p-model
git_path <- '../../../' # path to your local Git folder with git repos
source(paste(git_path, 'optimal_vcmax_R/calc_optimal_vcmax.R', sep = '')) # source the main model function
sourceDirectory(paste(git_path, 'optimal_vcmax_R/functions', sep = '')) # source the sub-function directory

## source NASA CO2 data
co2_nasa <- read.csv('nasa_co2_ppm.csv')

## run model at different elevations across time
high_elev_sim = calc_optimal_vcmax(z = 5000, cao = co2_nasa[c(41:161), 2])
high_elev_sim$elevation <- 'z = 5000 m'
low_elev_sim = calc_optimal_vcmax(z = 1000, cao = co2_nasa[c(41:161), 2])
low_elev_sim$elevation <- 'z = 1000 m'
elev_sim <- rbind(high_elev_sim, low_elev_sim)

## write output
write.csv(elev_sim, 'astrid_sim_output.csv')

## make some figs
astrid_sim_fig <- ggplot(data = elev_sim, aes(x = cao, y = nall, color = elevation)) +
  theme(legend.position = "right", 
        axis.title.y=element_text(size=rel(2.2), colour = 'black'),
        axis.title.x=element_text(size=rel(2.2), colour = 'black'),
        axis.text.x=element_text(size=rel(2), colour = 'black'),
        axis.text.y=element_text(size=rel(2), colour = 'black'),
        panel.background = element_rect(fill = 'white', colour = 'black'),
        panel.grid.major = element_line(colour = "grey")) +
  geom_line(lwd = 4) +
  scale_color_manual(values = c('blue', 'red')) +
  ylim(c(2.5, 3.3)) +
  ylab('Leaf Nitrogen (g m-2)') +
  xlab('CO2 (ppm)')

jpeg(filename = "astrid_sim_fig.jpeg", 
     width = 8, height = 8, units = 'in', res = 600)
plot(astrid_sim_fig)
dev.off()
