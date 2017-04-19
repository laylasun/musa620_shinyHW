# Philly Crime 2016-2017 Browser
# Homework for MUSA620 Week-Shiny
## Install

```
install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("dplyr")
# install.packages("leaflet")
# install.packages("ggplot2")
# install.packages("lubridate")

shiny::runGitHub("laylasun/musa620_shinyHW")
```

This application is an adapted example (https://github.com/seankross/Baltimore_Crime_Browser)
of a dashboard that can be quickly prototyped
and deployed in order to visualize crime in Philadelphia, PA. The dashboard
includes the following features:

1. An interactive map of Philadelphia, PA including:
  - Clustered crime events
  - Popup text for each event with crime details
2. Widgets that provide aggregate summaries of crime events.
3. A calendar that allows the user to filter crime events by date. This calendar  
   is consistent throughout the app.
4. Visualizations of crime over time and by type of crime on selected weekday with
   the weekday with the most crimes on top in the dropdown menu.

