# scrape.R
# 2017-11-18

# load ----------

# load packages
library(tidyverse)
library(rvest)

# scrape --------

# get url for census page w/ migration flow data
census_url <- "https://www.census.gov/data/tables/time-series/demo/geographic-mobility/state-to-state-migration.html"

# scrape webpage
census_page <- read_html(census_url)

# parse -------

# get links to migration flow xls files
migration_urls <- census_page %>% 
  html_nodes("a.attachmentAnchor") %>% 
  xml_attr("href")

# create df of urls and file extensions for downloading
migration_df <- tibble(url = migration_urls) %>% 
  mutate(row_number = row_number(),
         url = paste0("http:", url)) %>% 
  select(row_number, url) %>% 
  separate(url, into = c("front", "extension"), remove = FALSE,
           sep = "/state-to-state-migration/") %>% 
  mutate(extension= paste0("data/", tolower(extension)))

# download --------

# download files to /data 
migration_df %>% 
  walk(download.file(.$url, .$extension))
