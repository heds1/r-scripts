1.

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
library(dplyr)

training_set <- segmentationOriginal %>% filter(Case == "Train")
testing_set <- segmentationOriginal %>% filter(Case == "Test")

set.seed(125)

# modFit <- train(Case ~ ., method = "rpart", data = training_set)
# modFit$finalModel

training_set_trimmed <- training_set %>% select(Class, TotalIntenCh2, FiberWidthCh1, VarIntenCh4, PerimStatusCh1)
modFit <- train(Class ~ ., method = "rpart", data = training_set_trimmed)
modFit$finalModel

plot(modFit$finalModel)
text(modFit$finalModel)






3.

library(pgmm)
data(olive)
olive = olive[,-1]

split_sets <- function(x, split = c(0.7,0.3)) {

    assignments <- sample(c(TRUE,FALSE),nrow(x),replace=TRUE,prob=split)

    x$IsTraining <- assignments

    TrainingData <- subset(x, IsTraining)
    TrainingData <- TrainingData[,names(TrainingData)!="IsTraining"]

    TestData <- subset(x, IsTraining == FALSE)
    TestData <- TestData[,names(TestData)!="IsTraining"]

    return (list(TrainingData=TrainingData, TestData=TestData))
}


df <- split_sets(olive)

training <- df$TrainingData

mod_fit <- train(Area ~ ., method = "rpart", data = training)
newdata = as.data.frame(t(colMeans(olive)))
predict(mod_fit, newdata)



4. 

ozone <- read.table("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/ozone.data", sep = '\t', header=TRUE)


library(bestglm)
data(SAheart)
library(readr)



set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,] %>% mutate(chd = factor(chd))
testSA = SAheart[-train,] %>% mutate(chd = factor(chd))

set.seed(13234)

mod_fit <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl, method = "glm", family = "binomial", data = trainSA)

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

train_prediction <- predict(mod_fit, trainSA)
train_prediction <- as.numeric(train_prediction)-1
train_missclass <- missClass(trainSA$chd, prediction)
train_missclass

test_prediction <- predict(mod_fit, testSA)
test_prediction <- as.numeric(test_prediction)-1
test_missclass <- missClass(testSA$chd, prediction)
test_missclass

## that function doesn't work for me ...

sum(train_prediction!=trainSA$chd)/nrow(trainSA)

sum(test_prediction!=testSA$chd)/nrow(testSA)








5. 

vowel.train <- read_csv("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/vowel.train")
vowel.test <- read_csv("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/vowel.test")

vowel.train$y <- factor(vowel.train$y)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)

mod_fit <- train(y ~ ., method = "rf", data = vowel.train, prox = TRUE)

varImp(mod_fit)