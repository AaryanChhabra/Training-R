# Section: purrr

setwd("E:/Training/DataCamp/purrr")
library(purrr)  # Simplify iterations without using for loop:
library(tidyverse)
# The map function:


# map takes two arguments: first is the .x argument - a list or a vector. 2nd is the .f argument
# that is a file

# Example:

bird_count <- list(c(1,2,4), c(3,7,3,2))

# We want to calculate the sum of each vector in the list.
# Using for loop

sum <- list()
for(i in 1:length(bird_count)){
  sum[[i]] <- sum(bird_count[[i]])
}

#OR

sum <- list()
for(i in seq_along(bird_count)){
  sum[[i]] <- sum(bird_count[[i]])
}

#--- OR We can simply use Purr code:

bird_sum <- map(bird_count, sum)


# Sub-setting lists:


df1 <- data.frame(cbind(c(1,2,3),c(3,2,1)))
df2 <- data.frame(cbind(c(1,2,3,4),c(3,2,1,2)))

listdf <- list(l1 = df2,l2 = df1)


list_new <- list()
list_new[["Data"]] <- df1
is.list(list_new["Data"])
is.data.frame(list_new[["Data"]])

# Suppose we have a list with each element is a data frame with 14 rows. We want to check the number of rows in 
# each data frame.


df_rows <- data.frame(names = names(listdf), row_no = NA)

for(i in 1:length(listdf)){
  df_rows[i,"row_no"] <- nrow(listdf[[i]])
}

df_rows

# this for loop will do the job, 
# lets try purrr

map(listdf, ~nrow(.x))

# its like running nrow(listdf[[i]]) for all elements in the list

# Many flavors of map()

# like in the previous example, the output is a list.

# to pull out the number as a vector, we use: map_dbl - gives out vector of doubles.
  
map_dbl(listdf, ~nrow(.x))

# So, if we want to put it in a dataframe with the names along:

df_rows <- data.frame(names = names(listdf), row_no = NA)
df_rows$row_no <- map_dbl(listdf, ~nrow(.x))

df_rows



# We can also use map_lgl to get a logical output:

map_lgl(listdf, ~nrow(.x) == 3)


# use of map_chr: Taking the character out of the list into a vector

list_chr <- list("Amazing", "Horse", "Race")
names(list_chr) <- c("Verb", "Animal", "Happen")

map_chr(list_chr, "Horse")


map_chr(list_chr, ~.x)

# Can i write a for loop for the same?

chr_vector <- c()
for(i in 1:length(list_chr)){
  chr_vector[i] <- list_chr[[i]]
}

# Yes, It can be done.

#------------------ Section 2 -----------------
# Working with un-nammed lists:

# Firstly what pipes (%>%) do?

a <- c(1,3,6,3,1)
# I want a seq ranging from 1 to length of this vector a

len <- length(a)
seq <- seq(1,len)
seq

# One can use pipes:

seq <- length(a) %>%
  seq()

# it took the output of the first line and used it as an input of the second line. And finally 
# store it in the variable we provided.



# lets explore more:
son_list <- list("Amazing", "Horse", "Race")

names(son_list) <- c("Adjective", "Noun", "Verb")

dad_list <- list(son_list)
#dad_list[[2]] <- "Bro"

# now I have a list (son list) inside  a list (dad list)

# we can use map_chr and give am additional argument that will go in the son list and look at the coorsponding entry


map_chr(dad_list, "Noun")

# I didnt yet set the name of the son_list in the dad_list:

dad_list

# I can extract the Noun from the son list and set that as a name for the son list.

dad_list <- set_names(dad_list[1], "Whorse")

#OR

names(dad_list)[1] <- "Whorse"

#names(dad_list)[2] <- "Family"

#OR

dad_list <- dad_list %>%
  set_names(map_chr(dad_list, "Noun"))


## Lets use some data
install.packages("repurrrsive")

library(repurrrsive)


film_data <- sw_films

film_data <- film_data %>%
  set_names(map_chr(film_data, "title"))


# It has many sub-lists, which have named elements - sub-lists have name "title", so, we want to
# give that name to the sub-list itself

names(sw_films)
names(film_data)


#----------Some other jobs by map()

# to simulate data:



listMeans <- list(1,4,53,22)
# We want to take these mean vlues and run 4 rnorm
# Just a refreshment :
# we already used this:

map(listdf, ~nrow(.x))

#putiing listdf[[i]] (for all avilable i) in the place of .x and giving out a list

# now

list_DataFrame <- map(listMeans,
                      ~data.frame(a = rnorm(mean= .x,
                                            n=5,
                                            sd = 2.5)))

# similarly it will put listMeans[[i]] (for all the available i) in the place of .x and will give out a list.

head(list_DataFrame)

is.data.frame(list_DataFrame[[1]])

# One more example to make things clear:



water_flow_Data <- list(c(1,57,322,21), c(44,6675,323,43), c(12567,5764553,25))

# I need to take sum of all and then take a log() transformation

map(water_flow_Data, ~.x %>% # Basically isolating each vector from the list.
      sum() %>% # that isolated vector is going inside the sum() function
      log()) # output from the sum function is going in the log() function.

# We can also make a df using pipe and map:


bird_measurements %>%
  map_df(~ data_frame(weight = .x[["weight"]], # Basically taking the bird_measurement list as input and isolating its each element
                      wing_length = .x[["Wing Length"]])) # making a data frame with column namens as mentioned and there must be some named list in the bird_measurement list.

#------------map2 and pmap

# When we have 2 lists, suppose 1 has mean and the other has the sd. map2 will help to make the rnorm

simdata <- map2(list_of_means, lost_of_sd, ~data.frame(a = rnorm(mean = .x, n= 20, sd = .y),
                                                       b = rnorm(mean = 200, n= 20, sd = 15)))

# We can use pmap we we have 3 or more lists

# we firstly need to create a list of all the lists we want to use as our input.


input_list <- lisr( mean = list_of_means, # we make an input list that contains all the list we want to gie as input
                    sd = list_of_sd, # also we name them
                    samplesize = list_of_samplesize)

simdata <- pmap(input_list, # we put our input list as first argument
                function(mean, sd, samplesize) # we make a manual function giving the names of the list inside it
                data.frame(a = rnorm(mean=means, n = samplesize, sd = sd))) # finally we feed in the names at the right place

# ---------- Section3------


# using safely() function to troublshoot problems in the list:


# When working with list, if one encounters an error, it can mess up big.

a <- list("Character", 11) %>%
  map(safely(function(x)
  x*10,
  otherwise = NA_real_))

a[[1]] # it has made a list for result; showing it's output and error.

# Without safely()

# We have no idea where the error occured

a <- list("Chraacter", 11) %>%
  map(function(x) x*10)

# we can use transpose function at the end to see al the errors together:

a <- list("Character", 11) %>%
  map(safely(function(x)
    x*10,
    otherwise = NA_real_)) %>%
  transpose()

# We diagnose the code with safely() and solve it with possibly()

# usage:

a <- list("Character", 11) %>%
  map(possibly(function(x)
    x*10,
    otherwise = NA_real_))

a # now, instead of showing the reason for error, it just used NA and procedded.

# The walk() function

walk(a, print) # it makes it more readable
# kinda map, but more clear







