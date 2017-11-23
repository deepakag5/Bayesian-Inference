dataPreprocess <- function(df){
  
  ## Load the dataset
  
  dataSet <- read.csv(df,stringsAsFactors = T)
  
  head(dataSet)
  
  ## Summary and Structure of the data -- Descriptive Statistics
  
  str(dataSet)
  
  
  ## Convert the categorical columns as per Data Dictionary to factors 
  
  dataSet$OverallQual <- factor(dataSet$OverallQual,levels=c("1","2","3","4","5","6","7","8","9","10"))
  dataSet$OverallCond <- factor(dataSet$OverallCond,levels=c("1","2","3","4","5","6","7","8","9","10"))
  dataSet$Remodeled <- factor(ifelse(dataSet$YearBuilt!=dataSet$YearRemodAdd,1,0))
  dataSet$MSSubClass <- factor(dataSet$MSSubClass)
  dataSet$GarageYrBlt <- factor(dataSet$GarageYrBlt)
  dataSet$MoSold <- factor(dataSet$MoSold)
  dataSet$YrSold <- factor(dataSet$YrSold)
  
  ## Drop unnecessary variables
  notRequiredCols <- c("Id","YearBuilt","YearRemodAdd")
  
  
  dataSet <- dataSet[,!(colnames(dataSet) %in% notRequiredCols)]
  
  
  
  # Draw a missing map to see which columns have maximum NAs
  missmap(dataSet, col=c('red', 'green'), y.cex=0.6, x.cex=0.8)
  
  # Data Transformation - Convert NA which does not allude to Missing as per Data Dictionary to None
  
  naToNoneCols <- c("Alley","BsmtQual","BsmtCond","BsmtExposure","BsmtFinType1",
                    "BsmtFinType2","FireplaceQu","GarageType","GarageFinish","GarageQual",
                    "GarageCond","PoolQC","Fence","MiscFeature")
  
  dataSet[naToNoneCols] <- lapply(dataSet[naToNoneCols],as.character)
  dataSet[naToNoneCols][is.na(dataSet[naToNoneCols])] <- "None"
  dataSet[naToNoneCols] <- lapply(dataSet[naToNoneCols],as.factor)
  
  summary(dataSet)
  
  ######################################################
  ## Dealing with Missing Data
  
  # Again draw a missing map to see which columns have maximum NAs
  missmap(dataSet, col=c('red', 'green'), y.cex=0.6, x.cex=0.8)
  
  # Check number of NA in all the columns
  MissingValues <- as.data.frame(colSums(sapply(dataSet,is.na)))  
  
  # Convert ronames to columns
  MissingValues <- as.data.frame(setDT(MissingValues, keep.rownames = TRUE))
  
  # Rename the column names
  colnames(MissingValues) <- c("columnName","totalNA_Values")
  
  # Transform totalNA to percent, add it as column and arrange in descending order on the basis of it
  MissingValues <- MissingValues %>% 
    mutate_at(vars(totalNA_Values),funs(percentNA_Values=.*100/nrow(dataSet))) %>% 
    arrange(desc(percentNA_Values)) 
  
  # Check the top columns having maximum NA values 
  head(MissingValues,n=10)
  
  
  # Impute the Missing Data using Mice Package
  cat("Started...Imputing Missing Data")
  
  impdataSet <- mice(dataSet, m=1, method='cart', printFlag=FALSE)
  
  cat("....Finished...Imputing Missing Data")
  
  ## Check the variables imputed values
  
  # Some numeric variables
  xyplot(impdataSet, LotFrontage ~ LotArea)
  
  
  densityplot(impdataSet, ~LotFrontage)
  
  xyplot(impdataSet, MasVnrArea ~ MasVnrType)
  
  
  densityplot(impdataSet, ~MasVnrArea)
  
  # Some categorical variables
  table(dataSet$MasVnrType)
  
  table(impdataSet$imp$MasVnrType)
  
  table(dataSet$Electrical)
  
  table(impdataSet$imp$Electrical)
  
  
  # Use the imputed values in the original dataframe
  dataSet_complete <- complete(impdataSet)
  
  # Check if there are any more NA values
  sum(sapply(dataSet_complete, function(x) { sum(is.na(x)) }))
  
  summary(dataSet_complete)
  
  return(dataSet_complete)
  
}