<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

<br/>

<br/>

<br/>


# Theograph Proof of Concept Dashboard

The repository contains all code used by the NHS Transformation Unit analytics team during the development of the Theograph Proof of Concept Dashboard for the University of Liverpool.

<br/>

## Using the Repository

This codebase contains:

1. The `SQL` script needed for extracting the raw DynAirX data ready for processing within RStudio.
2. The `R` scripts needed for processing the raw DynAirX data ready for importing into the theograph dashboard.
3. The `R` and `.Rmd` scripts needed for creating and visualising the processed DynAirX data as an interactive dashboard.

To recreate the data pipeline created for this dashboard, users will need to ensure their working directory is structured as outlined in the [Repository Structure](##-Repository-Structure) section of this ReadMe. This can be undertaken by cloning the repository using Git or by simply downloading a zipped version of the tool from this repository.

For a more detailed guidance on how to recreate the Theograph Proof of Concept Dashboard using this repository, please see the `Theograph_creation_guidance.md` file located within the documentation subfolder.

<br/>

## Repository Structure

The current structure of the repository is detailed below:

``` plaintext

├─── data
     ├─── processed_extracts
     └─── raw_extracts
├─── documentation
     └─── project_documentation
├─── images
└─── src
     ├─── config
     |    └─── r_scripts
     ├─── data_extraction
     |    └─── sql_scripts
     ├─── data_processing
     |    └─── r_scripts
     └─── visualisation

```

<br/>

### `data`
This folder contains subfolders relating to both the raw and processed extracts. Due to GDRP, the (fictional) patient data files will not be uploaded to GitHub but placeholders are included in the repository to maintain subfolder structure.

### `documentation`
This folder contain the project documentation file, `Theograph_creation_guidance.md`.

### `images`
This folder contains all images used in the outputs or repository such as the Data Into Action logo.

### `src`
All code is stored within the `src` folder. This is then divided into `config` (R scripts), `data_extraction` (SQL scripts), `data_processing` (R scripts) and `visualisation` (RMD scripts).

<br/>

## Contributors

This repository has been created and developed by:
-   [Elliot Royle](https://github.com/elliotroyle)
-   [Andy Wilson](https://github.com/ASW-Analyst)
