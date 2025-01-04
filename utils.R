library(leaflet)
library(DT)
library(readxl)
library(dplyr)
library(scales)

data <- readRDS("data.RDS")

render_routes <- function(map, routes) {
  for (route in routes) {
    map <- map |> 
      addPolylines(
        data = data[[route]],
        lat = ~lat,
        lng = ~lon,
        color = df |> filter(Route == route) |> pull(Color),
        label = route,
        opacity = 0.8,
        weight = 3)
  }
  map
}

df <- read_xlsx("info.xlsx") |> 
  arrange(Route)
df$Color <- hue_pal()(nrow(df))

# TODO: Pre-sort by col 1 and alphabetically, not by URL
render_table <- function() {
  df |> 
    mutate(Route = paste0("<a href='", Link, "' target='_blank', style='color: ", Color, "'>", Route, "</a>")) |> 
    select(-c(Link, Color)) |> 
    datatable(
      rownames = FALSE,
      escape = FALSE,
      options = list(
        dom = "t",
        pageLength = -1
      ))
}
