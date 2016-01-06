#########################################################################################
#### Descriptive Analysis ####
#########################################################################################

#########################################################################################
#### INIT ####
#########################################################################################
directory <- "/Users/Sebastian/Documents/R/Dolar"
setwd(directory)
file.path <- "./DATA/PROCESSED/Dolar.csv"
date.format <- "%Y-%m-%d"

#########################################################################################
#### PACKAGES ####
#########################################################################################
#   If is not installed some of the packages bellow it is recomendable to run the next
#   code.

#   install.packages("car")
#   install.packages("FactoMineR")
#   install.packages("devtools")
#   library(devtools)
#   install_github("kassambara/factoextra")

library(car)
library(FactoMineR)
library(factoextra)

#########################################################################################
#### DATA ####
#########################################################################################
data <- read.csv(file.path, stringsAsFactors = FALSE)
data$date <- as.Date(data$date, format = date.format)
attach(data)
X <- cbind(tipo.cambio, search, desocupacion, exp.petrolera, exportaciones,
           importaciones, precio.petroleo)

#########################################################################################
#### DESCRIPTIVE ####
#########################################################################################

# Summary
summary(X)

# Scatterplot
scatterplotMatrix(X)

# Standard Deviation
lapply(data.frame(X), sd)

# Correlations
cor(X)

#########################################################################################
#### PCA ####
#########################################################################################
# Principal Component Analysis
X.pca <- PCA(X, ncp = estim_ncp(X)$ncp)
summary(X.pca)

sum((X.pca$eig$eigenvalue)^2)               # Total variance explained by components

eigenvalues <- X.pca$eig

# Coordinates Variables
X.pca$var$coord

# COS 2 Variables
X.pca$var$cos2

# Contribution Variables
X.pca$var$contrib

# Variables Plots (modify!!!!)
fviz_screeplot(X.pca, ncp = estim_ncp(X)$ncp) + theme_minimal()

fviz_pca_var(X.pca, col.var =  "contrib") +
  theme_minimal() +
  coord_fixed(ratio = 1)

# Coordinates Individual
X.pca$ind$coord

# COS 2 Individual
X.pca$ind$cos2

# Contribute Individual
X.pca$ind$contrib

# Individual Plots (modify!!!)

fviz_pca_ind(X.pca, geom = "text")

fviz_pca_biplot(X.pca, geom = "text")

# factor analysis