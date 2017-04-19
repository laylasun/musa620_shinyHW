# Downloaded from https://www.opendataphilly.org/dataset/crime-incidents
# 2017-03-37
# File downloaded as PPD_Crime_Incidents_2006-Present.csv

library(dplyr)
library(lubridate)
library(readr)
library(magrittr)
library(stringr)
library(purrr)

#crime1 <- read_csv("crime.csv")
#crime %>%
#  print(n=12,width=Inf)

phl_crime<-read_csv("PPD_Crime_Incidents_2006-Present.csv")
nrow(phl_crime) # 2,238,107 in total | 2,220,758 nonblank in Shape field
phl_crime <-phl_crime[which(phl_crime$Shape!=''), ]

# To view all the columns in the tibble table
phl_crime %>%
  print(n=12,width=Inf)

colnames(phl_crime)
colnames(phl_crime)[which(colnames(phl_crime) == "Dispatch Date/Time")] <- "Dispatch_Date_Time"
colnames(phl_crime)[which(colnames(phl_crime) == "Dispatch Date")] <- "Dispatch_Date"
colnames(phl_crime)[which(colnames(phl_crime) == "Dispatch Time")] <- "Dispatch_Time"
colnames(phl_crime)[which(colnames(phl_crime) == "Location Block")] <- "Location_Block"
colnames(phl_crime)[which(colnames(phl_crime) == "General Crime Category")] <- "General_Crime_Category"
colnames(phl_crime)[which(colnames(phl_crime) == "Police Districts")] <- "Police_Districts"

# date & time format reference: https://www.stat.berkeley.edu/~s133/dates.html
phl_crime %<>%
  mutate(time=seconds_to_period(Dispatch_Time)) %>% # using lubridate: convert secs into HMS format
  mutate(dispatch_year=format(Dispatch_Date,'%Y')) %>% # year e.g. 2015
  mutate(dispatch_month=format(Dispatch_Date,'%B')) %>% # full month e.g. October
  mutate(dispatch_weekday=format(Dispatch_Date,'%A')) # full weekdat e.g. Sunday

#crime <- crime %>%
#crime %<>%
 # mutate(CrimeDate = mdy(CrimeDate)) %>%
 # mutate(CrimeTime = hms(CrimeTime)) %>%
 # mutate(Inside_Outside = recode(Inside_Outside, "I" = "Inside", 
 #                                "O" = "Outside"))

#x<-"POINT (-75.130477 40.036389)" 
#str_extract_all(x,"-?[0-9]{2}\\.[0-9]+") -->[[1]] [1] "-75.130477" "40.036389" 

phl_crime$lat <- phl_crime$Shape %>%
  map_chr(function(x){str_extract_all(x, "-?[0-9]{2}\\.[0-9]+")[[1]][2]})
phl_crime$lng <- phl_crime$Shape %>%
  map_chr(function(x){str_extract_all(x, "-?[0-9]{2}\\.[0-9]+")[[1]][1]})

phl_crime %<>%
  select(-Dispatch_Time, -Shape) %>%
  filter(!is.na(lat)) %>%
  filter(!is.na(lng)) %>%
  filter()
#2,220,753 nonblank, non-na in both lat and lng fields


phl_crime %<>%
  filter(!is.na(Dispatch_Date)) %>%
  mutate(popdate = paste("Date:", Dispatch_Date)) %>%
  mutate(poploc = paste("Location:", Location_Block)) %>%
  mutate(popcrimecat = paste("Crime:", General_Crime_Category)) %>%
  mutate(content = paste(popdate, poploc, popcrimecat, sep = "<br/>"))

#min(phl_crime$Dispatch_Date) # 2006-01-01
#max(phl_crime$Dispatch_Date) #2017-03-24
saveRDS(phl_crime, "phl_crime.rds") #105.2 MB

# Further down-size the dataset by selecting the crimes in 2016 and 2017
phl_crime0 <- readRDS("phl_crime.rds") #nrow()=251378
phl_crime0 %>%
  print(n=12,width=Inf)
phl_crime0 %<>%
  filter(!is.na(General_Crime_Category)) # nrow()=2220094
nrow(phl_crime0)
phl_crime0 %<>%
  filter(Dispatch_Date >="2016-01-01") # nrow()=199079
saveRDS(phl_crime0, "phl_crime0.rds") #13.8 MB
# table(phl_crime0$dispatch_year) #year2016->165618 records; year2017->33461
# min(phl_crime0$Dispatch_Date) #"2016-01-01"
# max(phl_crime0$Dispatch_Date) #"2017-03-24"
 