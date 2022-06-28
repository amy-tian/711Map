# Geocoding a csv column of "addresses" in R

# Make sure to install the below packages
#ggmap, usethis, devtools, ggmapstyles, readr
devtools::install_github("dr-harper/ggmapstyles", force=TRUE)

# Load packages
library(ggmap)
library(ggmapstyles)
library(readr)

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


