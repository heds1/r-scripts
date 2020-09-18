# logical subsetting
x[(x$var1 <= 3 & x$var2 > 11), ]

# dealing with missing values
x[which(x$var2 > 8), ]

# sort(), can reverse by decreasing=TRUE
sort(x$var1, decreasing = TRUE)

# can also put all NAs to the end
sort(x$var1, na.last = TRUE)

# order df
x[order(x$var1), ]

# order by multiple
x[order(x$var1, x$var2), ]

# with arrange
library(dplyr)
arrange(x, var1)

# arrange decreasing
arrange(x, desc(var1))

# add column/var
y$newVar <- ... 

# add column to right of x (same thing)
y <- cbind(x, rnorm(5))

# same thing with rbind