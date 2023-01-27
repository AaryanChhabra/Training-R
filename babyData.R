library(tidyverse)


babynames <- readRDS("E:/Training/DataCamp/babynames.rds")
head(babynames)
tail(babynames)


# We can filter for multiple names at once:

babynames <- babynames %>%
  filter(name %in% c("Amy", "Zyrell"))

# OR 

babynames <- babynames %>%
  filter(name == "Amy" | name == "Zyrell")

# but I think it's better to learn the first one



# What name was most common:

babynames %>%
  group_by(name) %>%
  top_n(1, number)

# So, yhis will give us, in each name - the row coorsponding 
# to maximum muber ~ thus spitting out the year in which that 
# name was most common.


# ------  Grouped Mutates:

# We are now interesten in what percentage of people
# born in that year have that name.

# we can use this to get the total number of babies in each year:


babynames %>%
  group_by(year) %>%
  summarize(sum_of_eachYear = sum(number))

# We can make a seperate column for the same using mutate:

babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate( fraction = number/ year_total)

# No, getting a visualization of the fraction is better that  total as the total population
# will affect the graph. Suppose the initial population is low, then it would automatically 
# emply that the number of particular baby names are low. 

# and when we see low baby name number ~ we would think they were less popular, but that might not be
# necessarily true.



#---------- Window functions

# Looking at the biggest changes in each name:


# there is something called a lag function:
# See its use:

v1 <- c(1,2,4,7,11,16,22)
v2 <- lag(v1)


#it shifted each numbeerto the next right position

#now we can compare the two.
v1-v2

# Similarly lets do for babynames.

babynames_fraction <- babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate(fraction = number / year_total)


# Biggest jump in the name Mathew


babynames_fraction %>%
  filer(name == "Matthew") %>%
  arrange(year) %>%
  mutate(difference = fraction - lag(fraction)) %>%
  arrange(desc(difference))

# looking at changes in every name:

babynames_fraction %>%
  arrange(name, year) %>%
  mutate(difference = fraction - lag(fraction)) %>%
  group_by(name) %>%
  arrange(desc(difference))































