# convert NZTM x/y coordinates to lat/lon
# need proj4 package

library(proj4)

# import data
data <- read.csv("data.csv")

# define parameters (below are specific for NZTM --> lat/lon)
projection_definition <- "+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m"

# create list of lat/lon values
# "NZTM.X/Y" are the column names with the NZTM coordinates
p <- proj4::project(data[,c("NZTM.X", "NZTM.Y")], proj=projection_definition, inverse=TRUE)

# you can check it worked by running the following, which should print out lat/lon values
p[1]
p[2]

# append lat/lon values onto your dataframe
data$longitude <- p$x
data$latitude <- p$y
