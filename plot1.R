##  Requires dplyr library installed
##  install.packages("dplyr")
library(dplyr)

fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("household_power_consumption.txt")){
    download.file(fileUrl, destfile="household_power_consumption.zip", mode = "wb")
    dateDownloaded <- date()
    dlMessage <- paste("Household power consumption data successfully downloaded:", dateDownloaded)
    print(dlMessage)
    unzip ("household_power_consumption.zip")
}

power <- read.table("household_power_consumption.txt", header=TRUE,
                    colClasses=c("character", "character", "numeric", "numeric",
                                 "numeric", "numeric", "numeric", "numeric", "numeric"), sep =";", na="?")

power[,1]<-as.Date(power[,1], "%d/%m/%Y")

dates_for_proj<-filter(power, Date=="2007-02-01"|Date=="2007-02-02")

dates_for_proj[,10]<-as.POSIXct(paste(dates_for_proj$Date, dates_for_proj$Time), format="%Y-%m-%d %H:%M:%S")
colnames(dates_for_proj)[10]<-as.vector("Date.Time")

colnames(dates_for_proj)<-gsub("_", ".", colnames(dates_for_proj))

png(file="plot1.png", width = 480, height = 480)
hist(dates_for_proj$Global.active.power, col="red", 
     main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()