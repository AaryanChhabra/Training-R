# Section 4 

# Basketball trends:

# Matrices: In R, tables are stored as matrices. It also has data of same type only.


# Building a Matrix:

v1 <- c("A", "B", "C", "D", "E", "F")
v1M <- matrix(data = v1, nrow = 2, ncol = 3, byrow = T)

# See, it converting a vector into a matrix, Kind o f bending it actually.
# Doing by rows or by column.

v1M[1,2]

# rbind() function:

r1 <- c("I", "am", "Learning")
r2<- c("I", "hope", "so")
r3 <- c(1,2,3)

rM <- rbind(r1,r2,r3)
rM

# Note how the numbers in r3 are converted into characters

# cbind() also performs the same way by binding things column by column.


#----------

# naming dimension:

# We can give name to our columns and rows:

# to call now, we can use:

matrix["row_name", "col_name"]


# We even have named vectors:

# again we can call the thing by 

v1["name"]

charlie <- 1:5

names(charlie) <- v1 <- c("A", "B", "C", "D", "E") 

charlie["D"]

# To clear the names:

names(charlie) <- NULL


# Giving names to matrix:


temp.vec <- rep(c("A", "B"), each = 3)
temp.mat <- matrix(temp.vec, 3, 2)

rownames(temp.mat) <- c("First", "Second", "Third")
temp.mat

# To edit a particular element:
temp.mat[1,2] <- "S"
#--------------

# Matrix operations:

# We can again perform the operations on each element like we did for vectors.

FieldGoals # gives the Goals per year
Games # gives the number of games a player played in a year

# To find the field goals per game

round(FieldGoals/Games, 2)

# But what name it keeps? here both rows and columns are named the same
# In both matrices, so no question about that.


# MATPLOT()

?matplot()

FieldGoals


# It plots the thing columnwise, so we need to traspose the matrix
# Without transposing its giving information more about 
# with each point on X- axis represents a player.
matplot(FieldGoals, type = "b", pch = 15:20, col = 1:10)
# Like observe preformace of Kobe( the first vertical thing on graph) is kinda wide spread and each point
# descrbes an year.

matplot(t(FieldGoals), type = "b", pch = 15:20, col = 1:10)
# after transposing, we can track the performacne of each player by year.
# We can just follow a line and see how a player did over years.
# So, in conclusion, Time better be as rownames()

legend("bottomleft", inset = 0.01, legend = Players, col = 1:10, pch = 15:20, horiz = F)

# Subsetting:

# Subsetting a matrix:
v1[1:3]
Games[1:3,4:7]
Games[c(1,3),c(4,7)]
A <- Games[,"2008"]
is.matrix(A)
is.vector(A)
A
# Observe, how "A" is no longer a matrix, it's now a named vector.
# The sq. brcket have this quality, which returns a named vector, as R guesses that, we must be needing 
# a vector as we want a 1D thing.

# If we want a matrix instead, we can False the drop option,


A <- Games[,"2008", drop = F]
A

# In what cases we might not want to drop the thing:

sub <- MinutesPlayed[1,, drop = F]
sub
matplot(t(sub), type = "b", pch = 16, col = 1)
legend("bottomleft", inset = 0.01, legend = Players[1], col = 1, pch = 16, horiz = T)

# observe how if I dont use drop = F, it will become a vector and the graph is messed up

sub <- MinutesPlayed/Games
sub
matplot(t(sub[1,,drop = F]), type = "b", pch = 16, col = 1)
legend("bottomleft", inset = 0.01, legend = Players[1], col = 1, pch = 16, horiz = T)

# As its no longer a matrix, one Axis has lost its meaning.
#----------------

# Creating a function::


# lets create a function for the graph we have been making:

myplot <- function(Feature, player_rows = 1:10){
  sub <- Feature[player_rows,, drop = F]
  matplot(t(sub), type = "b", pch = 15:25, col = 1:20)
  legend("bottomleft", inset = 0.01, legend = Players[player_rows], col = 15:25, pch = 1:20, horiz = F)
  
}

# In the function above, we have setted a default parameter,
# i. e. rows, so , I dont specify the ows, I will take all players.



myplot(Games)
# -----------------------
# Homework Dataset

FreeThrows <- rbind(KobeBryant_FT, JoeJohnson_FT, LeBronJames_FT, CarmeloAnthony_FT, DwightHoward_FT, ChrisBosh_FT, ChrisPaul_FT, KevinDurant_FT, DerrickRose_FT, DwayneWade_FT)

FreeThrows

#Remove vectors - we don't need them anymore
rm(KobeBryant_FT, JoeJohnson_FT, CarmeloAnthony_FT, DwightHoward_FT, ChrisBosh_FT, LeBronJames_FT, ChrisPaul_FT, DerrickRose_FT, DwayneWade_FT, KevinDurant_FT)
#Rename
rownames(FreeThrows) <- Players
#Rename
colnames(FreeThrows) <- Seasons

#Check the matrix
FreeThrows

FreeThrowAttempts <- rbind(KobeBryant_FTA, JoeJohnson_FTA, LeBronJames_FTA, CarmeloAnthony_FTA, DwightHoward_FTA, ChrisBosh_FTA, ChrisPaul_FTA, KevinDurant_FTA, DerrickRose_FTA, DwayneWade_FTA)
#Remove vectors - we don't need them anymore
rm(KobeBryant_FTA, JoeJohnson_FTA, CarmeloAnthony_FTA, DwightHoward_FTA, ChrisBosh_FTA, LeBronJames_FTA, ChrisPaul_FTA, DerrickRose_FTA, DwayneWade_FTA, KevinDurant_FTA)
#Rename the columns
colnames(FreeThrowAttempts) <- Seasons
#Rename the rows
rownames(FreeThrowAttempts) <- Players

#Check the matrix
FreeThrowAttempts


# Making the plotting function


myplot <- function(Feature , player_rows = 1:10){
  sub <- Feature[player_rows, , drop = F]
  matplot(t(sub), type = "b", pch = 15:25, col = 1:20)
  legend("bottomleft", legend = Players[player_rows], pch = 15:25, col = 1:20, horiz = F)
  
}


FreeThrows

myplot(FreeThrows/Games)
myplot(FreeThrows/FreeThrowAttempts)
myplot((Points-FreeThrows)/FieldGoals)


