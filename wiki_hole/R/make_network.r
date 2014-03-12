library(igraph)
library(stringr)
library(plyr)

load('../data/extracted_vals.rdata')

titles <- unlist(llply(nn, function(x) x$title))
links <- llply(nn, function(x) x$links)

# match links with titles
# throw out the bad links
new.links <- vector(mode = 'list', length = length(links))
for(ii in seq(from = 2, to = length(links))) {
  mm <- links[[ii]] %in% titles
  new.links[[ii]] <- links[[ii]][mm]
}
new.links <- new.links[-1]

occ <- Reduce(rbind, Map(function(x, y) cbind(rep(x, length(y)), y), 
                         titles, new.links))

# make adjacency matrix
g <- graph.data.frame(occ, directed = TRUE)

save(g, file = '../data/star_trek_graph.rdata')
