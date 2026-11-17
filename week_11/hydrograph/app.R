# The purpose of this script is to run shiny app for HW assignment.
# For full test run practice, see HW_test_run.qmd in week_11's script's folder
# This is created by Gabby Tapat
# Created on 2026-11-15
# Updated on 2026-11-17

#Load libraries

library(shiny)
library(tidyverse)
library(here)


#Load data
combined <- read_csv(here("week_11", "hydrograph", "gage_data.csv"))


choices <- c(
  "Makiki stream" = "USGS-16238000",
  "Waihi stream" = "USGS-16238500",
  "Manoa-Palolo stream" = "USGS-16247100",
  "Pukele stream" = "USGS-16244000")     


# UI for application that creates line plots for discharge + turbidity for selected Ala Wai watershed streams that collect such data
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "united"), #theme of app/ background
  #see https://mastering-shiny.org/action-layout.html for more

    # Application title
    titlePanel("Hydrologic Data Explorer"),
       
    sidebarLayout(
      sidebarPanel(
        selectInput("monitoring_station_id", "Select Stream:", choices = choices),
        dateRangeInput("dateRange", "Date Range:",
                       start = min(combined$time, na.rm = TRUE),
                       end   = max(combined$time, na.rm = TRUE)),
        helpText("Warning: There are gaps in the data"),
        width = 3
      ),

      mainPanel(
        h3("Discharge over time"),
        plotOutput("Q_plot"),
        br(), #line break
        h3("Turbidity over time"),
        plotOutput("T_plot"),
        br(), #line break
        h3("Summary"),
        tableOutput("summary_table")
      )
    )
)

# Define server logic required to create plots & summary table
server <- function(input, output) {

  # Filter data reactively
  filtered <- reactive({
    req(input$monitoring_station_id, input$dateRange) #required inputs for app
    
    combined |>
      filter(monitoring_location_id == input$monitoring_station_id,
             time >= as_datetime(input$dateRange[1]),
             time <= as_datetime(input$dateRange[2]))
  })
  
  # Create plot for discharge/stream flow (term used interchangeably)
  output$Q_plot <- renderPlot({
    d <- filtered()
    validate(need(nrow(d)>0, "No data for selection")) #Validates input values and conditions for reactive rendering
    
    ggplot(d, aes(x = time, y = discharge_cfs)) +
      geom_line(colour = "#4682B4") +
      labs(
        title = input$monitoring_station_id, 
        x = "", 
        y = "Discharge (cfs)") +
      theme_minimal()+
      theme(
        axis.title.y = element_text(color = "#4682B4",
                                    size = 14,
                                    face = "bold"))
    
  })
  
  # Create plot for turbidity 
  output$T_plot <- renderPlot({
    d <- filtered()
    validate(need(nrow(d)>0, "No data for selection")) #Validates input values and conditions for reactive rendering
    
    ggplot(d, aes(x = time, y = turbidity_FNU)) +
      geom_line(colour = "#DEB887") +
      labs(
        title = input$monitoring_station_id, 
        x = "", 
        y = "Turbidity (FNU)") +
      theme_minimal()+
      theme(
        axis.title.y = element_text(color = "#DEB887",
                                    size = 14,
                                    face = "bold"))
    
  })
  
  # Summary table for data - min, max, avg values
  output$summary_table <- renderTable({
    d <- filtered()
    if (nrow(d) == 0) return(data.frame(note = "No data"))
    
    summarise(d,
              max_discharge = max(discharge_cfs, na.rm = TRUE),
              min_discharge = min(discharge_cfs, na.rm = TRUE),
              avg_discharge = mean(discharge_cfs, na.rm = TRUE),
              max_turbidity = max(turbidity_FNU, na.rm = TRUE),
              min_turbidity = min(turbidity_FNU, na.rm = TRUE),
              avg_turbidity = mean(turbidity_FNU, na.rm = TRUE)
    )

      })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
