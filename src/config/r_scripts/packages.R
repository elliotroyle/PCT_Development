
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
              "dplyr")

lapply(packages, library, character.only=TRUE)