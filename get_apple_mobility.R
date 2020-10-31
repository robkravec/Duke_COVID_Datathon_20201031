library(tidyverse)


applemobility <- read_csv("./data/applemobilitytrends-2020-10-30.csv") %>% 
  filter(country == "United States")


mobility_lng <- applemobility %>% 
  pivot_longer(cols = '2020-01-13':'2020-10-30',
               names_to = "date", values_to = "request_chage") %>% 
  mutate(date  = ymd(date))


saveRDS(counties, "./data/apple_mobility_report.Rds")
