## Load and install the required libraries

load.libraries <- c('data.table', 'testthat', 'gridExtra', 'corrplot', 'GGally', 'ggplot2', 'e1071', 'dplyr')
install.lib <- load.libraries[!load.libraries %in% installed.packages()]

for(libs in install.lib) install.packages(libs)

sapply(load.libraries, require, character = TRUE)

## Load the dataset

train <- read.csv("train.csv",stringsAsFactors = F)

head(train)

## Categorical and Numeric Variable Vector 

cat_var <- names(train)[which(sapply(train, is.character))]

numeric_var <- names(train)[which(sapply(train, is.numeric))]


## Structure of the data

str(train)

## Check for the relationship of the response variable with Numerical Variables
## We would create a pairplot of Sales Price with all numeric variables

## Check number of NA in all the columns

colSums(sapply(train, is.na))

