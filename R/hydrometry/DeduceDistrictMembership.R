



source(file = file.path(getwd(), 'R', 'hydrometry', 'Intersections.R'))



#' Deduce District Membership
#'
#' @param districts: The list of river basin districts
#' @param frame: Which records of <frame> lie within a district?
#' @param utm: Universal Transverse Mercator code
#'
DeduceDistrictMembership <- function (districts, frame, utm) {


  cores <- parallel::detectCores() - 2
  doParallel::registerDoParallel(cores = cores)
  clusters <- parallel::makeCluster(cores)
  X <- parallel::clusterMap(clusters, fun = Intersections, districts, MoreArgs = list(frame = frame, utm = utm))
  parallel::stopCluster(clusters)
  rm(clusters, cores)

  collection <- X %>%
    purrr::reduce(full_join, by='station_id')

  computations <- dplyr::left_join(x = frame, y = collection, by = 'station_id')

  return (computations)

}
