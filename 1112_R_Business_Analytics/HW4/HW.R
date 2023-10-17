#Q0 匯入要用到的資料和套件 並確認檔案內容


setwd("C:\\Users\\ASUS\\Desktop\\五234 R\\HW4") #放你的路徑
financialData <- read.csv("financialdata.csv")
financialData
# 把第一個變數id刪掉
data = financialData[,-1]
data$op_profit_growth_rate <- as.numeric(data$op_profit_growth_rate)
data$current_ratio <- as.numeric(data$current_ratio)
data$quick_rartio <- as.numeric(data$quick_rartio)

# 處理na（用平均值代替）
mean_col1 <- mean(data[, 11], na.rm = T)  # column 1 的平均數(na.rm = T 忽略遺失值)
na_c1rows <- is.na(data[, 11])           # column 1 中，有遺失值存在的資料(回傳TRUE/FALSE)
mean_col2 <- mean(data[, 14], na.rm = T) # column 3
na_c2rows <- is.na(data[, 14])        
mean_col3 <- mean(data[, 15], na.rm = T) # column 3
na_c3rows <- is.na(data[, 15])       

# 用 mean( column 1 ) ，填補第一欄位的遺漏值
data[na_c1rows, 11] <- mean_col1
data[na_c2rows, 14] <- mean_col2
data[na_c3rows, 15] <- mean_col3

# 變成矩陣
M = cor(data)
# 畫熱點圖
library(reshape2)
melted_cormat <- melt(M)
head(melted_cormat)

library(ggplot2)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

# 資料financialdata.csv 有163間公司的財務指標。

# 1. 以PCA或SPCA分析，找出每個主成份能解釋多少變異？
# 大概需要多少個PC來解釋這筆資料？

# install.packages("stats")
library(stats)
pca<- prcomp(data, center = TRUE, scale = TRUE)
names(pca) #sdev=std. deviation, rotation=coefficient主成份的係數矩陣
summary(pca)
plot(pca) #Variation	explained

## scree plot: variance
screeplot(pca) #same as plot(pca)
plot(pca, type="line")
abline(h=0.8, col="blue") #Kaiser eigenvalue-greater-than-one rule, choose pc1~pc5 by Kaiser

summary(pca)

#選前80%左右 & h在0.8以上 => 選前六個維度


# 2. 找出前三個主成份分別重點變數為何並解釋。
## Rotation matrix: Loadings are the percent of variance explained by the variable
pca$rotation

#visualize
ggplot(melt(pca$rotation[,1:3]), aes(Var2, Var1)) +
  geom_tile(aes(fill = value), colour = "white") +
  scale_fill_gradient2(low = "firebrick4", high = "steelblue",
                       mid = "white", midpoint = 0) +
  guides(fill=guide_legend(title="Coefficient")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        axis.title = element_blank())


# 3. 找出適合投資的公司。
# (不需指出是哪間公司，只需依第一主成份結果說明，
#   例如：適合投資資產報酬率高的公司)

