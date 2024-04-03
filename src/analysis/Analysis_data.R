
#Loading packages
library(gtsummary)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tidyverse)
library(stats)
library(sjPlot)
####

#download movies tsv
movies <- read_tsv("../../gen/temp/movies_data.tsv")

#prepare data
movies <- movies %>% select(!endYear)
movies <- movies %>% select(!isAdult)

#separate genre intp its own column
#create a dummy variable for each genre
movies$comedy <- ifelse(grepl("comedy", movies$genres, ignore.case = TRUE), 1, 0)
movies$documentary <- ifelse(grepl("documentary", movies$genres, ignore.case = TRUE), 1, 0)
movies$animation <- ifelse(grepl("animation", movies$genres, ignore.case = TRUE), 1, 0)
movies$romance <- ifelse(grepl("romance", movies$genres, ignore.case = TRUE), 1, 0)
movies$news <- ifelse(grepl("news", movies$genres, ignore.case = TRUE), 1, 0)
movies$sport <- ifelse(grepl("sport", movies$genres, ignore.case = TRUE), 1, 0)
movies$horror <- ifelse(grepl("horror", movies$genres, ignore.case = TRUE), 1, 0)
movies$fantasy <- ifelse(grepl("fantasy", movies$genres, ignore.case = TRUE), 1, 0)
movies$crime <- ifelse(grepl("crime", movies$genres, ignore.case = TRUE), 1, 0)
movies$thriller <- ifelse(grepl("thriller", movies$genres, ignore.case = TRUE), 1, 0)
movies$mistery <- ifelse(grepl("mistery", movies$genres, ignore.case = TRUE), 1, 0)
movies$scifi <- ifelse(grepl("scifi", movies$genres, ignore.case = TRUE), 1, 0)

# List of years
years <- c(2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023) 

# List of genres
genre <- c("comedy", "documentary", "animation", "romance", "news", "sport", "horror", "fantasy", "crime", "thriller", "mistery", "scifi")

# Initialize an empty list to store the results
average_ratings_per_year <- list()

# Loop over years
for (year in years) {
  # Filter data for the current year
  filtered_data <- movies %>%
    filter(startYear == year)
  
  # Initialize an empty list to store average ratings for each genre
  average_ratings <- list()
  
  # Loop over genres
  for (g in genre) {
    # Calculate mean rating for the current genre only if the dummy variable is 1
    mean_rating <- mean(filtered_data$averageRating[filtered_data[[g]] == 1], na.rm = TRUE)
    # Add mean rating to the list of average ratings for the current year
    average_ratings[[g]] <- mean_rating
  }
  
  # Add average ratings for the current year to the list
  average_ratings_per_year[[as.character(year)]] <- average_ratings
}

# Accessing average ratings for a specific year and genre
# For example, to access the average rating for "comedy" in the year 2000
avg_rating_2000_comedy <- average_ratings_per_year[["2000"]][["comedy"]]

# Convert the nested list structure into a data frame
average_ratings_df <- do.call(rbind, lapply(names(average_ratings_per_year), function(year) {
  data.frame(
    Year = rep(year, length(genre)),
    Genre = genre,
    AverageRating = unlist(average_ratings_per_year[[year]])
  )
}))

# Create graph to visualize data
# Convert Year to a factor to preserve ordering on x-axis
average_ratings_df$Year <- as.factor(average_ratings_df$Year)

# Plot the variation of ratings for each genre over the years
plot_avgratingsgenresyear <- ggplot(average_ratings_df, aes(x = Year, y = AverageRating, color = Genre, group = Genre)) +
  geom_line() +
  geom_point() +
  labs(x = "Year", y = "Average Rating", title = "Variation of Ratings by Genre Over Years") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

####save plot in pdf
ggsave("../../gen/output/average_rating_genres_each_year.pdf", plot_avgratingsgenresyear)



#plotting the distribution of movie ratings
norm_dist <- rnorm(27056, mean = mean(movies$averageRating), sd = sd(movies$averageRating))
plot(density(norm_dist), main = "Normal Distribution of Movie Ratings", xlab = "Average Rating", ylab = "Density")


# filteren op comedy movies
Comedy_num <- movies %>%
  filter(comedy == 1) %>%
  select(averageRating)

# generate a normal distribution of movie ratings for the genre comedy
comedy_dist <- rnorm(n = nrow(Comedy_num), mean = mean(Comedy_num$averageRating), sd = sd(Comedy_num$averageRating))
plot(density(comedy_dist), main = "Normal Distribution of Comedy Movie Ratings", xlab = "Average Rating", ylab = "Density")

# Create a data frame combining both distributions
combined_data <- data.frame(
  Distribution = c(rep("2. All genres", length(norm_dist)), rep("1.Comedy", length(comedy_dist))),
  Ratings = c(norm_dist, comedy_dist))

# Create a density plot
plot_distrmovieratings <- ggplot(combined_data, aes(x = Ratings, fill = Distribution)) +
  geom_density(alpha = 0.5) +
  labs(title = "Density Plot of All genres Ratings and Comedy Ratings",
       x = "Ratings",
       y = "Density") +
  scale_fill_manual(values = c("blue", "orange"))
  
####save plot in pdf
ggsave("../../gen/output/distribution_movie_ratings_vs_comedy.pdf", plot_distrmovieratings)

#plot overall rating movies in years
average_ratings_per_yearplot <- movies %>%
  group_by(startYear) %>%
  summarise(avg_rating = mean(averageRating, na.rm = TRUE))

average_ratings_per_yearplot$startYear <- as.character(average_ratings_per_yearplot$startYear)

plot_avgratingperyear <- ggplot(average_ratings_per_yearplot, aes(x = startYear, y = avg_rating, group = 1)) +
  geom_line() +  
  geom_point() +
  labs(title = "Average Movie Ratings by Year",
       x = "Year",
       y = "Average Rating") +
  ylim(5.5, 7) +
  scale_x_discrete(labels = function(x) substring(x, 3))

######save plot in pdf
ggsave("../../gen/output/average_ratings_per_yearplot.pdf", plot_avgratingperyear)


# Read the data from TSV file
movies_data <- read.delim("../../gen/temp/movies_data.tsv", header = TRUE, stringsAsFactors = FALSE)

# Convert start year and rating to appropriate data types
movies_data$startYear <- as.integer(movies_data$startYear)
movies_data$averageRating <- as.numeric(movies_data$averageRating)

# Split multiple genres and create rows for each individual genre
movies_data <- movies_data %>%
  separate_rows(genres, sep = ",\\s*")

# Filter the data for startYear = 2000 and 2023
filtered_data <- movies_data %>%
  filter(startYear == 2000 | startYear == 2023)

# Calculate the average rating for each genre and startYear
rating_summary <- filtered_data %>%
  group_by(genres, startYear) %>%
  summarise(avg_rating = mean(averageRating))

# Pivot the data to have startYear as columns
rating_summary_pivot <- pivot_wider(rating_summary, names_from = startYear, values_from = avg_rating)

# Calculate the difference in average rating between startYear = 2000 and 2023
rating_summary_pivot$difference <- rating_summary_pivot$"2023" - rating_summary_pivot$"2000"

# Reorder genres based on difference in rating
rating_summary_pivot <- rating_summary_pivot %>%
  arrange(difference)

# Define custom color function
get_color <- colorRampPalette(c("red", "green"))

# Create bar plot
plot_changeratingssince2000 <- ggplot(rating_summary_pivot, aes(x = reorder(genres, difference), y = difference, fill = difference)) +
  geom_bar(stat = "identity") +
  scale_fill_gradientn(colors = get_color(100), limits = range(rating_summary_pivot$difference), name = "Difference in Rating") +
  labs(title = "Difference in Average Rating per Genre (2000 vs 2023)",
       x = "Genre",
       y = "Difference in Rating") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

####save plot in pdf
ggsave("../../gen/output/total_genre_ratings_change_2000-2023.pdf", plot_changeratingssince2000)

