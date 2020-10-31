library(tidyverse)
library(lubridate)
library(sjmisc)

# For description of variables:
# https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md
url <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"

raw_data <- read.csv(url) 

# clean names and dates
clean_data <- raw_data %>%
  janitor::clean_names() %>%
  mutate(date = ymd(date)) %>%
  select(-contains("flag")) %>%
  to_dummy(c1_school_closing)

# country-level data
world_data <- clean_data %>%
  filter(region_name == "") %>%
  select(-contains("region"))

# state-level data
state_data <- clean_data %>%
  filter(country_code == "USA",
         region_code  != "")