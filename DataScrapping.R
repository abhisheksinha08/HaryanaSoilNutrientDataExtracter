# Create a data set of downloadable link to data related to soil nutrient of Haryana by block
# Author: Abhishek Sinha
# Date Created: 17th July, 2017.


# install tidyjson and rjson
if("tidyjson" %in% installed.packages()[, 1]==FALSE)
{
  install.packages("tidyjson")
}
if ("rjson" %in% installed.packages()[, 1] == FALSE)
{
  install.packages("rjson")
}
library(rjson)
library(tidyjson)


# Get Districts of haryana.
haryana_dist_url <- "http://soilhealth.dac.gov.in/CommonFunction/GetDistrict4Report?statecode=6"

json_data1 <- jsonlite::fromJSON(paste(readLines(haryana_dist_url), collapse =""))
haryana_dist <- json_data1[-c(1), c(2, 3)]
rm(json_data1)

# Blocks empty data frame
haryana_blocks<-data.frame()


# Iterate over all district data and extract block info
for (i in 1:nrow(haryana_dist))
{
  distId <- haryana_dist[i, 2]
  distName <- haryana_dist[i, 1]
  
  # Extract block data for each district
  temp1 <-
    jsonlite::fromJSON(paste(readLines(
      paste(
        "http://soilhealth.dac.gov.in/CommonFunction/GetBlock?Dist_code=",
        distId,
        sep = ""
      )
    ), collapse = ""))
  temp1 <- temp1[-c(1), c(2, 3)]
  temp1$DistrictId <- distId
  temp1$DistrictName <- distName
  if (i == 1)
  {
    haryana_blocks <- temp1
  }
  else
  {
    haryana_blocks <- rbind(haryana_blocks, temp1)
  }
}

# Update column names
colnames(haryana_blocks)<-c('BlockName', 'BlockId', 'DistricId', 'DistrictName')

# Write tidy data
write.csv(
  haryana_blocks,
  col.names = T,
  file = "haryana_blocks_url.csv",
  row.names = FALSE
)
