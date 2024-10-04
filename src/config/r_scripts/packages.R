
# Script for loading appropriate packages for CIPHA data extraction, processing and visualisation.

packages <- c("here",
              "tidyverse",
              "odbc",
              "DBI",
              "openxlsx",
              "readxl",
              "plotly", 
              "kableExtra",
              "DT", 
              "shiny",
              "fastmap",
              "rlang")

lapply(packages, library, character.only=TRUE)
