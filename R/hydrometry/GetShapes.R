# Title     : GetShapes.R
# Objective : GetShapes
# Created by: greyhypotheses
# Created on: 07/07/2023


#' Get Shapes Algorithm
#'
#' @note https://environment.data.gov.uk/catchment-planning
#'
#' @param number: A `river basin district` number
#' @param district: The district's name
#'
GetShapesAlg <- function (number, district) {

  url <- glue::glue('https://environment.data.gov.uk/catchment-planning/RiverBasinDistrict/{as.character(number)}/shapefile.zip')

  temp <- base::tempfile()
  utils::download.file(url = url, temp)
  utils::unzip(temp, files = NULL, list = FALSE, overwrite = TRUE,
               junkpaths = FALSE, exdir = file.path(getwd(), 'data', 'shapes', 'basin', 'districts', district),
               unzip = "internal", setTimes = FALSE)
  unlink(temp)

}


#' Get Shapes Interface
#'
#' @param numbers: A list of `river basin district` numbers
#' @param districts: A list of district names
#'
GetShapesInterface <- function (numbers, districts) {

  cores <- parallel::detectCores() - 2
  doParallel::registerDoParallel(cores = cores)
  clusters <- parallel::makeCluster(cores)
  parallel::clusterMap(clusters, fun = GetShapesAlg, numbers, districts)
  parallel::stopCluster(clusters)
  rm(clusters, cores)

}