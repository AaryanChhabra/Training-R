#DataTypes in R

#integer
x <- 2L
typeof(x)

# why to put this L ? - As in default R considers them as doubles.
# because that would make things less error.

x <- 2
typeof(x)

#double, ~anything with a decimal.
y <- 2.5
typeof(y)

#complex number
z <- 3 + 2i

#character

a <- "2L"
typeof(a)

#logical

q <- T
q <- F
typeof(q)

#using variable

A <- 10
B <- 5

C <- A + B
C

name <- "Aaryan"
greeting <- "Hello!"

#this gave a space in them automatically
to_show <- paste(name,greeting)
to_show

#if we don't want the space, we use paste0
to_show <- paste0(name,greeting)
to_show


# Use of logical operators:

result <- 4 < 5
result
4 != 5

# We also have on "!" - not variable,

result1 <- !TRUE
result1

#see how I used double not here to get the overall result to be neutral

result <- !(!(5>1))
result

# The use of OR and AND in this:

# This will give a TRUE if one of them is true::
check <- result | result1

# This will give TRUE, if both of them are TRUE:
check <- result & result1
check

# Simply checks if the variable inside is TRUE or not
isTRUE(result1)


# While loop:


while(FALSE){
  print("Hello")
}


counter <- 1
while(counter <= 12){
  print(counter)
  counter <- counter + 1
}

# see the value of the variable counter in updated outside
counter

# for loop

for(i in 1:5){
  to_print <- paste("Hello", i)
  print(to_print)
  }
 
# see it has made a frikin variable i outside:
i


# if statement:

# generates "n" random numbers, with mean "m" and st. dev "s"
#x <- rnorm(n, m, s)


rm(answer)
x <- rnorm(1)

# This is called nesting
if(x>1){
  answer <- "greater than 1"
} else{
    if(x >= -1){
      answer <- "Between -1 and 1"
      } else{
        answer <- "Less than -1"
      }
}


# Do observe the use of fancy curly brackets

answer

# we can use an else if to make our life simpler:
# Chaining statement

x <- rnorm(1)
if(x>1){
  answer <- "greater than 1"
} else if(x >= -1){
  answer <- "Between -1 and 1"
} else{
    answer <- "Less than -1"
  }

answer

# Homework Exercise:
# Law of Large Numbers

#The average of the actually measured value in our sample converges
#to the expected value of the measurement as n approaches infinity


# Normal Distribution
# keep in mind the 95% of data is within two st. deviation
# around 68% within 1 st. dev.


# We are going to test the law of large numbers here:

# To check if really 68.2% of data will fall in the 1 st. dev range
# and if really our mean will approach the expected the value?
rm(i)


N <- 10000
j <- 0

for( i in rnorm(N)){
  if(i > -1 & i < 1){
    j <- j+ 1
  }
}


fraction <- j/N
fraction

# AND indeed we see, it is working


# Time to check the mean:

N <- 100000000
summ <- 0

for( i in rnorm(N)){
  summ <- summ + i
}

mean <- summ / N

mean





