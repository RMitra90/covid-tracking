library(dygraphs)
library(shiny)
library(shinydashboard)
library(shinyWidgets)

covid <- as.data.frame(read.csv('covid_processed_data.csv', stringsAsFactors = F))
state_names <- sort(unique(covid$state))


shinyUI(fluidPage(title = "COVID-19 Tracking : USA", 
  
  # Application title
  titlePanel(p("COVID-19 Tracking : USA", 
               style = "color:black; font-family:tahoma; border-bottom: 4px solid black")),
  
  # Sidebar 
  sidebarLayout(
    
    sidebarPanel(width = 2,
       
       pickerInput("StateName","Choose State, Territory and/or Possession Address:", 
                   choices = state_names, selected = c("California"),
                   options = list(`actions-box` = TRUE),multiple = T),
       
       br(), br(), br(),
       
       p("Data Source: The COVID Tracking Project"),
       p("Last Updated: 30 June, 2020")
       
    ),
    
    # Show graphs
    mainPanel(width = 10,
      
      fluidRow(
        column(width = 12, dygraphOutput("cases"),
               
               br(),
               br(),
               
               fluidRow(
                 column(width = 6, dygraphOutput("daily_pos_cases")),
                 column(width = 6,dygraphOutput("currently_hospitalized"))
               )
               
              )
          )
      )
    )
))

