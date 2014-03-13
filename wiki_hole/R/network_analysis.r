library(igraph)
library(stringr)
library(reshape2)

load('../data/star_trek_graph.rdata')

# page rank
ranks <- page.rank(g)
order.ranks <- rev(sort(ranks$vector))
nam <- V(g)$name

# degree distributions
deg <- centralization.degree(g)

# closeness (number of steps to any other node)
clse <- centralization.closeness(g)

# betweenness (gonna run into these things a lot)
bet <- centralization.betweenness(g)
#stalpha <- alpha.centrality(g)

# diameter (long, weird wanders)
path <- get.diameter(g)  # weirdest wander

# other measures
ecc <- eccentricity(g)

# community analysis
#info <- infomap.community(g)
# make a smaller graph that can be plotted
#contract.vertices

