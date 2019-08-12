library(tm)
library(SnowballC)
library(randomForest)
library(caTools)
library(caret)
library(pROC)

discussion <- Category_RQ1$identified_message
label <- Category_RQ1$Category
dis_set <- cbind(discussion, label)
colnames(dis_set) <- c("Text", "Label")
dis_text <- as.data.frame(dis_set)
text = Corpus(VectorSource(dis_text$Text)) #build vector corpus
text <- tm_map(text, removePunctuation) #remove punctuation
text <- tm_map(text, removeNumbers) #remove numbers
text <- tm_map(text, tolower) #transform Capital
text <- tm_map(text, stemDocument) #stem
text <- tm_map(text, stripWhitespace) #remove white space
text <- tm_map(text, removeWords, stopwords("english")) #remove stopwords
text <- tm_map(text, removeWords, c("patch", "set","abandon","httpsreviewopenstackorgc","httpsreviewopenstackorg","codereview")) #remove special charaters
process_text <- DocumentTermMatrix(text,control = list(weighting = weightTfIdf)) #weight text using TF-idf
dim(process_text) #show the dimension of processed text
corpus_dense = removeSparseTerms(process_text, 0.99)
pro_text_df <- as.data.frame(as.matrix(process_text))
colnames(pro_text_df) <- make.names(colnames(pro_text_df))

Category_RQ1$y <-NA
Category_RQ1$y[Category_RQ1$Category=="Indirect"] = 1
Category_RQ1$y[Category_RQ1$Category=="Direct-Dup"] = 2
Category_RQ1$y[Category_RQ1$Category=="Direct-wReq"] = 3
Final_data_1$y[Category_RQ1$Category=="Direct"] = 2
pro_text_df$label <- as.factor(Category_RQ1$y)
 
#below run the model with bootstrap
library(doParallel)
cl <- makeCluster(3)
registerDoParallel(cl)
comb <- function(...) {
  mapply(rbind, ..., SIMPLIFY=FALSE)
}

#table(pro_text_df$label)
bootstrap_output <- foreach(i=1:5, .combine='comb', .multicombine=TRUE) %dopar% {
  set.seed(i)
  library(randomForest)
  library(pROC)
  library(caret)
  library(rms)
  library(ROCR)

  indices <- sample(nrow(pro_text_df), replace=TRUE)
  training <- pro_text_df[indices,]
  testing <- pro_text_df[-unique(indices),]
  testing$label

  
  RF = randomForest(label ~ ., data=training, ntree=500, mtry=6, importance=TRUE)
  predTest <- predict(RF, testing, type = "class")
  acc <- mean(predTest == testing$label)
  table(predTest,testing$label)
  confMatrix <- caret:::confusionMatrix(predTest, testing$label)
  Precision_Indirect <- confMatrix$byClass[1,5]
  Precision_Direct <- confMatrix$byClass[2,5]
  Precision_Direct_wReq<- confMatrix$byClass[3,5]
  Recall_Indirect <- confMatrix$byClass[1,6]
  Recall_Direct<- confMatrix$byClass[2,6]
  Recall_Direct_wReq <- confMatrix$byClass[3,6]
  Accuracy_Indirect <- confMatrix$byClass[1,11]
  Accuracy_Direct <- confMatrix$byClass[2,11]
  Accuracy_Direct_wReq <- confMatrix$byClass[3,11]
  Fscore_Indirect <- confMatrix$byClass[1,7]
  Fscore_Direct <- confMatrix$byClass[2,7]
  Fscore_Direct_wReq <- confMatrix$byClass[3,7]
  overall_accuracy <- confMatrix$overall[[1]]
  kappa <- confMatrix$overall[[2]]
  cbind(overall_accuracy,kappa,Precision_Indirect,Precision_Direct,Precision_Direct_wReq,Recall_Indirect,Recall_Direct,
        Recall_Direct_wReq,Accuracy_Indirect,Accuracy_Direct,Accuracy_Direct_wReq,Fscore_Indirect,Fscore_Direct,Fscore_Direct_wReq)
}
bootstrap_output
mean(bootstrap_output[[1]]) #overall_accuracy
mean(bootstrap_output[[2]]) #kappa score
mean(bootstrap_output[[3]]) #Precision_Indirect
mean(bootstrap_output[[4]]) #Precision_Direct
mean(bootstrap_output[[5]]) #Precision_Direct_wReq
mean(bootstrap_output[[6]]) #Recall_Indirect
mean(bootstrap_output[[7]]) #Recall_Direct
mean(bootstrap_output[[8]]) #Recall_Direct_wReq
mean(bootstrap_output[[9]]) #Accuracy_Indirect
mean(bootstrap_output[[10]]) #Accuracy_Direct
mean(bootstrap_output[[11]]) #Accuracy_Direct_wReq
mean(bootstrap_output[[12]]) #Fscore_Indirect
mean(bootstrap_output[[13]]) #Fscore_Direct
mean(bootstrap_output[[14]]) #Fscore_Direct_wReq