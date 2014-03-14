library(igraph)
library(ggplot2)
library(reshape2)
library(scales)
source('../R/parse_map.r')

load('../data/network_stats.rdata')

theme_set(theme_bw())
cbp <- c('#E69F00', '#56B4E9', '#009E73', '#F0E442', 
         '#0072B2', '#D55E00', '#CC79A7')

# degree plot
mdeg <- melt(unlist(deg$res))
gdeg <- ggplot(mdeg, aes(x = value))
gdeg <- gdeg + geom_histogram()
ggsave(filename = '../doc/figure/degree.png', plot = gdeg,
       height = 10, width = 15)

# infomap graph
map <- '../data/star_trek.map'
infograph <- parse.map(map)
module.assign <- as.data.frame(infograph$modules)
module.assign$names <- nam[module.assign$node]
#module.assign$names[which(module.assign$module == 4)]
