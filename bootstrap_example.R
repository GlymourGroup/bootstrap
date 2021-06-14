library("dplyr")

#------------------------------
# Instructions
#------------------------------
#Set working directory first so you don't have to put in the full paths:
# - In RStudio:
#   -Session -> Set Working Directory -> To Source File Location

#------------------------------
# Options
#------------------------------
nBootstraps <- 1000

#------------------------------
# Load data
#------------------------------
d <- read.csv(file.path("data.csv"))

head(d)
pairs(d)

#------------------------------
# Run main analysis
#------------------------------
#This is the analysis function you want to get a bootstrap estimate for:
model <- lm(y~a*x, data=d)
summary(model)
coefficients(model)
main_est <- coefficients(model)[["a"]]
main_est

#The coefficient of interest estimated using the full data set is:
main_CI <- confint(model)["a",]
main_CI

#------------------------------
#Run bootstrapping
#------------------------------
#Set up a table to hold the bootstrap results
results <- data.frame(bootstrapID=1:nBootstraps,
                      estimate=rep(NA,nBootstraps))
head(results)

#Bootstrapping loop
for(i in 1:nBootstraps){
  #Resample data sets of the same size as the original data, with replacement
  d_boot <- sample_n(d,nrow(d),replace=TRUE)

  #Estimate the model on the resampled data
  model_boot <- lm(y~a*x, data=d_boot)

  #The coefficient of interest is the one on a, so we pull it out and add it to the results table
  results[i,"estimate"] <- coefficients(model_boot)[["a"]]
}

#Look at summary of bootstrap results and get bootstrap 95% CI
summary(results)
bootstrap_est <- mean(results$estimate)
bootstrap_CI <- quantile(results$estimate,probs=c(0.025,0.975))

#------------------------------
# Compare results
#------------------------------
#Compare to estimate output by model (They should be similar for this simple linear model)

#Estimates
main_est
bootstrap_est

#CIs
main_CI
bootstrap_CI
