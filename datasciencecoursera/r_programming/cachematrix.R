## makeCacheMatrix creates a list containing functions to 
## 1. set the value of a matrix,
## 2. get the value of the matrix,
## 3. set the value of the matrix inverse,
## 4. get the value of the matrix inverse.
## cacheSolve first checks whether the value of the matrix 
## inverse has been set, and if so, it returns that value
## (along with a message saying it's using cached data)
## rather than calculating it. If that value has not been
## set, it calculates it.

## create matrix object that can cache its inverse
makeCacheMatrix <- function(x = matrix()) {

	# instantiate `my_inverse` inv as null
	my_inverse <- NULL
	
	# set the matrix (as `my_matrix` global var)
	setmat <- function(y) {

		my_matrix <<- y
		my_inverse <<- NULL

	}

	# get the matrix
	getmat <- function() my_matrix

	# set the inverse (as `my_inverse` global var`)
	setinv <- function(inverse) my_inverse <<- inverse

	# get the inverse
	getinv <- function() my_inverse

	# return list of outputs
	list(
		setmat = setmat,
		getmat = getmat,
		setinv = setinv,
		getinv = getinv)

}


## compute the inverse of a matrix returned by makeCacheMatrix 
## (or retrieve the inverse if it's already been calculated)
cacheSolve <- function(x, ...) {
	## Return a matrix that is the inverse of 'x'

	# try to get the inverse from env
	my_inverse <- x$getinv()

	# if inverse was retrieved, return data
	if (!is.null(my_inverse)) {
		message('Getting cached data')
		return (my_inverse)
	}

	# get matrix
	data <- x$getmat()

	# solve matrix, store as `my_inverse`
	my_inverse <- solve(data, ...)

	# set the inverse
	x$setinv(my_inverse)

	# return inverse
	my_inverse

}


# # TESTING

# # create matrix
# mymat <- matrix(c(4,2,7,6), 2, 2)

# # store it ?
# test <- makeCacheMatrix()

# # set the matrix
# test$setmat(mymat)

# # get the matrix
# test$getmat()
# #      [,1] [,2]
# # [1,]    4    7
# # [2,]    2    6

# # solve the inverse
# cacheSolve(test)
# #      [,1] [,2]
# # [1,]  0.6 -0.7
# # [2,] -0.2  0.4

# # now lets test that it returns the cached value if we set it

# # store it
# test <- makeCacheMatrix()

# # set it
# test$setinv(solve(mymat))

# # solve (get cached value)
# cacheSolve(test)
# # Getting cached data
# #      [,1] [,2]
# # [1,]  0.6 -0.7
# # [2,] -0.2  0.4