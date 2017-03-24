#dataloader.R
##Load packages and setwd
if (!require("dplyr")) {
  install.packages("dplyr")
}
if (!require("plyr")) {
  install.packages("plyr")
}
require("dplyr")
require("plyr")
setwd("~")
par(mar=c(1,1,1,1))
## Downloading and loading the full dataset
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
data <- read.table(unz(temp, "household_power_consumption.txt"),header=T, sep=';', na.strings="?", 
                   nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
unlink(temp)
data$Date = as.Date(data$Date, format="%d/%m/%Y")

## Subsetting the data
subdata <- subset(data, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(data)
## Converting dates
datetime <- paste(as.Date(subdata$Date), subdata$Time)
subdata$Datetime <- as.POSIXct(datetime)
