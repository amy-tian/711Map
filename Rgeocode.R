# Geocoding a csv column of "addresses" in R

#load ggmap
ggmap::register_google(key = 'KEY')
library(readr)

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
write_excel_csv(origAddress, "geocoded4.csv")

mapAddress<- get_map(location='Taiwan', zoom=8)

ggmap(mapAddress) + geom_point(data=origAddress, aes(x=lon, y=lat))




