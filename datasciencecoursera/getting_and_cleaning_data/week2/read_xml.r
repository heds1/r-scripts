# https://xml2.r-lib.org/
# https://blog.rstudio.com/2015/04/21/xml2/


library(xml2)

file_url <- 'https://www.w3schools.com/xml/simple.xml'

doc <- download_xml(file_url)
my_doc <- read_xml(doc)

# equivalent to xmlName(rootNode) from tutorial
xml_name(my_doc)

# show all
xml_children(my_doc)

# subset, equivalent to
xml_children(my_doc)[1]

my_names <- xml_find_all(my_doc, './/name')

xml_path(my_names)


