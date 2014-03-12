library(XML)
library(tm)
library(stringr)
library(plyr)

source('extractor.r')

startrek <- xmlTreeParse(file = '../data/enmemoryalpha_pages_current.xml',
                         useInternal = TRUE)

top <- xmlRoot(startrek)

#limit <- xmlSize(top)

nn <- list()
for(ii in seq(from = 6, to = 1000)) {
  nn[[ii]] <- get.info(top[[ii]])
}
