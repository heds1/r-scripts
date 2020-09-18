library(dplyr)
# library(lubridate)

# create temp file
temp <- tempfile()

# download zip file, store in temp
download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
    temp)

# read in data
df <- read.table(
    file = unz(temp, 'household_power_consumption.txt'),
    sep = ';',
    header = TRUE,
    stringsAsFactors = FALSE)

# unlink temp file
unlink(temp)

# subset and convert datatypes
df2 <- df %>%
    filter(Date %in% c('1/2/2007','2/2/2007')) %>%
    mutate(
        Datetime = as.POSIXct(
            paste(Date, Time, sep = ' '),
            format = '%d/%m/%Y %H:%M:%S'),
        Global_active_power = as.numeric(Global_active_power)
    )

# open device
png(file = 'plot2.png',
    width = 480,
    height = 480)

# construct plot
with(df2, 
    plot(
        Global_active_power ~ Datetime,
        ylab = 'Global Active Power (kilowatts)',
        xlab = '',
        type = 'l'))

# close device
dev.off()