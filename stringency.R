library(tidyverse)
library(lubridate)

# For description of variables:
# https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md
url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"

raw_data <- read.csv(url) 

# clean names and dates
clean_data <- raw_data %>%
  janitor::clean_names() %>%
  mutate(date = ymd(date)) %>%
  select(-contains("flag"),
         -m1_wildcard)

# further clean variable names
names(clean_data)[6:23] <- substring(names(clean_data)[6:23], 4)

# country-level data
world_data <- clean_data %>%
  filter(region_name == "") %>%
  select(-contains("region"))

# state-level data
state_data <- clean_data %>%
  filter(country_code == "USA",
         region_code  != "") %>%
  select(-c("country_name", 
            "country_code")) %>%
  rename(state = region_name)
