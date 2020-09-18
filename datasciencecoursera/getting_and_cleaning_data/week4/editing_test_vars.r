df <- read.csv('https://baltimorecity.gov/api/views/dz52-2aru/rows.csv?accessType=DOWNLOAD')

# the download doesn't actually work

# make lowercase
tolower(names(df))

# also toupper()

# strsplit() e.g. 'Location.1', split on period
split_names <- strsplit(names(cameraData,'\\.'))

# using sapply() to get first element with strsplit
first_element <- function(x) {x[1]}
sapply(split_names, first_element)

# sub()
reviews <- c('id','solution_id','reviewer_id')
sub(pattern = '_',
    replacement = '', 
    x = reviews)

# gsub()
testName <- 'this_is_a_test'
sub('_', '', testName)
# [1] 'thisis_a_test'
gsub('_', '', testName)
# [] 'thisisatest'

# finding values: grep(), grepl()
# find index of match
grep('Alameda', df$intersection)

# find bool of match
table(grepl('Alameda', df$intersection))

# subsetting
df2 <- df[!grepl('Alameda', df$intersection), ]

# use value = TRUE to return the value rather than just the index
grep('Alameda', df$intersection, value = TRUE)
# [1] 'Alameda st at blah', 'thing at other thing'

# check that a value doesn't appear
length(grep('JeffStreet', df$intersection))
# [1] 0

library(stringr)
nchar()

substr('Jeffrey Leek', 1, 7)
# [1] 'Jeffrey'

paste()

str_trim('Jeff     ')
# [1] 'Jeff'

# Important points about text in datasets
# names of vars should be:
#   all lower case where possible
#   descriptive ('diagnosis' vs 'Dx')
#   not duplicated
#   not have underscores or dots or white spaces
# variables with character values
#   should usually be made into factor variables (depends on application)
#   should be descriptive (use TRUE/FALSE instead of 0/1 and Male/Female vs 0/1 or M/F)