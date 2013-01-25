##

mammal <- read.csv('pantheria_WR2005_wtax_DD_OC.csv', header = T)

mammal[mammal == -999] <- NA

vari <- names(mammal)
vari <- vari[c(1, 3:5, 8:10, 13:15, 19, 32, 34)]

mammal <- mammal[, vari]
names(mammal) <- tolower(names(mammal))

log.trans <- log(mammal[, 5:9])
mammal[, 5:9] <- log.trans

write.csv(mammal, 'pantheria_mung.csv')
