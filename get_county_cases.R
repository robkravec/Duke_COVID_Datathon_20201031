library(tidyverse)
library(jsonlite)
library(lubridate)

county_cases <- read_csv("https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_confirmed_usafacts.csv")

county_deaths <- read_csv("https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_deaths_usafacts.csv")

county_pop <- read_csv("https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_county_population_usafacts.csv") 

cdc_rates <- fromJSON("https://data.cdc.gov/resource/vbim-akqf.json")

county_cases_lng <- county_cases %>% 
  filter(countyFIPS != 0) %>% 
  pivot_longer(cols = '1/22/20':'10/30/20',
               names_to = "date", values_to = "cases")  %>% 
  mutate(date = mdy(date)) %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))


county_deaths_lng <- county_deaths %>% 
  filter(countyFIPS != 0) %>% 
  pivot_longer(cols = '1/22/20':'10/30/20',
               names_to = "date", values_to = "deaths") %>% 
  mutate(date = mdy(date)) %>% 
  mutate(year = year(date),
         month = month(date),
         day = day(date))
  


county_pop<- county_pop %>% 
  filter(countyFIPS != 0)


join_cols  <- c("countyFIPS",  "stateFIPS",  "year" , "month", "day")

counties <- inner_join(county_cases_lng, 
                       county_deaths_lng, 
                       by = join_cols) %>% 
  select(-ends_with(".y")) %>% 
  rename(county_name = "County Name.x", 
         state = "State.x",
         date = "date.x")


      
counties <- counties %>%
  left_join(county_pop[, c("countyFIPS", "population")], 
             by = c("countyFIPS"))


NYC_counties <- c("New York County",
                  "Kings County",
                  "Bronx County",
                  "Richmond County",
                  "Queens County")

NYC_pop <- sum(
  county_pop %>%
    filter(State == "NY", `County Name` %in% NYC_counties) %>%
    select(population) %>%
    pull()
)


counties[counties$countyFIPS == 1, "population"] <- NYC_pop

counties %>% 
  mutate(death_prop = deaths / population,
         case_prop = cases / population)

saveRDS(counties, "./data/county_rates.Rds")
