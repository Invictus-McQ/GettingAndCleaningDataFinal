
#PLOT 2
source('dataloader.R')
## Create Plot 2
plot(subdata$Global_active_power~subdata$Datetime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
## Saving to file
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()
