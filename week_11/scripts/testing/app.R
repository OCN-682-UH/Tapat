#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sliderInput(inputId = "num", # ID name for the input
  label = "Choose a number", # label for input
  value = 25, min = 1, max = 100
),

textInput(inputId = "title",
          label = "Write a title",
          value = "Histogram of Random Normal Values"),

plotOutput("hist"), #creates space for a plot called hist

verbatimTextOutput("stats") #creates a space for stats

)



# Define server logic required to draw a histogram
server <- function(input, output) {
  output$hist <-renderPlot({
    
    #{} allows to put all R code in one nice chunck
    
    data <- reactive({
      tibble(x = rnorm(input$num)) # number of points in my slider
    })
     
    
    ggplot(data(), aes(x=x)) +
      geom_histogram()+
      labs(title = input$title) #adds a new title
    
  })
  
  output$stats <- renderPrint({
    base::summary(data()) # calculate summary stats based on the #'s
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
