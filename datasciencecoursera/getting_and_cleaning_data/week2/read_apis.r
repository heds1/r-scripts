# accessing twitter from R

# make a twitter api app...

# then

library(httr)

myapp = oauth_app('twitter',
    key = 'yourConsumerKeyHere',
    secret = 'yourConsumerSecretHere')

sig = sign_oath1.0(mpapp,
    token = 'yourTokenHere',
    token_secret = 'yourTokenSecretHere')

homeTL = GET('https://api.twitter.com/1.1/statuses/home_timeline.json', sig)

# converting the json object

json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

# httr allows GET, POST, PUT, DELETE if you are authorised
# can authenticate with username and pw
# most modern APIs use oauth or something
# httr works will with FB, google, twitter, github etc.