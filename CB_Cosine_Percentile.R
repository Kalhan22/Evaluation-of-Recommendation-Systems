#CB Recommendatiosn with Cosine Siimlarity and Percentile Measure

detach("package:RMySQL", unload=TRUE)
detach("package:sqldf", unload=TRUE)
library(RMySQL)
con <- dbConnect(MySQL(),user="root", password="mickey1992",dbname="dwh", host="localhost")
rs <- dbSendQuery(con, "select * from DWH.CB_PERCENTILE;")
data <- fetch(rs,n = -1)

detach("package:RMySQL", unload=TRUE)
library(sqldf)
joined_data <- sqldf("select a.user_id,a.movie_id,(rank*5)/9066 as percentile_rating,rating from data as a join all_movie_data as b on (a.user_id = b.user_id and a.movie_id = b.movie_id) ")


#RMSE
merged_data <- sqldf("select user_id,movie_id,rating,percentile_rating as pr_rating from joined_data")
merged_data_subset <- data.frame(merged_data$user_id,merged_data$movie_id,as.numeric(merged_data$rating),as.numeric(merged_data$pr_rating))
colnames(merged_data_subset) <- c("user_id","movie_id","rating","pred")
merged_data_subset$diff <- merged_data_subset$rating - merged_data_subset$pred
diff_data <- subset(merged_data_subset,rating == pred)
head(merged_data_subset)
merged_data_subset_clean <- na.omit(merged_data_subset)
sqrt(sum(merged_data_subset_clean$diff*merged_data_subset_clean$diff)/nrow(merged_data))





#Diversity
##Measuring Diversity Scores for Each Recommendation
##Content Based Recommendation System
setwd("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project")
data_cb <- read.csv("CB_wts.csv")
na.omit(data_cb)
colnames(data_cb) <- c("user_id","movie_id","wt")
require(plyr)
top_n <- ddply(data_cb, "user_id", function(x) head(x[order(x$wt, decreasing = TRUE) , ], 50))
na.omit(top_n)
num_row <- unique(top_n$user_id)

count <- 1

sum <- 0
while(count < length(num_row)){
  row <- top_n[count,]
  user_id_elem <- row$user_id
  mid_data <- subset(top_n,user_id == user_id_elem )
  na.omit(mid_data)
  i <-  1
  

  print(count)
  while(i<=50)
  {
    wt_one <- mid_data[i,]$wt
    
    j <- 1
    while(j<=50)
    {
      
      wt_two <- mid_data[j,]$wt
      wt_diff <- wt_one - wt_two
      j <- j+1
    }
    i <- i + 1 
    if(!is.na(wt_diff)){
      
      sum <- sum + wt_diff
      
    }
   
  }
  
  
  count <- count + 1 
}
print(sum/length(num_row))

