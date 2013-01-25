###############################################################################
##
##  small script to install a bunch of useful/necessary packages
##
###############################################################################

to.install <- c('ggplot2', 'scales', 'reshape2', 'plyr', 'maps', 'mapproj')
install.packages(to.install, repos = 'http://cran.us.r-project.org')
