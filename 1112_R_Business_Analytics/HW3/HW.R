#Q0 匯入要用到的資料和套件 並確認檔案內容
# install.packages("class")
library(class)
library(tidyverse)
# install.packages("randomForest")
library(randomForest)
library(ggplot2)
# install.packages("factoextra")
library(factoextra)
# install.packages("dplyr")
library(dplyr)

setwd("C:\\Users\\ASUS\\Desktop\\五234 R\\HW3") #放你的路徑
airline <- read.csv("airline_survey.csv")
airline<-na.omit(airline)
set.seed(100)

# 1. 辨認出滿意與不滿意客戶 Predict passenger satisfaction.
# 任選1種監督式學習方法配適模型，預測滿意度satisfaction (2類：滿意、中立或不滿意)。

# 調整變數型態（文字轉為數字級距）
airline$satisfaction <- as.factor(ifelse(airline$satisfaction == "satisfied", 1, 0))
airline$Gender<- as.factor(ifelse(airline$Gender=="Male",1,0))
airline$Customer.Type<- as.factor(ifelse(airline$Customer.Type=="Loyal Customer",1,0))
airline$Type.of.Travel<- as.factor(ifelse(airline$Type.of.Travel=="Business travel",1,0))
airline$Class<- as.factor(ifelse(airline$Class=="Business",2,ifelse(airline$Class=="Eco",1,0)))
airline<- airline %>% mutate(
  Flight.Distance = (Flight.Distance - min(Flight.Distance)) / (max(Flight.Distance) - min(Flight.Distance)),
  Departure.Delay.in.Minutes= (Departure.Delay.in.Minutes - min(Departure.Delay.in.Minutes)) / (max(Departure.Delay.in.Minutes) - min(Departure.Delay.in.Minutes)),
  Arrival.Delay.in.Minutes= (Arrival.Delay.in.Minutes - min(Arrival.Delay.in.Minutes)) / (max(Arrival.Delay.in.Minutes) - min(Arrival.Delay.in.Minutes))
)

# training and test data
airline.1<-airline[sample(1:nrow(airline),2000),]
traind<-airline.1[sample(1:nrow(airline.1),1600),]
testd<-airline.1[sample(1:nrow(airline.1),400),]

### KNN ###
pred=knn(traind[,2:24], testd[,2:24], cl=traind[,25], k = 6) #prob=T
table(real=testd[,25], pred)

#choose k
range <- 1:round(0.2 * nrow(traind)) #通常 k 的上限為訓練樣本數的 20%
accuracies <- rep(NA, length(range))

for (i in range) {
  test_predicted <- knn(train = traind[,2:24], test = testd[,2:24], cl = traind[,25], k = i)
  conf_mat <- table(testd$satisfaction, test_predicted)
  accuracies[i] <- sum(diag(conf_mat))/sum(conf_mat)
}

##視覺化上面結果
plot(range, accuracies, xlab = "k")
which.max(accuracies) #k

# 找出重要變數：哪些因素影響客戶滿意度。

# 從數據大小可看出變數的重要性，取前3筆作為重要變數： Online.boarding、Inflight.wifi.service、Type.of.Travel
RF <- randomForest(satisfaction~. ,data=traind, importane = T, na.action = na.omit)
importance(RF)
varImpPlot(RF)

# 2. 描述客戶 Customer segmentation
# 任選1種非監督式方法，將客戶分群，介紹你分出來的群，
# 對於這些不同的客戶群集提出給該航空業的商業策略建議。

# 註：不需使用所有變數，可以先篩選你覺得有用的變數再去做分析。
#不需做訓練集、測試集。若電腦無法讀取大資料，可任選部分資料讀取。
airline.2<-airline.1[,-c(1:2)]
airline.2<-na.omit(airline.2)

E.dist <- dist(airline.2, method="euclidean") # 歐式距離
tree1 <- hclust(E.dist, method="ward.D2")
fviz_nbclust(airline.2, FUN = hcut, method = "wss") #運用Gap statistic找適合的分群數目

plot(tree1, xlab="Euclidean",h=-1) #h=-1 齊頭--分五組
rect.hclust(tree1,k=4,border="blue")#把3群畫出來

cluster <- cutree(tree1, k=4)  # 分成3群
table(cluster)#看分群狀況

airline.2=cbind(airline.2,cluster)

# Oline.boarding
ggplot( data= airline.2) +
  geom_bar( aes( x = Online.boarding)) + 
  facet_wrap( ~ cluster)

# Inflight.wifi.service
ggplot( data =airline.2) +
  geom_bar( aes( x = Inflight.wifi.service)) + 
  facet_wrap( ~ cluster)

# Type.of.Travel
ggplot( data =airline.2) +
  geom_bar( aes( x = Type.of.Travel)) + 
  facet_wrap( ~ cluster)

# Class
ggplot( data =airline.2) +
  geom_bar( aes( x = Class)) + 
  facet_wrap( ~ cluster)

# Inflight.entertainment
ggplot( data =airline.2) +
  geom_bar( aes( x = Inflight.entertainment)) + 
  facet_wrap( ~ cluster)

# Seat.comfort
ggplot( data =airline.2) +
  geom_bar( aes( x = Seat.comfort)) + 
  facet_wrap( ~ cluster)

# Leg.room.service
ggplot( data =airline.2) +
  geom_bar( aes( x = Leg.room.service)) + 
  facet_wrap( ~ cluster)
