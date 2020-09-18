# week 1 quiz

setwd("...")

df <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', destfile = 'data.csv')

df <- read.csv('data.csv')

vals <- df %>% select(VAL)

vals %>% group_by(VAL) %>% tally() %>% filter(VAL > 13) %>% summarise(total = sum(n))

vals %>% group_by(VAL) %>% tally() %>% tail()



library(readxl)

# doesn't work
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx', destfile = 'ngap.xlsx')


# https://readxl.tidyverse.org/reference/cell-specification.html
# use range(cell_limits(...))

dat <- read_excel('ngap.xlsx', range = cell_limits(c(18,7), c(23,15)))



file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'