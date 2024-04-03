OUTPUT = ../../gen/output/

$(OUTPUT)average_rating_genres_each_year.pdf $(OUTPUT)distribution_movie_ratings_vs_comedy.pdf $(OUTPUT)table_linear_regression.pdf $(OUTPUT)average_ratings_per_yearplot.pdf $(OUTPUT)total_genre_ratings_change_2000-2023.pdf: Analysis_data.R
	R --vanilla < Analysis_data.R

clean:
	R -e "unlink('../../gen/temp/*.tsv*')"