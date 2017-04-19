
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("dplyr")
# install.packages("leaflet")
# install.packages("ggplot2")
# install.packages("lubridate")

library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(lubridate)

shinyServer(function(input, output, session) {
  filtered_crime <- reactive({
    input$date1
    
    isolate({
      phl_crime %>%
        filter(Dispatch_Date >= input$date1[1]) %>%
        filter(Dispatch_Date <= input$date1[2])
    })
  })
  
  filtered_crime_wd <- reactive({
    input$weekday
    
    isolate({
      phl_crime %>%
        filter(Dispatch_Date >= input$date1[1]) %>%
        filter(Dispatch_Date <= input$date1[2]) %>%
        filter(dispatch_weekday == input$weekday)
    })
  })
  
  observe({
    input$date1
    
    updateDateRangeInput(session, "date2",
                         "Select dates to visualize:",
                         start = input$date1[1],
                         end = input$date1[2],
                         min = min(phl_crime$Dispatch_Date), max = max(phl_crime$Dispatch_Date))
  })
  
  observe({
    input$date2
    
    updateDateRangeInput(session, "date1",
                         "Select dates to visualize:",
                         start = input$date2[1],
                         end = input$date2[2],
                         min = min(phl_crime$Dispatch_Date), max = max(phl_crime$Dispatch_Date))
  })
  
  observe({
    input$weekday
    
    x <- names(tail(sort(table(filtered_crime()$dispatch_weekday)), 1))
    
    y<-ifelse(x==input$weekday,x,input$weekday)
    x_desc <- paste("Day with most crime:",x)
    updateSelectInput(session, "weekday",
                      choices = c(x, wd[wd!=x]),
                      selected = y
    )
  })
  
  output$crime_map <- renderLeaflet({
    filtered_crime() %>%
      leaflet() %>%
      setView(lng = "-75.177781", lat = "39.968367", zoom = 12) %>%
      addProviderTiles(providers$CartoDB.DarkMatter)%>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 popup = ~content)
  })
  
  output$daily_plot <- renderPlot({
    daily_crime <- filtered_crime() %>%
      group_by(Dispatch_Date) %>%
      summarize(Crimes_Per_Day = n())
    
    ggplot(daily_crime, aes(Dispatch_Date, Crimes_Per_Day)) + geom_line()+
      xlab("Selected Date") + ylab("Total Crimes per Day") 
  })
  
  output$desc_plot <- renderPlot({
    desc_crime <- filtered_crime_wd() %>%
      group_by(General_Crime_Category) %>%
      summarize(Total = n())
    
    ggplot(desc_crime, aes(x=reorder(General_Crime_Category, -Total), y=Total)) + geom_bar(stat = "identity") + coord_flip()+
    xlab("Total Counts") + ylab("Crime Category Description")+
      ggtitle(paste("Crime Categories on Selected Weekday -", input$weekday))
  })
  
  output$total_crimes <- renderText({
    as.character(nrow(filtered_crime())) # so smart by using nrow()!!
  })
  
  output$common_crime <- renderText({
    names(tail(sort(table(filtered_crime()$General_Crime_Category)), 1)) #sort: in ascending order; tail(df,1):grab the last row
  })
  
  output$weekday_crime <- renderText({
    #names(tail(sort(table(wday(filtered_crime()$CrimeDate, label = TRUE, abbr = FALSE))), 1))
    names(tail(sort(table(filtered_crime()$dispatch_weekday)), 1))
  })
  
})
