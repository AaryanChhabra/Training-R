# dplyr in some depth

library(dplyr)
library(tidyverse)

counties


filtered <- counties %>%
  select(state, county, population, unemployment) %>%
  arrange(desc(population))


# -------- Count Variable:


View(counties)


counties %>%
  count(state)

# This gives an idea about how many counties ar there in each state ~ simply by looking at the number of times 
# a state appears in the state column.

# We can also add sort parameter in the count, it will arrange according to the most common to the least.


# ONE AMAZING THING:

# if instead we want to count not only the occurence in the column, but we want to look for some other variable, we use weight.

counties %>%
  count(state, wt = population, sort = T)

#OR

counties %>%
  group_by(state) %>%
  summarise(n = sum(population)) %>%
  arrange(desc(n))


# -------- Groupby and summarize


counties %>%
  group_by(state) %>%
  summarize(total_pop = sum(population),
            avg_unemployment = mean(unemployment))

# We can subgroup by adding another parameter in group_by

counties %>%
  group_by(state, metro) %>%
  summarize(total_pop = sum(population),
            avg_unemployment = mean(unemployment)) %>%
  ungroup()


# Always a good habit to un-group after grouping

#-------- 

#looking at most extreme observation from each group:

counties %>%
  select(state, county, population, unemployment) %>%
  group_by(state) %>%
  top_n(1, population)
# This will display top "1" row that has max population. So, we will get to see its 
# county, unemployment..

# beneficial in visualization - in pulling the extreme examples.

#---------- Selecting and Transforming Data

# we can directly select a range of columns, using

counties %>%
  select(state, county, drive:walk)



# Or we can select columns that have a specific word in them :


counties %>%
  select(state, contains("work"))


# Or use " starts_with() " to select the columns that start with a particular word.


# we can remove a column by simply:

counties %>%
  select(-walk)

 
# Gives every colum except walk.


#----- rename the columns


counties %>%
  select(state, county, population, unemployment) %>%
  rename(Unemployment_Rate = unemployment)

# we can simentaniously select and rename:


counties %>%
  select(state, county, population, Unemployment_Rate = unemployment)
  

#--------- transmute verb: A combinaton of select and mutate.



counties %>%
  transmute(state, county, population, unemployment_Per_population = unemployment / population)



