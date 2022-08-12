getwd()

setwd( "D:/Mahmoud/Books/Data Science/Getting-and-Cleaning-Data-Course-Project/data")

library(tidyverse)


data <-list.files()

y<- data.frame()

for(i in data){
  Mean <- mean(scan(i), na.rm =T)

  Standard_deviation <- sd(scan(i),na.rm = T)

  Measurement <- str_remove(i, ".txt")

  x<-data.frame(Measurement,Mean,Standard_deviation)

  y<-bind_rows(x,y)
  
}


write.table(y,file = "tidy_data.txt",row.name=FALSE)
