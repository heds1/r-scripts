# base
#   - start with blank canvas and build up from there
#   - start with plot function or similar
#   - use annotation functions to add/modify (text, lines, points, axis)
#   - convenient, mirrors how we think of building plots and analysing data
#   - can't go back once plot has started (e.g., to adjust margins), need to plan in advance
#   - difficult to 'translate' to others once a new plot has been created
#   (no graphical 'language')
#   - plot is just a series of R commands
library(datasets)
data(cars)
with(cars, plot(speed, dist))


# lattice
#   - plots are created with a single function call (xyplot, bwplot, etc.)
#   - most useful for conditioning types of plots: looking at how y changes with x across 
#   levels of z
#   - things like margins/spacing set automatically because entire plot is specified at once
#   - good for putting many many plots on a screen
#   - sometimes awkward to specify an entire plot in a single function call
#   - annotation in plot is not especially intuitive
#   - use of panel functions and subscripts difficult to wield and require
#   intense preparation
#   - cannot 'add' to the plot once it's created
library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4,1))


# ggplot2
#   - splits the difference between base and lattice in a number of ways
#   - automatically deals with spacings, text, titles but also allows you to annotate
#   by 'adding' to a plot
#   - superficial similarity to lattice but generally easier/more intuitive to use
#   - default mode makes many choices for you (but you can still customize)
library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)