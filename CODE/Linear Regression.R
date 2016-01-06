######################################## DOLAR ##########################################

################################## LINEAR REGRESSION ####################################

################################## WORKING DIRECTORY ####################################
### Set a working directory
directory <- "/Users/Sebastian/Documents/R/Dolar"
setwd(directory)

###################################### PACKAGES ########################################
require(ggplot2)
require(reshape2)
require(scales)

####################################### DATA ###########################################
### Import data
DATA <- read.csv("./DATA/PROCESSED/Dolar.csv", stringsAsFactors = FALSE)

### Set variables
attach(DATA)
date <- as.Date(date, "%Y-%m-%d")
Y <- cbind(search)
X <- cbind(tipo.cambio)

##################################### LINEAR MODEL ####################################
linear.regression <- lm(Y ~ X)
summary(linear.regression)

prediction <- predict(linear.regression)

###################################### DUMMIES ########################################
dummy <- c(rep(0, 57), 1, rep(0, 74), 1, rep(0, 10))
X <- cbind(tipo.cambio, dummy)
linear.regression.dummy <- lm(Y ~ X)
summary(linear.regression.dummy)

prediction.dummy <- predict(linear.regression.dummy)

####################################### PLOT ##########################################
df <- data.frame(date, Y, prediction, prediction.dummy)
dfm <- melt(df, id.vars = c("date"))
qplot(date, value, data = dfm, group = variable, colour = variable, geom = "line") + 
  scale_x_date(labels = date_format("%Y"))
