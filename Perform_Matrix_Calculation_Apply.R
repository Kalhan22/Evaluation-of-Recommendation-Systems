##Apply R function to the rescue.
##The crux of the problem here is not to take movies which have higher weights but take all movies among user selection
## which has a higher weight

##start from 4406
final_dataset_2<- data.frame(0,0,0)
colnames(final_dataset_2) <- c('Parent','Chile','wt')
counter_parent <- 1
while(counter_parent <= length(all_movie_ids)){
  print(counter_parent)
  movie_parent_data_elem <- subset(transposed_data_mod, movie_id == all_movie_ids[counter_parent])
  x <- as.matrix(transposed_data_mod[,-1])
  d <- as.matrix(movie_parent_data_elem[,-1])
  movie_ids <- transposed_data_mod[,1]
  curr_movie <- data.matrix((rep(all_movie_ids[counter_parent], length(movie_ids))))
  mid_data <- cbind(curr_movie,movie_ids)
  data_wt <- cbind(mid_data,rowSums(t(apply(x,1,function(x) x*d)))/sqrt(data.matrix(rowSums(x^2)) * c(data.matrix(rowSums(d^2)))))
  data_wt <- data.frame(data_wt)
  colnames(data_wt) <- c('Parent','Chile','wt')
  data_set_interim <- data_wt[order(-data_wt$wt),]
  data_set_interim_2 <- data_set_interim[1:300,]
  colnames(data_set_interim_2) <- c('Parent','Chile','wt')                 
  final_dataset_2 <- rbind(final_dataset_2,data_set_interim_2)
  counter_parent <- counter_parent + 1
}


##rowSums(t(apply(x,1,function(x) x*d)))/sqrt(data.matrix(rowSums(x^2)) * c(data.matrix(rowSums(d^2))))

