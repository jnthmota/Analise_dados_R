library(twitteR)
library(ROAuth)
library(tm)
library("stringi")
library(wordcloud)
library(syuzhet)

consumer_key <- ''
consumer_secret <- ''
access_token <- ''
access_secret <- ''

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tweets <- searchTwitter("vacina", n=1000, lang="pt")
dados <- twListToDF(tweets)
dim(dados)  
corpus <- Corpus(VectorSource(dados$text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, novasstop)
tdm <- as.matrix((TermDocumentMatrix(corpus, control=list(stemming = TRUE))))
dim(tdm)
fre <- rowSums(tdm)
fre <- sort(fre,decreasing = TRUE)
head(fre)
wordcloud(corpus, min.freq = 30, max.words = 30, random.order = FALSE,rot.per = 0.35, colors=brewer.pal(8,"Dark2"))
s<- get_nrc_sentiment(dados$text)
barplot(colSums(s), las=2, col = rainbow(10), ylab= "Contagem", 
        main = "Sentimentos em relação ao a CPI" )
