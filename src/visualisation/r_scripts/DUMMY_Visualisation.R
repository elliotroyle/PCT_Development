library(ggplot2)
library(plotly)
library(dplyr)
library(readxl)
library(kableExtra)
library(DT)

# Sample data for two time series
set.seed(123)
date_seq <- seq(as.Date("2020-01-01"), as.Date("2023-12-31"), by = "month")
HBA1c_value <- rnorm(length(date_seq), mean = 10, sd = 2)  # Random numerical values
Insulin_value <- rnorm(length(date_seq), mean = 5, sd = 1.2)  # Random numerical values
labels <- sample(c("Contact Type"), length(date_seq), replace = TRUE)  # Random labels

# Combine into a data frame
time_series_data <- data.frame(Date = date_seq, HBA1c_Value = HBA1c_value, Insulin_Value = Insulin_value, Labels = labels)

# Define a vector of colors for the label points
colors <- c("#cb7dfb", "#ffc648", "#ff4877")

# Create a factor variable for color assignment with appropriate labels
time_series_data$Type <- factor(
  sample(c("Diagnosis", "Prescription", "Review"), nrow(time_series_data), replace = TRUE),
  levels = c("Diagnosis", "Prescription", "Review")
)

# Create the first ggplot for HBA1c numerical points with fixed color
p1 <- ggplot(time_series_data, aes(x = Date, y = HBA1c_Value)) +
  geom_line(color = "lightblue") +
  geom_point(color = "lightblue", size = 2) +  # Plot points
  labs(title = "HBA1c Over Time",
       x = "Date",
       y = "HBA1c") +
  scale_x_date(date_labels = "%d/%m/%Y") +  # Format X-axis dates
  theme_minimal()

# Create the second ggplot for Insulin numerical points with fixed color
p2 <- ggplot(time_series_data, aes(x = Date, y = Insulin_Value)) +
  geom_line(color = "orange") +
  geom_point(color = "orange", size = 2) +  # Plot points
  labs(title = "Insulin Over Time",
       x = "Date",
       y = "Insulin") +
  scale_x_date(date_labels = "%d/%m/%Y") +  # Format X-axis dates
  theme_minimal()

# Create the third ggplot for labels with random colors and custom legend
p3 <- ggplot(time_series_data, aes(x = Date, y = factor(Labels, levels = c("Contact Type")), color = Type)) +
  geom_point(size = 2) +  # Plot label points with random colors
  scale_color_manual(values = colors, name = "Contact Type") +  # Custom color legend
  labs(title = " ",
       x = "Date",
       y = " ") +
  scale_x_date(date_labels = "%d/%m/%Y") +  # Format X-axis dates
  theme_minimal()

# Convert ggplots to plotly objects
p1_plotly <- ggplotly(p1)
p2_plotly <- ggplotly(p2)
p3_plotly <- ggplotly(p3)

# Combine the plots using subplot with different heights
combined_plot <- subplot(
  p1_plotly,
  p2_plotly,
  p3_plotly,
  nrows = 3,  # Arrange plots in three rows
  shareX = TRUE,  # Share X-axis between the plots
  titleX = TRUE,
  titleY = TRUE,
  heights = c(0.45, 0.45, 0.10)  # Adjust the heights of the plots
) %>%
  layout(
    xaxis = list(
      rangeslider = list(visible = TRUE),  # Enables scrolling
      rangeselector = list(visible = TRUE)  # Adds range selector
    )
  )

# Display the combined interactive plot
combined_plot


# Dummy patient table

table_path <- "C:/Users/elliot.royle/OneDrive - Midlands and Lancashire CSU/Git/Primary-Care-Theograph/data/processed_extracts/DUMMY_Cipha_Data.xlsx"

dummy_table_df <- read_excel(table_path, sheet = 1)

dummy_cipha_vis <- dummy_table_df %>%
  kable(format = "html", align = "lrrrrr") %>%  # Adjust align if needed
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive")) %>%
  row_spec(0, background = "#407EC9", color = "white")  # Style the header row
