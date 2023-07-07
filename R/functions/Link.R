# Title     : Link.R
# Objective : Link directories
# Created by: greyhypotheses
# Created on: 07/07/2023


LinkDirectories <- function (path) {

  if (!dir.exists(paths = path)) {
    dir.create(path = path, showWarnings = TRUE, recursive = TRUE)
  }

}