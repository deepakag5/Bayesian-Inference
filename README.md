# Bayesian-Inference
Bayesian Data Analysis and Model Comparison 

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






