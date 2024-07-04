<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

<br/>

<br/>

<br/>

# Theograph Proof of Concept Dashboard

The repository contains all code used by the NHS Transformation Unit analytics team during the development of the Theograph Proof of Concept Dashboard for the University of Liverpool.

<br/>

## Using the Repository

This codebase contains:

1. The `R` scripts needed for processing the raw DynAirX data ready for importing into the theograph dashboard.
2. The `R` and `.Rmd` scripts needed for creating and visualising the processed DynAirX data as an interactive dashboard.

To recreate the data pipeline created for this dashboard, users will need to ensure their working directory is structured as outlined in the [Repository Structure](##-Repository-Structure) section of this ReadMe. This can be undertaken by cloning the repository using Git or by simply downloading a zipped version of the tool from this repository.

<br/>

## Repository Structure

The current structure of the repository is detailed below:

``` plaintext

├─── data
     ├─── processed_extracts
     ├─── raw_extracts
     └─── supporting_data
├─── documentation
     └─── project_documentation
├─── images
└─── src
     ├─── config
          └─── r_scripts
     ├─── data_processing
          └─── r_scripts
     └─── visualisation
          └─── r_scripts


```

<br/>

### `data`
This folder contains subfolders relating to x, y and z.

### `documentation`
This folder contain the project documentation, including x, y and z.

### `images`
This folder contains all images used in the outputs or repository such as the TU logo.

### `src`
All code is stored within the `src` folder. This is then divided into x, y and z.


<br/>

## Contributors

This repository has been created and developed by:
-   [Elliot Royle](https://github.com/elliotroyle)
-   [Andy Wilson](https://github.com/ASW-Analyst)
