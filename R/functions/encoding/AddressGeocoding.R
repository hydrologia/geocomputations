# Title     : AddressGeocoding.R
# Objective : Address Geocoding
# Created by: greyhypotheses
# Created on: 07/07/2023


#' Address Geocoding
#'
#' @description Retrieves the longitude & latitude values of an address, place, via a geocoding service
#'
#' @param address: A list of addresses/places, e.g., c('Auckland, New Zealand', 'Magway, Myanmar', 'Monrovia, Liberia')
#'
AddressGeocoding <- function (address) {

  # Inserting the list into a dataframe
  queries <- data.frame(address = address)

  # The reference notes of function geo(.) outline the <method> options
  places <- tidygeocoder::geocode(queries, address = address, method = 'osm') %>%
    data.frame()

  # Renaming
  latest <- dplyr::rename(places, 'longitude' = 'long', 'latitude' = 'lat')

  # Setting-up as geographic coördinates
  latest <- latest %>%
    sf::st_as_sf(coords = c('longitude','latitude'), crs = 'EPSG:4326', remove = FALSE)

  return(latest)

}