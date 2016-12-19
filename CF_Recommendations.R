final_dataset_2 <- read.csv("/Users/Kalhan/Desktop/Waterloo Data/CS 846/CS 846 Project/output_300.csv",sep = " ")
final_dataset_2 <- subset(final_dataset_2,Parent != Chile)
detach("package:RMySQL", unload=TRUE)
library(sqldf)

final_data_interim <- sqldf("select user_id,movie_id,chile as child_movie_id,wt from all_movie_data as a join final_dataset_2 as b on (a.movie_id = b.Parent)")
final_data <- sqldf("select a.user_id,b.movie_id,a.child_movie_id,wt,rating from final_data_interim as a  join all_movie_data as b on (a.child_movie_id = b.movie_id and a.user_id = b.user_id) ")
final_data <- sqldf("select user_id,movie_id,sum(wt) as sum_wt,sum(wt*rating) as sum_rating_wt from final_data group by user_id,movie_id")
final_data <- sqldf("select user_id,movie_id,sum_rating_wt/sum_wt from final_data")
colnames(final_data) <- c("user_id","movie_id","pr_rating")

##library(dplyr)
##final_data_hope <- inner_join(final_data_interim,all_movie_data)
##41820929792 bytes

##rating_calculation <- sqldf("select user_id,movie_id,sum(wt) as sum_wt,sum(wt*rating) as sum_wt_rating from final_data_hope by user_id,movie_id")



##remove.packages('RMySQL')
##detach("package:RMySQL", unload=TRUE)
##detach("package:SQLite", unload=TRUE)

##select user_id,movie_id,Child_Movie_id,rating,wt,RANK() OVER(partition by user_id order by wt desc) as xx from (

##sqldf("select user_id,movie_id,Chile as Child_Movie_id,rating,wt from all_movie_data as a join final_dataset_2 as b on (a.movie_id = b.Parent)")

##select user_id,movie_id,Chile as Child_Movie_id,rating,wt from all_movie_data as a join final_dataset_2 as b on (a.movie_id = b.Parent)

##sqldf("select user_id,movie_id,rating,rank() over( Partition by user_id order by rating desc) as xx from all_movie_data")