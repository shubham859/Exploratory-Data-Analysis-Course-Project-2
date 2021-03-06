NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

vehicle <- SCC[grepl("Vehicle", SCC$Short.Name), "SCC"]
NEI <- NEI[NEI$SCC %in% vehicle, ]
years <- seq(1999, 2008, length.out = 4)
bm <- data.frame(city = as.character(),
                 year = as.numeric(),
                 total_em = as.numeric())
baltimore <- NEI[NEI$fips == "24510", ]
for (y in years) {
    row <- vector()
    Em <- baltimore[baltimore$year == y, ]
    total_emission <- sum(Em$Emissions)
    row <- c("Baltimore", y, total_emission)
    bm <- rbind(bm, row)
}
colnames(bm) <- c("City", "Year", "Total_Emissions")

la <- data.frame(city = as.character(),
                 year = as.numeric(),
                 total_em = as.numeric())
los_angeles <- NEI[NEI$fips == "06037", ]
for (y in years) {
    row <- vector()
    Em <- los_angeles[los_angeles$year == y, ]
    total_emission <- sum(Em$Emissions)
    row <- c("Los Angeles", y, total_emission)
    la <- rbind(la, row)
}
colnames(la) <- c("City", "Year", "Total_Emissions")
df <- rbind(bm, la)

png("plot6.png", width = 600, height = 480)
g <- ggplot(data = df, aes(Year, Total_Emissions, color = City)) +
    labs(title = "YoY Emission in Baltimore & LA from Motor Vehicles")
g + geom_line(aes(group = City), size = 1) + 
    theme(axis.text.y = element_blank(), 
          plot.title = element_text(family = "Helvetica",
                                    face = "bold", size = (20)),
          axis.title = element_text(family = "Helvetica",
                                    face = "bold", size = (15)),
          legend.position = "none")
dev.off()

