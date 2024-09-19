
# Script for loading appropriate packages for CIPHA data extraction, processing and visualisation.

packages <- c("here",
              "tidyverse",
              "odbc",
              "DBI",
              "purrr",
              "tidyr",
              "stringr",
              "openxlsx",
              "readxl",
              "dplyr",
              "ggplot2",
              "plotly", 
              "kableExtra",
              "DT", 
              "readxl")

lapply(packages, library, character.only=TRUE)
