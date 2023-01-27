# Section 2 

# Lists ~ it can store data of different type.

setwd("E:/Training/Udemy/Advanced R")

MU <- read.csv("P3-Machine-Utilization.csv")

summary(MU)
head(MU)

# Add a new column that gives the utilization ~

MU$Utilization <- 1 -  MU$Percent.Idle

# Handling Date and Time in R

# The date is kind of ambiguous: If it is American or European

# So, we use POSIX for removing this confusion.

# POSIXct measures the second passed from the start of the year 1970 ~ giving out an Integer.

as.POSIXct(MU$Timestamp, format = "%d/%m/%Y %H:%M")

# the use of lowercase and upper case can get a little weird.
# one can look at some examples by ?POSIXct

MU$POSIXtime <- as.POSIXct(MU$Timestamp, format = "%d/%m/%Y %H:%M")

head(MU)

# Lets rearrange columns

MU$Timestamp <- NULL
MU <- MU[,c(4,1,2,3)]

#-------- LISTS------

summary(MU)

MU$Machine <- factor(MU$Machine)
Machine_RL1 <- MU[MU$Machine == "RL1",]
summary(Machine_RL1)
# In this summary, we still see other factors ~ called legacy factor memory to remove that:

Machine_RL1$Machine <- factor(Machine_RL1$Machine)
summary(Machine_RL1)

util_stat_RL1 <- c(min(Machine_RL1$Utilization, na.rm = T)
                   , mean(Machine_RL1$Utilization, na.rm = T),
                   max(Machine_RL1$Utilization, na.rm = T))


util_under_90 <- which(MU$Utilization < 0.9)

# We just want to check if we have at least 1 machine falling below 90.



util_under_90_flag <- length(util_under_90) >= 1


list_RL1 <- list("RL1", util_stat_RL1, util_under_90_flag)

# Naming component of a list:


names(list_RL1) <- c("Machine", "Stats", "LowThreshold")

# We could have even guve the names in the first step:

list_RL1 <- list(Machine = "RL1", Stats = util_stat_RL1, LowThreshold = util_under_90_flag)

# Extracting component of a list:

#[] Will always return a list

# [[]] Will always return the actual component:


# $ same as [[]]


# returns 1 component that is a list.
typeof(list_RL1[1])

# Returns one component that is its object in the form of  a vector.
typeof(list_RL1$Stats)
typeof(list_RL1[[2]])

t <- list_RL1$Stats
is.double(t)

# Gives out 3rd element of the vector - Max Utilization.

list_RL1$Stats[3]
# OR
list_RL1[[2]][3]

# ------ Adding Or Deleting list components:


list_RL1[4] <-  "New Information"

#- Adding the unknown utilization hours in the list.

list_RL1$UnknownHours <- Machine_RL1[is.na(Machine_RL1$Utilization), "POSIXtime"]

# It added a new component to the list and gave her a name also.


# one fancy thing, if while adding a new component, I gave a number higher that needed.

list_RL1[10] <-  "New Information"

# It will make numbers in between to NULL.

# Removing a component of List:


list_RL1[4] <- NULL

# This Kinda shifted everything backwords. - It doesnt happen in Data frame unless we tell it to do So.

list_RL1[9] <- NULL


# We can even add a data frame to the list:

list_RL1$DATA <- Machine_RL1

summary(list_RL1)

# ----- Subsetting a list:

sublist_RL1 <- list_RL1[c(1:4, 9)]
list_RL1[c("Machine" , "Stats")]


# So, Basically [[]] are for accessing element of a list. [] is for subsetting.


# Creating a timeseries plot:

library(ggplot2)

p <- ggplot(data = MU)

p + geom_line(aes(x = POSIXtime, y = Utilization, color = Machine))

# Its still a mess, So add a facet

myplot <- p + geom_line(aes(x = POSIXtime, y = Utilization)) +
  facet_grid(Machine~.) + geom_hline(yintercept = 0.9, color = "Grey", size = 0.8, linetype = 6)

# We also added a fancy threshold line.

# We can even add a plot to the list.

list_RL1$myplot <- myplot

              