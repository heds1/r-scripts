# metacharacters

#  ^ represents start of a line

^i think
# i think we all rule
# i think ...
# i think blah
# BUT NOT 'interesting, i think...'
 
# $ represents the end of a line
morning$
# well they have something this morning

# character classes with [] will match all versions of the word 'bush'
# regardless of capitalisation
[Bb][Uu][Ss][Hh] 

# look at beginning of line to start with 'i' or 'I', followed by the literal
# 'am'
^[Ii] am 

# can specify range of letters [a-z] or [a-zA-Z], order doesn't matter.
# to look for any number followed by any letter
^[0-9][a-zA-Z] 
# 7th inning stretch
# 2nd half soon to begin

# when used at the beginning of a character class [], the ^ is also a
# metacharacter that indicates matching characters NOT in the indicated class.
# so to look for lines that don't end in a period or a question mark
[^?.]$

# '.' is used to refer to any character.
9.11
# 9-11
# 9/11
# 203.111.239.113
# 9:11

# | means 'or'
# matches anything with the word floor or fire
flood|fire

# can do as many ORs as possible
floor|earthquake|hurricane

# can use with other metacharacters
# match either good/Good at beginning of line, or bad/Bad anywhere
^[Gg]ood|[Bb]ad

# parentheses ()
# now they both have to be at the beginning of the line
^([Gg]ood|[Bb]ad)

# question mark: indicates that the expression is optional
# so we can include W, w, W., w., or none at all
[Gg]eorge([Ww]\.)? [Bb]ush

# need to escape the character dot because . is a metacharacter (meaning any character)

# * means 'any number, including none, of the item'
# this will match any char with any number of times inside parentheses
(.*)

# + means 'at least one of them'
# at least one number, followed by any number of chars, followed by at least one number again
[0-9]+ (.*)[0-9]+

# {} are interval quantifiers, which let us specify the minimum and maximum
# number of matches of an expression look for bush/Bush, and debate, and in
# between we want a space, followed by something that's not a space, and we want
# to see that between 1 and 5 times.
[Bb]ush( +[^ ]+ +){1,5} debate

# m,n means at least m but not more than n matches
# m means exactly m matches
# m, means at least m matches

# parentheses not only limit the scope of alternatives divided by |, but also
# can be used to remember text matches by the subexpression enclosed.
# we refer to the matched text with \1, \2, etc.

# looking for at least one space, followed by at least one character, followed
# by at least one space, followed by the exact same match that was in the
# parentheses (i.e., whatever that happened to be)
 +([a-zA-Z]+) +\1 +
# blah blah
# night night

# * is 'greedy' so it always matches the longest possible string that satisfies
# the regular expression
# looking for something that starts and finishes with s. takes longest.
^s(.*)s
# sitting at starbucks
# setting up mysql and rails

# the greediness of * can be turned off with the ?, as in
^s(.*?)s$
# sitting at s
# setting up mys