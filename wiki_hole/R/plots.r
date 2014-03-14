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
blockdeg <- data.frame(degree(infograph$graph))
names(blockdeg) <- 'val'
mod.deg <- ggplot(blockdeg, aes(x = val)) + geom_bar()
mod.deg <- mod.deg + xlab('module number')
ggsave(filename = '../doc/figure/mod_deg.png', plot = mod.deg,
       height = 10, width = 15)

members <- data.frame(module.assign$module)
names(members) <- 'assign'
mem.hist <- ggplot(members, aes(x = assign)) + geom_bar()
mem.hist <- mem.hist + xlab('module number')
ggsave(filename = '../doc/figure/modules.png', plot = mem.hist,
       height = 10, width = 15)
