##  Requires dplyr library installed, if it is not installed,
##  remove ## from next line to install as script runs
##  install.packages("dplyr")
library(dplyr)


##  First, see if household power data is in working directory, if not
##  download and unzip.  Display message indicating time/date of download

fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("household_power_consumption.txt")){
    download.file(fileUrl, destfile="household_power_consumption.zip", mode = "wb")
    dateDownloaded <- date()
    dlMessage <- paste("Household power consumption data successfully downloaded:", dateDownloaded)
    print(dlMessage)
    unzip ("household_power_consumption.zip")
}



##  Read data into R
power <- read.table("household_power_consumption.txt", header=TRUE,
                    colClasses=c("character", "character", "numeric", "numeric",
                                 "numeric", "numeric", "numeric", "numeric", "numeric"), sep =";", na="?")

##  Convert dates into correct format
power[,1]<-as.Date(power[,1], "%d/%m/%Y")


##  Extract days to be analyzed
dates_for_proj<-filter(power, Date=="2007-02-01"|Date=="2007-02-02")

##  Create and name new column that will contain Date/Time
##  
dates_for_proj[,10]<-as.POSIXct(paste(dates_for_proj$Date, dates_for_proj$Time),
                                format="%Y-%m-%d %H:%M:%S")

colnames(dates_for_proj)[10]<-as.vector("Date.Time")


##  Substitute "." for "_" in column names (I prefer the way this looks)
colnames(dates_for_proj)<-gsub("_", ".", colnames(dates_for_proj))

##***************
##*The plotting *
##***************

##  Create PNG file, 480x480 pixels
png(file="plot4.png", width = 480, height = 480)

##  Set parameter of plot to hold 2x2
par(mfrow=c(2,2))

##  Plot Date.Time vs. Global active power
with(dates_for_proj, plot(Date.Time, Global.active.power, xlab = "",  
                          ylab="Global Active Power (kilowatts)", type="o", pch=NA))

##  Plot Date.Time vs. voltage
with(dates_for_proj, plot(Date.Time, Voltage, xlab = "datetime", type="o", pch=NA))

##  Plot Date.Time vs Submetering columns, add legend
with(dates_for_proj, plot(Date.Time, Sub.metering.1, type="o", pch=NA, 
                          xlab="", ylab="Energy sub metering"))
points(dates_for_proj$Date.Time, dates_for_proj$Sub.metering.2, col = "red", type="o", pch=NA)
points(dates_for_proj$Date.Time, dates_for_proj$Sub.metering.3, col = "blue", type="o", pch=NA)
legend("topright", pch= NA, col = c("black", "blue", "red"), bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1)

##  Plot Date.Time vs. Global reactive power
with(dates_for_proj, plot(Date.Time, Global.reactive.power, xlab = "datetime", 
                          ylab="Global_reactive_power", type="o", pch=NA))

##  Close graphics device
dev.off() 