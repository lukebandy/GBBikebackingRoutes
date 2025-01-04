# Libraries
library(xml2)
library(purrr)
library(stringr)

# Function
# TODO: Accept rtept (route point) tags as well as trkpt
parse_file <- function(file) {
  k <- read_html(file.path("data", file))
  gpx_tags <- xml_find_all(k, "//trkpt") # Track points
  gpx <- xml_attrs(gpx_tags)
  # Parse the data into atomic objects we know how to handle
  gpx.vec <- unlist(gpx,use.names = TRUE)
  lon <- as.numeric(gpx.vec[names(gpx.vec)=="lon"])
  lat <- as.numeric(gpx.vec[names(gpx.vec)=="lat"])
  # Build the dataframe
  gpxdf <- data.frame(
    cbind(
      lat,
      lon
    )
  )
  names(gpxdf) <- c("lat","lon")
  gpxdf
}

# Parse
files <- list.files("data/", recursive = TRUE)
data <- map(files, parse_file, .progress = TRUE)
data <- setNames(data, files |> str_remove(".gpx") |> str_extract("/.+") |> str_sub(2))

# Write
saveRDS(data, "data.RDS")
