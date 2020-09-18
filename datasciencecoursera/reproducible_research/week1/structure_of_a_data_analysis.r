# Structure of a data analysis

## Steps in a data analysis
- define the question
- define the ideal dataset
- determine what data you can access
- obtain the data
- clean the data
- exploratory data analysis
- statistical prediction/modeling
- interpret results
- challenge results
- synthesize/write up results
- create reproducible code

## Define the question
- start with a general question:
    - 'can i automatically detect emails that are spam or not?'
- make it concrete:
    - 'can i use quantitative characteristics of the emails to classify them as
spam/not?'

## Define the ideal dataset
- the dataset may depend on your goal
    - descriptive: a whole population
    - exploratory: a random sample with many vars measured
    - inferential: the right population, randomly sampled
    - predictive: a training and test dataset from the same pop
    - causal: data from a randomized study
    - mechanistic: data about all components of the system

## Determine what data you can access
- sometimes you can find data free on the web
- other times you may need to buy the data
- be sure to respect the terms of use
- if the data don't exist, you may need to generate it yourself

## Obtain the data
- try to obtain the raw data
- be sure to reference the source
- polite emails go a long way
- if you will load the data from an internet source, record the url and time
accessed

## Clean the data
- raw data often needs to be processed
- if it is preprocessed, make sure you understand how
- understand the source of the data (census, sample, convenience sample,
etc.)
- may need reformatting, subsampling - record these steps
- determine if the data are good enough - if not, quit or change data

### subsampling dataset - split into training and test
```{r}
set.seed(3435)
train_indicator <- rbinom(4601, size = 1, prob = 0.5)
table(train_indicator)
# train_df <- df[train_indicator == 1, ]
# test_df <- df[train_indicator == 0, ]
```

## Exploratory data analysis
- look at summaries of the data
- check for missing data
- create exploratory plots
- perform exploratory analyses (e.g., clustering)

## Statistical prediction/modeling
- should be informed by the results of your exploratory analysis
- exact methods depend on the question of interest
- transformations/processing should be accounted for when necessary
- measures of uncertainty should be reported

## Interpret results
- use appropriate language (describes, correlates with/associated with,
leads to/causes, predicts)
- give an explanation
- interpret coefficients
- interpret measures of uncertainty

## Challenge results
- challenge all steps: question, data source, processing, analysis,
conclusions
- challenge measures of uncertainty
- challenge choices of terms to include in models
- think of potential alternative analyses

## Synthesize/write-up results
- lead with the question
- summarize the analyses into the story
- don't include every analysis, include it if it is needed for the story, or
if it is needed to address a challenge
- order analyses according to the story, rather than chronologically
- include 'pretty' figures that contribute to the story
in this example..
- lead with the question: can i use quantitative characteristics of emails
to classify them as spam?
- describe the approach: collected data from UCI -> created training/test
sets; explored relationships; chose logistic model on training set by
cross-validation; applied to test, 78% test set accuracy
- interpret results: number of dollar signs seems reasonable, e.g., 'make
money with this product \$ \$ \$ \$'
- challenge results: 78% isn't that great; could use more vars; why logistic
regression?
