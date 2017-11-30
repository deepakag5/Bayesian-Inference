bayesianModelAveraging <- function(train_preProcessed,test_preProcessed,significantVars){
  
# Create a subset of dataset on the basis of the significant numerical variables
train_complete_sub <- train_preProcessed[ ,significantVars]
test_complete_sub  <- test_preProcessed [ ,significantVars]

## Bayesian Approach

bma_SalePrice = bas.lm(log(SalePrice) ~ .-TotalBsmtSF, data = train_preProcessed[ ,significantVars], prior = "BIC", 
                       modelprior = uniform(), method = "MCMC")

print(summary(bma_SalePrice))

# Posterior Mean, Standard Deviation and Posterior Probabilities 

# ’BMA’ Bayesian model averaging, using optionally only the ’top’ models
# ’BPM’ the model that is closest to BMA predictions under squared error loss
# ’MPM’ the median probability model of Barbieri and Berger 
# ’HPM’ the highest probability model


estimatorResults <- data.frame(BMA=double(),BPM=double(),MPM=double(),HPM=double(),stringsAsFactors=FALSE)

for (estimatorName in colnames(estimatorResults)) {
  print(coef(bma_SalePrice,estimator = estimatorName))
}


## 95% credible intervals for these coefficients
confint(coef(bma_SalePrice,estimator = estimatorName),level = 0.95)

yPred <- fitted(bma_SalePrice, type = "response", estimator = "BMA")

exp_yPred <- exp(yPred)

graphics.off()

plot(train_complete_sub$SalePrice,exp_yPred,col=c('blue', 'green'), xlab = "Actual SalePrice",
     ylab = "Predicted SalePrice", main = "Predicted Vs Actual Saleprice", xaxt="n")

axis(1, at=seq(0,755000,100000), labels = c("0","150000","250000","350000","450000","550000","655000","755000"))


# Plotting the training dataset actual and predicted values
trainDF <- cbind(train_complete_sub,yPred=as.data.frame(exp_yPred))

plot.new()

p <- ggplot(aes(x=SalePrice,y=exp_yPred), data=trainDF) + xlab("Actual SalePrice") + 
  ylab("Predicted SalePrice") +  ggtitle("Predicted Vs Actual SalePrice") 

p1 <- p + geom_point() + scale_x_continuous(limits = c(0,755000),breaks = c(0,200000,400000,755000)) + 
  scale_y_continuous(limits = c(0,755000),breaks = c(0,200000,400000,755000))+
  geom_smooth()

plot(p1)



for (estimatorName in colnames(estimatorResults)) {
  testing_y<- test_complete_sub$SalePrice
  y_pred = predict(bma_SalePrice, test_complete_sub, estimator=estimatorName)$fit
  MSE <- mean((testing_y-exp(y_pred))^2,na.rm = T)
  RMSE <- MSE^0.5
  print(paste0("Root Mean Square Error ",estimatorName," ",RMSE,sep = ""))
}


}
