set.seed(12345)
dataMatrix <- matrix(rnorm(400), nrow = 40)

# add cluster
heatmap(dataMatrix)

for (i in 1:40) {
    # flip coin
    coinFlip <- rbinom(1, size = 1, prob = 0.5)

    # if coin is heads add a common pattern to that row
    # for that row, 5 cols == 0, five cols == 3
    if (coinFlip) {
        dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 3), each = 5)
    }
}

# heatmap
par(mar = rep(0.2, 4))
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])

# add cluster
heatmap(dataMatrix)

# patterns in rows and cols
hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])

plot(rowMeans(dataMatrixOrdered), 40:1, xlab = 'Row mean', ylab = 'Row', pch = 19)
plot(colMeans(dataMatrixOrdered), xlab = 'Column', ylab = 'Column mean', pch = 19)

# related problems
#   - find a new set of variables that are uncorrelated and explain as much variance as poss
#   - if you put all the vars together in one matrix, find the best matrix created with
#       fewer variables (lower rank) that explains the original data.
#   - the first goal is statistical, and the second goal is data compression.

# related solutions: PCA/SVD
# SVD
#   if X is a matrix with each var in a col and each obs in a row, then the SVD
#   is a 'matrix decomposition' 
#           X = UDV^t
#   where the cols of U are orthogonal (left singular vectors), the cols of V are
#   orthogonal (right singular vectors) and D is a diagonal matrix (singular values, 
#   where all of the entries not on the diagonal are 0).
# In other words, we decompose X into three different matrices. A is a m x n matrix;
#   U is an m x n orthogonal matrix; D is an n x n diagonal matrix; and V is an n x n
#   orthogonal matrix.
# in this case, t is equivalent to transpose, so v^t == t(v) in R

# a common analogy for matrix decomposition (or factorization) is the factoring of numbers,
# for example, of 10 into 2 x 5.

# PCA
# the principal components are equal to the right singular values (the V) if you first scale
# (subtract the mean, divide by the sd) the variables.

# components of the SVD: the u and v (left and right singular values respectively)

svd1 <- svd(scale(dataMatrixOrdered))

> dim(svd1$u)
# [1] 40 10
> dim(svd1$v)
# [1] 10 10

# it therefore looks like u has the rows, while v has the cols??

# first left singular vector ex
svd1$u[, 1]

par(mfrow = c(1, 3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd1$u[, 1], 40:1, xlab = 'Row', ylab = 'First left singular vector', pch = 19)
plot(svd1$v[, 1], xlab = 'Row', ylab = 'First left singular vector', pch = 19)

# these are very similar to the colmeans approach above. it picked up the
# shift in means, both from a row dimension and a col dimension.

# components of the SVD: variance explained (using the d matrix)
# (first one explains most variance, and so on)
par(mfrow = c(1, 2))

plot(svd1$d, xlab = 'Column', ylab = 'Singular value', pch = 19)

# scale everything proportionally - this is basically the same as above, so the
# higher the singular value, the more variance it explains. prop of variance explained
# is a bit more readable/meaningful.
plot(svd1$d^2/sum(svd1$d^2), xlab = 'Column', ylab = 'Prop of variance explained', pch = 19)

# relationship to principal components
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)

# plot first cols of each
plot(pca1$rotation[, 1], svd1$v[, 1], pch = 19, xlab = 'Principal component 1',
    ylab = 'Right singular vector 1')
abline(c(0, 1))


# set up a different matrix with 1s and 0s only
# there is only one pattern, that is, there is only one dimension of variance.
# so if we do svd, we should only have one singular value explaining all the variance,
# and no others.
constantMatrix <- dataMatrixOrdered*0

for (i in 1:dim(dataMatrixOrdered)[1]) {
    constantMatrix[i,] <- rep(c(0, 1), each = 5)
}

svd1 <- svd(constantMatrix)

par(mfrow = c(1, 3))

image(t(constantMatrix)[, nrow(constantMatrix):1])

plot(svd1$d, xlab = 'Column', ylab = 'Singular value', pch = 19)

plot(svd1$d^2/sum(svd1$d^2), xlab = 'Column', ylab = 'Prop of variance explained', pch = 19)

# what if we add a second pattern?
# add one that goes across rows and also across columns

set.seed(678910)
for (i in 1:40) {
    # flip a coin
    coinFlip1 <- rbinom(1, size = 1, prob = 0.5)
    coinFlip2 <- rbinom(1, size = 1, prob = 0.5)
    # if coin is heads, add a common pattern to that row
    if (coinFlip1) {
        dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 5), each = 5)
    }
    if (coinFlip2) {
        dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 5), times = 5)
    }
}

hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order,]

svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1, 3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rep(c(0, 1), each = 5), pch = 19, xlab = 'Column', ylab = 'Pattern 1')
# first col has mean of 0, second col has mean of 1, 3rd col mean 0, and so on
plot(rep(c(0, 1), times = 5), pch = 19, xlab = 'Column', ylab = 'Pattern 2')


# v and patterns of variance in rows
# tries to do the same as above
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1, 3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd2$v[, 1], pch = 19, xlab = 'Column', ylab = 'First right singular vector')
plot(svd2$v[, 2], pch = 19, xlab = 'Column', ylab = 'Second right singular vector')

# d and variance explained
# first component explains over 50% of the dataset variance
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1, 2))
plot(svd1$d, xlab = 'Column', ylab = 'Singular value', pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = 'Column', ylab = 'Prop of variance explained', pch = 19)


# missing values
dataMatrix2 <- dataMatrixOrdered
# randomly insert some missing data
dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA
# this won't work
svd1 <- svd(scale(dataMatrix2))

# imputing with impute::impute.knn
library(impute)
dataMatrix2 <- dataMatrixOrdered
dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA
# if k = 5, imputes NAs with the mean of the 5 nearest observations
dataMatrix2 <- impute.knn(dataMatrix2)$data
svd1 <- svd(scale(dataMatrixOrdered))
svd2 <- svd(scale(dataMatrix2))
par(mfrow = c(1, 2))
plot(svd1$v[, 1], pch = 19)
plot(svd2$v[, 1], pch = 19)


# notes and further resources
#   - scale matters
#   - PCs/SVs may mix real patterns
#   - can be computationally intensive

# D is the diagonal matrix sandwiched between U and V^t in the SVD
# representation of the data matrix. The diagonal entries of D are like weights
# fthe U and V cols accounting for the variation in the data. They're given in
# decreasing order from highest to lowest.