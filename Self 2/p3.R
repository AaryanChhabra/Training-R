# Section 3

# Vectors:

#Sequence of elements of same data type.

# Keep in mind, the indexing starts from 1

# A character in vector:

vector1 <- c("Yes", "No", 7)
vector1

typeof(vector1[3])

#As we can't mix the data types in a vector.
# Notice, how the number 7 is converted into a type character.
# As in that vector, other stuff was a character.

# An important thing to note here is: even a single number that we give 
#is stored as a vector

#---------------------

# "c" stands for combine by the way

vector1 <- c(1,2,3,4,3,2,1)
is.numeric(vector1)
is.integer(vector1)
# Spits as FALSE as it by default it stores as double.
is.double(vector1)

vectorInteger <- c(1L,2L,3L)
is.numeric(vectorInteger)
is.integer(vectorInteger)
is.character(vectorInteger)



seq(1,15) # creates a sequence of number from 1 to 15
1:15 # Also works in the same way

# But the seq function gives us an additional parameter - a step
seq(1,15,2)

rep(3,50) # Will create a vector of length 50, containg just 3

rep(NA, N) # Might come handy I suppose

# We can even replicate a character
rep("A", 100)

# We can even replicate a vector.

x <- c(1,2,3)
rep(x, 10)


#--------

# Use of [] 

w <- c("e","d","c","b","a")
w[3]

# IMP # To call all except the first one:
w[-1]


# To call element 1 to 3
w[1:3] # OR
w[seq(1,3)]
w[-1:-3] # Will remove the 1st to 3rd positioned elements


# what if we go out of the limit:
w[1:7] # It shows NA

# Some useless stuff pops out when we put index 0.
w[0]
  

#------------

# Vectorized Operation:

# Vector Arithmetic:
# Easy to compare vector element by element: even boolian operations

v1 <- c(1,5,2,6,3,1,2)
v2 <- c(5,6,7,4,3,1,3)

v1>v2

# Recycling of vectors:

v1 <- c(1,5,2,6,3,1,2,2,3,4,5,6,5,7)
v2 <- c(5,6,7,4,3,1,3)

v1+v2
# If it's a proper multiple, it won't even show an error.

v1>v2

# Vector even works with functions.

#----------------- 


N <- 100
x <- rnorm(N)
y <- rnorm(N)


# Vectorized approach: Faster approach
z <- x*y

#De-vectorized approach:
d <- rep(NA,N)

for(i in 1:N){
  d[i] <- x[i] * y[i]
}

# Why the vectorized approach is faster?
# Turns out R runs code in bg by giving it to already written code in 
# C or FORTRAN - so, when doing vectorized operation, it knows that
# all element are of the same type, so , it doesn't have to give detail of each.

#--------


# Functions in R

# we have been working with functions only so far.

c()
seq()
paste()
is.numeric()
typeof()
sqrt()


# To dig deeper

?seq()

# So, in seq, we can even mention the length of seq. 
# we want, it will calculate the step by itself.

seq(0,100, length.out = 51)

# Can use along.with to get length identical to a vector
x <- c("a", "b", "c")
seq(10, 20, along.with=x)

?rep

rep(c("a", "b"), each = 5) 

rep(c("a", "b"), times = 5) 

# Observe the difference between the two and see what "each" did

#--------------------
# Packages in R

# Packages are the collection of R function, data, compiled code.
# Library is the directory where the packages are stored.
 
# ------------ HOMEWORK -----------


# Financial Statements


#Data
revenue <- c(14574.49, 7606.46, 8611.41, 9175.41, 8058.65, 8105.44, 11496.28, 9766.09, 10305.32, 14379.96, 10713.97, 15433.50)
expenses <- c(12051.82, 5695.07, 12319.20, 12089.72, 8658.57, 840.20, 3285.73, 5821.12, 6976.93, 16618.61, 10054.37, 3803.96)

#Solution

"""Scenario: You are a Data Scientist working for a consulting firm. One of your
colleagues from the Auditing department has asked you to help them assess the
financial statement of organisation X.
You have been supplied with two vectors of data: monthly revenue and monthly
expenses for the financial year in question. Your task is to calculate the following
financial metrics:
- profit for each month
- profit after tax for each month (the tax rate is 30%)
- profit margin for each month - equals to profit a after tax divided by revenue
- good months - where the profit after tax was greater than the mean for the year
- bad months - where the profit after tax was less than the mean for the year
- the best month - where the profit after tax was max for the year
- the worst month - where the profit after tax was min for the year"""

#______My Poor Solution_______


profit <- revenue - expenses
profit_taxed <- profit - profit*(0.3)

m_profit <- mean(profit_taxed)

good_months <- c()
bad_months <- c()
best_month <- c()

j <- 1

for(i in profit_taxed){
  if(i > m_profit){
    good_months[j] <- j
    if( i == max(profit_taxed)){
      best_month[j] <- j
    }
  } else{
    bad_months[j] <- j
    }
  j <- j +1

  }

good_months <- good_months[!is.na(good_months)]


#-------My Good Solution----------


# A good solution would use logical operator

profit <- revenue - expenses
pat <- profit - profit*(0.3)

pat_m <- mean(pat)
good_months <- pat > pat_m
bad_months <- pat < pat_m
best_month <- pat == max(pat)

# We are getting logical value
# To find the index of the good and bad months:

good_months <- which(good_months, arr.ind = TRUE)


