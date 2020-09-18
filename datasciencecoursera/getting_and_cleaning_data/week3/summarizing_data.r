base_dir <- '...'
dir.create(paste0(base_dir,'data'))

file_url <- 'https://data.baltimorecity.gov/resource/k5ry-ef3g.csv'

download.file(
    file_url,
    destfile = paste0(base_dir, 'restaurants.csv'))

df <- read.csv(paste0(base_dir, 'restaurants.csv'))

head(df)
tail(df)
summary(df)
str(df)

# normal quantiles
quantile(df$councildistrict, na.rm=TRUE)

# probs = ... for specific quantiles
quantile(df$councildistrict, na.rm=TRUE, probs = c(0.5, 0.75, 0.9))

# make table. useNA arg with add NA to table if there are any NAs
table(df$zipcode, useNA = 'ifany')

# 2d table
table(df$councildistrict, df$zipcode)

# check for missing values
sum(is.na(df$councildistrict))

any(is.na(df$councildistrict))

all(df$zipcode > 0)

# row and col sums
colSums(is.na(df))

all(colSums(is.na(df))==0)

# values with specific characteristics
table(df$zipcode %in% c('21212'))
# FALSE  TRUE 
#   983    17 

table(df$zipcode %in% c('21212','21213'))
# FALSE  TRUE 
#   965    35 

# subset by specific characteristics
df[df$zipcode %in% c('21212','21213'),]

# cross tabs
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit, data = DF)
xt
#         Admit
# Gender   Admitted Rejected
#   Male       1198     1493
#   Female      557     1278

xtabs(Freq ~ Gender + Dept, data = DF)
#         Dept
# Gender     A   B   C   D   E   F
#   Male   825 560 325 417 191 373
#   Female 108  25 593 375 393 341

# flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt <- xtabs(breaks ~., data=warpbreaks)
xt

# quick summarize large table
ftable(xt)

# size of dataset
fake_data <- rnorm(1e5)
object.size(fake_data)
print(object.size(fake_data), units = 'Mb')