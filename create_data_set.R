#create data set for bootstrap example
n <- 1000

#This is the quantity we are estimating
mainEffect <- 0.1

d <- data.frame(a=rnorm(n))
d$x <- 0.3*d$a + 0.5*rnorm(n)
d$y <- mainEffect*d$a + 0.2*d$x + 0.01*d$a*d$x + 0.25*rnorm(n)
write.csv(d,"data.csv",row.names=FALSE)
