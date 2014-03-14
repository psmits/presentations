library(xtable)
library(igraph)

load('../data/network_stats.rdata')

top10 <- order.ranks[1:10]


weird <- nam[path]

series <- c('star trek: the original series', 
            'star trek: the next generation', 
            'star trek: deep space nine', 
            'star trek: voyager', 
            'star trek: enterprise')
best.series <- sort(order.ranks[series], decreasing = TRUE)
degree.series <- deg$res[which(nam %in% series)]
names(degree.series) <- series
close.series <- clse$res[which(nam %in% series)]
names(close.series) <- series

series.table <- cbind(page.rank = best.series, 
                      degree = degree.series, 
                      closeness = close.series)
series.x <- xtable(series.table)
digits(series.x)[2:4] <- c(4, 0, 5)
print.xtable(series.x,
             file = '../doc/series_table.tex')


captains <- c('jean-luc picard', 'james t. kirk',
              'benjamin sisko', 'kathryn janeway',
              'jonathan archer')
best.captain <- sort(order.ranks[captains], decreasing = TRUE)
degree.captain <- deg$res[which(nam %in% captains)]
names(degree.captain) <- captains
close.captain <- clse$res[which(nam %in% captains)]
names(close.captain) <- captains
captain.table <- cbind(page.rank = best.captain, 
                      degree = degree.captain, 
                      closeness = close.captain)
captain.x <- xtable(captain.table)
digits(captain.x)[2:4] <- c(5, 0, 5)
print.xtable(captain.x,
             file = '../doc/captain_table.tex')
