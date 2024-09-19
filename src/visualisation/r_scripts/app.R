
# Theograph application app-side script.

## Packages needed for generating the application.

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(readxl)

## Loading GP event data

timeseries_path <- "C:/Users/elliot.royle/OneDrive - Midlands and Lancashire CSU/Git/Primary-Care-Theograph/data/processed_extracts/DUMMY_RStudio_Data.xlsx"

dummy_TS_df <- read_excel(timeseries_path, sheet = 1)

dummy_TS_df$Date <- as.Date(dummy_TS_df$Date)

## Define UI ----
ui <- fluidPage(
  titlePanel("Theograph Dashboard"),
  
  # Output: Plot and download button
  plotlyOutput("timeseriesPlot"),
  downloadButton("downloadData", "Download Patient Data")
)

## Define server logic ----
server <- function(input, output) {
  
  # Filter data for visualization
  TS_df <- dummy_TS_df %>%
    filter(Patient == 'Jane Doe')
  
  # Create time series plot
  output$timeseriesPlot <- renderPlotly({
    plot_1 <- ggplot(TS_df, aes(x = Date, y = Biomedical_Value_1)) +
      geom_line(color = "blue") +
      geom_point(aes(text = paste("Date:", Date, "Value:", Biomedical_Value_1)), color = "blue") +
      labs(x = "Date", y = "Biomedical Value 1") +
      theme_minimal()
    
    ggplotly(plot_1, tooltip = "text")
  })
  
  # Download data handler
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("patient_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(TS_df, file, row.names = FALSE)
    }
  )
}

# Run the application ----
shinyApp(ui = ui, server = server)
