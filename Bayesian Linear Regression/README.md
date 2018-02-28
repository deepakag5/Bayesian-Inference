# Bayesian-Inference
Bayesian Data Analysis & Model Comparison 

The abstract was taken from the website Kaggle. I chose this specific problem because it provided me an opportunity to take an existing dataset and implement Bayesian Model Averaging (a Bayesian Approach) and compare it with different Bayesian models and also against the Multiple Regression Models calculated in the dataset.

I applied Multiple Linear Regression and Bayesian Linear Regression Techniques and compared the results. 

The R files contains one Driver file which is sourcing four other R files for specific tasks namely Data Cleaning and Preprocessing, Exploratory Data Analysis, Multiple Linear Regression and Bayesian Linear Regression. Mainly we have used pakages like Mice, dplyr, amelia, BAS, ggplot2.

I had two different data sets namely train dataset and test dataset. Both contained numerous variables in terms of features which were describing a house. The training dataset contained 1460 observations for which sale price of the house was provided. The test dataset contained 1459 observations for which the sale price needs to be predicted. 

Let's take a look at first few rows of the train dataset:

![1_data](https://user-images.githubusercontent.com/32446623/33156745-a645b68e-cfca-11e7-8046-5a9cbc79a37f.png)

Now we check the data structure of the columns:

![2_datastructure](https://user-images.githubusercontent.com/32446623/33157321-42369384-cfcf-11e7-8061-bd5b2c3c6e2c.png)

The dataset contained 23 nominal variables and 23 ordinal variables. Nominal Includes variables like the weather condition and material used for construction. For the nominal and ordinal variables, the levels were in the range of 2 to 28. Total of 14 discrete variables comprise the number of kitchens, washrooms, and bedrooms. This also includes the garage capacity and construction or re-modeling dates. 20 continuous variables describe the area dimension of each observation. Lot size and total dwelling square footage are common home listing available online. Area measurements on the basement, porches and main living area are further classified into respective classes based on quality and type.

Now let's check the missing data column-wise using missing map function of Amelia package:

![3_missingmap](https://user-images.githubusercontent.com/32446623/33157342-77a83ec8-cfcf-11e7-829c-f895ef6b1550.png)


By looking at data dictionary it was clear that for some columns values were not missing but they were labeled incorrectly. For example, I found that NA means = no basement, no garage, etc.; not that answer was unavailable. After labeling correctly, I still had missing values which can be viewed in updated Missing Map.

![4_missingmap](https://user-images.githubusercontent.com/32446623/33157349-7f60790a-cfcf-11e7-972f-e7fd5b58ce15.png)

Using dplyr we create columns which shows us missing values in the dataset and their respective percentages column-wise:

![5_missingvalues](https://user-images.githubusercontent.com/32446623/33157443-17c98312-cfd0-11e7-8e32-ea8c8ea4dad3.png)

As we have a small dataset and removing a good percentage (~17%) of observations is not prudent here. So, instead of removing these rows straightaway, I used mice package to impute data on basis of decision tree methods and checked whether data has been imputed in a sensible way. For numeric variables we check the ditribution and density of the columns with respect to another column with which it has some relationship. As we can see from below graphs that LotFrontage has been imputed in an expected manner.

![6_imputeddatascatter](https://user-images.githubusercontent.com/32446623/33157519-a81da6aa-cfd0-11e7-9b3d-196a0e4bcc82.png)

![7_imputeddatadensity](https://user-images.githubusercontent.com/32446623/33157528-af686346-cfd0-11e7-9167-7110e58ddaeb.png)

For categorical variables we can check the frequency:

![8_imputeddatacategorical](https://user-images.githubusercontent.com/32446623/33157601-50a16e56-cfd1-11e7-99c1-4fe8b1679ff8.png)

As we know to apply Linear Regression we should satisfy below assumptions :

Linear relationship
Multivariate normality
No or little multicollinearity
No auto-correlation
Homoscedasticity

Here, we check the relationship of numeric predictor variable with SalePrice by drawing scatter plots:

![10_salepricevsnumeric](https://user-images.githubusercontent.com/32446623/33157605-50cd8ca2-cfd1-11e7-8630-ce9fbc83243d.png)

For Categorical variables we draw box plots:

![11_salepricevscategorical](https://user-images.githubusercontent.com/32446623/33157606-50d8d9ae-cfd1-11e7-87a3-49de77969b0f.png)

To address multi-collinearity and auto-correlation we need check correlation between numerical variables. There should not be multi-collinearity in the linear models because it causes more noise in the data. To keep our model working correctly, I removed the variables like LotFrontage, FullBath, Garage Area which had strong correlation (>0.6 or <-0.6) based on our correlation plot.

![12_correlationplot](https://user-images.githubusercontent.com/32446623/33157607-50e67730-cfd1-11e7-9690-8e254d712caa.png)

For categorical variables we can use chi-square test


Let's check the distribution of response variable.  :

![9_salepricehist](https://user-images.githubusercontent.com/32446623/33157602-50acc4cc-cfd1-11e7-8661-ad17bf754a52.png)

As we can see, the histogram is skewed right (not normally distributed) as the outliers were present at the higher price range so we can apply square root, cube root or log transformation. We chose log as data is highly skewed.

Also, we draw a Quantile Plot which also shows that data is not noramally distributed.

![13_salepriceqqplot](https://user-images.githubusercontent.com/32446623/33157609-50f2e2fe-cfd1-11e7-8f69-f9df458e8d44.png)


Let's check the SalePrice again after applying log transformation.

![14_logsalepricedensity](https://user-images.githubusercontent.com/32446623/33157610-51027fac-cfd1-11e7-9daa-4b96e046e355.png)

![15_logsalepriceqqplot](https://user-images.githubusercontent.com/32446623/33157611-5115e1c8-cfd1-11e7-8e27-2d64bea31a34.png)


Let's again draw scatter plots for predictor variables with log transformed SalePrice :

![16_logsalepricevsnumeric](https://user-images.githubusercontent.com/32446623/33157613-513d9ed4-cfd1-11e7-9ace-b3fa310e37d0.png)

Now we apply multiple linear regression and see the summary of it:

![16_linearregression](https://user-images.githubusercontent.com/32446623/33157612-512a72be-cfd1-11e7-9526-acdf953ab080.png)

Also, check the residual plot:

![17_residualplot](https://user-images.githubusercontent.com/32446623/33157614-51597e1a-cfd1-11e7-873f-f096142d2472.png)
![18_residualqqplot](https://user-images.githubusercontent.com/32446623/33157615-516a81c4-cfd1-11e7-9eba-baabcba70db7.png)

Check the RMSE of Multiple Linear Regression :

![19_rmselinearregression](https://user-images.githubusercontent.com/32446623/33157616-51777d48-cfd1-11e7-9b81-97a161bd4453.png)


Let's apply Bayesian Linear Regression and check the results:

![20_bayesianlinearregression](https://user-images.githubusercontent.com/32446623/33157617-5184f50e-cfd1-11e7-9c9c-4f6f4165a10b.png)

We also take a look at the marginal posterior probabilities :

![20_bmacoefficients](https://user-images.githubusercontent.com/32446623/33157618-5192e952-cfd1-11e7-8e97-183d749675c2.png)

Also, we check the 95% confidence intervals for the coefficients:

![21_95percentconfidence](https://user-images.githubusercontent.com/32446623/33157619-51a34e28-cfd1-11e7-9559-94054e1e71ef.png)

We check the RMSE for different Bayesian Methods namely BMA, BPM, HPM, MPM :

![24_bayesianrmse](https://user-images.githubusercontent.com/32446623/33157623-51e12aa4-cfd1-11e7-9408-41877bb3c8cd.png)

Coming to the most important observation of Bayesian Analysis , we would also like to check the parameter probabilities and plot the beta coefficient posterior distribution for each feature. 

![22_posteriorbma](https://user-images.githubusercontent.com/32446623/36808324-be76b662-1c92-11e8-91d4-e5c9dc440d63.png)


![23_posteriorbma](https://user-images.githubusercontent.com/32446623/36808331-c5da9810-1c92-11e8-83ab-07b98a7112b7.png)



Notice how weakest features like “MasVnrArea”,"BedroomAbvGr","OpenPorchSF", have a large overlap with 0. In each plot the overlap is quantified by the height of the black vertical line extending up from x=0. While the significant variables like "Garagecars","GrLivArea","PoolArea", "EnclosedPorch","KitchenAbvGrd" don't have this vertical line and also the width of the distribution shows how significant that variable in idetifying target variable (Sales Price) here. The narrower the width, the more significant the distribution is which can be compared by looking at linear regression p-value coefficients.


Last but not the least, we check the scatter plot of actual vs predicted SalePrice:

![25_salepriceactual](https://user-images.githubusercontent.com/32446623/33157624-51f24d52-cfd1-11e7-85c2-214cf8b29e6f.png)

![26_actualvspredictedsaleprice](https://user-images.githubusercontent.com/32446623/33157625-5202fb02-cfd1-11e7-91e6-9d61c5295c21.png)


Conclusion

In our analysis, Bayesian Analysis (interval estimation) shows a clear edge over more traditional Multiple Linear Regression (point estimation or frequentist). I hope the above analysis was lucid and would have helped in understading Bayesian Data Analysis.




















