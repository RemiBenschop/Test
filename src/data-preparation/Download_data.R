#loading packages
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)

## Get the data from the URLs
options(timeout = max(1000, getOption("timeout")))
urls <- c(
  'https://datasets.imdbws.com/title.basics.tsv.gz',
  'https://datasets.imdbws.com/title.ratings.tsv.gz'
)

## Naming the URL's
names <- c("Basics", "Ratings")

## write the data to a TSV file
for (i in 1:length(urls)) {
  download.file(urls[i], paste0("../../gen/temp/", names[i], ".tsv.gz"), mode = "wb")
}
