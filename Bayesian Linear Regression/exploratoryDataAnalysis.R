exploratoryDataAnalysis <- function(train_preProcessed){


## Categorical and Numeric Variable Vector 

cat_var <- names(train_preProcessed)[which(sapply(train_preProcessed, is.factor))]

numeric_var <- names(train_preProcessed)[which(sapply(train_preProcessed, is.numeric))]



## First we would like to see the distribution of Response Variable - SalePrice

hist(train_preProcessed$SalePrice, # histogram
     col="skyblue", # column color
     border="black",
     prob = TRUE, # show densities instead of frequencies
     xlab = "SalePrice",
     main = "SalePrice Distribution")
lines(density(train_preProcessed$SalePrice), # density plot
      lwd = 2, # thickness of line
      col = "blue")



## Check for the relationship of the response variable with Numerical Variables
## We would create scatterplot of Sales Price with all numeric variables

train_numeric <- train_preProcessed[,numeric_var]

train_numeric_melt <- melt(train_numeric, id="SalePrice")

ggplot(train_numeric_melt,aes(x=value, y=SalePrice)) +
  facet_wrap(~variable, scales = "free") +
  geom_point()


## Check for the relationship of the response variable with Categorical Variables
## We would create boxplot of Sales Price with all Categorical variables

train_categorical <- train_preProcessed[,c(cat_var,"SalePrice")]

drawBoxPlots <- function(df){
  
  dfMelt <- melt(df, id="SalePrice")
  
  p <- ggplot(dfMelt, aes(factor(value), SalePrice)) 
  p + geom_boxplot() + facet_wrap(~variable, scale="free")  
  
}

drawBoxPlots(train_categorical[,c(1:8,ncol(train_categorical))])
drawBoxPlots(train_categorical[,c(9,ncol(train_categorical))])
drawBoxPlots(train_categorical[,c(10:15,ncol(train_categorical))])
drawBoxPlots(train_categorical[,c(15:25,ncol(train_categorical))])
drawBoxPlots(train_categorical[,c(25:35,ncol(train_categorical))])
drawBoxPlots(train_categorical[,c(35:43,ncol(train_categorical))])


## Check the correlation matrix to see significant variables and also check multi-colliearity

trainCorr = cor(na.omit(train_numeric))

head(round(trainCorr,2))

row_indic <- apply(trainCorr, 1, function(x) sum(x > 0.3 | x < -0.3) > 1)

trainCorr_subset <- trainCorr[row_indic ,row_indic ]

corrplot(trainCorr_subset, method = "number", type="lower", tl.srt=45)

# Remove the variables having multicollinearity and are a function of each other

significantNumVariable <- train_numeric %>% 
                       select(-c(LotFrontage, LotArea,X1stFlrSF, X2ndFlrSF,
                             FullBath, TotRmsAbvGrd, GarageArea)) %>%
                                          colnames()

# Another way of writing above piece of code
# significantNumVariable <-  colnames(train_numeric[,!(numeric_var %in% c("LotFrontage", "LotArea",
#                                      "X1stFlrSF","X2ndFlrSF","FullBath", "TotRmsAbvGrd","GarageArea"))]) 


## Perform the ANOVA Test to check association of catrgorical variable with numeric / nominal and discrete

trainFact <- as.data.frame(train_categorical[,cat_var])

# Add SalePrice variable to dataframe

trainFact <- cbind(trainFact,"SalePrice"=train_preProcessed[,"SalePrice"])

# Remove the NAs (if there are any)

trainFact <- na.omit(trainFact)

# Fit a linear model

trainFactModel <- lm(SalePrice~., trainFact)

# Perform ANOVA test
trainFactAnova <- anova(trainFactModel)

# Subset for the significant variable - p-value less than 0.01
trainFactAnova_sub <- subset(trainFactAnova,`Pr(>F)`<=0.1)

# Save the name of these variables in a vector
significantCatVariables <- rownames(trainFactAnova_sub)

## Normality Test

ggplot(train_preProcessed, aes(SalePrice)) +
  geom_density() +
  scale_x_continuous(breaks = c(0,200000,400000,755000))


qqnorm(train_preProcessed$SalePrice,main = "Normal Q-Q Plot",
       xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
       plot.it = TRUE)
qqline(train_preProcessed$SalePrice)


# LogNormal Distribution of SalePrice

ggplot(train_preProcessed, aes(log(SalePrice))) +
  geom_density(colour="blue") +
  scale_x_continuous(breaks = c(0,200000,400000,755000))


qqnorm(log(train_preProcessed$SalePrice),main = "Normal Q-Q Plot",
       xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
       plot.it = TRUE)
qqline(log(train_preProcessed$SalePrice))

## Homoscedesticity Test

ggplot(train_numeric_melt,aes(x=value, y=log(SalePrice))) +
  facet_wrap(~variable, scales = "free")+
  geom_point()

print(significantNumVariable)

return(significantNumVariable)

}