phl_crime <- readRDS("phl_crime0.rds")
phl_crime$lat <- as.numeric(phl_crime$lat)
phl_crime$lng <- as.numeric(phl_crime$lng)
wd<-c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
#a<-"Monday"
#wd<-wd[wd!="Monday"]
#nrow(phl_crime)
#head(phl_crime$lat)
#min(phl_crime$Dispatch_Date)
#table(phl_crime$dispatch_weekday)

