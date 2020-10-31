library(factoextra)

test <- combined_data %>%
  filter(year_mon == "Sep 2020") %>%
  select(c(
    labor_force,
    total_pop,
    unemp_rt,
    mean_government_response_index
  )) %>%
  drop_na() %>%
  scale()

fviz_nbclust(test, kmeans, method = "wss")

km.res <- kmeans(test, 4, nstart = 25)

print(km.res)

aggregate(test, by=list(cluster=km.res$cluster), var)

fviz_cluster(km.res, test)
