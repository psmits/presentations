library(igraph)
library(stringr)
library(plyr)

load('../data/extracted_vals.rdata')

titles <- laply(nn, function(x) x$title)
links <- llply(nn, function(x) x$links)

# match links with titles
# throw out the bad links
# make adjacency matrix
