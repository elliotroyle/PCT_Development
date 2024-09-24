library(shiny)
library(ggplot2)
library(dplyr)
library(readxl)
library(plotly)
library(kableExtra)

# Load, inspect and transform the data
timeseries_path <- "C:/Users/elliot.royle/OneDrive - Midlands and Lancashire CSU/Git/Primary-Care-Theograph/data/processed_extracts/DUMMY_RStudio_Data.xlsx"
dummy_TS_df <- read_excel(timeseries_path, sheet = 1)
dummy_TS_df$Date <- as.Date(dummy_TS_df$Date)

# Define UI
ui <- fluidPage(
  titlePanel("Theograph Tool"),
  sidebarLayout(
    sidebarPanel(
      selectInput("patient", "Select Patient:", 
                  choices = unique(dummy_TS_df$Patient),
                  selected = unique(dummy_TS_df$Patient)[1])
    ),
    mainPanel(
      plotlyOutput("combined_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive data frame based on selected patient
  TS_df <- reactive({
    dummy_TS_df %>%
      filter(Patient == input$patient)
  })
  
  # Function to check if data is entirely blank
  is_data_blank <- function(data, y_col, test_col, unit_col) {
    return(all(is.na(data[[y_col]])) | 
             all(is.na(data[[test_col]])) | 
             all(is.na(data[[unit_col]])))
  }
  
  # Function to create timeseries plots
  create_time_series_plot <- function(data, date_col, y_col, test_col, unit_col, vis_colour) {
    if (!(date_col %in% names(data)) | !(y_col %in% names(data)) | !(test_col %in% names(data)) | !(unit_col %in% names(data))) {
      stop("One or more specified columns are not found in the data frame.")
    }
    
    if (is_data_blank(data, y_col, test_col, unit_col)) {
      return(NULL)
    }
    
    first_non_na_test <- data[[test_col]][!is.na(data[[test_col]])][1]
    first_non_na_unit <- data[[unit_col]][!is.na(data[[unit_col]])][1]
    
    data$tooltip_text <- paste0(
      "Date: ", format(data[[date_col]], "%d/%m/%Y"), "\n",
      first_non_na_test, ": ", data[[y_col]], " ", first_non_na_unit
    )
    
    y_label <- paste(first_non_na_test, "\n(", first_non_na_unit, ")", sep = "")
    
    plot <- ggplot(data, aes_string(x = date_col, y = y_col)) +
      geom_line(color = vis_colour) + 
      geom_point(aes(text = tooltip_text), color = vis_colour, size = 2) + 
      labs(title = paste(first_non_na_test, "Over Time"),
           x = "Date",
           y = y_label) +
      scale_x_date(date_labels = "%d/%m/%Y") +  
      theme_minimal()
    
    return(plot)
  }
  
  output$combined_plot <- renderPlotly({
    plot_1 <- create_time_series_plot(
      data = TS_df(),
      date_col = "Date",
      y_col = "Biomedical_Value_1",
      test_col = "Biomedical_Test_1",
      unit_col = "Biomedical_1_Units",
      vis_colour = "blue"
    )
    
    plot_2 <- create_time_series_plot(
      data = TS_df(),
      date_col = "Date",
      y_col = "Drug_1_Value",
      test_col = "Drug_Name_1",
      unit_col = "Drug_1_Units",
      vis_colour = "lightblue"
    )
    
    plot_3 <- create_time_series_plot(
      data = TS_df(),
      date_col = "Date",
      y_col = "Biomedical_Value_2",
      test_col = "Biomedical_Test_2",
      unit_col = "Biomedical_2_Units",
      vis_colour = "orange"
    )
    
    plot_4 <- create_time_series_plot(
      data = TS_df(),
      date_col = "Date",
      y_col = "Drug_2_Value",
      test_col = "Drug_Name_2",
      unit_col = "Drug_2_Units",
      vis_colour = "yellow"
    )
    
    colours <- c("#cb7dfb", "#e83f3f", "#03fca1")
    TS_df()$Type <- as.factor(TS_df()$Type)
    TS_df()$tooltip_text_5 <- paste0(
      "Date: ", format(TS_df()$Date, "%d/%m/%Y"), "\n",
      "Event: ", TS_df()$Type
    )
    
    plot_5 <- ggplot(TS_df(), aes(x = Date, colour = Type)) +
      geom_point(aes(y = 1, text = tooltip_text_5), size = 2) +
      scale_color_manual(values = colours, 
                         labels = levels(TS_df()$Type),
                         name = "Contact Type") +
      labs(title = " ", x = "Date", y = " ") +
      scale_x_date(date_labels = "%d/%m/%Y") +
      theme_minimal() +
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank())
    
    plot_list <- list(
      ggplotly(plot_1, tooltip = "text"),
      ggplotly(plot_2, tooltip = "text"),
      ggplotly(plot_3, tooltip = "text"),
      ggplotly(plot_4, tooltip = "text"),
      ggplotly(plot_5, tooltip = "text")
    )
    plot_list <- Filter(Negate(is.null), plot_list)
    
    combined_plot <- subplot(
      plot_list,
      nrows = length(plot_list),
      shareX = TRUE,
      titleX = TRUE,
      titleY = TRUE,
      heights = c(rep(0.225, length(plot_list) - 1), 0.1)
    ) %>%
      layout(
        xaxis = list(
          rangeslider = list(visible = FALSE),
          rangeselector = list(),
          fixedrange = TRUE
        )
      )
    
    return(combined_plot)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
