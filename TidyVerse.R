# Introduction to tidyverse:
library(gapminder)
library(tidyverse)

deta <- gapminder
# Some Data modificaton

str(deta)
deta$year <- factor(deta$year)


#----- Filter 

fdeta <-deta %>%
  dplyr::filter(year == "2007")

fdeta <- gapminder %>%
  dplyr::filter(country == "United States")

# We need quotes around text, but not numbers.
# we can even apply multiple filter at once:

fdeta <- deta %>%
  filter(country == "United States" | year == "2007")

# this way it has all United states AND all 2007.

fdeta <- deta %>%
  filter(country == "United States" & year == "2007")

# OR

fdeta <- deta %>%
  filter(country == "United States" , year == "2007")

# this way it has data that has both US and 2007.


#------------ Arrange verb - sorts based on ascending or descending order.


fdeta <- deta %>%
  arrange(gdpPercap)

View(fdeta)


# to arrange in descending order:

fdeta <- deta %>%
  arrange(desc(gdpPercap))

head(fdeta)


# We can of course combine the two:

fdeta <- deta %>%
  filter( year == 2007) %>%
  arrange(desc(gdpPercap))

head(fdeta) # ~ will give the information about highest to lowest gdp in
# a particular year.


#-------- Mutate verb



fdeta <- gapminder %>%
  mutate(pop = pop/1000000) %>%
  rename(popM = pop)

# what on the left is being replaced by what is on the right.
# in one go I mutated a column and renamed it.


head(fdeta)


# We can add a new variable also.

fdeta <- gapminder %>%
  mutate(gdp = gdpPercap * pop)

head(fdeta)

# It created a new variable ~ Its just like mutating an existing 
# variable, instead here the variable didn't exist already.


# Visualizing with ggplot2:

library(ggplot2)

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

head(gapminder_2007)

p <- ggplot(data = gapminder_2007,  aes(x = gdpPercap, y = lifeExp))

p + geom_point()

# Lets be creative and look the difference in two years

head(gapminder)


gapminder_2007_1952 <- gapminder %>%
  filter(year == 2007 | year == 1952)

p <- ggplot(data = gapminder_2007_1952, aes(x = gdpPercap, y = lifeExp))

p + geom_point(aes(color = year)) 

# The graph kinda looks kinky, lets setup the x-coordinate. ~ one outlier kinda disturbing th beauty



p + geom_point(aes(color = year)) + xlim(c(0, 6000))

# We got our graph.
#--------- Log Scales

# Instead of cutting the right side of the x-xis, one can use a log scale.

p <- ggplot(data = gapminder_2007,  aes(x = gdpPercap, y = lifeExp))

p + geom_point() + scale_x_log10() +xlab("GPD per Cap (log)") + ylab("Life Expectancy")


#--------- Some additional things.

head(gapminder_2007)

p <- ggplot(data =gapminder_2007, aes(x = gdpPercap, y = lifeExp))

p + geom_point(aes(color = continent, size = pop))


#--------- Faceting:
# Now instead of dividing by color, we can make separate sub-graphs.




p <- ggplot(data =gapminder_2007, aes(x = gdpPercap, y = lifeExp))

p + geom_point() + facet_wrap(continent~.)
p + geom_point() + facet_wrap(.~continent)

# I am observing no difference between the above 2


p + geom_point() + facet_grid(.~continent)

# I am finding wrap to be better.


p <- ggplot(data =gapminder, aes(x = gdpPercap, y = lifeExp))

p + geom_point(aes(color = continent, size = pop)) + scale_x_log10()+
  facet_wrap(year~.)

# I have made a beautiful plot above, take a look.


#---------- Summarize verb


# Summarize many observation into a single thing

gapminder %>% 
  filter(year ==2007) %>%
  summarize(meanLifeExp <- mean(lifeExp),
            totalpop = sum(pop))

# I think this kinda summarizes by making a separate column for 
# each summary we want.



# ------ Grouping Verb

pp <- gapminder %>%
  group_by(year) %>%
  summarize(mL = mean(lifeExp))

pp

# The output of it is really amazing


pp <- gapminder %>%
  group_by(continent) %>%
  summarize(meanLE = mean(lifeExp))

head(pp)
# Some nice working with histogram and bar charts, 
# Suppose I have some descrete varibles, If i use geom_bar, it will see the 
# occurence of those names in that column and will make a graph.
# Suppose america occurs 3 times Spain occurs 2 times.


# But if I have some data coorrosponding to those names, I should use geom_col()

ggplot(data = pp , aes(x = continent, y = meanLE)) + geom_col( color = "Black", size = 1)

#OR

ggplot(data = pp , aes(x = continent, y = meanLE)) + geom_bar(stat="identity")

#========= Some fancy code

levels <- sample(LETTERS, 100, replace = TRUE)


ips <- sample(seq(100,999), 100, replace = TRUE)

ips

levels <- sample(LETTERS, 100, replace = TRUE)

data <- data.frame(ips, levels)

data


unique.levels <- sort(unique(data$levels))

count <- table(data$levels)

count.df <- data.frame(unique.levels, count)


plot <- ggplot(count.df, aes(unique.levels, Freq, fill=unique.levels))

plot + geom_bar(stat="identity") + 
  labs(title="Level Count",
       subtitle="count for every lvl played",
       y="Count", x="Levels") + 
  theme(legend.position="none")

#--------- Visulize summarizd data

pp <- gapminder %>%
  group_by(year) %>%
  summarize(totalp = sum(pop),
            mL = mean(lifeExp))
pp


ggplot(pp,aes(x= year, y = totalp))+ geom_point() +geom_smooth()



# We should expand the limits of y:

ggplot(pp,aes(x= year, y = totalp))+ geom_point() +geom_smooth() +
  expand_limits(y = 0)

pp <- gapminder %>%
  group_by(year, continent) %>%
  summarize(totalp = sum(pop),
            mL = mean(lifeExp))

gapminder
pp

ggplot(pp, aes(x= year, y = totalp, color = continent)) + geom_point() +
  expand_limits(y = 0) + geom_smooth()




# ____________--------- Line plots


ggplot(pp, aes(x= year, y = totalp, color = continent)) + geom_line( size = 1) +
  expand_limits(y = 0)




# BAR Plots:

pp <- gapminder %>%
  group_by(continent) %>%
  summarize(meanLE = mean(lifeExp))

ggplot(data = pp , aes(x = continent, y = meanLE)) + geom_bar(stat="identity")


# Histograms

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

ggplot(gapminder_2007, aes(x = lifeExp)) + geom_histogram()

#--------- Box Plot


ggplot(gapminder_2007, aes(a=continent, y = lifeExp)) + geom_boxplot()