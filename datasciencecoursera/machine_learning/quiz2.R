ggplot(training, aes(x=as.numeric(row.names(training)), y=CompressiveStrength,
colour=Age)) + geom_point()


4. preProcess(IL, method="pca", thresh=0.8)


5.

il_train <- training[,c(TRUE, grepl("^IL", names(training))[2:length(names(training))])]
il_test <- testing[,c(TRUE, grepl("^IL", names(testing))[2:length(names(testing))])]

fit_std <- train(diagnosis ~ ., method = "glm", data = il_train)
confusionMatrix(il_test$diagnosis, predict(fit_std, il_test))

pca_preproc <- preProcess(il_train, method = "pca", thresh = 0.8)
train_pc <- predict(pca_preproc, il_train)
fit_pca <- train(diagnosis ~ ., method = "glm", data = train_pc)
confusionMatrix(il_test$diagnosis, predict(fit_pca, il_test))