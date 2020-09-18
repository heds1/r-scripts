# load dpylr for data work
library(dplyr)

# files are in current wd. read in data
scc <- readRDS('Source_Classification_Code.rds')
summ <- readRDS('summarySCC_PM25.rds')

# Q1: have total emissions from PM2.5 decreased in the US from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission
# from all sources for each of the years 1999, 2002, 2005 and 2008.

emissions_summary <- summ %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

png('plot1.png')
with(emissions_summary, 
    plot(year,
        total,
        xlab = 'Year',
        ylab = 'Total PM2.5 Emissions (ton)',
        col = 'blue',
        pch = 19,
        main = 'Total PM2.5 Emissions in the United States by Year'))
dev.off()

# Answer: Yes.

# Q2: Have total emissions from PM2.5 decreased in Baltimore City, Maryland from
# 1999 to 2008? Use the base plotting system.

baltimore <- summ %>%
    filter(fips == '24510') %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

png('plot2.png')
with(baltimore, 
    plot(year,
        total,
        xlab = 'Year',
        ylab = 'Total PM2.5 Emissions (ton)',
        col = 'blue',
        pch = 19,
        main = 'Total PM2.5 Emissions in Baltimore City by Year'))
dev.off()

# Answer: Yes.


# Q3: Of the four types of sources indicated by the type (point, nonpoint,
# onroad, nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999–2008 for Baltimore City? Which have seen increases in
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot
# answer this question.

library(ggplot2)

baltimore <- summ %>%
    filter(fips == '24510') %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

png('plot3.png')
ggplot(baltimore, aes(x = year, y = total, col = type)) +
    geom_point() +
    geom_smooth() +
    ggtitle('PM2.5 Emissions in Baltimore City by Emission Type') +
    labs(y = 'Total PM2.5 Emissions (ton)', x = 'Year', col = 'Emission type') +
    theme(plot.title = element_text(hjust = 0.5))
dev.off()

# Answer: The only emission type to have seen an increase is 'point'. The three
# other types, 'non-road', 'nonpoint' and 'on-road' all showed a decreasing
# emission trend.


# Q4: Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

# get SCC codes of sectors related to coal
coal_codes <- unique(scc[grep('coal', scc$EI.Sector, ignore.case=TRUE), 'SCC'])

# filter summary for coal emissions
coal <- summ %>%
    filter(SCC %in% coal_codes) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

# plot
png('plot4.png')
ggplot(coal, aes(x = year, y = total)) +
    geom_point() +
    geom_smooth() +
    ggtitle('PM2.5 Emissions Attributed to Coal in the United States') +
    labs(y = 'Total PM2.5 Emissions (ton)', x = 'Year') +
    theme(plot.title = element_text(hjust = 0.5))
dev.off()

# Answer: Coal emissions remained relatively stable from 1999 to 2005, but saw a
# significant decline between 2005 and 2008.


# Q5: How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?

# It's not clear what defines a motor vehicle (e.g., is an aircraft a motor
# vehicle in this question?), so I've just chosen those sectors with the word
# 'vehicle' in their name
vehicle_metadata <- scc[grep('vehicle', scc$EI.Sector, ignore.case=TRUE), ]

# merge datasets to get not only the code but also the description
vehicle <- left_join(vehicle_metadata, summ, by = c('SCC' = 'SCC')) %>%
    filter(fips == '24510') %>%
    group_by(year, EI.Sector) %>%
    summarise(total = sum(Emissions))

# plot
png('plot5.png', width = 1000)
ggplot(vehicle, aes(x = year, y = total, col = EI.Sector)) +
    geom_point() +
    geom_smooth() +
    ggtitle('PM2.5 Emissions From Motor Vehicles in Baltimore City') +
    labs(y = 'Total PM2.5 Emissions (ton)', x = 'Year', col = 'Emission sector') +
    theme(plot.title = element_text(hjust = 0.5))
dev.off()

# Answer: Diesel heavy-duty vehicle emissions and gasoline light duty vehicle
# emissions dropped considerably (particularly between 1999-2002), while diesel
# light-duty vehicle emissions and gasoline heavy-duty vehicle emissions have
# been relatively stable.


# Q6: Compare emissions from motor vehicle sources in Baltimore City with
# emissions from motor vehicle sources in Los Angeles County, California (fips
# == "06037"). Which city has seen greater changes over time in motor vehicle
# emissions?

vehicle <- left_join(vehicle_metadata, summ, by = c('SCC' = 'SCC')) %>%
    filter(fips %in% c('24510','06037')) %>%
    group_by(fips, year, EI.Sector) %>%
    summarise(total = sum(Emissions))

# make facet_wrap labels
my_labs <- as_labeller(c(`06037` = 'LA County', `24510` = 'Baltimore City'))

# plot
png('plot6.png', width=1000)
ggplot(vehicle, aes(x = year, y = total, col = EI.Sector)) +
    geom_point() +
    geom_smooth() +
    ggtitle('PM2.5 Emissions From Motor Vehicles in Baltimore and LA County') +
    labs(y = 'Total PM2.5 Emissions (ton)', x = 'Year', col = 'Emission sector') +
    theme(plot.title = element_text(hjust = 0.5)) +
    facet_wrap(. ~ fips, scales = 'free_y', 
        labeller = my_labs)
dev.off()

# Answer: While Baltimore's diesel heavy-duty vehicle and gasoline light-duty
# emissions dropped significantly, LA County's emissions from those two vehicle
# categories have been relatively stable (in fact, increasing from 1999-2008 for
# the diesel heavy-duty vehicles). Both areas did not see very large changes in
# the emissions from diesel light-duty vehicles and gasoline heavy-duty vehicles.
