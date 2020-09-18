library(tidyverse)
base_dir <- 'c:/users/hls/code/datasciencecoursera/getting_and_cleaning_data/week3/data/'

# Q1 
download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv',
    destfile = 'c:/users/hls/code/datasciencecoursera/getting_and_cleaning_data/week3/data/df.csv')

df <- read.csv('c:/users/hls/code/datasciencecoursera/getting_and_cleaning_data/week3/data/df.csv')

agriculture_logical <- df$ACR == 3 & df$AGS == 6

which(agriculture_logical)
# 125, 238, 262

# Q2
library(jpeg)

download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg',
    destfile = paste0(base_dir, 'pic.jpg'))

pic <- jpeg(paste0(base_dir, 'getdata_jeff.jpg'))
# jpeg doesn't do anything

# -152 -105

# Q3
download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv',
    destfile = paste0(base_dir, 'gdp.csv'))

gdp <- read.csv(paste0(base_dir, 'gdp.csv'))

download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv',
    destfile = paste0(base_dir, 'edu.csv'))

edu <- read.csv(paste0(base_dir, 'edu.csv'))




df <- gdp %>% 
    inner_join(edu, by = c('X' = 'CountryCode')) %>%
    mutate(GDP = as.numeric(as.character(Gross.domestic.product.2012))) %>%
    arrange(desc(GDP))

# there's actually 224, not 234, matches... 13 country is st kitts..


# Q4
df %>% 
    filter(
        Income.Group %in% c('High income: OECD', 'High income: nonOECD')) %>%
    group_by(Income.Group) %>%
    summarise(avg_ranking = mean(GDP, na.rm=TRUE))


# Q5
my_quant <- quantile(df$GDP, probs = c(0.2,0.4,0.6,0.8,1), na.rm=TRUE)
q5 <- df %>%
    drop_na(GDP) %>%
    select(
        Income.Group, GDP, X) %>%
    mutate(quant = case_when(
        GDP <= my_quant[1] ~ names(my_quant)[1],
        GDP <= my_quant[2] ~ names(my_quant)[2],
        GDP <= my_quant[3] ~ names(my_quant)[3],
        GDP <= my_quant[4] ~ names(my_quant)[4],
        GDP <= my_quant[5] ~ names(my_quant)[5]
        ))



table(q5$Income.Group, q5$quant)