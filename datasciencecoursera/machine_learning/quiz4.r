1.

library(readr)
vowel.train <- read_csv("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/vowel.train")
vowel.test <- read_csv("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/vowel.test")

# drop first col for rownames
vowel.train <- vowel.train[, -1]
vowel.test <- vowel.test[, -1]

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)
set.seed(33833)

library(caret)

mod_rf <- train(y ~ ., method = "rf", data = vowel.train, prox = TRUE)
confusionMatrix(vowel.test$y, predict(mod_rf, vowel.test))

mod_boost <- train(y ~ ., method = "gbm", data = vowel.train)
confusionMatrix(vowel.test$y, predict(mod_boost, vowel.test))

rf_pred <- predict(mod_rf, vowel.test)
b_pred <- predict(mod_boost, vowel.test)

combined_pred <- rf_pred[rf_pred == b_pred]
filtered_test <- vowel.test[rf_pred == b_pred ,]

confusionMatrix(filtered_test$y, combined_pred)


2.

remove_assignment_var <- function(x) {
    return (x[, names(x) != 'AssignedSet'])
}

split_sets <- function(x, split = c(0.7,0.3), validation = FALSE) {

    if (validation == TRUE) {

        assignments <- sample(
            x = c("train","test","validation"),
            size = nrow(x),
            replace = TRUE,
            prob = split)

        x$AssignedSet <- assignments
        TrainingData <- subset(x, AssignedSet == 'train')
        TestData <- subset(x, AssignedSet == 'test')
        ValidationData <- subset(x, AssignedSet == 'validation')
        TrainingData <- remove_assignment_var(TrainingData)
        TestData <- remove_assignment_var(TestData)
        ValidationData <- remove_assignment_var(ValidationData)

        return (list(TrainingData=TrainingData, TestData=TestData, ValidationData=ValidationData))

    } else {
        assignments <- sample(c(TRUE,FALSE),nrow(x),replace=TRUE,prob=split)

        x$IsTraining <- assignments

        TrainingData <- subset(x, IsTraining)
        TrainingData <- TrainingData[,names(TrainingData)!="IsTraining"]

        TestData <- subset(x, IsTraining == FALSE)
        TestData <- TestData[,names(TestData)!="IsTraining"]

        return (list(TrainingData=TrainingData, TestData=TestData))
    }
}

library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)

data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

dat <- split_sets(adData, split = c(0.6,0.2,0.2), validation = TRUE)
dat <- split_sets(adData)

set.seed(62433)

mod_rf <- train(diagnosis ~ ., method = "rf", data = dat$TrainingData, prox = TRUE)
mod_gbm <- train(diagnosis ~ ., method = "gbm", data = dat$TrainingData)
mod_lda <- train(diagnosis ~ ., method = "lda", data = dat$TrainingData)

pred1 <- predict(mod_rf, dat$TestData)
pred2 <- predict(mod_gbm, dat$TestData)
pred3 <- predict(mod_lda, dat$TestData)

stacked <- data.frame(
    diagnosis = dat$TestData$diagnosis,
    pred1 = pred1,
    pred2 = pred2,
    pred3 = pred3)

combModFit <- train(diagnosis ~ ., method = "rf", data = stacked)

confusionMatrix(stacked$diagnosis, predict(combModFit, stacked))
confusionMatrix(stacked$diagnosis, pred1)
confusionMatrix(stacked$diagnosis, pred2)
confusionMatrix(stacked$diagnosis, pred3)



3.

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(233)

mod_las <- train(CompressiveStrength ~ ., method = "lasso", data = training)


4.

library(lubridate) # For year() function below
library(forecast)

dat = read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv")
dat <- dat[, -1]
training = dat[year(dat$date) < 2012,] %>% mutate(date=ts(date))
testing = dat[(year(dat$date)) > 2011,] %>% mutate(date=ts(date))
tstrain = ts(training$visitsTumblr)

mod <- bats(training$date)