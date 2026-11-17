#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    selectInput(inputId = "min_stars",
                label = "Show stars with at least this many sea stars",
                choices = c(1, 5, 10, 20),
                selected = 5),
    plotOutput("star_map")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    })
}

# Run the application 
shinyApp(ui = ui, server = server)
