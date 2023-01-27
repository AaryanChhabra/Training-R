"Hello World!!"
mydata <- read.csv(file.choose())
library(ggplot2)

ggplot(data = mydata, aes(x= carat, y = price, colour = clarity)) + 
  geom_point(alpha = 0.1) +
  goem_smooth()
