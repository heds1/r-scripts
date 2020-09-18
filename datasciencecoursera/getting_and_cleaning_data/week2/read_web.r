con = url('https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en')
htmlCode = readLines(con)
close(con)

htmlCode


# parse with xml
library(XML)


# GET from the httr package
library(httr); html2 = GET(url)
content2 = content(html2, as='text')
parsedHtml = htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml, '//title', xmlValue)

# authentication
pg2 = GET('http://httpbin.org/basic-auth/user/passwd', authenticate('user','passwd'))
pg2
names(pg2)

# use handles
google = handle('http://google.com')
pg1 = GET(handle=google, path='/') # you can authenticate this once, then works from there
pg2 = GET(handle=google, path='search')