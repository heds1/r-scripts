# read json

library(jsonlite)

json_data <- fromJSON('https://api.github.com/users/heds1/repos')

names(json_data)

# https://www.smashingmagazine.com/2018/01/understanding-using-rest-api/
# add query parameters

json_data <- fromJSON('https://api.github.com/users/heds1/repos?type=owner')

test <- fromJSON('https://official-joke-api.appspot.com/jokes/programming/random')