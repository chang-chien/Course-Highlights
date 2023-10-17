library(tm)
# install.packages("proxy")
library(proxy)
# install.packages("tidytext")
library(tidytext)
library(wordcloud2)

setwd("C:\\Users\\ASUS\\Desktop\\五234 R\\HW5") #放你的路徑
data <- read.csv("IMDb_Feature Film_2022_review_data.csv")
data <- na.omit(data)


data_s <- subset(data,Title=="Scream")
# 創建 Corpus
x <- Corpus(VectorSource(data_s$Review))
# 清理文本
x <- tm_map(x, content_transformer(tolower))
x <- tm_map(x, removePunctuation)
myStopWords <- c(stopwords("english"), "just", "even","will","much","also","still","one","can","really","scream","movie","movies","film","films" )#remove some words
x <- tm_map(x, removeWords, myStopWords)
# 建立 Term-Document Matrix
x_tdm <- TermDocumentMatrix(x)
# 轉換為矩陣
review_mx <- as.matrix(x_tdm)
# Sum rows and frequency data frame
freq_dfx <- rowSums(review_mx)
# Sort term_frequency in descending order
freq_dfx <- sort(freq_dfx, decreasing = T)
# View the top 20 most common words
barplot(freq_dfx[1:20], col = "royalblue", las = 2)
freq_dfx <- data.frame(word = names(freq_dfx),
                       num = freq_dfx)
# 生成文字雲
wordcloud2(freq_dfx, size = 0.9)
# 計算相似度
x_tdm2 <- removeSparseTerms(x_tdm, sparse = 0.9)
mydata_x <- as.data.frame(as.matrix(x_tdm2))
hc_x <- hclust(d = dist(mydata_x, method = "cosine"), method = "complete")
plot(hc_x)
#sentiments 
get_sentiments("bing")
bing_word_countsx <- freq_dfx %>%
  inner_join(get_sentiments("bing")) 
bing_word_countsx
table(bing_word_countsx$sentiment)
bing_word_countsx %>% 
  filter(sentiment == "positive") %>% 
  select(word,num)%>% 
  wordcloud2()


data_a <- subset(data,Title=="The Adam Project")
y <- Corpus(VectorSource(data_a$Review))
y <- tm_map(y, content_transformer(tolower))
y <- tm_map(y, removePunctuation)
myStopWords <- c(stopwords("english"), "just","can","really","will","still","one","every","even","much","movie","movies","film","films","adam","project" )#remove some words
y <- tm_map(y, removeWords, myStopWords)
y_tdm <- TermDocumentMatrix(y)
review_my <- as.matrix(y_tdm)
freq_dfy <- rowSums(review_my)
freq_dfy <- sort(freq_dfy, decreasing = T)
barplot(freq_dfy[1:20], col = "royalblue", las = 2)
freq_dfy <- data.frame(word = names(freq_dfy),
                       num = freq_dfy)
wordcloud2(freq_dfy, size = 0.9)
y_tdm2 <- removeSparseTerms(y_tdm, sparse = 0.9)
mydata_y <- as.data.frame(as.matrix(y_tdm2))
hc_y <- hclust(d = dist(mydata_y, method = "cosine"), method = "complete")
plot(hc_y)
bing_word_countsy <- freq_dfy %>%
  inner_join(get_sentiments("bing")) 
bing_word_countsy
table(bing_word_countsy$sentiment)
bing_word_countsy %>% 
  filter(sentiment == "positive") %>% 
  select(word,num)%>% 
  wordcloud2()

#再進一步分析Review Sentiment和Satisfaction Index的關係
library(syuzhet)
#第一部電影
# 執行情感分析，將情感分數添加到 movie_data
data_s$Sentiment_Score <- get_sentiment(data_s$Review, method = "afinn")
# 第二部電影
data_a$Sentiment_Score <- get_sentiment(data_a$Review, method = "afinn")
# 繪製 Review 和 Satisfaction_Index 的散點圖
plot(data_s$Sentiment_Score, data_s$Satisfaction_Index,
     xlab = "Sentiment Score", ylab = "Satisfaction Index",
     main = "Review Sentiment vs. Satisfaction Index",
     xlim = c(-30, 80), ylim = c(-6, 4))
points(data_a$Sentiment_Score, data_a$Satisfaction_Index, col = "red")


plot(data_a$Sentiment_Score, data_a$Satisfaction_Index,
     xlab = "Sentiment Score", ylab = "Satisfaction Index",
     main = "Review Sentiment vs. Satisfaction Index",
     xlim = c(-30, 80), ylim = c(-6, 4))

