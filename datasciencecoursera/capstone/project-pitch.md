Data Science Specialization: Final Pitch
========================================================
author: Hedley Stirrat
date: 7 July 2020
autosize: true


<font size='22'>Predictive Text Modelling and Shiny Application</font>

<style type="text/css">
body > div > div.slides > section.present > div > font > pre > code {
  font-size: 16px;
}

</style>

What is predictive text modelling?
========================================================
Predictive text modelling (or natural language processing) aims to predict the next word in a sentence
based on a provided input of words.

It encompasses a broad field of
machine learning, and is used in a wide range of contexts. Many of us use
predictive text models every day without really noticing--for example,
when our Google search provides autocomplete functionality, or our text
messaging app guesses the next word that we will type.

<img src="autocomplete.png" />


How predictive text models work
========================================================
A few key concepts underly all predictive text models.
- The text dataset, or <font weight="700">corpus</font>, comprises a series of documents (examples of text)
- Each document is split up into <font weight="700">tokens</font>, usually words, which
are the building blocks of predictive text models.
- <font weight="700">N-grams</font> are then created from the tokens. N-grams
  are strings of words of length *n*.
- N-grams are used to produce a <font weight="700">document-frequency matrix</font>, which counts
the frequency of terms appearing in our corpus and forms the basis of prediction.


Try it out yourself
========================================================
We've created an R Shiny application that implements a simple predictive text
model. You simply enter your text in the text box, click "Predict!", and the top
five word predictions will be displayed for you. 

**https://heds1.shinyapps.io/capstone/**

For more information about how the app works, or to see the source code for data processing and
the application itself, check out the <a href="https://github.com/heds1/datasciencecoursera/tree/master/capstone">author's Github repository.</a>

Happy predicting!


How the algorithm works
========================================================

The word prediction algorithm itself is remarkably simple. It utilises a
dictionary of n-grams (of lengths 2 to 5) to predict the next word given an
input of up to four words. Firstly, an exact match is looked for in the
processed training dataset dictionary. If any matches are found, the predicted
word is directly based on the dictionary's actual next word for the given
n-gram. Matches are ranked by simple frequency counts in the training dataset,
smoothed with add-one smoothing. 

If less than five matches are found, the length of the n-gram is reduced by one,
and the dictionary is queried again. The same process is repeated until five
matches have been found, or the entire dictionary has been traversed.

