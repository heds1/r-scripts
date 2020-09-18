library(ggplot2)

# using mpg dataset
qplot(displ, hwy, data = mpg)

# facets
# separated by tilde. vars on rhs are cols
qplot(displ, hwy, data = mpg, facets = . ~ drv)

# basic components of a ggplot2 plot
#   - df
#   - aesthetic mappings: how data are mapped to color, size, etc.
#   - geoms: geometrics objects like points, lines, shapes
#   - facets: for conditional plots
#   - stats: statistical transformations like binning, quantiles, smoothing
#   - scales: what scale an aesthetic map uses (example: male = red, female = blue)
#   - coordinate system

geom_point() + facet_grid(. ~ var) + geom_smooth(method = 'lm')

# annotation
#   - labels: xlab, ylab, labs, ggtitle
#   - each of the 'geom' functions has options to modify
#   - for things that only make sense globally, use theme()
#   - two standard themes included, theme_gray() and theme_bw()

# applies to all points
geom_point(color = 'blue')

# color by fct var
geom_point(aes(color = var))

# labels
labs(title = 'thing')

# subscript
labs(x = expression('log ' * PM[2.5]))

# axis limits
# ggplot doesn't remove outliers by default (unlike plot)

# if you change limits, then ggplot will actually remove everything out of the limits
g + geom_line() + ylim(-3, 3)

# to include the point (but just change the axis limits)
g + geom_line() + coord_cartesian(ylim = c(-3, 3))

# use the cut() function to convert a continuous variable to categorical
# calculate deciles
cutpoints <- quantile(df$var, seq(0, 1, length = 4), na.rm = TRUE)

# cut the data at the deciles and create a new fct var
df$var2 <- cut(df$var1, cutpoints)

# see the levels of the newly created fct var
levels(df$var2)

# example plot
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))

g + geom_point(alpha = 1/3)
    + facet_wrap(bmicat ~ no2dec, nrow = 2, ncol = 4)
    + geom_smooth(method = 'lm', se=FALSE, col = 'steelblue')
    + theme_bw(base_family = 'Avenir', base_size = 10)
    + labs(x = expression('log ' * PM[2.5]))
    + labs(y = 'yaxis label')
    + labs(title = 'title')
