########################### IST 707 Final Project ##############################
#Name: Zeyang Zhou
#Email: zezhou@syr.edu

# Run these three functions to get a clean test of code
dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# Set the working directory 
setwd("F:/desktop/2021 Spring/IST 707 data analysis/course project/data")

# Load R packages
source("R packages.R")

# Load the dataset
vgsales <- read.csv("vgsales.csv")

str(vgsales)
summary(vgsales)
# Missing values
which(rowSums(is.na(vgsales))==TRUE) # Locate the Na's rows

vgsales[11594,]
vgsales$Global_Sales[11594]<- vgsales$NA_Sales[11594]+vgsales$EU_Sales[11594]+vgsales$JP_Sales[11594]+vgsales$Other_Sales[11594]
vgsales$Global_Sales[11594]
vgsales[13539,]
vgsales$Global_Sales[13539]<- vgsales$NA_Sales[13539]+vgsales$EU_Sales[13539]+vgsales$JP_Sales[13539]+vgsales$Other_Sales[13539]
vgsales$Global_Sales[13539]
table(is.na(vgsales)) # double check

# Data type
str(vgsales)
vgsales$Year<-as.integer(vgsales$Year)
table(is.na(vgsales$Year))
unique(vgsales$Year)
vgsales<- na.omit(vgsales)
table(is.na(vgsales$Year))
table(is.na(vgsales))

# Outliers
unique(vgsales$Platform)
length(unique(vgsales$Platform))

unique(vgsales$Genre)
length(unique(vgsales$Genre))

unique(vgsales$Publisher)
length(unique(vgsales$Publisher))

unique(vgsales$Year)
length(unique(vgsales$Year))
min(vgsales$Year)
max(vgsales$Year)
boxplot(vgsales$Year)

vgsales[which(vgsales$Year==1980),]
vgsales[which(vgsales$Year==2017),]
vgsales[which(vgsales$Year==2020),] # Outlier

vgsales<- vgsales[-which(vgsales$Year==2020),]

# Rerank
vgsales$Rank = seq(length(vgsales$Rank))     
summary(vgsales)

str(vgsales)
table(is.na(vgsales))
summary(vgsales)
table(duplicated(vgsales)) # None duplicate

#Descriptive analysis
sales <-aggregate(vgsales$Global_Sales, by=list(vgsales$Publisher), FUN=sum)
head(sales)
barplot(sales$x,las=2)

# Create training (60%) and test (40%) sets for the vgsales data.
vgsales_t<- vgsales[order(vgsales$Year,-vgsales$Global_Sales),]
summary(vgsales_t)
new_train_t<- vgsales_t[c(1:round(0.6*length(vgsales_t$Year))),]
new_test_t<- vgsales_t[c(1:(length(vgsales_t$Year)-round(0.6*length(vgsales_t$Year)))),]

train_t<- vgsales_t[c(1:round(0.6*length(vgsales_t$Year))),]
test_t<- vgsales_t[c(1:(length(vgsales_t$Year)-round(0.6*length(vgsales_t$Year)))),]
train_t<- train_t[,-c(1,2)]
test_t<- test_t[,-c(1,2)]

train_t$Revenue<- cut(train_t$Global_Sales,breaks=c(0,0.48,Inf),labels=c("0","1"))

test_t$Revenue<- cut(test_t$Global_Sales,breaks=c(0,0.48,Inf),labels=c("0","1"))
write.csv(vgsales,file = "vgsales_p.csv",row.names = F)
vgsales_r<- vgsales
vgsales_r$Revenue<- cut(vgsales$Global_Sales,breaks=c(0,0.48,Inf),labels=c("0","1"))
write.csv(vgsales_r,file = "vgsales_r.csv",row.names = F)

train_t$Revenue<- as.factor(train_t$Revenue)
test_t$Revenue<- as.factor(test_t$Revenue)
train_t<- train_t[,c(1,2,3,4,10)]
test_t<- test_t[,c(1,2,3,4,10)]

write.csv(train_t,file = "train_t.csv",row.names = F)
write.csv(test_t,file = "test_t.csv",row.names = F)


# visualization
# par(xpd=T,mar=par()$mar+c(5,4,4,4))

# Genre
barplot(table(vgsales$Genre),cex.names=0.8,legend.text = TRUE,col = rainbow(12),las=2,args.legend =list(x='topright',inset=-0.1,cex=0.4),main="Genre Count")

# Platform
platform = vgsales %>% group_by(Platform) %>% summarise(Count = n())
p1 = ggplot(aes(x = Platform , y = Count , fill=Count) , data=platform) +
  geom_bar(colour='black',stat='identity') +
  theme_bw()+
  theme(axis.text.x = element_text(angle=45,hjust=1) , 
        plot.title = element_text(hjust=0.5))+  ## title center
  ggtitle('Platform Count')+
  scale_fill_distiller(palette = 'RdYlBu') +
  ylab('Count')

grid.arrange(p1, ncol = 1)

# top 10
library(tidyverse)
library(ggthemes)
library(ggplot2)
library(reshape2)
games_sales10 <-vgsales %>%
  group_by(Name) %>%
  summarise(sum_global_sales = sum(Global_Sales),.groups = 'drop') %>%
  arrange(desc(sum_global_sales))
games_totalsales <- head(games_sales10,10)

options(repr.plot.width = 16, repr.plot.height = 8)
ggplot(data= games_totalsales, aes(x= Name, y=sum_global_sales)) +
  geom_bar(stat = "identity",  aes(x= Name, y=sum_global_sales,fill=Name))+
  ggtitle("Top-10 Games by Sales") +
  xlab("Games") +
  ylab("in millions") +
  theme_stata()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position="none")
# pulisher
publisher_sales <-vgsales %>%
  group_by(Publisher) %>%
  summarise(sum_global_sales = sum(Global_Sales),.groups = 'drop') %>%
  arrange(desc(sum_global_sales))
publisher_sales20 <- head(publisher_sales,20)

options(repr.plot.width = 16, repr.plot.height = 8)
ggplot(data= publisher_sales20, aes(x= Publisher, y=sum_global_sales)) +
  geom_bar(stat = "identity",  aes(x= Publisher, y=sum_global_sales,fill=Publisher))+
  coord_flip()+
  ggtitle("Top-20 Publisher by Sales") +
  xlab("Publishers") +
  ylab("in millions") +
  geom_text(aes(label=Publisher), vjust=0.5,hjust=0, color="black",
            position = position_dodge(1), size=4)+
  theme_stata()+
  theme(legend.position="none",axis.text.y=element_blank())
# Platform sales
library(RColorBrewer)
library(reshape2)
library(gridExtra)
library(scales)
platform_sales = vgsales %>% group_by(Platform) %>% summarise(Global_Sales = sum(Global_Sales),
                                                         NA_Sales = sum(NA_Sales),
                                                         EU_Sales = sum(EU_Sales),
                                                         JP_Sales = sum(JP_Sales))

platform_sales = melt(platform_sales)
names(platform_sales) = c('Platform','SaleType','Sale')
ggplot(data = platform_sales,aes(x = Platform ,y = Sale , fill = SaleType)) + 
  geom_bar(colour='black',stat='identity',position='dodge') + 
  theme_bw()+
  theme(axis.text.x = element_text(angle=45,hjust=1),
        plot.title = element_text(hjust=0.5))+
  ggtitle('Platform Sales') +
  scale_fill_brewer(palette = 'YlGnBu')


#################### Association rules
str(vgsales_r)
head(vgsales_r)
summary(vgsales_r)
vgsales_g<- vgsales_r[,c(3,5,6,12)]
vgsales_na<-vgsales_r[,c(3,5,6,7)]
vgsales_eu<-vgsales_r[,c(3,5,6,8)]
vgsales_jp<-vgsales_r[,c(3,5,6,9)]
vgsales_oa<-vgsales_r[,c(3,5,6,10)]

# Global sales
myRules<- apriori(vgsales_g,parameter=list(supp=0.001,conf = 0.7,minlen=2),appearance = list(rhs={"Revenue=1"}))
myRules
goodrules <- myRules[quality(myRules)$lift > 1]
goodrules
inspect(goodrules) 
goodrules<-sort(goodrules, by="lift", decreasing=TRUE)
inspect(goodrules[1:10])

plot(goodrules,method="graph",interactive=TRUE,shading=NA)
# NA
vgsales_na$Revenue<- cut(vgsales_na$NA_Sales,breaks=c(0,0.24,Inf),labels=c("0","1"))
vgsales_na<- vgsales_na[,-c(4)]
myRules<- apriori(vgsales_na,parameter=list(supp=0.001,conf = 0.7,minlen=2),appearance = list(rhs={"Revenue=1"}))
myRules
goodrules <- myRules[quality(myRules)$lift > 1]
goodrules
inspect(goodrules) 
goodrules<-sort(goodrules, by="lift", decreasing=TRUE)
inspect(goodrules[1:10])

plot(goodrules,method="graph",interactive=TRUE,shading=NA)

# EU
vgsales_eu$Revenue<- cut(vgsales_eu$EU_Sales,breaks=c(0,0.14,Inf),labels=c("0","1"))
vgsales_eu<- vgsales_eu[,-c(4)]
myRules<- apriori(vgsales_eu,parameter=list(supp=0.001,conf = 0.6,minlen=2),appearance = list(rhs={"Revenue=1"}))
myRules
goodrules <- myRules[quality(myRules)$lift > 1]
goodrules
inspect(goodrules) 
goodrules<-sort(goodrules, by="lift", decreasing=TRUE)
inspect(goodrules[1:10])

plot(goodrules,method="graph",interactive=TRUE,shading=NA)

# JP
vgsales_jp$Revenue<- cut(vgsales_jp$JP_Sales,breaks=c(0,0.07,Inf),labels=c("0","1"))
vgsales_jp<- vgsales_jp[,-c(4)]
myRules<- apriori(vgsales_jp,parameter=list(supp=0.001,conf = 0.7,minlen=2),appearance = list(rhs={"Revenue=1"}))
myRules
goodrules <- myRules[quality(myRules)$lift > 1]
goodrules
inspect(goodrules) 
goodrules<-sort(goodrules, by="lift", decreasing=TRUE)
inspect(goodrules[1:10])

plot(goodrules,method="graph",interactive=TRUE,shading=NA)

# Other Area Sales
vgsales_oa$Revenue<- cut(vgsales_oa$Other_Sales,breaks=c(0,0.04,Inf),labels=c("0","1"))
vgsales_oa<- vgsales_oa[,-c(4)]
myRules<- apriori(vgsales_oa,parameter=list(supp=0.001,conf = 0.7,minlen=2),appearance = list(rhs={"Revenue=1"}))
myRules
goodrules <- myRules[quality(myRules)$lift > 1]
goodrules
inspect(goodrules) 
goodrules<-sort(goodrules, by="lift", decreasing=TRUE)
inspect(goodrules[1:10])

plot(goodrules,method="graph",interactive=TRUE,shading=NA)
#################### KNN
search_grid = expand.grid(k = c(5, 7, 9, 11, 13))

# set up 3-fold cross validation procedure
train_control <- trainControl(
  method = "cv", 
  number = 3
)

# more advanced option, run 5 fold cross validation 10 times
train_control_adv <- trainControl(
  method = "repeatedcv", 
  number = 3,
  repeats = 10
)

# train model
knn <- train(Revenue~.,
             data = train_t,
             method = "knn",
             #trControl = train_control_adv,
             trControl = train_control,
             tuneGrid = search_grid)

knn$results %>% 
  top_n(5, wt = Accuracy) %>%
  arrange(desc(Accuracy))

# results for best model
confusionMatrix(knn)

pred <- predict(knn, newdata = test_t)
confusionMatrix(pred, test_t$Revenue)
mylabels=c("Name")
label_col=new_test_t[mylabels]
combined_pred=cbind(label_col, pred)

#colnames(combined_pred)=c("ImageId", "Label")

write.csv(combined_pred, file="vgsales-KNN-pred.csv", row.names=TRUE)

## compute AUC and plot ROC curve
library(pROC)

pred_numeric = predict(knn, newdata = test_t, type="prob")

head(pred_numeric)

# plot ROC and get AUC
roc <- roc(predictor=pred_numeric$`1`,
           response=test_t$Revenue,
           levels=rev(levels(test_t$Revenue)))

roc$auc
#Area under the curve
plot(roc,main="ROC")
#################### SVM with Linear Kernel
train_s<- vgsales_t[c(1:round(0.6*length(vgsales_t$Year))),]
test_s<- vgsales_t[c(1:(length(vgsales_t$Year)-round(0.6*length(vgsales_t$Year)))),]
train_s<- train_s[,-c(1,2)]
test_s<- test_s[,-c(1,2)]

train_s$Revenue<- cut(train_s$Global_Sales,breaks=c(0,0.48,Inf),labels=c("low","high"))

test_s$Revenue<- cut(test_s$Global_Sales,breaks=c(0,0.48,Inf),labels=c("low","high"))


vgsales_r<- vgsales
vgsales_r$Revenue<- cut(vgsales$Global_Sales,breaks=c(0,0.48,Inf),labels=c("low","high"))

train_s$Revenue<- as.factor(train_s$Revenue)
test_s$Revenue<- as.factor(test_s$Revenue)
train_s<- train_s[,c(1,2,3,4,10)]
test_s<- test_s[,c(1,2,3,4,10)]

write.csv(vgsales_r,file = "vgsales_s.csv",row.names = F)

search_grid = expand.grid(C = seq(0, 2, length = 20))

# set up 3-fold cross validation procedure
train_control <- trainControl(
  method = "cv", 
  number = 3,
  classProbs = TRUE
)

# more advanced option, run 5 fold cross validation 10 times
train_control_adv <- trainControl(
  method = "repeatedcv", 
  number = 3,
  repeats = 10,
  classProbs = TRUE
)

svm = train(Revenue ~., data = train_s, 
               method = "svmLinear", 
               trControl = train_control,
               tuneGrid = search_grid)

# top 5 modesl
svm$results %>% 
  top_n(5, wt = Accuracy) %>%
  arrange(desc(Accuracy))

# results for best model
confusionMatrix(svm)

pred <- predict(svm, newdata = test_s)
confusionMatrix(pred, test_s$Revenue)

## compute AUC and plot ROC curve
library(pROC)

pred_numeric = predict(svm, newdata = test_s, type="prob")

head(pred_numeric)

# plot ROC and get AUC
roc <- roc(predictor=pred_numeric$high,
           response=test_s$Revenue,
           levels=rev(levels(test_s$Revenue)))

roc$auc
#Area under the curve
plot(roc,main="ROC")


#################### SVM with Radial Kernel
search_grid = expand.grid(sigma = seq(0.1, 1, length=2),
                          C = seq(0.1, 1, length = 2))

# set up 3-fold cross validation procedure
train_control <- trainControl(
  method = "cv", 
  number = 3,
  classProbs = TRUE
)

# more advanced option, run 5 fold cross validation 10 times
train_control_adv <- trainControl(
  method = "repeatedcv", 
  number = 3,
  repeats = 10,
  classProbs = TRUE
)

svm = train(Revenue ~., data = train_s, 
            method = "svmRadial", 
            trControl = train_control,
            tuneGrid = search_grid)

# top 5 modesl
svm$results %>% 
  top_n(5, wt = Accuracy) %>%
  arrange(desc(Accuracy))

# results for best model
confusionMatrix(svm)

pred <- predict(svm, newdata = test_s)
confusionMatrix(pred, test_s$Revenue)

## compute AUC and plot ROC curve
library(pROC)

pred_numeric = predict(svm, newdata = test_s, type="prob")

head(pred_numeric)

# plot ROC and get AUC
roc <- roc(predictor=pred_numeric$high,
           response=test_s$Revenue,
           levels=rev(levels(test_s$Revenue)))

roc$auc
#Area under the curve
plot(roc,main="ROC")


#################### SVM with Polynomial Kernel
search_grid = expand.grid(degree=c(1,2,3),
                          scale = c(0.001, 0.01, 0.1, 1.0),
                          C = seq(0.1, 2, length = 20))

# set up 3-fold cross validation procedure
train_control <- trainControl(
  method = "cv", 
  number = 3,
  classProbs = TRUE
)

# more advanced option, run 5 fold cross validation 10 times
train_control_adv <- trainControl(
  method = "repeatedcv", 
  number = 3,
  repeats = 10,
  classProbs = TRUE
)

svm = train(Revenue ~., data = train_s, 
            method = "svmPoly", 
            trControl = train_control,
            tuneGrid = search_grid)

# top 5 modesl
svm$results %>% 
  top_n(5, wt = Accuracy) %>%
  arrange(desc(Accuracy))

# results for best model
confusionMatrix(svm)

pred <- predict(svm, newdata = test_s)
confusionMatrix(pred, test_s$Revenue)

## compute AUC and plot ROC curve
library(pROC)

pred_numeric = predict(svm, newdata = test_s, type="prob")

head(pred_numeric)

# plot ROC and get AUC
roc <- roc(predictor=pred_numeric$high,
           response=test_s$Revenue,
           levels=rev(levels(test_s$Revenue)))

roc$auc
#Area under the curve
plot(roc,main="ROC")


#################### Naive Bayes
train_s<- vgsales_t[c(1:round(0.6*length(vgsales_t$Year))),]
test_s<- vgsales_t[c(1:(length(vgsales_t$Year)-round(0.6*length(vgsales_t$Year)))),]
train_s<- train_s[,-c(1,2)]
test_s<- test_s[,-c(1,2)]

train_s$Revenue<- cut(train_s$Global_Sales,breaks=c(0,0.48,Inf),labels=c("low","high"))

test_s$Revenue<- cut(test_s$Global_Sales,breaks=c(0,0.48,Inf),labels=c("low","high"))


vgsales_r<- vgsales
vgsales_r$Revenue<- cut(vgsales$Global_Sales,breaks=c(0,0.48,Inf),labels=c("low","high"))


train_s<- train_s[,c(1,3,4,10)]
test_s<- test_s[,c(1,3,4,10)]
train_s$Platform <- as.numeric(train_s$Platform)
train_s$Genre<- as.numeric(train_s$Genre)
train_s$Publisher<- as.numeric(train_s$Publisher)

test_s$Platform <- as.numeric(test_s$Platform)
test_s$Genre<- as.numeric(test_s$Genre)
test_s$Publisher<- as.numeric(test_s$Publisher)

train_s$Revenue<- as.factor(train_s$Revenue)
test_s$Revenue<- as.factor(test_s$Revenue)

features <- setdiff(names(train_s), "Revenue")

x <- train_s[, features]
y <- train_s$Revenue

# set up 3-fold cross validation procedure
train_control <- trainControl(
  method = "cv", 
  number = 3
)

# more advanced option, run 3 fold cross validation 10 times
train_control_adv <- trainControl(
  method = "repeatedcv", 
  number = 3,
  repeats = 10
)

# set up tuning grid
search_grid <- expand.grid(usekernel = c(TRUE, FALSE),
                           laplace = c(0, 1), 
                           adjust = c(0,1,2))

# train model
nb.m2 <- train(
  x = x,
  y = y,
  method = "naive_bayes",
  trControl = train_control,
  tuneGrid = search_grid
)

# top 5 modesl
nb.m2$results %>% 
  top_n(5, wt = Accuracy) %>%
  arrange(desc(Accuracy))

# results for best model
confusionMatrix(nb.m2)

pred <- predict(nb.m2, newdata = test_s)
confusionMatrix(pred, test_s$Revenue)

## compute AUC and plot ROC curve
library(pROC)

pred_numeric = predict(nb.m2, newdata = test_s, type="prob")

# plot ROC and get AUC
roc <- roc(predictor=pred_numeric$high,
           response=test_s$Revenue,
           levels=rev(levels(test_s$Revenue)))

roc$auc
#Area under the curve
plot(roc,main="ROC")

