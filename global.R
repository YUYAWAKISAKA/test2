library(shiny)  
library(tm)  
library(wordcloud)  
library(memoise)  
library(markovchain)

"Plato in the Word Clouds:
Creates word clouds for some of Plato's popular dialogues &  
uses a Markov model to generate sentences of arbitrary length"


# The list of valid dialogues
books <- list("Apology" = "clean_apology",  
              "Euthyphro" = "clean_euthyphro")

# Use "memoise" to cache the results
getTermMatrix <- memoise(function(book) {  
  # stop malicious users
  if (!(book %in% books))
    stop("Unknown book")

  # read in the text
  text <- readLines(sprintf("%s.txt", book),
                    encoding="UTF-8")
  # make a corpus for the wordcloud
  # ideally your text would already be cleaned, but including this for good measure
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "and", "but"))

  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))

  m = as.matrix(myDTM)

  sort(rowSums(m), decreasing = TRUE)
})
# create the markov chain
# Use "memoise" to cache the results
makeChain <- memoise(function(book){  
  # read in the text
  text <- readLines(sprintf("%s.txt", book),
                    encoding="UTF-8")
  terms <- unlist(strsplit(text, ' '))
  fit <- markovchainFit(data = terms)
  return(fit)
})
