
# Script for creating the timeseries and table visualisations to population the theograph tool, including the dynamic filtering functionality

# Standalone packages necessary for testing
library(ggplot2)
library(dplyr)
library(readxl)
library(plotly)
library(kableExtra)

# Load, inspect and transform the data
timeseries_path <- "C:/Users/elliot.royle/OneDrive - Midlands and Lancashire CSU/Git/Primary-Care-Theograph/data/processed_extracts/DUMMY_RStudio_Data.xlsx"
dummy_TS_df <- read_excel(timeseries_path, sheet = 1)
dummy_TS_df$Date <- as.Date(dummy_TS_df$Date)

# TEMP filter the data for specific patients
TS_df <- dummy_TS_df %>%
  filter(Patient == 'Joe Bloggs') #'Jane Doe', 'Joe Bloggs'

# Function to check if data is entirely blank
is_data_blank <- function(data, y_col, test_col, unit_col) {
  return(all(is.na(data[[y_col]])) | 
           all(is.na(data[[test_col]])) | 
           all(is.na(data[[unit_col]])))
}

# Function to create timeseries plots from different biomedical and prescription values with custom tooltips
create_time_series_plot <- function(data, date_col, y_col, test_col, unit_col, vis_colour) {
  
  # Ensuring the column names are valid
  if (!(date_col %in% names(data)) | !(y_col %in% names(data)) | !(test_col %in% names(data)) | !(unit_col %in% names(data))) {
    stop("One or more specified columns are not found in the data frame.")
  }
  
  # Check if data is blank
  if (is_data_blank(data, y_col, test_col, unit_col)) {
    return(NULL)  # Return NULL if data is blank
  }
  
  # Create dynamic labels for y-axis and tooltips
  first_non_na_test <- data[[test_col]][!is.na(data[[test_col]])][1]
  first_non_na_unit <- data[[unit_col]][!is.na(data[[unit_col]])][1]
  
  # Tooltip text format: "Date: [Date]\n[Biomedical_Test]: [Value] [Units]"
  data$tooltip_text <- paste0(
    "Date: ", format(data[[date_col]], "%d/%m/%Y"), "\n",
    first_non_na_test, ": ", data[[y_col]], " ", first_non_na_unit
  )
  
  # Y-axis label formatting
  y_label <- paste(first_non_na_test, "\n(", first_non_na_unit, ")", sep = "")
  
  # Create the ggplot object
  plot <- ggplot(data, aes_string(x = date_col, y = y_col)) +
    geom_line(color = vis_colour) +  # Ensure line is drawn
    geom_point(aes(text = tooltip_text), color = vis_colour, size = 2) +  # Points with custom tooltips
    labs(title = paste(first_non_na_test, "Over Time"),
         x = "Date",
         y = y_label) +  # Y-axis label formatting
    scale_x_date(date_labels = "%d/%m/%Y") +  
    theme_minimal()
  
  return(plot)
}

# Create plots with checks for empty data
plot_1 <- create_time_series_plot(
  data = TS_df,
  date_col = "Date",
  y_col = "Biomedical_Value_1",
  test_col = "Biomedical_Test_1",
  unit_col = "Biomedical_1_Units",
  vis_colour = "blue"
)

plot_2 <- create_time_series_plot(
  data = TS_df,
  date_col = "Date",
  y_col = "Drug_1_Value",
  test_col = "Drug_Name_1",
  unit_col = "Drug_1_Units",
  vis_colour = "lightblue"
)

plot_3 <- create_time_series_plot(
  data = TS_df,
  date_col = "Date",
  y_col = "Biomedical_Value_2",
  test_col = "Biomedical_Test_2",
  unit_col = "Biomedical_2_Units",
  vis_colour = "orange"
)

plot_4 <- create_time_series_plot(
  data = TS_df,
  date_col = "Date",
  y_col = "Drug_2_Value",
  test_col = "Drug_Name_2",
  unit_col = "Drug_2_Units",
  vis_colour = "yellow"
)

# Underpinning event series
colours <- c("#cb7dfb", "#e83f3f", "#03fca1")
TS_df$Type <- as.factor(TS_df$Type)

# Create the tooltip text for plot_5
TS_df$tooltip_text_5 <- paste0(
  "Date: ", format(TS_df$Date, "%d/%m/%Y"), "\n",
  "Event: ", TS_df$Type
)

plot_5 <- ggplot(TS_df, aes(x = Date, colour = Type)) +
  geom_point(aes(y = 1, text = tooltip_text_5), size = 2) +
  scale_color_manual(values = colours, 
                     labels = levels(TS_df$Type),
                     name = "Contact Type") +
  labs(title = " ", x = "Date", y = " ") +
  scale_x_date(date_labels = "%d/%m/%Y") +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

# Transforming ggplot objects to plotly with custom tooltips
p1_plotly <- if (!is.null(plot_1)) ggplotly(plot_1, tooltip = "text") else NULL
p2_plotly <- if (!is.null(plot_2)) ggplotly(plot_2, tooltip = "text") else NULL
p3_plotly <- if (!is.null(plot_3)) ggplotly(plot_3, tooltip = "text") else NULL
p4_plotly <- if (!is.null(plot_4)) ggplotly(plot_4, tooltip = "text") else NULL
p5_plotly <- if (!is.null(plot_5)) ggplotly(plot_5, tooltip = "text") %>%
  layout(
    legend = list(
      orientation = "h",  # Horizontal legend
      x = 0.5,            # Center horizontally
      y = -0.075,         # Position below the plot
      xanchor = "center", # Anchor the legend to its center
      yanchor = "top"     # Anchor the legend's top to the specified y position
    )
  ) else NULL

# Combine plots into a subplot, removing NULL plots
plot_list <- list(p1_plotly, p2_plotly, p3_plotly, p4_plotly, p5_plotly)
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

# Creating a table to view all data related to a single patient

output$downloadData <- downloadHandler(
  filename = function() {
    paste("patient_data_", Sys.Date(), ".csv", sep = "")
  },
  content = function(file) {
    write.csv(TS_df, file, row.names = FALSE)
  }
)
