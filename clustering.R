library(factoextra)

set.seed(8675309)

clustering <- readRDS("./data/clustering.rds")

data <- clustering %>%
  select(-county_name) %>%
  scale()

fviz_nbclust(data, kmeans, method = "wss")

km.res <- kmeans(data, 3, nstart = 100)

fviz_cluster(km.res, data)

print(km.res)

view(clustering[c(18, 55, 41),])
