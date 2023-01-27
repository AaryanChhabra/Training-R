# Advanced Analytics in R for data science.
setwd("E:/Training/Udemy/Advanced R")
library(tidyverse)

fin <- read.csv("P3-Future-500-The-Dataset.csv", stringsAsFactors = T)

# Considering empty space as NA

fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings = c(""), stringsAsFactors = T)

head(fin)
str(fin)

# ID and Inception are taken as an integer here, we dont want that tbh.
# revenew and expenses are taken as Factors ~ shouldnt be the case.

# So, changing from a non factor to a factor.

fin$ID <- factor(fin$ID)
fin$Inception <- factor(fin$Inception)


# The factoe variable trap:

# Comes when converting a factor to a non factor:

# Like we have characters 

a <- c("1","2","4","6")
typeof(a)

b <- as.numeric(a)
typeof(b)

# Convertig factors into numeric:


z <- factor(c("1","2","4","4"))

y <- as.numeric(z)

# See how it is messed up:
y

# It is actually spitting out the numeric assiged to the factors, like 3 was assigned 
# to 4, so it came like that

# So, how to deal with this:
# First convert it into character, then into numeric:


y <- as.character(z)
y <- as.numeric(y)
y

#------ Sub and gSub functons

# sub replaces one instance and gsub replaces all, here we will use gsub.


fin$Expenses <- gsub(" Dollars", "", fin$Expenses)

# woring ~ first is the patten we are looking for, 2nd is the replacement, 3rd is
# where are we looking for this pattern.


# Lets replace the commas also,

fin$Expenses <- gsub(",", "", fin$Expenses)

# to remove the dollar sign, we do:
# we need to use \\ as dollar itself is a special character. ~ escape sequence

fin$Revenue <- gsub("\\$", "", fin$Revenue)

fin$Revenue <- gsub(",", "", fin$Revenue)


head(fin)

fin$Growth <- gsub("%", "", fin$Growth)

fin <- fin %>%
  rename(Growth_Percentage = Growth)


# converting all into numeric:

fin$Expenses <- as.numeric(fin$Expenses)
fin$Growth_Percentage <- as.numeric(fin$Growth_Percentage)
fin$Revenue <- as.numeric(fin$Revenue)

# ----------- Dealing with Missing Data:

# Ways to deal with it:
# 1. Predict with 100% Accurcy OR Leave the record as is OR Remove the record entirely
# OR replace with mean/median OR Filling by fitting a model 

# we can take different approaches based on the scenario.

# ------------ What is an NA ?

# it's also a logical variable.

# the logic is simple, as we dont know, so,we can put T or F. So we put NA

# We cant even compare them, as we  don't know:

NA == NA
NA == FALSE
NA == TRUE
NA == 4

# As we are not sure about any of this, it will spit out NA

# ------ Locating Missing Data:

head(fin, 34)
# we have got some empty spaces, Some NA, some <NA>.

# To pull out these rows,


complete.cases(fin) # It will give out T/F values, regarding completeness of the rows.

# So to pick out these rows,

fin_UC <- fin[!complete.cases(fin),]

# But the issue is, it consideres NA only, it doesnt pick empty space as an missing value.

# we can deal with this while importing:

fin <- read.csv("P3-Future-500-The-Dataset.csv", na.strings = c(""), stringsAsFactors = T)

# Now it will replace everything that in mentioned in the na.string function, as NA.

# These <NA> are used for missing values in Factors. Because what if the category name is NA itself.

head(fin ,24)

str(fin)


# Using which():


fin[fin$Revenue == 9746272,]

# We observe 2 NA rows poping up in this. Why so?
# This is the R way of telling that there are 2 rows which are missing the value for this variable.
# It even puts NA in rest of the entries, as if it had values, that would have mis-guided us.

# To solve this issue:



which(fin$Revenue == 9746272)

# Which also ignore NA

# So we will get row numbr as output.

# to get the whole row as an output, of course:
 
#fin[which(fin$Revenue == 9746272),]

fin[which(fin$Employees == 45),]

#OR

fin %>%
  filter(Employees == 45)

#------- Using is.na:


fin$Expenses == NA
# As we cant compare something with NA , we get a vector of NAs

fin[fin$Expenses == NA,]
# Look at its outcome and ponder.

# We use is.na() instead:
fin[is.na(fin$Expenses),]
fin[is.na(fin$State),]



fin[which(fin$Expenses == NA),] # This does not work !!

#-------- Removing record with Missing DATA


# A good habit is to make a backup of the data set before doing this.


fin_backup <- fin

# this will remove the rows with NA in them
fin <- fin[!is.na(fin$Industry),]

# -------- Resetting Data frame Index:

# We see, even after shuffeling the rows, the inital row number is stil there.

rownames(fin) <- 1:nrow(fin)

OR 

rownames(fin) <- NULL

# This will reset the row names:

# ------ Factual Analysis Method:

# Sometimes we are certain about an entry, but it is missing in the dataset.

# Lets firstly see the rows with NA in them:


fin[is.na(fin$State),]

# We can ofcourse do it one by one, but that might get tedious.

# So, other way to do it is in reference to another column. Like If the city column in New York, put NY in State.

fin[is.na(fin$State) & fin$City == "New York", "State"] <- "NY"

fin[is.na(fin$State) & fin$City == "San Francisco", "State"] <- "CA"


# In this, we choose the rows where state is NA and city is new york. and then we choose State as the column we want to edit.
# then given it the character "NY".

# ------ Median Imputation Method:


# Like we have to fill a missing value in a column off number of employees. A good way to di it to fll it with
# the median value of all the entries that belong to the same idustry, as this missing entry belong to.


median(fin[,"Employees"], na.rm = T) # Gives the median of the column employee, and we removed NA as the mess up the result

median(fin[fin$Industry == "Retail", "Employees"], na.rm = T) # Gives us median of Employees belonging to Retail Sector only.


med_emp_retail <- median(fin[fin$Industry == "Retail", "Employees"], na.rm = T)


fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_emp_retail

# Check:
fin[3,]


# Doing same for Financial Services:

median(fin[fin$Industry == "Financial Services", "Employees"], na.rm =T)
median(fin[,"Employees"], na.rm = T) 

med_emp_fin <- median(fin[fin$Industry == "Financial Services", "Employees"], na.rm =T)

fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- med_emp_fin


# ------- Part 2

fin[!complete.cases(fin),]


fin[is.na(fin$Growth_Percentage) & fin$Industry == "Construction", "Growth_Percentage"] <- median(fin[fin$Industry == "Construction", "Growth_Percentage"], na.rm = T)


# To deal with NA in revenew and Expenses:

med_rev_con <- median(fin[fin$Industry == "Construction" , "Revenue"], na.rm = TRUE)
fin[is.na(fin$Revenue) & fin$Industry == "Construction", "Revenue"] <- med_rev_con

# Similar for expenses:


med_rev_con <- median(fin[fin$Industry == "Construction" , "Expenses"], na.rm = TRUE)

# take some time out to think why I have added an external filter of profit to be NA in the code below.
fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit), "Expenses"] <- med_rev_con


#-------

# Finding the profit by subtracting the two:

fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue"] - fin[is.na(fin$Profit), "Expenses"]

fin[!complete.cases(fin),]

# Just putting the last bit - Expenses:

fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]



fin[!complete.cases(fin),]

# Just one row is left and nothing we can do about it, so leaving it as is.



# --------- Visualization:

library(ggplot2)

p <- ggplot(data = fin)

p + geom_point(aes(x = Revenue , y = Expenses, colour = Industry, size = Profit))

d <- ggplot(data = fin, aes(x = Revenue , y = Expenses, colour = Industry))

d +geom_point() + geom_smooth(fill = NA, size = 1.1)


# Making a box plot:

f <- ggplot(data = fin, aes(x = Industry, y = Growth_Percentage, color = Industry))

f + geom_boxplot()











