library(bslib)
library(shinyWidgets)
library(purrr)

source("utils.R")

ui <- page_sidebar(
  title = "GB Bikepacking Routes",
  sidebar = sidebar(
    open = FALSE,
    width = 280,
    
    # Map tile selection
    selectizeInput(inputId = "tiles",
                   label = "Map tiles",
                   choices = c("OpenStreetMap.Mapnik",
                               "Esri.WorldImagery")),
    
    # Button to open code repo
    actionButton(inputId = "code", 
                 label = "View Source Code", 
                 icon = icon("github"), 
                 onclick = "window.open('https://github.com/lukebandy/GBBikebackingRoutes', '_blank')")
  ),
  layout_columns(
    card(
      leafletOutput("map"),
      full_screen = TRUE
    ),
    card(
      DTOutput("table"),
      card_footer("Select rows to filter map")
    )
  )
)

server <- function(input, output) {
  
  output$table <- renderDT({
    render_table()
  })
  
  output$map <- renderLeaflet({
    leaflet() |> 
      render_routes(names(data))
  })
  
  observeEvent(input$tiles, {
    leafletProxy('map') |> 
      clearTiles() |> 
      addProviderTiles(input$tiles)
  })
  
  # TODO: Stop double render on open
  observeEvent(input$table_rows_selected, ignoreNULL = FALSE, ignoreInit = TRUE, {
    
    if (is.null(input$table_rows_selected)) {
      routes <- names(data)
    } else {
      routes <- df |> filter(row_number() %in% input$table_rows_selected) |> pull(Route)
    }
    
    leafletProxy('map') |> 
      clearShapes() |> 
      render_routes(routes)
  })
}

shinyApp(ui, server)