##Trasnpose the Data to get the Item to Item Colloborative Filtering
all_movie_data <- read.csv("<Location>/FACT_RATING_PUSHED.csv")
nrow(all_movie_data)
head(all_movie_data)

install.packages('reshape')
library(reshape)
t(all_movie_data)
getwd()
setwd("<Location>")
transposed_data <- reshape(all_movie_data, direction = "wide", idvar="movie_id", timevar="user_id")

write.table(transposed_data,file = "FACT_RATING_transposed.csv",sep = ",",na = "")

##install.packages('RMySQL')
##library('RMySQL')
##con <- dbConnect(MySQL(),
##                 user="****", password="*****",
##                 dbname="***", host="****")
