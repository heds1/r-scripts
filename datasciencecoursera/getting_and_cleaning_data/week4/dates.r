d1 <- date()
d1

class(d1)
# [1] character

d2 <- Sys.Date()
class(d2)
# [1] Date

# formatting dates
# %d day as number (0-31)
# %a abbreviated weekday
# %A unabbreviated weekday
# %m month
# %b abbreviated month
# %B unabbreviated month
# %y 2-digit year
# %Y 4-digit year

format(d2, '%a %b %d')
# [1] 'Sun Jan 12'

# creating dates
x <- c('1jan1960', '2jan1960', '31mar1960')
z <- as.Date(x, '%d%b%Y')

# can see differences of dates
z[1] - z[2]

as.numeric(z[1] - z[2])

# converting to Julian
weekdays(d2)
months(d2)

# lubridate
library(lubridate)

# look for all standard formats with the given order
ymd('20140108')
mdy('08/04/2013')
dmy('03-04-2013')

# dealing with times
ymd_hms('2011-08-03 10:15:03')

# set timezone
ymd_hms('2011-08-03 10:15:03', tz = 'Pacific/Auckland')

x <- dmy(x)

wday(x[1])

wday(x[1], label = TRUE)