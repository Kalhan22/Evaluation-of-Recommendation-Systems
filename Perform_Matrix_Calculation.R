

##Calcuates the Similarity of the two matrxes
getSimilarity <- function(parent,child){
  dot_parent_child <- sum(parent*child)
  mod_parent <- parent^2
  mod_child <- child^2
  similarity <- dot_parent_child/sqrt((sum(mod_parent)*sum(mod_child)))
  #print('Similarity')
  #print(similarity)
  return(similarity)
}


#To get the Cosine Similarity of each Item for Colloborative Filtering 
#Algo
#For Each Movie
#For Each Movie and if Movie is not as the same movie
#Multiple perform dot product of two rows
transposed_data_mod <- transposed_data
transposed_data_mod[is.na(transposed_data_mod)] <- 0
all_movie_ids <- transposed_data_mod$movie_id
all_movie_ids <- unique(all_movie_ids)
counter_parent <- 1
counter_child <- 1
final_dataset<- data.frame(0,0,0)
colnames(final_dataset) <- c("Movie Parent","Movie Child","Similarity Index")
while(counter_parent <= length(all_movie_ids)){
  
  counter_child <- 1
  movie_parent_data_elem <- subset(transposed_data_mod, movie_id == all_movie_ids[counter_parent])
    while(counter_child <= length(all_movie_ids)){
      counter_child <- counter_child + 1
        ##Condition removed where parent not equal to
        #print('Parent')
        #print(counter_parent)
        #print('Child')
        print(counter_child)
        
        movie_child_data_elem <- subset(transposed_data_mod, movie_id == all_movie_ids[counter_child])
        sim_wt <- getSimilarity(as.numeric(movie_child_data_elem[,-1]),as.numeric(movie_parent_data_elem[,-1]))
        final_dataset <- rbind(final_dataset,c(all_movie_ids[counter_parent],all_movie_ids[counter_child],sim_wt))
      
      
    }
  counter_parent <- counter_parent + 1
}

##Calcuates the Similarity of the two matrxes
getSimilarity <- function(parent,child){
  dot_parent_child <- sum(parent*child)
  mod_parent <- parent^2
  mod_child <- child^2
  similarity <- dot_parent_child/(mod_parent*mod_child)
  #print('Similarity')
  #print(similarity)
  return(similarity)
}




