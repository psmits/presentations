library(ggplot2)
library(reshape2)
library(plyr)
library(grid)
theme_set(theme_bw())
cbp <- c('#E69F00', '#56B4E9', '#009E73', '#F0E442', 
         '#0072B2', '#D55E00', '#CC79A7')
theme_update(axis.text = element_text(size = 20),
             axis.title = element_text(size = 30),
             legend.text = element_text(size = 30),
             legend.title = element_text(size = 32),
             legend.key.size = unit(1, 'cm'),
             strip.text = element_text(size = 30))

# all of chicago
chi.dat <- read.csv('chicago-illinois.csv')
tiny.pop <- chi.dat[chi.dat$bg_pop < 1000, ]
pop.risk <- ggplot(tiny.pop, aes(x = bg_pop, y = bg_smoke_risk))
pop.risk <- pop.risk + geom_point()
pop.risk <- pop.risk + stat_smooth(size = 1.5)
pop.risk <- pop.risk + labs(x = 'Block population', 
                            y = 'Risk percent')
ggsave(plot = pop.risk, filename = 'pop_risk.png',
       units = 'in', height = 10, width = 13)

pop.risk <- ggplot(tiny.pop, aes(x = bg_smoke_risk, y = bg_pop_risk))
pop.risk <- pop.risk + geom_point()
pop.risk <- pop.risk + stat_smooth(size = 1.5)
pop.risk <- pop.risk + labs(x = 'Risk percent', 
                            y = 'Percent block population at risk')
ggsave(plot = pop.risk, filename = 'pop_fact.png',
       units = 'in', height = 10, width = 13)


# make some plots of the cluster
clustu <- read.csv('fire_data.csv', header = FALSE)
names(clustu) <- c('addy', 'year', 'alarm', 'risk')
clustu$risk <- clustu$risk / 100
clustu$year <- as.factor(clustu$year)
clustu$year[clustu$year == '5' | clustu$year == '6'] <- 5
clustu$year <- as.character(clustu$year)
clustu$year[clustu$year == '5'] <- '5+'
clustu$alarm <- mapvalues(clustu$alarm, 
                          from = unique(clustu$alarm), 
                          to = c('yes', 'no'))

# what's the distribution of risk across chicago Geo-Ids vs Cluster
group.risk <- rbind(cbind(loc = 'city', risk = chi.dat$bg_smoke_risk),
                    cbind(loc = 'cluster', risk = clustu$risk))
group.risk <- data.frame(group.risk)
group.risk$risk <- as.numeric(as.character(group.risk$risk))
big.risk <- ggplot(group.risk, aes(x = risk, fill = loc))
big.risk <- big.risk + geom_histogram(aes(y = ..density..),
                                      alpha = 0.6, position = 'identity')
big.risk <- big.risk + geom_density(alpha = 0.35, position = 'identity')
big.risk <- big.risk + labs(x = 'Risk percent', y = 'Density')
big.risk <- big.risk + scale_fill_manual(values = cbp)
ggsave(plot = big.risk, filename = 'big_risk.png',
       units = 'in', height = 10, width = 13)

# differences between years
clu.dif <- ggplot(clustu, aes(x = year, y = risk))
clu.dif <- clu.dif + geom_violin() + geom_boxplot(width = 0.1)
clu.dif <- clu.dif + labs(x = 'Year in Grad School', y = 'Risk')
ggsave(plot = clu.dif, filename = 'clu_dif.png',
       units = 'in', height = 10, width = 13)

# differences between alarms
clu.alm <- ggplot(clustu, aes(x = alarm, y = risk))
clu.alm <- clu.alm + geom_violin() + geom_boxplot(width = 0.1)
clu.alm <- clu.alm + labs(x = 'Working alarm?', y = 'Risk')
ggsave(plot = clu.alm, filename = 'clu_alm.png',
       units = 'in', height = 10, width = 13)

# who has a working alarm?
work.alm <- ggplot(clustu, aes(x = alarm, fill = year))
work.alm <- work.alm + geom_bar(position = 'fill')
work.alm <- work.alm + scale_fill_manual(values = cbp)
work.alm <- work.alm + labs(x = 'Working alarm?', y = 'Percent of respondants')
ggsave(plot = work.alm, filename = 'work_alm.png',
       units = 'in', height = 10, width = 13)
