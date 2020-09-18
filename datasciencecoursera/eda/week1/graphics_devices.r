# a graphics device is something or some place where you can make a plot appear
#   - a window on your computer (screen device)
#   - a pdf file (file device)
#   - a png or jpeg (file device)
#   - a scalable vector graphics (SVG) file (file device)

# when you make a plot in R, it has to be 'sent' to a specific graphics device

# the most common place for a plot to be 'sent' is the screen device
#   - mac: quartz()
#   - windows: windows()
#   - unix: x11()

# when making plot, you need to consider how the plot will be used, to determine
# what device the plot should be sent to
#   - the list of devices is found in ?Devices;
#   - there are also devices created by users on CRAN

# for quick visualisations and exploratory analysis, usually you want to use the
# screen device
#   - functions like plot() in base, xyplot() in lattice, or qplot() in ggplot2
#     will default to sending a plot to the screen device
#   - on a given platform, there is only once screen device

# for plots that may be printed out or be incorporated into a document (e.g.,
# papers, reports), usually a 'file device' is more appropriate
#   - there are many different file devices to choose from

# note: not all graphics devices are available on all platforms

# how does a plot get created?
# there are two basic approaches to plotting. the first is most common:
#   1. call a plotting function like plot
#   2. the plot appears on the screen device
#   3. annotate plot if necessary

library(datasets)
with(faithful, plot(eruptions, waiting))
title = main('Old Faithful Geyser Data')

# the second approach to plotting is most commonly used for file devices
#   1. explicitly launch a graphics device
#   2. call a plotting function to make a plot (note, if you are using a file device, 
#       no plot will appear on the screen)
#   3. annotate plot if necessary
#   4. explicitly close graphics device with dev.off() VERY IMPORTANT

# open pdf device in wd
pdf(file = 'myplot.pdf')

# create plot and send to file
with(faithful, plot(eruptions, waiting))

# annotate plot
title(main('Title'))

# close pdf file device
dev.off()


# graphics file devices. there are 2 basic types: vector and bitmap devices
# vector formats:
#   - pdf: useful for line-type graphics, resizes well, usually portable, not efficient
#       if a plot has many objects/points
#   - svg: xml-based scalable vector graphics; supports animation and interactivity,
#       potentially useful for web-based plots
#   - win.metafile: windows metafile (only on windows)
#   - postscript: older format, also resizes well, usually portable, can be used to
#       create encapsulated postscript files; windows systems often don't have a
#       postscript viewer

# bitmap formats
#   - png: bitmapped format, good for line drawings or images with solid colours,
#       uses lossless compression, most web browsers can read this format natively,
#       good for plotting many many points, doesn't resize well
#   - jpeg: good for photos or natural screens, uses lossy compression, good for
#       plotting many points, doesn't resize well, not great for line drawings
#   - tiff: supports lossless compression
#   - bmp: a native windows bitmapped format

# it's possible to open multiple graphics devices (screen, file or both),
# for example when viewing multiple plots at once
# plotting can only occur on one graphics device at a time
# the currently active graphics device can be found by calling dev.cur()
# every open graphics device is assigned an integer >= 2
# you can change the active graphics device with dev.set(<integer>) where
# <integer> is the number associated with the graphics device you want to switch to.

# copying plots can be useful bc some plots require a lot of code and it can be
# a pain to type all that in again for a different device.
#   - dev.copy: copy a plot from one device to another
#   - dev.copy2pdf: copy a plot to a pdf file

# note: copying a plot is not an exact operation, so the result may not be 
#   identical to the original.

library(datasets)
with(faithful, plot(eruptions, waiting))
title(main('Title'))
dev.copy(png, file = 'geyserplot.png')
dev.off()