## ---------------------------
##
## Script name: plot3.R
##
## Purpose of script: To download relevant data and create plot3.png.
##
## Author: Shelbournator
##
## Date Created: 2020-03-30
##
## ---------------------------
##
## Notes: This script is part of a series including plot2.R, plot3.R and plot4.R.
##
## Data : https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## ---------------------------
##
##
#### --------------
# Overall brief
#### --------------
# 1. Fork and clone the following GitHub repository: https://github.com/rdpeng/ExData_Plotting1
# 2. Construct each plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
# 3. Name each of these plot files as plot1.png, plot2.png, etc.
# 4. Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot.
# 5. The code file should include reading the data and the code that creates the PNG file.
# 6. Add the PNG file and the R code file to the top-level folder of the git repository
# 7. When you are finished with the assignment, push your git repository to GitHub 

#### --------------
# 1. Download, unzip, and read in data.
#### --------------
if(!file.exists("./data")){dir.create("./data")}

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("./data/EPC.zip")){download.file(fileURL, destfile="./data/EPC.zip", method="curl")}

if(!file.exists("./data/EPC.txt")){
        unzip("./data/EPC.zip", exdir="./data/EPC.txt")
}

filename <- dir("data/EPC.txt")
colnames <- read.table(paste0("data/EPC.txt/", filename), sep=";", nrow=1)
raw.data <- read.table(paste0("data/EPC.txt/", filename), sep=";", skip=66500, nrows=3500, colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric"), col.names=colnames[1,])

data <- raw.data

#### --------------
# 2. Clean and tidy data.
#### --------------

require(lubridate)
data$Date <- dmy(data$Date)
data$Time_Date <- paste(data$Date, data$Time)
data$Time_Date <- strptime(data$Time_Date, "%Y-%m-%d %H:%M:%S")

data <- data[which(data$Date >= "2007-02-01"),]
data <- data[which(data$Date <= "2007-02-02"),]


#### --------------
# 3. Build plot 3:
#       (1) Global Active Power Line
#       (2) Energy Sub Meeting Line
#       (3) Voltage line
#       (4) Global Reactive Power Line
#### --------------

png(file="plot4.png") # Initialize graphic device

# Set graph parameters
par(mfrow = c(2,2))
par(mar = c(4,4,2,2))

# Create graph 1
plot(data$Time_Date, data$Global_active_power, type="l", ylab = "Global Active Power", xlab = " ")

# Create graph 2
plot(data$Time_Date, data$Voltage, type="l", ylab = "Voltage", xlab = "datetime")

# Create graph 3
with(data, plot(Time_Date, Sub_metering_1, type="l", xlab=" ", ylab = "Energy sub metering"))
lines(data$Time_Date, data$Sub_metering_2, col="red")
lines(data$Time_Date, data$Sub_metering_3, col="blue")
legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")

# Create graph 4
plot(data$Time_Date, data$Global_reactive_power, type="l", ylab = "Global_reactive_power", xlab = "datetime")

dev.off() # Turn graphic device off
