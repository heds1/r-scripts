# k-means clustering
# a partitioning approach
#   - fix a number of clusters
#   - get 'centroids' of each cluster
#   - assign things to closest centroid
#   - recalculate centroids
# requires
#   - a defined distance metric
#   - a number of clusters
#   - an initial guess as to cluster centroids
# produces
#   - a final estimate of cluster centroids
#   - an assignment of each point to clusters

set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = 'blue', pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels as.character(1:12))

# kmeans()
# important params: x, centers, iter.max, nstart

df <- data.frame(x, y)
kmeansObj <- kmeans(df, centers = 3)
names(kmeansObj)
# [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss" "betweenss"    "size"        
# [8] "iter"         "ifault"  

# the 'cluster' element tells you which cluster each point (row) belongs to
kmeansObj$cluster
# [1] 3 1 1 3 2 2 2 2 2 2 2 2

# 'centers' tells you the location of the centroids

par(mar = rep(0.2, 4))
# plot x/y; colour by cluster element
plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
# add centroid points using the plus symbol
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)

# visualise with heatmaps

# heatmap() runs a HCA on the rows and columns of the table
dataMatrix <- as.matrix(df)[sample(1:12), ]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1, 2), mar = c(2, 4, 0.1, 0.1))

# image plot original data
image(t(dataMatrix)[, nrow(dataMatrix):1], yaxt = 'n')

# reorder rows of data so that clusters are put together
image(t(dataMatrix)[, order(kmeansObj$cluster)], yaxt = 'n')


