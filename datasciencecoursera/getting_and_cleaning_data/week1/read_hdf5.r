# hdf = heirarchical data format
#   - used for storing large datasets
#   - supports storing a range of datat types
#   - data stored in groups
# groups containing zero or more data sets and metadata
#   - have a group header with group name and list of attributes
#   - have a group symbol table with a list of objects in group
# datasets are multidimentional array of data elements with metadata
#   - have a header with name, datatype, dataspace, and storage layout
#   - have a data array with the data

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

 BiocManager::install('rhdf5')

library(rhdf5)

# create file
created <- h5createFile('example.h5')

# create groups
created <- h5createGroup('example.h5','foo')
created <- h5createGroup('example.h5','bar')
created <- h5createGroup('example.h5','foo/foobar')
h5ls('example.h5')

# write data
A <- matrix(1:10, nr = 5, nc = 2)
h5write(A, 'example.h5', 'foo/A')
B = array(seq(0.1, 2.0, by = 0.1), dim = c(5,2,2))
attr(B, 'scale') <- 'liter'
h5write(B, 'example.h5', 'foo/foobar/B')
h5ls('example.h5')

# write df
df <- data.frame(1L:5L, seq(0,1, length.out=5),
    c('ab','cde','fghi','a','s'), stringsAsFactors = FALSE)
h5write(df, 'example.h5', 'df')
h5ls('example.h5')

# read data
readA <- h5read('example.h5', 'foo/A')
readB <- h5read('example.h5', 'foo/foobar/B')
readC <- h5read('example.h5', 'df')

# write and read..
> h5read('example.h5','foo/A')
#      [,1] [,2]
# [1,]    1    6
# [2,]    2    7
# [3,]    3    8
# [4,]    4    9
# [5,]    5   10
# index call tells us write to first 3 rows, and first column.
h5write(c(12,13,14), 'example.h5', 'foo/A', index = list(1:3,1))
h5read('example.h5','foo/A')     
# [,1] [,2]
# [1,]   12    6
# [2,]   13    7
# [3,]   14    8
# [4,]    4    9
# [5,]    5   10

# can pass same index command to h5read()