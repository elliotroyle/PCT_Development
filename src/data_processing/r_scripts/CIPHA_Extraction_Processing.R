
# Script for processing raw CIPHA DynAirX data into workable format.

## Loading raw data

raw_file_path <- paste0(here(),"/data/raw_extracts/CIPHA_Data_Raw.xlsx")

raw_CIPHA_df <- readxl::read_excel(raw_file_path)


## Splitting main data file into various subsets for visualisation

