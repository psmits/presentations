library(igraph)
library(stringr)
library(reshape2)

load('../data/star_trek_graph.rdata')
#write.graph(g, file = '../data/star_trek_complete.net', format = 'pajek')

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

# write out the statistics
save.image(file = '../data/network_stats.rdata')
