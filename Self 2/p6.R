#----------Section 6
setwd("E:/Training/Udemy/Datasets")
library(ggplot2)

movies <- read.csv("P2-Movie-Ratings.csv", stringsAsFactors = T)

colnames(movies) <- c("Film", "Genre", "CriticRating", "AudianceRating", "BudgetM", "Year" )

str(movies)
head(movies)

summary(movies)
# Observe Year is treated as a neumeric here, we need to convert it into a factor.

factor(movies$Year)

ggplot(data = movies, aes(x = CriticRating, y = AudianceRating )) + 
  geom_point()
#aes tells how do we want to map the data.

# add color , size

ggplot(data = movies, aes(x = CriticRating, y = AudianceRating, color = Genre, size = BudgetM )) + 
  geom_point()

#---------Plotting With Layers

p <- ggplot(data = movies, aes(x = CriticRating, y = AudianceRating, color = Genre, size = BudgetM ))

# here p is an object, and we add plotting layers on top of that

p + geom_line() + geom_point()

p + geom_point()

#------ Override Aes

p + geom_point(aes(size = CriticRating))


p + geom_point(aes(color = BudgetM))

# p itself is not changing, we override for  specific plot.

# We canoverrie x itself

p + geom_point(aes(x= BudgetM))

# Observe hoe the legend and labels stil remain the same.

p + geom_line(size = 1)

# Note how we didnt use aes in the bracket

#--------Mapping vs Setting
p <- ggplot(data = movies, aes(x = CriticRating, y = AudianceRating ))

p + geom_point()

# Adding Colors
# By mapping
p + geom_point(aes(color = Genre))

# By setting:

p + geom_point(color = "DarkGreen")

# I cant put this dark green in aes,,
# As R will map the color to an new variable called DarkGreen
# It will think DarkGreen is a category and will assign a color to that.
# So, I suppose if we want to use our data and give size and color accordingly, we use mapping.


#=--------- Histogram and Density charts

h <- ggplot(data = movies, aes(x = BudgetM))
h + geom_histogram(binwidth = 7, fill = "Green")


h + geom_histogram(binwidth = 7, aes(fill = Genre))

# Add a border
h + geom_histogram(binwidth = 7, aes(fill = Genre), color = "DarkBlue")

#-------Denity Chart

h + geom_density(aes(fill = Genre), position = "stack")
 

#------------Starting Layers tips..

t <- ggplot( data = movies, aes(x= AudianceRating))


tc <- ggplot( data = movies, aes(x= CriticRating))

tc + geom_histogram(binwidth = 7, fill = "White", color = "DarkBlue")

tc + geom_density(aes(fill = Genre), position = "stack")


#------Stat Transformation
p <- ggplot(data = movies, aes(x = CriticRating, y = AudianceRating, color = Genre ))

# We can fit a smooth curve to see the tend:


p + geom_point() + geom_smooth(fill = NA)



#---- Box Plots

bp<- ggplot(data = movies, aes(x=Genre, y = AudianceRating))

bp1 <- ggplot(data = movies, aes(x=Genre, y = CriticRating))

bp + geom_boxplot(size = 0.5) + geom_point(size = 1)

# A tip


bp + geom_boxplot(size = 0.5) + geom_jitter(size = 1)

# Fancy way

bp + geom_jitter(size = 1) + geom_boxplot(size = 0.7, alpha = 0.5)
  
bp1 + geom_jitter(size = 1) + geom_boxplot(size = 0.7, alpha = 0.5)


# ------- Factes

v <- ggplot(data = movies, aes(x =BudgetM))

v + geom_histogram(binwidth = 10, aes(fill = Genre) , color = "Black")


# Facets:

v + geom_histogram(binwidth = 10, aes(fill = Genre) , color = "Black") +
    facet_grid(Genre~., scales = "free")


# Apply to scatterplots:

w <- ggplot(data = movies, aes(x = CriticRating, y = AudianceRating, color = Genre))

w + geom_point(size = 3) + facet_grid(Genre~.)
 
w + geom_point(size = 3) + facet_grid(.~Year)

w + geom_point(size = 3) + facet_grid(Genre~Year)

w + geom_point(size = 2) + geom_smooth(fill = NA) +  facet_grid(Genre~Year)


w + geom_point(aes(size = BudgetM)) + geom_smooth(fill = NA) +  facet_grid(Genre~Year)


#--------- Coordinates::

# Limit our axis, # Zoom in our axis.

m <- ggplot(data = movies, aes(x = CriticRating, y = AudianceRating, size = BudgetM, color = Genre))

# To zoom in suppose to the higer x value:

m + geom_point() +xlim(c(50,100))

# But it would be illegal to use on histogram to limit the Y-axis
# as it will cutoff the important data.

# It is actually cutting out the data rather than zooming in

# to litrelly zoom in,

w + geom_point(aes(size = BudgetM)) + geom_smooth(fill = NA) +  facet_grid(Genre~Year) + coord_cartesian(ylim= c(0,100))


# Some final touch-ups-- THEME
h <- ggplot(data = movies, aes(x = BudgetM))

# AXIS LABEL

h + geom_histogram(binwidth = 7, aes(fill = Genre), color = "DarkBlue") +
  xlab("Money Axis") + ylab("Movie Number")
# Label formatting:


h + geom_histogram(binwidth = 7, aes(fill = Genre), color = "DarkBlue") +
  xlab("Money Axis") + ylab("Movie Number") + 
  theme(axis.title.x = element_text(color = "DarkBlue", size = 30),
        axis.title.y = element_text(color = "Red", size =30))

# Changing the axis text:


h + geom_histogram(binwidth = 7, aes(fill = Genre), color = "DarkBlue") +
  xlab("Money Axis") + ylab("Movie Number") + 
  theme(axis.title.x = element_text(color = "DarkBlue", size = 30),
        axis.title.y = element_text(color = "Red", size =30),
        axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 20))

?theme


# Legend Formatting:



h + geom_histogram(binwidth = 7, aes(fill = Genre), color = "DarkBlue") +
  xlab("Money Axis") + ylab("Movie Number") + 
  theme(axis.title.x = element_text(color = "DarkBlue", size = 30),
        axis.title.y = element_text(color = "Red", size =30),
        axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 20),
        
        legend.title = element_text(size= 30),
        legend.text = element_text(size= 20),
        legend.position = c(1,1),
        legend.justification = c(1,1))


# The position of the legned:

#justification means we want 1,1 of legend at 1,1 of th graph. 
# Here 1 is extreem right and 0 is extreem left

# For the title:
h + geom_histogram(binwidth = 7, aes(fill = Genre), color = "DarkBlue") +
  xlab("Money Axis") + ylab("Movie Number") +
  ggtitle("Movie Budget Distribution")+
  theme(axis.title.x = element_text(color = "DarkBlue", size = 30),
        axis.title.y = element_text(color = "Red", size =30),
        axis.text.x =element_text(size = 20),
        axis.text.y =element_text(size = 20),
        
        legend.title = element_text(size= 30),
        legend.text = element_text(size= 20),
        legend.position = c(1,1),
        legend.justification = c(1,1),
        
        plot.title = element_text(size = 40, family = "Courier"))


        