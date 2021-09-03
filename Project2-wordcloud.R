#install.packages("tm")
#install.packages("SnowballC")
#install.packages("wordcloud")
#install.packages("RColorBrewer")

library(tm)
library(SnowballC)
library(wordcloud)
library(wordcloud2)
library(RColorBrewer)

# file choose by navigator 
text = readLines(file.choose())
# or by filepath
# filePath = "http://www.abc.txt" for example
# text = readLines(filePath)

# Corpus process
docs = Corpus(VectorSource(text))

#inspect the content of the document
inspect(docs)

# text transformation
# by using tm_map() function 
# replace special characters with space
toSpace = content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs = tm_map(docs, toSpace, "/")
docs = tm_map(docs, toSpace, "@")
docs = tm_map(docs, toSpace, "\\|")
docs = tm_map(docs, toSpace, "â???¢\t")
docs = tm_map(docs, toSpace, "Â???O")
docs = tm_map(docs, toSpace, "Â???T")
docs = tm_map(docs, toSpace, "Â???\u009d")
#docs = tm_map(docs, toSpace, "Â???"")
docs = tm_map(docs, toSpace, "Â???T")

# text cleaning
# by using tm_map() function
# convert text to lower case
#docs = tm_map(docs, content_transformer(tolower))

# remove numbers
docs = tm_map(docs, removeNumbers)
# remove english common stopwords
docs = tm_map(docs, removeWords, stopwords("english"))
# remove punctuations
docs = tm_map(docs, removePunctuation)
# eliminate extra white spaces
docs = tm_map(docs, stripWhitespace)

# if necessary, stemming text
# docs = tm_map(docs, stemDocument)

# specify your stopwords
docs = tm_map(docs, removeWords, c("the", "and", "that", "for"))
# convert text to upper case
docs = tm_map(docs, content_transformer(toupper))
docs = tm_map(docs, removeWords, c("THE"))
docs = tm_map(docs, toSpace, "CAN")
docs = tm_map(docs, toSpace, "FIELDS")
docs = tm_map(docs, toSpace, "STUDY")
docs = tm_map(docs, toSpace, "USING")
docs = tm_map(docs, toSpace, "HOLES")
#docs = tm_map(docs, removePunctuation)

# build a term-document matrix
tdm = TermDocumentMatrix(docs,control = list(tolower = FALSE))
m = as.matrix(tdm)
d = sort(rowSums(m), decreasing=TRUE)
t = data.frame(word = names(d), freq=d)
head(t, 10)

# generate the wordcloud
set.seed(1)
wordcloud(words=t$word,         # words
          freq=t$freq,          # frequency 
          min.freq=1,           # minimum frequency to be used
          max.words=200,        # maximum words to be used
          random.order=FALSE,   # false: big font centered
          rot.per=0.35,         # % of words to be rotated
          colors=brewer.pal(8, "Dark2")  # 8: font size, Dark2, set1~3, Blues, ...
)
