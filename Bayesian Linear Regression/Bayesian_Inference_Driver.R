## Load and install the required libraries

load.libraries <- c('Hmisc','mice','Amelia','data.table', 'testthat', 'gridExtra', 'corrplot', 
                    'GGally', 'ggplot2', 'e1071', 'dplyr','reshape2','dummies','BAS')

install.lib <- load.libraries[!load.libraries %in% installed.packages()]

for(libs in install.lib) install.packages(libs)

sapply(load.libraries, require, character = TRUE)

# Source the required files
source("dataPreprocess.R")
source("exploratoryDataAnalysis.R")
source("multipleLinearRegression.R")
source("bayesianModelAveraging.R")

# Train Data File
trainDatasetFile = "train.csv"

# Test Data File
testDatasetFile = "test.csv"

# Preprocess Train Dataset
train_preProcessed <- dataPreprocess(trainDatasetFile)

# Exploratory Data Analysis of Train Dataset
significantVars <- exploratoryDataAnalysis(train_preProcessed)

# Preprocess Test DataSet
test_preProcessed <- dataPreprocess(testDatasetFile)

# Apply Frequentist Approach - Multiple Linear Regression
multipleLinearRegression(train_preProcessed,test_preProcessed,significantVars)


# Apply Bayesian Approach - Bayesian Model Averaging
bayesianModelAveraging(train_preProcessed,test_preProcessed,significantVars)
