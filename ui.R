#shiny::runGitHub("seankross/Baltimore_Crime_Browser")
library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Philadelphia Crime Browser", titleWidth = 250),
  dashboardSidebar(
    width = 200,
    sidebarMenu(
      menuItem("Map of Philadelphia", tabName = "map", icon = icon("map")),
      menuItem("Graphs & Metrics", tabName = "graphs", icon = icon("signal", lib = "glyphicon")),
      menuItem("About", tabName = "about", icon = icon("question-circle")),
      menuItem("Source Code", href = "http://github.com/seankross/Baltimore_Crime_Browser", icon = icon("github-alt"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
      fluidRow(
        column(width = 8,
               box(width = NULL,
                   leafletOutput("crime_map", height = 500))
        ),
        column(width = 4,
               box(width = NULL,
                   dateRangeInput("date1", "Select dates to visualize:",
                                  start = "2017-01-01", end = "2017-01-31",
                                  min = min(phl_crime$Dispatch_Date), max = max(phl_crime$Dispatch_Date)),
                   submitButton("Submit")
               ),
               box(width = NULL,
                   h4("Number of Crimes"),
                   h5(textOutput("total_crimes"))),
               box(width = NULL,
                   h4("Most Common Crime"),
                   h5(textOutput("common_crime"))),
               box(width = NULL,
                   h4("Day of the Week with the Most Crime"),
                   h5(textOutput("weekday_crime")))
        )
      )
      ),
      tabItem(tabName = "graphs",
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           plotOutput("daily_plot"))),
                column(width = 6,
                       box(width = NULL,
                           plotOutput("desc_plot")))
              ),
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           dateRangeInput("date2", "Select dates to visualize:",
                                          start = "2017-01-01", end = "2017-01-31",
                                          min = min(phl_crime$Dispatch_Date), max = max(phl_crime$Dispatch_Date)),
                           submitButton("Submit")
                       )
                ),
                column(width = 6,
                       box(width = NULL,
                           selectInput("weekday", "Select a weekday to visualize (weekday with the most crime as default):",
                                       c("Tuesday", wd[wd!="Tuesday"])),
                           submitButton("Submit")
                       )
                )
              )),
      tabItem(tabName = "about",
              fluidRow(
                column(width = 10,
                       box(width = NULL,
                           includeMarkdown("about.md")))
              )
      )
    )
  )
)