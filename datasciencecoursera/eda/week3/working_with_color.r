# defaults include
heat.colors()
topo.colors()

# color utilities
# the grDevices package has two functions
#   - colorRamp
#   - colorRampPalette
# these functions take palettes of colors and help interpolate between the colors
# the function colors() lists the names of colors you can use in any plot

# colorRamp: take a palette of colors and return a function that takes values between
#   0 and 1, indicating the extremes of the color palette (e.g., see the 'gray' function)

# colorRampPalette: take a palette of colors and return a function that takes integer arguments
#   and returns a vector of colors interpolating the palette (like heat.colors or topo.colors)


# colorRamp example
pal <- colorRamp(c('red','blue'))

# get red, i.e., one end of the spectrum specified
pal(0)
#      [,1] [,2] [,3]
# [1,]  255    0    0

# get blue
pal(1) 
#      [,1] [,2] [,3]
# [1,]    0    0  255

# get in between the two
pal(0.5)
#       [,1] [,2]  [,3]
# [1,] 127.5    0 127.5

# get a sequence of colours of length len
# i.e., get a sequence of colors between 0 and 1 (between red and blue in this case)
pal(seq(0, 1, len = 10))


# colorRampPalette example
pal <- colorRampPalette(c('red','blue'))

# takes integer args (not args between 0 and 1 like colorRamp does)
# returns chr vector of, in this case, red and blue
pal(2)
# [1] "#FF0000" "#0000FF"

# return red and blue, plus the 8 intermediate colors
pal(10)
# [1] "#FF0000" "#E2001C" "#C60038" "#AA0055" "#8D0071" "#71008D" "#5500AA" "#3800C6" "#1C00E2" "#0000FF"


# RColorBrewer package
# three types of palettes
#   - sequential (e.g. light to dark)
#   - diverging (e.g. dark to light to dark)
#   - qualitative (categorical data)

# palette info can be used in conjunction with the colorRamp() and colorRampPaletter() funs


library(RColorBrewer)
cols <- brewer.pal(3, 'BuGn')

cols

pal <- colorRampPalette(cols)

image(volcano, col = pal(20))

# smoothScatter creates a 2d histogram
# darker areas are higher density than lighter areas
x <- rnorm(10000)
y <- rnorm(10000)
smoothScatter(x, y)


# rgb function can be used to produce any color via red, green, blue proportions

# color transparency can be added via the alpha parameter to rgb

# the colorspace package can be used for a different control over colors

# add transparency (it's the fourth param to rgb, using alpha = 0.2)
plot(x, y, col = rgb(0, 0, 0, 0.2), pch = 19)

