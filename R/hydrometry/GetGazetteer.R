# Title     : GetGazetteer.R
# Objective : Get Gazetteer
# Created by: greyhypotheses
# Created on: 07/07/2023


#' Get Gazetteer
#'
#'
GetGazetteer <- function (utm) {

  # Coordinates
  # utils::read.csv()
  # readr::read_csv()
  url <- 'https://raw.githubusercontent.com/thirdreading/references/master/warehouse/hydrometry/gazetteer.csv'
  stations <- data.table::fread(url, header = TRUE, encoding = 'UTF-8')


  # setting the reference coordinates
  frame <- st_as_sf(stations, coords = c('longitude', 'latitude')) %>%
    st_set_crs(value = 'EPSG:4326')
  frame$longitude <- stations$longitude
  frame$latitude <- stations$latitude


  # transforming
  frame <- st_transform(frame, crs = paste0('EPSG:', utm))
  frame$utm_x <- as.numeric(st_coordinates(frame, UTM)[, 1])
  frame$utm_y <- as.numeric(st_coordinates(frame, UTM)[, 2])


  return (frame)

}