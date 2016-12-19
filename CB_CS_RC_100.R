#Evaluation Metrics for CB Results

#Precision
##Precision and Recall Calculation for the CB Results.

##Methodology: Get Top 100 Recommendations from the list. Check on the training set
install.packages('sqldf')
library(sqldf)
all_movie_data <- read.csv("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/FACT_RATING_PUSHED.csv")

setwd("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project")
data_cb <- read.csv("validation_CB_movie_rating_short.csv")
nrow(data_cb)
require(plyr)
colnames(data_cb)

usage_pred <- rbinom(810197, 1, 0.5)
data_cb <- cbind(data_cb,usage_pred )
predicted_data_top_n <- ddply(data_cb, "user_id", function(x) head(x[order(x$rating_prediction, decreasing = TRUE) , ], 100))

head(predicted_data_top_n)

##
##Precision Calculation
x <- sum(predicted_data_top_n$usage_pred)/nrow(predicted_data_top_n)
x



#RMSE for CB
merged_data <- sqldf("select a.user_id,a.movie_id,a.rating,b.rating_prediction as pr_rating from all_movie_data as  a join data_cb as b on (a.user_id = b.user_id and a.movie_id = b.movie_id)")
merged_data_subset <- data.frame(merged_data$user_id,merged_data$movie_id,as.integer(merged_data$rating),as.integer(merged_data$pr_rating))
colnames(merged_data_subset) <- c("user_id","movie_id","rating","pred")
merged_data_subset$diff <- merged_data_subset$rating - merged_data_subset$pred
diff_data <- subset(merged_data_subset,rating == pred)
head(merged_data_subset)
merged_data_subset_clean <- na.omit(merged_data_subset)
sqrt(sum(merged_data_subset_clean$diff*merged_data_subset_clean$diff)/nrow(merged_data))




#Diversity
##Measuring Diversity Scores fr Each Recommendation

##Content Based Recommendation System
setwd("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project")
data_cb <- read.csv("CB_wts.csv")

require(plyr)
top_n <- ddply(data_cb, "user_id", function(x) head(x[order(x$wt, decreasing = TRUE) , ], 100))

num_row <- unique(top_n$user_id)

count <- 1
sum <- 0
while(count < length(num_row)){
  row <- top_n[count,]
  user_id_elem <- row$user_id
  print(count)
  print
  mid_data <- subset(top_n,user_id == user_id_elem )
  i = 1
  
  while(i<=100)
  {
    wt_one <- mid_data[i,]$wt
    j = 1
    while(j<=100)
    {
      
      wt_two <- mid_data[j,]$wt
      wt_diff <- wt_one - wt_two
      j = j+1
    }
    i = i + 1 
    sum = sum + wt_diff
  }
  
  
  count <- count + 1 
}
print(sum/length(num_row))






#Novelty
top_n_cf <- top_n
require(plyr)
#top_n_cf <- ddply(final_data_interim, "user_id", function(x) head(x[order(x$wt, decreasing = TRUE) , ], 50))
top_n_cf_final <- data.frame(top_n_cf$user_id,top_n_cf$movie_id,top_n_cf$wt)
colnames(top_n_cf_final) <- c("user_id","movie_id","wt")

##Assuming the User was given a preference
##to choose and give feedback in terms of whether the
##movie was redundant or not

##Below presents a random distribution of whether a movie was redundant or not.
user_redunduncy_check<- rbinom(67100, 1, 0.5)
##Done

##Integrating this result with that of t he previous result
combined_data <- cbind(top_n_cf_final,user_redunduncy_check)

##Algorithm Steps
#1 Get Max redunduncy score for each user
#2 Wherever the redunduncy is 1 and curr_max redunduncy is less than wt, decrease current redunduncy by 10%
#3 Do this for all users
#4 Get median novelty score for each user

#Data Check
data <- sqldf("select user_id,max(wt),sum(user_redunduncy_check) from combined_data group by 1")

all_users <- unique(data$user_id)

counter <- 1
final_novelty_values <- data.frame()
while(counter <= length(all_users) ){
  user <- all_users[counter]
  data_per_user <- subset(combined_data, user_id == user)
  max_redunduncy_for_user <- max(data_per_user$wt)
  user_redunduncy_value <- max_redunduncy_for_user
  counter_inner <- 1
  while(counter_inner < nrow(data_per_user)){
    if(data_per_user$user_redunduncy_check[counter_inner] == 1){
      user_redunduncy_value <-  user_redunduncy_value -  user_redunduncy_value/10
    }
    counter_inner <- counter_inner + 1
    
  }
  final_novelty_values <- rbind(final_novelty_values,user_redunduncy_value)
  
  counter = counter + 1
}

colnames(final_novelty_values) <- c("novelty")

median(as.vector(final_novelty_values$novelty))











