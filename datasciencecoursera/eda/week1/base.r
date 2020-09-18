# core plotting and graphics are incorporated into the following base packages:
#   - graphics
#   - grDecives
# lattice plotting are in
#   - lattice
#   - grid

# we focus on using the base plotting system to create graphics on the screen device.
# two phases for creating a base plot:
#   - initialising a new plot
#   - annotating an existing plot

# calling plot(x, y) or hist(x) will launch a graphics device (if one is not
# already open) and draw a plot on the device 

# if the arguments to plot are not of some special class, then the default method
# for plot is called; this function has many arguments, letting you set the
# title, x-axis label, y-axis label, etc.

# the base graphics system has many params that can be set and tweaked
# ?par

# simple base graphics: hist
library(datasets)
hist(airquality$Ozone)

# scatterplot
library(datasets)
with(airquality, plot(Wind, Ozone))

# boxplot
airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = 'Month', ylab = 'Ozone (ppb)')

# params
#   - pch: plotting symbol (default is open circle)
#   - lty: line type (default is solid line), can be dashed, dotted, etc.
#   - lwd: line width, specified as integer multiple
#   - col: color, specified as number, string or hex code; the colors() function
#       gives you a vector of colors by name
#   - xlab: char string for x-axis label
#   - ylab: char string for y-axis label 

# the par() function is used to specify global graphics params that affect all plots in an
#   R session. These params can be overridden when specified as arguments to specific
#   plotting functions.
#   - las: orientation of axis labels on plot
#   - bg: background color
#   - mar: margin size
#   - oma: outer margin size (default is 0 for all sides)
#   - mfrow: no. of plots per row, column (plots are filled row-wise)
#   - mfcol: no. of plots per row, column (plots are filled column-wise)

# plot(): make scatterplot, or other type of plot depending on class of object

# lines: add lines to a plot
# points: add points to a plot
# text: add text labels to a plot
# title: add annotations
# mtext: add arbitrary text to margins
# axis: adding axis ticks/labels

# base plot with annotation
with(airquality, plot(Wind, Ozone, main = 'Title'), type = 'n')
with(subset(airquality, Month == 5), points(Wind, Ozone, col = 'blue'))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = 'red'))
legend('topright', pch = 1, col = c('blue','red'), legend = c('May', 'Other Months'))

# base plot with regression line
with(airquality, plot(Wind, Ozone, main = 'Ozone and Wind in NYC', pch = 20))
model = lm(Ozone ~ Wind, airquality)
abline(model, lwd = 2)

# multiple base plots
par(mfrow = c(1,2))
with(airquality, {
    plot(Wind, Ozone, main = 'Ozone and Wind')
    plot(Solar.R, Ozone, main = 'Ozone and Solar Radiation')
})

# change outer margin with oma
par(mfrow = c(1,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(airquality, {
    plot(Wind, Ozone, main = 'Ozone and Wind')
    plot(Solar.R, Ozone, main = 'Ozone and Solar Radiation')
    plot(Temp, Ozone, main = 'Ozone and Temperature')
    mtext('Ozone and Weather in NYC', outer = TRUE)
})
