library(stringr)
library(sjlabelled)
library(tidyverse)
library(zoo)

# unemployment data

uemp_data <- readRDS("data/unemp_covid.rds")

uemp_data <- uemp_data %>%
  janitor::clean_names() 

# convert city to full state name
city_to_state <- function(x) {
  # get state abbreviation from city var
  state_abb <- str_sub(x, -2)
  abb_ind <- which(state.abb == state_abb)
  
  return(state.name[abb_ind])
}

# convert metfips to state name
fips_to_state <- function(x) {
  fips_ind <- which(fips_code == as.character(x))
  city <- fips_location[fips_ind]
  
  if(is.null(city)) {
    return(NA)
  } else {
    return(city_to_state(city))
  }
}

# add state column and clean a bit
uemp_data <- remove_all_labels(uemp_data) %>%
  mutate(state = map(metfips, fips_to_state)) %>%
  unnest(cols = c(state))

uemp_data_2020 <- uemp_data %>%
  filter(grepl("2020", year_mon, fixed = TRUE)) %>%
  mutate(year_mon = as.character(year_mon))

state_data_tc <- state_data %>%
  mutate(
    year_mon = paste(month(date, label = TRUE), year(date))
  ) %>%
  select(year_mon,
         state,
         stringency_index,
         government_response_index,
         economic_support_index,
         containment_health_index) %>%
  group_by(year_mon, state) %>%
  summarise(
    mean_stringency_index = mean(
      stringency_index,
      na.rm = TRUE
    ),
    mean_government_response_index = mean(
      government_response_index,
      na.rm = TRUE
    ),
    mean_economic_support_index    = mean(
      economic_support_index,
      na.rm = TRUE
    ),
    mean_containment_health_index  = mean(
      containment_health_index,
      na.rm = TRUE
    ))
  
combined_data <- inner_join(uemp_data_2020, state_data_tc, 
                            by = c("state", "year_mon"))

saveRDS(combined_data, "./data/combined.rds")
