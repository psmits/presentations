library(XML)
library(tm)
library(stringr)
library(plyr)

source('extractor.r')

startrek <- xmlTreeParse(file = '../data/enmemoryalpha_pages_current.xml',
                         useInternal = TRUE)

top <- xmlRoot(startrek)

limit <- xmlSize(top)

nn <- list()
for(ii in seq(from = 2, to = limit)) {
  nn[[ii]] <- get.info(top[[ii]])
}

# remove the bad pages
good <- !laply(llply(nn, function(x) x == 'bad page'), any)
nn <- nn[good]

save(nn, file = '../data/extracted_vals.rdata')
