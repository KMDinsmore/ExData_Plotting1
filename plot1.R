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
png(file="plot1.png", width = 480, height = 480)

#   Create histogram of Global active power frequency
hist(dates_for_proj$Global.active.power, col="red", 
     main="Global Active Power", xlab="Global Active Power (kilowatts)")
##  Close graphic device
dev.off()