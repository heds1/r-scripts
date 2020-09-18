# why do we use graphs for exploratory analysis
#   - to understand data properties
#   - to find patterns in data
#   - to suggest modeling strategies
#   - to 'debug' analyses

# characteristics of exploratory graphs
#   - they are made quickly
#   - a large number are made
#   - the goal is for personal understanding
#   - axes/legends are generally cleaned up (later)
#   - color/size are primarily used for information

# example question: are there any counties in the US that exceed the national
# standard for fine particle pollution? (annual mean avg over 3 years can't
# exceed 12 ug/m3)

# simple summaries of data
# one dimension:
#   - five-number summary
summary(df$variable)

#   - boxplots
boxplot(df$variable, col = 'blue')
# overlaying features
# add line at 12 to show the cutoff
abline(h = 12)

#   - histogram
hist(df$variable, col = 'green')
# plot raw data underneath
rug(df$variable) 
# change breaks (i.e. number of bars)
hist(df$variable, col = 'green', breaks = 100)
# add vertical lines
abline(v = 12, lwd = 2)
abline(v = median(df$variable), col = 'magenta', lwd = 4)

#   - barplot
barplot(table(df$region), col = 'wheat', main = 'Number of Counties in Each Region')

# 2d summaries
# boxplots
boxplot(var1 ~ var2, data = df, col = 'red')

# histograms
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(df, region == 'east')$var1)
hist(subset(df, region == 'west')$var1)

# scatterplot, add extra dimension with col
with(df, plot(var1, var2, col = region))
abline(h = 12, lwd = 2, lty = 2)

# multiple scatterplots
par(mfrow = c(2, 1), mar = c(5, 4, 2, 1))
with(subset(df, region == 'west'), plot(var1, var2, main = 'West'))
with(subset(df, region == 'east'), plot(var1, var2, main = 'East'))



