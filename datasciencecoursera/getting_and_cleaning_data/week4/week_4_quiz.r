# Q1

df <- read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')

strsplit(names(df), 'wgtp')[123]

# '' '15'


# Q2

df <- read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', skip = 4)

gdp <- as.numeric(gsub(',', '', df$X.4))[1:190]

mean(gdp[!is.na(gdp)])
# [1] 377652.4


# Q3

country_names <- df$X.3[1:190]
grep('^United', country_names, value = TRUE)
# [1] "United States"        "United Kingdom"       "United Arab Emirates"


# Q4
library(dplyr)
gdp <- read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', skip=4)
edu <- read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv')

df <- full_join(edu,gdp, by = c('CountryCode' = 'X'))
# can't find anything to do with month


# Q5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

library(lubridate)

length(which(year(sampleTimes) == 2012))
# 250

# mondays in 2012
twenty12 <- sampleTimes[which(year(sampleTimes) == 2012)]
length(which(wday(twenty12)==2))
# 47