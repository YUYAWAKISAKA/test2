library(shiny)

fluidPage(  
  # Application title, browser tab title
  titlePanel("Plato in the Word Clouds", 'plato_clouds'),

  sidebarLayout(
    # Lefthand sidebar with a slider
    sidebarPanel(
      selectInput("selection", "Choose a dialogue:",
                  choices = books),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 25, value = 10),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 250,  value = 100),
      sliderInput("n_words",
                  "Words to Generate:",
                  min=1, max = 25, value=10),
      textOutput("generated_text")


    ),

    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
    )
  )
)
