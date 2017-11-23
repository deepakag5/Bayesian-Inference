multipleLinearRegression <- function(train_preProcessed,test_preProcessed,significantVars){

# Create a subset of dataset on the basis of the significant numerical variables
train_complete_sub <- train_preProcessed[,significantVars]
test_complete_sub <- test_preProcessed[,significantVars]


## Multiple Linear Regression

SalePriceNorm_Full = lm(log(SalePrice) ~ .-TotalBsmtSF , data = train_complete_sub)

print(summary(SalePriceNorm_Full))

plot(SalePriceNorm_Full)

testing_y<- test_complete_sub$SalePrice
predicted_y<- predict(SalePriceNorm_Full,test_complete_sub)
MSE<- mean((testing_y-exp(predicted_y))^2,na.rm = T)
RMSE <- MSE^0.5
paste("Root Mean Squared Error",RMSE)



}




