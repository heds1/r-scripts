Data Science Specialization:
Final Pitch
========================================================
author: Hedley Stirrat
date: 7 July 2020
autosize: true

<font size='22'>Predictive Text Modelling</font>

<style type="text/css">
body > div > div.slides > section.present > div > font > pre > code {
  font-size: 16px;
}

</style>

What is predictive text modelling?
========================================================
Predictive text modelling (or natural language processing) aims to predict the next word in a sentence
based on a provided input of words. It encompasses a broad field of
machine learning, and is used in a wide range of contexts. Many of us use
predictive text models every day without really noticing--for example,
when our Google search provides autocomplete functionality, or our text
messaging app guesses the next word that we will type.

How predictive text models work
========================================================
As is always the case, there are myriad implementations. However, underlying
all predictive text models are a few key concepts. 
- The text dataset, or <font weight="700">corpus</font>, is first created from the training data, where
  each piece of text (news article, Twitter post, etc.) is called a document
- Each document is split up into <font weight="700">tokens</font>, which are essentially subwords or characters.
  Tokens are the building blocks of predictive text models, and allow a logical
  handling of often complex text inputs.
- <font weight="700">N-grams</font> are then created from the tokens. N-grams
  are strings of words of length *n*, which form the basis of prediction.
- The tokens or n-grams are then used to produce a <font weight="700">document-frequency matrix<font>, which counts
  the instances of tokens or n-grams appearing in each document and as a whole in
  the corpus. Our predictive text models can use our document-frequency matrix,
  or something similar, to predict the next word!

What's going on behind the scenes?
========================================================
The financial independence/early retirement predictor is based on this simple
function that calculates compounding interest from your investment accounts:
<font size='10'>

```r
# function to calculate number of years until retirement
cmpd_interest_until_target <- function(rate, initial, target, injection) {
	dat <- data.frame(year = 0, principal = initial)
	while(dat[nrow(dat), 'principal'] < target) {
		this_year <- dat[nrow(dat), 'year'] + 1
		this_principal <- dat[nrow(dat), 'principal'] + rate * dat[nrow(dat), 'principal'] + injection
		dat <- bind_rows(dat, data.frame(year = this_year, principal = this_principal))
	}
	return (dat)
}
```
</font>
To see what it looks like, let's assume the following: a 7% annual rate of return,
an initial principal of \$50000, a retirement target of \$1.5M, and annual contributions
of \$40000. How long will it take for us to retire?

How long will it take?
========================================================


![plot of chunk unnamed-chunk-3](project-presentation-figure/unnamed-chunk-3-1.png)

***
Looks like financial independence is about 17 years away!
But what if we increase our contribution rate? Or
realize we don't need to have such a high income when we're retired?
To try it out for yourself,
head on over to

**https://heds1.shinyapps.io/fire-calc/**
