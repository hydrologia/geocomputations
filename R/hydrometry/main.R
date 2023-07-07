# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 07/07/2023


rm(list = ls())
source(file = file.path(getwd(), 'R', 'functions', 'Unlink.R'))
source(file = file.path(getwd(), 'R', 'functions', 'Link.R'))



#' Shape Data/Archives
#' https://environment.data.gov.uk/catchment-planning
#'
extra <- list('anglian' = 5, 'dee' = 11, 'humber' = 4, 'north_west' = 12, 'northumbria' = 3,
              'severn' = 9, 'solway_tweed' = 2, 'south_east' = 7, 'south_west' = 8, 'thames' = 9)
districts <- names(extra)
numbers <- unlist(unname(extra))



#' Geography
#' Setting the reference coordinates
#'
source(file = file.path(getwd(), 'R', 'functions', 'encoding', 'UTM.R'))
source(file = file.path(getwd(), 'R', 'functions', 'encoding', 'AddressGeocoding.R'))

degrees <- AddressGeocoding(address = 'England')
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)



#' Get Shapes
#'
#'
#'
source(file = file.path(getwd(), 'R', 'hydrometry', 'GetShapes.R'))
UnlinkDirectories(path = file.path(getwd(), 'data', 'shapes', 'basin', 'districts'))
GetShapesInterface(numbers = numbers, districts = districts)



#' Gazetteer
#'
#'
source(file = file.path(getwd(), 'R', 'hydrometry', 'GetGazetteer.R'))
frame <- GetGazetteer(utm = utm)



#' Intersections
#'
#'
source(file = file.path(getwd(), 'R', 'hydrometry', 'Intersections.R'))
cores <- parallel::detectCores() - 2
doParallel::registerDoParallel(cores = cores)
clusters <- parallel::makeCluster(cores)
X <- parallel::clusterMap(clusters, fun = Intersections, districts, MoreArgs = list(frame = frame, utm = utm))
parallel::stopCluster(clusters)
rm(clusters, cores)

collection <- X %>%
  purrr::reduce(full_join, by='station_id')

computations <- dplyr::left_join(x = frame, y = collection, by = 'station_id')



#' Storage
#'
#'
storage <- file.path(getwd(), 'warehouse', 'hydrometry')
filestr <- 'gazetteer.csv'

LinkDirectories(path = storage)
UnlinkFiles(path = file.path(storage, filestr))

plain <- sf::st_drop_geometry(computations)
data.table::fwrite(x = plain, file = file.path(storage, filestr), append = FALSE,
                   sep = ',', row.names = FALSE, col.names = TRUE)
