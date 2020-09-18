## Final project for Getting and Cleaning Data

### Dataset
The data for this project comes from the Human Activity Recognition Using Smartphones Data Set.

A description of the dataset can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

A direct link to the dataset can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Approach
Using run_analysis.R, the data is downloaded and stored in a temporary local file. The relevant data is loaded into the local environment, and merged into one dataset. The dataset is subsetted to only extract measurements of the mean and standard deviation. Some further data cleanup then occurs, including renaming variables and providing more descriptive field names. Finally, the data is summarised into a tidy dataset in a wide format, showing the mean measurement value of each variable for a given subject and activity combination.

### Codebook
The codebook describing the dataset can be found here: https://github.com/heds1/datasciencecoursera/blob/master/getting_and_cleaning_data/week4/project/code_book.md

### Submitted Dataset
The final submitted dataset is in a tidy, wide format. The data can be read directly into RStudio with the following code:
    
    df <- read.table('https://raw.githubusercontent.com/heds1/datasciencecoursera/master/getting_and_cleaning_data/week4/project/submission.txt', header = TRUE)
