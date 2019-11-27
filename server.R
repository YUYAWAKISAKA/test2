library(shiny)  
library(tm)  
library(wordcloud)  
library(memoise)  
library(markovchain)

options(device='cairo')

# server
function(input, output, session) {  
  apol <- makeChain('clean_apology')
  euthy <- makeChain('clean_euthyphro')

  # generate_text
  generate_text <- function(n_words){
    input$update
    if (input$selection=='clean_apology') {
      my_fit <- apol
    } else{
      my_fit <- euthy
    }
    markovchainSequence(n=n_words, markovchain=my_fit$estimate)
  }

  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })

  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  # plot
  output$plot <- renderPlot({
    options(device='cairo')
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Spectral"))})

  # markov text
  output$generated_text <- renderText({
    generate_text(input$n_words)

  })
}
