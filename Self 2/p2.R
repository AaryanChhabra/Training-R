
# ------------ Multiple Linear Regression:


setwd("E:/Training/Udemy/MachineLearning/Machine Learning A-Z (Codes and Datasets)/Machine Learning A-Z (Codes and Datasets)/Part 2 - Regression/Section 5 - Multiple Linear Regression/R")

company_data <- read.csv("50_Startups.csv")

# Profit is their dependent variable:


# So we have their investment in various areas, we want to see, which area majorly contributes to 
# more profits.


# Some conditions for Linear Regression: Linearity, Multivariate Normality, independence of errors, lack of multicollinearity, homoscedasticity.

# Dummy variables -- When working with categories, on need to create dummy variable in order to make sence of correlatin.

# Now like we have 2 categories, we cn assign them 0 and 1.

# The choice of assigned variable doesn't bias the result.
# One way to think about it is: Zero kinda becomes the default state and the 
# coefficient of the dummy variable becomes th e coefficient of switching from the default state 
# to the state we assigned 1.


# The dummy variable trap:

# We should not include all the dummy variable in the equation - as in that case we 
# would essentially be duplicating a variable.

# So, if we created 10 dummy variable, we should only include 9. As they all need to be independent.


# Multiple Linear Regression:
company_data$State <- factor(company_data$State)

library(caTools)

set.seed(12)
split = sample.split(company_data$Profit, SplitRatio = 0.8)

training_set <- company_data[split,]
test_set <- company_data[!split,]


regressor <- lm(formula = Profit ~ R.D.Spend + Administration Marketing.Spend + State)

# OR We can simply write

regressor <- lm(formula = Profit ~ . ,
   data = training_set)


summary(regressor)

# We see R.D.Spend have a good correlation with the profit.

# So we can modify our regressor to get some more insights, 



regressor <- lm(formula = Profit ~ R.D.Spend ,
                data = training_set)

summary(regressor)

y_pred <- predict(regressor, newdata = test_set)


library(tidyverse)

predVSreal <- cbind(test_set, y_pred) %>%
  dplyr::select(Profit, y_pred)# we can see them side by side - see its a good estimate.

#ggplot(data = predVSreal) + geom_point(aes(x= Profit, y = y_pred)) + geom_smooth(aes(x= Profit, y = y_pred), method = 'lm')


# Lets try backward elimination in choosing the important variables:

regressor <- lm(formula = Profit ~ R.D.Spend + Administration + Marketing.Spend + State, 
                data = training_set)


summary(regressor)
# Administration and State looks way too useless... Remove

regressor <- lm(formula = Profit ~ R.D.Spend + Marketing.Spend, 
                data = training_set)

# Both variables are coming out to be significant.

summary(regressor)

# Automatic Implementation:

backwardElimination <- function(x, sl) { # x being the dataset and sl is significance level
  numVars = length(x) # length is the no. of cols.
  for (i in c(1:numVars)){ # As we will repeat the thing the number of variables we have
    regressor = lm(formula = Profit ~ ., data = x) # Making regressor with all data x
    maxVar = max(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"]) # finding the variable with max p value ( we did 2: numVars as the first row is the interscept)
    if (maxVar > sl){
      j = which(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"] == maxVar) # selecting which row/variable has crossed Sl
      x = x[, -j] # Eliminating that variable - updating dataset
    }
    numVars = numVars - 1 # updating number of variables
  }
  return(summary(regressor))
}

SL = 0.05
dataset = dataset[, c(1,2,3,4,5)]
backwardElimination(training_set, SL)

