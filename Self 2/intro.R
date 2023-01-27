# Machine Learning - Section 1

setwd("E:/Training/Udemy/MachineLearning/Machine Learning A-Z (Codes and Datasets)/Machine Learning A-Z (Codes and Datasets)/Part 1 - Data Preprocessing/Section 2 -------------------- Part 1 - Data Preprocessing --------------------/R")

# Importing Dataset

coust_data <- read.csv("Data.csv")

# Data preparing - Missing Data
# Removing the lines with missing data? - not here / Taking the mean of the column,


mean_age <- mean(coust_data$Age, na.rm = T)
mean_salary <- mean(coust_data$Salary, na.rm = T)

coust_data[is.na(coust_data$Age), "Age"] <- round(mean_age)
coust_data[is.na(coust_data$Salary), "Salary"] <- round(mean_salary)


# While working with numerical data - we need to convert categorical
# data into factors 

# We can even choose the level we want to give to a particular category.

coust_data$Country <- factor(coust_data$Country)

coust_data$Purchased <- factor(coust_data$Purchased)

# Splitting data into training set and test set.


#install.packages("caTools")
library(caTools)

set.seed(123)
split = sample.split(coust_data$Purchased, SplitRatio = 0.8) # We put the thing which we want to predict after the $

# It gives a logical outcome.

training_set <- coust_data[split,]
test_set <- coust_data[!split,]

# Feature Scalling:

# We might need to scale the data before we proceede further - Standardize or Normalize.


training_set[,2:3] <- scale(training_set[,2:3])
test_set[,2:3] <- scale(test_set[,2:3])


# A trick, one can comment out multiple lines by control + shift + c

# Simple Linear Regression:

# I do know, what it is.



setwd("E:/Training/Udemy/MachineLearning/Machine Learning A-Z (Codes and Datasets)/Machine Learning A-Z (Codes and Datasets)/Part 2 - Regression/Section 4 - Simple Linear Regression/R")

salary_data <- read.csv("Salary_Data.csv")

# It simply has years of experience and salary:

library(caTools)

set.seed(123)
split = sample.split(salary_data$YearsExperience, SplitRatio = 2/3) # We put the thing which we want to predict after the $

training_set <- salary_data[split,]
test_set <- salary_data[!split,]


# The linear regression package we are going to use takes care of the feature scaling:


regressor <- lm(formula = Salary ~ YearsExperience,  # formula = dependent ~ independent variable 
                data = training_set)

summary(regressor)

# Predicting our test set results:


y_pred <- predict(regressor, newdata = test_set)

# Visualizing results:


library(ggplot2)

ggplot(data = training_set)+ geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
                color = "Red") + geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
                                           color = "Blue") + ggtitle("Salary Vs. Years of Experience (Training Set)") + xlab("Years Of Experience") + ylab("Salary")
# OR   


ggplot(data = training_set)+ geom_point(aes(x = YearsExperience, y = Salary), color = "Red") + geom_smooth(aes(x = YearsExperience, y = Salary), method = 'lm')
  

# Lets see hoe our model does on the test set:

ggplot()+ geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary),
                                        color = "Red") + geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)), # We dont chane this as our regressor is trainr=ed on the training set
                                                                   color = "Blue") + ggtitle("Salary Vs. Years of Experience (Test Set)") + xlab("Years Of Experience") + ylab("Salary")
# OR

ggplot()+ geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary), color = "Red") + geom_smooth(aes(x = training_set$YearsExperience, y = training_set$Salary), method = 'lm', color = "Blue") +
  ggtitle("Salary Vs Years Of Experience - on test set") + xlab(" Years Of Experience") + ylab(" Salary")


