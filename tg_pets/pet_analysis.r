library(plyr)
library(reshape2)
library(ape)
library(taxize)
library(ggplot2)
library(grid)
library(scales)
library(stringr)
library(geiger)
library(picante)

raws <- read.delim(file = 'darwin_pets.tsv', sep = '\t')
names(raws) <- c('timestamp', 'year', 'pets.now', 'pets.past',
                 'pets.perfect', 'hpc', 'comments')

clean.pets <- function(petvec) {
  ps <- llply(petvec, tolower)
  ps <- laply(ps, function(x) str_split(x, ','))
  ps <- llply(ps, str_trim)
  ps <- llply(ps, function(x) x[x != ''])
  ps <- llply(ps, function(x) str_replace(x, "\\'", ''))

  nas <- which(laply(ps, function(x) any(x %in% c('no', 'none'))))
  for(ii in seq(length(nas))) {
    ps[[nas[ii]]] <- NA
  }
  ps
}
now <- clean.pets(raws$pets.now)
past <- clean.pets(raws$pets.past)
futu <- clean.pets(raws$pets.perfect)

now.npets <- laply(now, length)
now.npets[laply(now, function(x) any(is.na(x)))] <- 0

past.npets <- laply(past, length)
past.npets[laply(past, function(x) any(is.na(x)))] <- 0

futu.npets <- laply(futu, length)
futu.npets[laply(futu, function(x) any(is.na(x)))] <- 0

x <- data.frame(npet = c(now.npets, past.npets, futu.npets),
                lab = rep(c('now', 'past', 'future'), 
                          each = length(now.npets)))
x$lab <- factor(x$lab, levels = c('past', 'now', 'future'))
# number of pets
gpet <- ggplot(x, aes(x = npet))
gpet <- gpet + geom_histogram()
gpet <- gpet + facet_wrap(~ lab)
gpet <- gpet + labs(x = 'number of pets')
ggsave(filename = 'number_pets.png', plot = gpet, width = 6, height = 4)

################################################################################
# current distribution of pet type
pets <- read.delim(file = 'pets.csv')
bytime <- split(pets, pets$timestatus)
nowtab <- table(bytime$present$entry)
now.popular <- nowtab[nowtab >= 4]
names(now.popular)

pastab <- table(bytime$past$entry)
pas.popular <- pastab[pastab >= 4]
names(pas.popular)

futtab <- table(bytime$future$entry)
fut.popular <- futtab[futtab >= 4]
names(fut.popular)

################################################################################
# tree stuff
# things surrounding a tree
unis <- read.delim(file = 'unique_taxa_Peter.csv', sep = '\t')
unis$species <- as.character(unis$species)
unis <- unis[unis$realspecies != 'n', ]
unis$species <- str_trim(unis$species)

# make them only binomials
name.split <- llply(str_split(unis$species, '\\s'), function(x) x[1:2])
singles <- laply(name.split, function(x) any(is.na(x)))
name.split[singles] <- llply(name.split[singles], function(x) x[1])
unis$species <- laply(name.split, function(x) paste0(x, collapse = ' '))
# lots of duplicates
unis <- unis[!(duplicated(unis$species)), ]
unis$species <- str_replace_all(unis$species, '\\s', '_')
rownames(unis) <- unis$species

# big ass tree
ass.tree <- read.tree(file = 'TimetreeOfLife2015.nwk')
chec <- name.check(ass.tree, unis)
ass.tree <- ape::drop.tip(ass.tree, tip = chec$tree_not_data)
ass.tree <- ape::drop.tip(ass.tree, ass.tree$tip.label[1])

# My seperating from nearest neighbor?
ed <- evol.distinct(ass.tree)  

# amount of evolutionary time encapsulated
vcv <- vcv.phylo(ass.tree)
tot.time <- sum(vcv[lower.tri(vcv)])

# basic tree plot
png(filename = 'tree_limited.png')
ass.tree <- ladderize(ass.tree)
plot.phylo(ass.tree, 
           type = 'phylogram',
           show.tip.label = FALSE)
axisPhylo()
dev.off()

# lineage through time plot
png(filename = 'ltt_limited.png')
ltt.plot(ass.tree, log = 'y')
dev.off()
