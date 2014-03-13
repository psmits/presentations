library(igraph)
library(ggplot2)
library(reshape2)
library(scales)

theme_set(theme_bw())
cbp <- c('#E69F00', '#56B4E9', '#009E73', '#F0E442', 
         '#0072B2', '#D55E00', '#CC79A7')

# degree plot
deg <- melt(unlist(stdeg))
gdeg <- ggplot(deg, aes(x = value))
gdeg <- gdeg + geom_histogram()
ggsave(filename = '../doc/figure/degree/png', plot = gdeg,
       height = 10, width = 15)

# infomap graph
# set layout

