phl_crime <- readRDS("phl_crime.rds")
phl_crime$lat <- as.numeric(phl_crime$lat)
phl_crime$lng <- as.numeric(phl_crime$lng)
wd<-c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
#a<-"Monday"
#wd<-wd[wd!="Monday"]

#head(phl_crime$General_Crime_Category)
#min(phl_crime$Dispatch_Date)
#table(phl_crime$dispatch_weekday)
