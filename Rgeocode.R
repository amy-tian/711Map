# Geocoding a csv column of "addresses" in R

# Make sure to install the below packages
#ggmap, usethis, devtools, ggmapstyles, readr
devtools::install_github("dr-harper/ggmapstyles", force=TRUE)

# Load packages
library(ggmap)
library(rlang)
library(cli)
library(usethis)
library(devtools)
library(ggmapstyles)
library(readr)

library(sf)
library(ggplot2)
library(tmap)
library(tmaptools)
library(leaflet)
library(dplyr)

# If you have trouble downloading devtools where it tells you are missing package "cli" try this
# remove.packages("cli")
# install.packages("cli")

# Put in your Google API KEY
ggmap::register_google(key = 'AIzaSyAbypWUq7Gvil3tKWusGGRlXfrh8AHAyz0')

# Read in the CSV data and store it in a variable 
origAddress <- read.csv(file = "Github/711Map/complete_data.csv", encoding= "UTF-8", stringsAsFactors = FALSE)

# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
for(i in 1:nrow(origAddress))
{
  tryCatch({
    # Print(“Working…”)
    result <- geocode(origAddress$addresses[i], output = "latlona", source = "google")
    origAddress$lon[i] <- as.numeric(result[1])
    origAddress$lat[i] <- as.numeric(result[2])
    origAddress$geoAddress[i] <- as.character(result[3])
    
  }, error=function(e){cat("Warning:",conditionMessage(e), "\n")})
}

# Write a CSV file containing origAddress to the working directory
write_excel_csv(origAddress, "geocoded_stores.csv")

# load map data
geocoded_stores <- read.csv(file= "Github/711Map/geocoded_stores.csv", encoding= "UTF-8", stringsAsFactors = FALSE)

library(ggmapstyles)
library(rjson)
basemap <- get_snazzymap("Taiwan", mapRef = "https://snazzymaps.com/style/83/muted-blue")
ggmap(basemap)

library(ggmap)
basemap2 <- get_map(location="Taiwan", zoom=7)

# Plot map data
ggmap(basemap2) + geom_point(data=geocoded_stores, aes(x=lon, y=lat), size=0.5) + theme_bw() 


options(scipen=999)
basemap <- st_read("Github/711Map/TWCityTownship/CityTownship.shp", stringAsFactors=F)

toGeoJSON(data= geocoded_stores, geocoded_storesGeoJSON,)
