##Trasnpose the Data to get the Item to Item Colloborative Filtering
all_movie_data <- read.csv("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/FACT_RATING_PUSHED.csv")
nrow(all_movie_data)
head(all_movie_data)

install.packages('reshape')
library(reshape)
t(all_movie_data)
getwd()
setwd("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/")
transposed_data <- reshape(all_movie_data, direction = "wide", idvar="movie_id", timevar="user_id")

write.table(transposed_data,file = "FACT_RATING_transposed.csv",sep = ",",na = "")

##install.packages('RMySQL')
##library('RMySQL')
##con <- dbConnect(MySQL(),
##                 user="root", password="mickey1992",
##                 dbname="dwh", host="localhost")
##Test Random Query
##Useful Link https://www.r-bloggers.com/mysql-and-r/
##rs <- dbSendQuery(con, "select * from DWH.FACT_RATINGS LIMIT 10;")
##data <- fetch(rs)
##Testing ends