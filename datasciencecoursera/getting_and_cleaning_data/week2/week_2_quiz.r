# q1

# https://github.com/r-lib/httr/blob/master/demo/oauth2-github.r

library(httr)

# find OAuth settings for github
oauth_endpoints('github')

myapp <- oauth_app("github",
  key = "my_key...",
  secret = "my_secret..."
)

# get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints('github'), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)

# get the content, try to parse it
test <- content(req,as='parsed')

# find repo names, it's the third element
repo_names <- lapply(test, function(x) x[[3]])

# find the datasharing repo
grep('datasharing', repo_names)
# [1] 16

# get datasharing repo
datasharing <- test[[16]]

# get creation date
datasharing$created_at
[1] "2013-11-07T13:25:07Z"



# Q2
base_dir <- '...'

file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(file_url,
    destfile = paste0(base_dir,'acs.csv'))

acs <- read.csv(paste0(base_dir,'acs.csv'))

library(sqldf)

sqldf('select pwgtp1 from acs where AGEP < 50')

# Q3
myvec <- sqldf('select distinct AGEP from acs')


# Q4
file_url <- 'http://biostat.jhsph.edu/~jleek/contact.html'
download.file(file_url,
    destfile = paste0(base_dir,'html.html'))

lines <- readLines(paste0(base_dir, 'html.html'))

lapply(lines, nchar)[c(10,20,30,100)]
# [[1]]
# [1] 45

# [[2]]
# [1] 31

# [[3]]
# [1] 7

# [[4]]
# [1] 25


# Q5

# download and store data
file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
download.file(file_url,
    destfile = paste0(base_dir,'fort.for'))

# read data using read.fwf, this is basically trial and error to get the right
# widths, they don't really make sense to me.
df <- read.fwf(paste0(base_dir,'fort.for'),
                     widths = c(15,4,9,4,9,4,9,4,9), skip = 3, header = FALSE)

# apply headers, then drop header row
colnames(df) <- as.character(unlist(df[1,]))
df <- df[-1,]

# get col sum for answer, remember these are factors so convert to char before
# numeric
sum(as.numeric(as.character(df[,4])))
# [1] 32426.7