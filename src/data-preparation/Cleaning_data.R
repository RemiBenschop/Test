# Setup
library(tidyverse)
library(dplyr)
library(readr)

# Specify the path to your TSV file
file_path_basics <- "../../gen/temp/Basics.tsv.gz"
file_path_ratings <- "../../gen/temp/Ratings.tsv.gz"

# Read the TSV file into a data frame
title_basics_data <- read_tsv(file_path_basics)
title_ratings_data <- read_tsv(file_path_ratings)

#Filtering dataset
data.frame(title_basics_data)
#Filtering for year
filtered_title_basics <- title_basics_data[title_basics_data$startYear >= 2000 & title_basics_data$startYear <= 2023,]

#Filtering for movies
filtered_title_basics <- filtered_title_basics[filtered_title_basics$titleType == 'movie',]

#Filtering for number of votes >1000
filtered_title_ratings_data <- title_ratings_data[title_ratings_data$numVotes > 1000,]

#merge the two files
merged_lists <- filtered_title_basics %>% left_join(filtered_title_ratings_data, by= 'tconst')

#remove NA from the ratings column
movies <- merged_lists %>% na.omit(merged_lists$averageRating)

#final list is called movies for further data wrangling'

#specify output file path
output_file_path <- "../../gen/temp/movies_data.tsv"

# Write the data to a TSV file called movies_data.tsv
write.table(movies, file = output_file_path, sep = "\t", row.names = FALSE)

