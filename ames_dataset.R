## Load and install the required libraries

load.libraries <- c('data.table', 'testthat', 'gridExtra', 'corrplot', 'GGally', 'ggplot2', 'e1071', 'dplyr','reshape2')
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

## First we would like to see the distribution of Response Variable - SalePrice

hist(train$SalePrice, # histogram
     col="skyblue", # column color
     border="black",
     prob = TRUE, # show densities instead of frequencies
     xlab = "SalePrice",
     main = "SalePrice Distribution")
lines(density(train$SalePrice), # density plot
      lwd = 2, # thickness of line
      col = "blue")




## Check for the relationship of the response variable with Numerical Variables
## We would create pairplot of Sales Price with all numeric variables

train_numeric <- train[,numeric_var]

train_numeric_melt <- melt(train_numeric, id="SalePrice")

ggplot(train_numeric_melt,aes(x=value, y=SalePrice)) +
  facet_wrap(~variable, scales = "free")+
  geom_point()


## Check number of NA in all the columns

colSums(sapply(train, is.na))

