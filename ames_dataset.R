## Load and install the required libraries

load.libraries <- c('Hmisc','mice','Amelia','data.table', 'testthat', 'gridExtra', 'corrplot', 
                    'GGally', 'ggplot2', 'e1071', 'dplyr','reshape2','dummies')
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
## We would create scatterplot of Sales Price with all numeric variables

train_numeric <- train[,numeric_var]

train_numeric_melt <- melt(train_numeric, id="SalePrice")

ggplot(train_numeric_melt,aes(x=value, y=SalePrice)) +
  facet_wrap(~variable, scales = "free")+
  geom_point()


## Check for the relationship of the response variable with Categorical Variables
## We would create boxplot of Sales Price with all Categorical variables

train_categorical <- train[,c(cat_var,"SalePrice")]

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

row_indic <- apply(trainCorr, 1, function(x) sum(x > 0.5 | x < -0.5) > 1)

trainCorr_subset<- trainCorr[row_indic ,row_indic ]

corrplot(trainCorr_subset, method = "number", type="lower", tl.srt=45)


## Perform the ANOVA Test to check association of catrgorical variable with numeric / nominal and discrete

# Convert the categorical variables to factors

trainFact <- as.data.frame(sapply(train_categorical[,cat_var],as.factor))

# Add SalePrice variable to dataframe

trainFact <- cbind(trainFact,"SalePrice"=train[,"SalePrice"])

# Remove the categorical variable having most values(~50%) as NA

na_cat_var <- c("Alley","Functional","Fence","PoolQC","MiscFeature","FireplaceQu")

# Remove the NA columns from dataframe

trainFact_sub <- trainFact[,!(colnames(trainFact) %in% na_cat_var)]

# Remove the NAs still left (~100 rows)

trainFact_sub_notna <- na.omit(trainFact_sub)

# Fit a linear model

trainFactModel <- lm(SalePrice~., trainFact_sub_notna)

# Perform ANOVA test
trainFactAnova <- anova(trainFactModel)


## Dealing with Missing Data


train_raw <- read.csv("train.csv")

# Convert the required columns to factors
train_raw$MSSubClass <- as.factor(train_raw$MSSubClass)
train_raw$MoSold <- as.factor(train_raw$MoSold)
train_raw$YrSold <- as.factor(train_raw$YrSold)

# Draw a missing map to see which columns have maximum NAs
missmap(train_raw[-1], col=c('red', 'green'), y.cex=0.6, x.cex=0.8)

# Check number of NA in all the columns
MissingValues <- as.data.frame(colSums(sapply(train,is.na)))  

# Convert ronames to columns
MissingValues <- as.data.frame(setDT(MissingValues, keep.rownames = TRUE))

# Rename the column names
colnames(MissingValues) <- c("columnName","totalNA_Values")

# Transform totalNA to percent, add it as column and arrange in descending order on the basis of it
MissingValues <- MissingValues %>% 
  mutate_at(vars(totalNA_Values),funs(percentNA_Values=.*100/nrow(train))) %>% 
  arrange(desc(percentNA_Values)) 

# Check the top columns having maximum NA values 
head(MissingValues,n=10)


# Drop columns having more than 20 % missing values

exclude <- c('PoolQC', 'MiscFeature', 'Alley', 'Fence')
include <- setdiff(names(train_raw), exclude)

train_raw <- train_raw[include]

imp.train_raw <- mice(train_raw, m=1, method='cart', printFlag=FALSE)


## Check the siginificant variables using the imputed values

# Some numeric variables
xyplot(imp.train_raw, LotFrontage ~ LotArea)


densityplot(imp.train_raw, ~LotFrontage)


# Some categorical variables
table(train_raw$GarageType)

table(imp.train_raw$imp$GarageType)

table(train_raw$GarageFinish)

table(imp.train_raw$imp$GarageFinish)

table(train_raw$BsmtExposure)

table(imp.train_raw$imp$BsmtExposure)


# Use the imputed values in the original dataframe
train_complete <- complete(imp.train_raw)

# Check if there are any more NA values
sum(sapply(train_complete, function(x) { sum(is.na(x)) }))

summary(train_complete)


## Normality Test

ggplot(train_complete, aes(SalePrice)) +
  geom_density() +
  scale_x_continuous(breaks = c(0,200000,400000,755000))


qqnorm(train_complete$SalePrice,main = "Normal Q-Q Plot",
       xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
       plot.it = TRUE)
qqline(train_complete$SalePrice)

train_complete_norm <- train_complete %>% mutate(SalePriceNorm = log(SalePrice))


# LogNormal Distribution of SalePrice

ggplot(train_complete_norm, aes(SalePriceNorm)) +
  geom_density() +
  scale_x_continuous(breaks = c(0,200000,400000,755000))


qqnorm(train_complete_norm$SalePriceNorm,main = "Normal Q-Q Plot",
       xlab = "Theoretical Quantiles", ylab = "Sample Quantiles",
       plot.it = TRUE)
qqline(train_complete_norm$SalePriceNorm)


train_complete_dummy <- dummy.data.frame(train_complete,sep='_')

ncol(train_complete_dummy)


#write.csv(summary(train_complete_dummy),"c.csv")


## Homoscedesticity Test

numeric_var_norm <- names(train_complete_norm)[which(sapply(train_complete_norm, is.numeric))]

train_complete_numeric <- train_complete_norm[,numeric_var_norm]

train_complete_numeric_melt <- melt(train_complete_numeric, id="SalePriceNorm")

ggplot(train_complete_numeric_melt,aes(x=value, y=SalePriceNorm)) +
  facet_wrap(~variable, scales = "free")+
  geom_point()

## Multiple Linear Regression

train_complete_dummy <- train_complete_dummy %>% mutate(SalePriceNorm = log(SalePrice))

SalePriceNorm_full = lm(SalePriceNorm ~ . - SalePrice, data = train_complete_dummy)


