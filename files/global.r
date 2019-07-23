source("./dependencies.R")
################################ Set Shiny Variables ################################


# Choose color of Loading icon
options(spinner.color="#0dc5c1")

# Set colors
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

# Set the CSS 
tags$head(
  tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
)#,

# color leaflet background
tag.map.title <- tags$style(HTML("
  .leaflet-container { background: #ffffff; }
"))


## Add Title
rr <- tags$div(
  tag.map.title
)

################################ Data ################################

# Read and Format Data Frame

# State shape file read in from esri.com
state_shapefiles <- read_sf(dsn = "~/data/state-shape-files/") %>% 
  rename(state = name)
state_df <- read.csv("~/data/StatesFIPSCodes.csv", header=TRUE, stringsAsFactors=FALSE);
store <- read_csv("~/data/SuperstoreExample.csv", col_types = cols(`Postal Code` = col_character())) %>% 
  rename(row_id = `Row ID`,
         order_id = `Order ID`,
         order_date = `Order Date`,
         ship_date = `Ship Date`,
         ship_mode = `Ship Mode`,
         customer_id = `Customer ID`,
         customer_name = `Customer Name`,
         segment = Segment,
         country = Country,
         city = City,
         state = State,
         zipcode = `Postal Code`,
         region = Region,
         product_id = `Product ID`,
         category = Category,
         sub_category = `Sub-Category`,
         product_name = `Product Name`,
         sales = Sales,
         profit = Profit,
         quantity = Quantity,
         discount = Discount
  ) %>% 
  mutate(order_date = as.Date(order_date, origin = "1899-12-30"),
         ship_date = as.Date(ship_date, origin = "1899-12-30"),
         zipcode = as.character(zipcode),
         profitability_yn = case_when(
           profit >= 0 ~ "Profitable",
           profit < 0 ~ "Unprofitable"
            ),
         year = year(order_date),
         month = month(order_date),
         ym = as.yearmon(order_date, "%m%Y")
         )

state_coord <- read.csv("~/data/state_coord.csv", header=TRUE, stringsAsFactors=FALSE) %>% 
  rename(state = State)

# Create dataset for leaflet by state
df <- store %>% 
  group_by(state, region) %>% 
  summarise(total_sales = sum(sales)) %>% 
  merge(state_df, by.x = "state", by.y = "STATE_NAME") %>% 
  merge(state_coord, by.x = "state", by.y = "state") %>% 
  rename(state_fips = STATE_FIPS, 
         state_ens = STATENS,
         state_abbr = STUSAB)

# write to csv for ease of use later.
#write_csv(dat, path = "~/data/market_sales.csv")

# merge store info with state shapefile
dat <- state_shapefiles %>% 
  filter(iso_a2 == "US") %>% 
  merge(df, by.x = "state", by.y = "state") %>% 
  filter(state != "Hawaii",
         state != "Alaska")

# Sales Palette
sales_palette <- colorQuantile("Blues",
                               dat$total_sales
)
# Sales Palette
sales_bin_palette <- colorBin("Blues",
                              domain = dat$total_sales,
                              bins = 5
)

# Label leaflet
labels <- sprintf(
  "<strong>%s</strong><br/>$%g",
  dat$state, dat$total_sales
) %>% lapply(htmltools::HTML)

# label for leaflet
labels <- sprintf(
  "<strong>%s</strong><br/>$%g",
  dat$state, dat$total_sales
) %>% lapply(htmltools::HTML)

# set color scale
bins <- c(0, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, Inf)
pal <- colorNumeric(
                  palette = "YlGnBu",
                  domain = dat$total_sales)


# Code to read in Shapefiles goes here


#######

############ GRAPHS ##########

  # graph Sales by segment
  seg_sales <- 
    store %>% 
    group_by( profitability_yn, ym ,segment)%>% 
    summarise(sum_sales = sum(sales)) %>% 
    ggplot(aes(x =ym, y=sum_sales)) +
    geom_area(aes(colour = as_factor(profitability_yn), fill = as_factor(profitability_yn)),
              show.legend = FALSE) +
    facet_grid(segment ~ .) +
    labs(title = "Monthly Sales by Segment",
         y = NULL,
         x = NULL) +
    theme_bw() +
    theme()

#category Sales
cat_sales <- 
  store %>% 
  group_by( profitability_yn, ym ,category)%>% 
  summarise(tot_sales = sum(sales)) %>% 
  ggplot(aes(x =ym, y=tot_sales)) +
  geom_area(aes(colour = as_factor(profitability_yn), fill = as_factor(profitability_yn)),
            show.legend = FALSE) +
  facet_grid(category ~ .) +
  labs(title = "Monthly Sales by Category",
       y = NULL,
       x = NULL) +
  theme_bw() +
  theme()

################# For Main Plot Leaflet #################

leaf <- dat %>% 
  leaflet() %>%
  addTiles() %>% 
  addPolygons(fillColor = ~sales_bin_palette(total_sales),
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 2,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>% 
  addLegend("bottomright", pal = sales_bin_palette, values = ~total_sales,
            title = "Sales Overall",
            labFormat = labelFormat(prefix = "$"),
            opacity = 1
  )

  