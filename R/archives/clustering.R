library(factoextra)

set.seed(8675309)

clustering <- readRDS("./data/clustering.rds")

data <- clustering %>%
  select(-county_name) %>%
  scale()

fviz_nbclust(data, kmeans, method = "wss")

km.res <- kmeans(data, 3, nstart = 100)

fviz_cluster(km.res, data) +
  labs(x = "PC 1",
       y = "PC 2", 
       title = "K-Means Clusters | COVID + Economic Factors") +
  theme(plot.title = element_text(size = 20),
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 16))

print(km.res)

view(clustering[c(18, 55, 41),])