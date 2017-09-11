library(ggplot2)
library(scales)

theme_set(theme_bw())

survfun <- function(x, scale = 1, shape = 1) {
  st <- exp(-(scale * x) ^ shape)
  st
}

x <- data.frame(x = seq(0.0001, 1, by = 0.0001))

sim <- ggplot(x, aes(x = x))
sim <- sim + stat_function(fun = survfun, colour = 'black')
sim <- sim + stat_function(fun = survfun, args = list(shape = 1.5), colour = 'blue')
sim <- sim + stat_function(fun = survfun, args = list(shape = 0.5), colour = 'red')
sim <- sim + coord_trans(y = 'log')
sim <- sim + labs(x = 'Age', y = 'log S(t)')

ggsave(sim, file = 'figure/surv_sim.png', width = 6, height = 4)
