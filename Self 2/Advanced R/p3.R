# Apply Function:
setwd("E:/Training/Udemy/Advanced R/P3-Weather-Data")

# Importing Data

Chicago <- read.csv("Chicago-F.csv", row.names = 1)
NewYork <- read.csv("NewYork-F.csv", row.names = 1)
Houston <- read.csv("Houston-F.csv", row.names = 1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names = 1)

is.data.frame(Chicago)

# We should convert it into a Matrix, as all data type is numeric 
# and we will need some features of a matrix.


Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)


weather <- list(Chicago, NewYork, Houston, SanFrancisco)
weather

# Giving names while making:

weather <- list(Chicago = Chicago, NewYork = NewYork, Houston = Houston, SanFrancisco= SanFrancisco)

weather$Chicago # Yes, working
weather[[3]][1,2]


# ----- Apply family of function:


apply(M, 1, mean) # Means apply function will apply the mean function to rows of the matrix M.

apply(M, 2, max) #Means apply the max function to the column of matrix M.

# ----- Using apply function:

# we want average for every row
apply(Chicago, 1, mean)


# Recreating apply function with a loop:

Chicago

# Finding mean of every row via loop:
output <- NULL
for(i in 1:5){
  output[i] <- mean(Chicago[i,])
}
names(output) <- rownames(Chicago)
output

# Using Apply function:

output <- apply(Chicago, 1, mean)
output

# there is also one predefined function - rowMeans
rowMeans(Chicago)


# LAPPLY Function:

?lapply
# Takes an object and applies a function and spits out a list.


Chicago
# To Transpose this matrix, we use the t function
t(Chicago)

# We can apply this t function to all thi matrix together like

t_weather <- lapply(weather, t)

# Like we want to add a new row to the matrix:

rbind(Chicago, NewRow = 1:12)

lapply(weather, rbind, NewRow = 1:12) # So, we can pass the optional parameters of the function like that.

lapply(weather, rowMeans)
# OR
lapply(weather, apply, 1, mean)




#------------ Combining lapply with [ ]

weather


# What if we want to take average of weather in January over all the cities

# Suppose I want the [1,1] entry for the each Matrix.

lapply(weather, "[", 1, 1) # What is happening here is :- As lapply will go through each 
                           #  matrix, we are giving it a square bracket - as we need not to give it two. 
                          # Then we are passing the argument to go inside the sq bracket. that is [1,1]

# If I wanted the first row of each Matrix:

lapply(weather, "[", 1,)

lapply(weather, "[", ,3)


# Adding your own functions:

p <- function(x){
  x[1,]
}

p(Chicago)

lapply(weather,p)


#we could have done it in one line:

lapply(weather, function(x) x[1,]) # simply a fancy way of asking to get [1,] for each matrix in list.

lapply(weather , function(z) z[1,] - z[2,]) # gives us the difference between high and low temp:

lapply(weather , function(z) round((z[1,] - z[2,])/z[2,], 2)) # Gives us the fluctuation temperature

# As there are various scales of temperature - the result we are getting here is more usefull in sort of comparing 
# rather that absolute conclusion.

# lemme  try to understand it stepwise:

fluct <- function(x){
  p = (x[1,] - x[2,])/x[2,]
  p = round(p,2)
  p
}

lapply(weather, fluct)

#---- sapply function: A Simpler Version of lapply ~ thus the name.

# like in the case of lapply, we were doing:

lapply(weather, "[", 1, 7)

sapply(weather, "[", 1, 7) # returns the same thing but now in the form of a named vector.

# If a thing cant go in a vector, it gives them in a matrix:

sapply(weather, "[", 1, 10:12) 

lapply(weather, rowMeans)
# VS
p <- sapply(weather, rowMeans)
is.matrix(p)

# Lets do same for the fractional chhange:

fluct <- function(x){
  p = (x[1,] - x[2,])/x[2,]
  p = round(p,2)
  p
}

sapply(weather, fluct)

#------  Nesting apply function:

# How to get the max of each row?

lapply(weather, apply, 1, max) # I did it by myself though

# Could have also done it like:

lapply(weather, function(x) apply(x, 1, max))

sapply(weather, function(x) apply(x, 1, max))

# Which.max() nd which.min() function.

# So like we did for max and min, and we got some values -  but now we want, when was the highest and the lowest temp.

max(Chicago[1,]) # gives us the max value 
which.max(Chicago[1,]) # Gives us the name of the max value.

apply(Chicago, 1, function(x) names(which.max(x)))


# Now can apply it to the whole list:

sapply(weather, apply, 1, function(x) names(which.max(x)))

#oR

sapply(weather, function(y) apply(y, 1, function(x) names(which.max(x))))

       