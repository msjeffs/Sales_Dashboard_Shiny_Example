server <- function(input, output, session) {
  ### <-- Reactive Functions Go Here --> ###
  
  
  ### <-- Observe Functions Go Here --> ###

observe({
  print(input$RegionInput)
})
  
  ### <-- Plots Go Here ###
  
# Page 1.2 Plots
output$plot1a <- renderPlotly({
  ggplotly(seg_sales)
  })

output$plot2a <- renderPlotly({
  ggplotly(cat_sales)
  })



output$leaflet_map <- renderLeaflet({
  # Insert Main Leaflet Map Here
  leaf
})

# this is where the clustered map will go
output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    
    
  })
  
output$table = DT::renderDataTable({
    
    DT::datatable(store,
              options = list(
                "pageLength" = 20)
    )
  })
}

  # output$plot2 <- renderPlot({
  #   filtered <- 
  #   store %>%
  #     filter(
  #       Region == input$RegionInput
  #     )
  #   # Insert Plot Here
  #   ggplot(filtered, aes(Sales)) +
  #     geom_histogram() +
  #     theme_classic()
  # })
  # 
  # output$results <- renderTable({
  #   filtered <-
  #     store %>%
  #     filter(Segment == input$SegmentInput,
  #            Region == input$RegionInput,
  #            Country == input$CountryInput
  #     )
  #   filtered
  # })
  
#   output$sales <- renderValueBox({
#     valueBox(
#       dollar_format()(round(sum(store$Sales), 2)), "Sales", icon = icon("glyphicon-tags", lib = "glyphicon"),
#       color = "red"
#     )
#   })
#   
#   
#   output$profit <- renderValueBox({
#     valueBox(
#       dollar_format()(round(sum(sales$profit), 2)), "Profit", icon = icon("glyphicon-star", lib = "glyphicon"),
#       color = "aqua"
#     )
#   })
#   
#   output$profitRatio <- renderValueBox({
#     valueBox(
#       round((sum(store$Profit) / sum(sales$sales)), 2), "Profit Ratio", icon = icon("glyphicon-equalizer", lib = "glyphicon"),
#       color = "purple"
#     )
#   })
#   
#   output$profitOrder <- renderValueBox({
#     valueBox(
#       dollar_format()(round(sum(sales$profit) / length(unique(store$`Order ID`)),2 )), "Profit Per Order", icon = icon("glyphicon-barcode", lib = "glyphicon"),
#       color = "yellow"
#     )
#   })
#   
#   output$salesCustomer <- renderValueBox({
#     valueBox(
#       dollar_format()(round(sum(store$sales) / length(unique(store$`Customer ID`)), 2)), "Sales Per Customer", icon = icon("glyphicon-user", lib = "glyphicon"),
#       color = "purple"
#     )
#   })
#   
#   output$averageDiscount <- renderInfoBox({
#     valueBox(
#       dollar_format()(round(sum(sales$discount) / length(unique(store$`Order ID`)), 2)), "Average Discount", icon = icon("glyphicon-tag", lib = "glyphicon"),
#       color = "yellow"
#     )
#   })
#   
# }
# 
# # Date range input =========================================
# # Only label and value can be set for date range input
# # updateDateRangeInput(session, "inDateRange",
# #                      label = paste("Date range", c_label),
# #                      start = paste("2013-01-", c_num, sep=""),
# #                      end = paste("2013-12-", c_num, sep=""),
# #                      min = paste("2001-01-", c_num, sep=""),
# #                      max = paste("2030-12-", c_num, sep="")
# # )
# # 
# # output$test <- renderPlot({
# #   
# #   hist(cars$dist,
# #        probability = TRUE,
# #        breaks = 10,
# #        xlab = "ZX axis",
# #        main = "cars distance test")
# # })
