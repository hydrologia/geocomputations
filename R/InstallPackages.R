# Title     : InstallPackages.R
# Objective : Install and activate packages
# Created by: greyhypotheses
# Created on: 07/07/2023


#' Official packages
#'
InstallPackagesOfficial <- function (){

  packages <- c('tidyverse', 'ggplot2', 'moments', 'tinytex', 'rmarkdown', 'stringr', 'latex2exp', 'mapview', 'tseries',
              'roxygen2', 'healthcareai', 'equatiomatic', 'rstatix', 'matrixStats', 'patchwork', 'geoR', 'PrevMap',
              'kableExtra', 'bookdown', 'lme4', 'nlme', 'MASS', 'viridis', 'DescTools', 'sf', 'raster', 'tmap',
              'terra', 'spData', 'tidygeocoder', 'rnaturalearth', 'geodata', 'leaflet', 'splancs', 'doParallel')

  # Install
  .install <- function(x){
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
    }
  }
  lapply(packages, .install)

}


#' Packages in development
InstallPackagesExtraneous <- function () {

  packages <- 'spDataLarge'
  repositories <- 'https://nowosad.r-universe.dev'

  # Install
  .install <- function(x, y){
    if (!require(x, character.only = TRUE)) {
      install.packages(x, repos = y, dependencies = TRUE)
    }
  }
  mapply(FUN = .install, x = packages, y = repositories)

}