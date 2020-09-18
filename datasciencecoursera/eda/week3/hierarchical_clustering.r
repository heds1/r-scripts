# clustering organizes things that are close into groups
#   - how do we define close?
#   - how do we group things?
#   - how do we visualise the grouping?
#   - how do we interpret the grouping?

# hierarchical clustering
#   - an agglomerative approach
#   - find closest two things, put them together; find next closest
#   - requires a defined distance, a merging approach
#   - produces a tree showing how close things are to each other

# how do we define close?
#   - most important step (garbage in = garbage out)
#   - distance or similarity
#       continuous (euclidean distance, straight line between points)
#       continuous (correlation similarity)
#       binary (manhattan distance, like a city grid - can't go directly, as bird flies)
#   - pick a distance/similarity that makes sense for your problem

set.seed(1234)
par(mar = c(0, 0, 0, 0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = 'blue', pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels as.character(1:12))

# dist(x, method)
# calculates distance between rows in df (i.e. points in our data)
# the output is a lower triangular matrix, where (i,j) indicates the
# distance between points i and j. clearly you only need a lower triangular matrix
# since the distance between i and j is the same as that between j and i.
df <- data.frame(x = x, y = y)
dist(df)

distxy <- dist(df)
# hclust for dendrograms
# hclust takes the dist triangular matrix as an argument
hClustering <- hclust(distxy)
plot(hClustering)


# prettier dendrograms
myplclust <- function(
    hclust,
    lab = hclust$labels,
    lab.col = rep(1, length(hclust$labels)),
    hang = 0.1, ...) {

    # modification of plclust for plotting hclust objects in colour.
    # copyright Eva KF Chan 2009
    # arguments: 
    #   - hclust: hclust object
    #   - lab: a chr vector of labels of the leaves of the tree
    #   - lab.col: colour for the labels; NA = default devide foreground colour
    #   - hang: as in hclust and plclust
    # side effect: a display of hierarchical cluster with coloured leaf labels
    y <- rep(hclust$height, 2)
    x <- as.numeric(hclust$merge)
    y = y[which(x < 0)]
    x <- x[which(x < 0)]
    x <- abs(x)
    y <- y[order(x)]
    x <- x[order(x)]
    plot(hclust, labels = FALSE, hang = hang, ...)
    text(x = x,
        y = y[hclust$order] - (max(hclust$height) * hang),
        labels = lab[hclust$order],
        col = lab.col[hclust$order],
        srt = 90,
        adj = c(1, 0.5),
        xpd = NA,
        ...)

}

myplclust(hClustering, lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))

# heatmap() runs a HCA on the rows and columns of the table
dataMatrix <- as.matrix(df)[sample(1:12), ]
heatmap(dataMatrix)
# columns are sets of observations


# notes
#   - picture may be unstable
#       change a few points, have different missing values, pick a different distance,
#       change the merging strategy, change the scale of points for one var
#   - but it is deterministic
#   - choosing where to cut isn't always obvious
#   - should be primarily used for exploration