# body <- dashboardBody(
#   fluidRow(
#     box(title = "Box title", "Box content"),
#     box(status = "warning", "Box content")
#   ),
# 
#   fluidRow(
#     box(
#       title = "Title 1", width = 4, solidHeader = TRUE, status = "primary",
#       "Box content"
#     ),
#     box(
#       title = "Title 2", width = 4, solidHeader = TRUE,
#       "Box content"
#     ),
#     box(
#       title = "Title 1", width = 4, solidHeader = TRUE, status = "warning",
#       "Box content"
#     )
#   ),
# 
#   fluidRow(
#     box(
#       width = 4, background = "black",
#       "A box with a solid black background"
#     ),
#     box(
#       title = "Title 5", width = 4, background = "light-blue",
#       "A box with a solid light-blue background"
#     ),
#     box(
#       title = "Title 6",width = 4, background = "maroon",
#       "A box with a solid maroon background"
#     )
#   )
# )
# 
# 
title_Page1 <- h4("Executive Overview - Profitability Overview", align = "center")


ui <-
  fluidPage( theme = shinytheme("lumen"),
  navbarPage( title = "Welcome to Shiny",
              # id = "activePanel",
              # selected = "fixed-top", 
              inverse=FALSE,
              collapsible = TRUE,
              fluid = TRUE,
              #theme = shinythemes::shinytheme("yeti"),
              windowTitle = "Sales Dashboard",
              #icon = icon("glyphicon-cloud", lib = "glyphicon"),
              
              tabPanel("Dashboard", # Title of Component
                       fluidRow(
                        title_Page1
                       ,
                       # KPI Rows
                       fluidRow(
                         
                         column(1,
                                "Sales",
                                dollar_format()(round(sum(store$sales), 2))
                         ),
                         column(1, offset = 1,
                                "Profit",
                                dollar_format()(round(sum(store$profit), 2))
                         ),
                         column(1, offset = 1,
                                "Profit Ratio",
                                round((sum(store$profit) / sum(store$sales)), 2)
                         ),
                         column(1, offset = 1,
                                "Profit / Order",
                                dollar_format()(round(sum(store$profit) / length(store$order_id),2 ))
                         ),
                         column(1, offset = 1,
                                "Sales / Customer",
                                dollar_format()(round(sum(store$sales) / length(store$customer_id), 2))
                         ),
                         column(1, offset = 1,
                                "Average Discount",
                                dollar_format()(round(sum(store$discount) / length(store$order_id), 2))
                         )
                       ),

                          fluidRow(
                            column(12,
                                   
                                   fluidRow(
                                     column(10,
                                          withSpinner(leafletOutput(outputId = "leaflet_map", height = "300px"))
                                          
                                     ),
                                     column(2,wellPanel(
                                            "Filter by: ",
                                            pickerInput("RegionInput", "Region",
                                                        choices = unique(store$region), 
                                                        selected = store$region[-1],
                                                        options = list(`actions-box` = TRUE),
                                                        multiple = T),
                                            "Date Range between: ",
                                            dateRangeInput("inDateRange", "Date range input:")
                                     )
                                            )
                                     )
                                   )
                                   
                            ),
                       
                       fluidRow(
                         column(12,
                                fluidRow(
                                  column(6,
                                         h6( align = "left"),
                                         withSpinner(plotlyOutput(outputId = "plot1a", height = "400px"))
                                  ),
                                  column(6,
                                         h6( align = "left"),
                                         withSpinner(plotlyOutput(outputId = "plot2a", height = "400px"))
                                  )
                                )
                         )
                         
                       )
                            )
              
                          
# Next Page                     
              
              ),
              tabPanel("Table", h4("Table"),

                       fluidRow(

                         column(1,
                                "Sales",
                                dollar_format()(round(sum(df$sales), 2))
                         ),
                         column(1,
                                "Profit",
                                dollar_format()(round(sum(df$profit), 2))
                         ),
                         column(1,
                                "Profit Ratio",
                                round((sum(df$profit) / sum(df$sales)), 2)
                         ),
                         column(1, offset = 1,
                                "Profit Per Order",
                                dollar_format()(round(sum(store$profit) / length(store$row_id),2 ))
                         ),
                         column(1, offset = 1,
                                "Sales per Customer",
                                dollar_format()(round(sum(store$sales) / length(store$customer_id), 2))
                         ),
                         column(1, offset = 1,
                                "Average Discount",
                                dollar_format()(round(sum(store$discount) / length(store$order_id), 2))
                         )
                       ),
                       
                       withSpinner(DT::dataTableOutput("table"))
                       ),
              tabPanel("Map", h4("Scatter Geo Map Option"),
                       
                         # Leaflet
                         withSpinner(leafletOutput("map")),
                         p(),
                         actionButton("recalc", "New points")
              
                       ),
              tabPanel("Development",
                       fluidRow(dashboardPage(
                dashboardHeader(title = "My Dashboard"),
                dashboardSidebar(),
                dashboardBody(
                )
                )
              ))
                         ))
  
             
                     
              



