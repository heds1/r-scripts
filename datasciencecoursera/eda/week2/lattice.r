# uses lattice and grid packages
# lattice includes functions like xyplot, bwplot, levelplot
# grid implements a different graphics system independent of the base system
# lattice builds on top of grid
# we seldom call functions from grid directly
# lattice doesn't have a two-phase aspect with separate plotting and annotation
# like in base plotting.
# all plotting/annotation is done at once with a single function call

# xyplot: scatterplots
# bwplot: boxplots
# histogram: ..
# stripplot: like a boxplot but with actual points
# dotplot: plot dots on 'violin strings'
# splom: scatterplot matrix; like pairs() in base plotting system
# levelplot, contourplot: for plotting 'image' data

# lattice functions generally take a formula for their first argument, of the form
xyplot(y ~ x | f * g, data)

# we use the formula notation here, hence the ~.
# on the left side of the ~ is the y-axis var; right side is x-axis.
# f and g are conditioning variables - they are optional
#   - the * indicates an interaction bewteen two vars
# 'look at y and x for every level of f and g' (e.g. f and g are categorical vars)
# the second argument is the data frame or list from which the vars in the formula
# should be looked up.
#   - if no df or list is passes, then the parent frame is used
#   - if no other arguments are passed, defaults are used

# simple lattice plot
library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data = airquality)

# plot ozone vs wind by month
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5, 1))

# lattice behaviour
# lattice functions behave differently from base graphics functions in one critical way.
#   - base graphics functions plot data directly to the graphics device (screen, pdf, etc.)
#   - lattice graphics functions return an object of class trellis
#   - the print methods for lattice functions actually do the work of plotting the data
#       on the graphics device
#   - lattice functions return 'plot objects' that can, in principle, be stored (but it's
#       usually better to just save the code + cata)
#   - on the cmd, trellis objects are auto-printed so that it appears the function
#       is plotting the data.

# no autoprint
p <- xyplot(Ozone ~ Wind, data = airquality)
print(p)

# autoprint
xyplot(Ozone ~ Wind, data = airquality)


#   - lattice panel functions lattice functions have a panel function which controls
#       what happens inside each panel of the plot
#   - lattice comes with default panel functions, but you can supply your own in you want to
#       customize what happens in each panel
#   - panel functions receive the x/y coordinates of the data points in their panel
#       (along with any optional arguments)
#   - panels receive subset of data defined by the conditioning var that is supplied

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y = x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c('Group 1', 'Group 2'))
xyplot(y ~ x | f, layout = c(2, 1))

# custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
    # first call the default panel function for 'xyplot'
    panel.xyplot(x, y, ...)

    # add a horizontal line att he median
    panel.abline(h = median(y), lty = 2)
})

# custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
    # first call the default panel function for 'xyplot'
    panel.xyplot(x, y, ...)

    # aoverlay a simple linear regression
    panel.lmline(x, y, col = 2)
})