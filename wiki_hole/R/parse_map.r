library(igraph)
library(stringr)
#' read in a map file from mapequation.org
#'
#' # is the line starter for a summary
#' * is the line starter for key data
#'
#' @param map file path of interest
#' @return node membership and graph object
parse.map <- function(map) {
  x <- scan(file = map, what = '', sep = '\n', quiet = TRUE)

  star <- str_locate(x, '\\*')
  star.loc <- which(!is.na(star[, 1]))[-1]

  wmods <- seq(from = star.loc[1] + 1, to = star.loc[2] - 1)
  mods <- x[wmods]
  wnodes <- seq(from = star.loc[2] + 1, to = star.loc[3] - 1)
  nodes <- x[wnodes]
  wlinks <- seq(from = star.loc[3] + 1, to = length(x))
  links <- x[wlinks]

  # extract module names
  mod.names <- lapply(nodes, function(x) {
                      mod.num <- as.numeric(str_extract(x, '([^\\:]*)'))
                      node.num <- as.numeric(str_extract(str_split(x, ' ')[[1]][2], 
                                                         '([0-9]+)'))
#                      flow.in <- as.numeric(str_extract(str_split(x, ' ')[[1]][3],
#                                                        '([0-9]+)'))
#                      flow.out <- as.numeric(str_extract(str_split(x, ' ')[[1]][4],
#                                                         '([0-9]+)'))
                      out <- list()
                      out$module <- mod.num
                      out$node <- node.num
#                      out$flow.in <- flow.in
#                      out$flow.out <- flow.out
                      out})
  mod.names <- Reduce(rbind, lapply(mod.names, unlist))

  edge.list <- lapply(links, function(x) {
                      as.numeric(str_split(x, ' ')[[1]])})
  edge.list <- Reduce(rbind, edge.list)
  edge.list <- edge.list[edge.list[, 3] != min(edge.list[, 3]), ]
  graph <- graph.data.frame(edge.list, directed = TRUE)
  E(graph)$weight <- edge.list[, 3]

  out <- list()
  out$modules <- mod.names
  out$graph <- graph
  out
}
