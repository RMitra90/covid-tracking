library(shiny)
library(dygraphs)
library(dplyr)
library(xts)


covid <- as.data.frame(read.csv('covid_processed_data.csv', stringsAsFactors = F))

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  # Cumulative Positive Cases, Recovered, Deaths
  output$cases <- renderDygraph({
    
    covid$date <- as.Date(covid$date)
    
    covid$positive[is.na(covid$positive)] <- 0
    covid$recovered[is.na(covid$recovered)] <- 0
    covid$death[is.na(covid$death)] <- 0
    
    df1 <- filter(covid, state %in% input$StateName)
    
    df2 <- df1 %>% 
      group_by(date) %>% 
      summarise(Positive = sum(positive),
                Recoveries = sum(recovered),
                Fatalities = sum(death))
    
    df3 <- as.xts(x = df2[-1], order.by = df2$date)
    
    dgraph <- dygraph(df3, main = "Cumulative count of positive cases, recoveries and fatalities") %>%
      dyAxis("y", label = "Total cases") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE,
                colors = c("#FA8072", "green", "blue")) %>%
      dyRangeSelector() %>%
      dyLegend(show = "follow")
    
    dgraph
    
  })
  
  # Daily Positive Cases
  output$daily_pos_cases <- renderDygraph({
    
    covid$date <- as.Date(covid$date)
    covid$Positive_Increase[is.na(covid$Positive_Increase)] <- 0
    covid$Positive_Increase[covid$Positive_Increase < 0] <- 0
    
    df1 <- filter(covid, state %in% input$StateName)
    
    df2 <- df1 %>% 
      group_by(date) %>% 
      summarise(Positive_Increase = sum(Positive_Increase))
    
    df3 <- xts(x = df2$Positive_Increase, order.by = df2$date)
    
    dgraph <- dygraph(df3, main = "Daily count of positive cases") %>%
      dyAxis("y", label = "Daily positive cases") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE) %>%
      dyRangeSelector() %>%
      dyLegend(show = "always", hideOnMouseOut = FALSE)%>%
      dySeries("V1", label = "Positive Cases")
    
    dgraph
    
  })
  
  # Currently Hospitalized (Daily)
  output$currently_hospitalized <- renderDygraph({
    
    covid$date <- as.Date(covid$date)
    
    covid$hospitalizedCurrently[is.na(covid$hospitalizedCurrently)] <- 0
    covid$inIcuCurrently[is.na(covid$inIcuCurrently)] <- 0
    covid$onVentilatorCurrently[is.na(covid$onVentilatorCurrently)] <- 0
    
    df1 <- filter(covid, state %in% input$StateName)
    
    df2 <- df1 %>% 
      group_by(date) %>% 
      summarise(Hospitalized = sum(hospitalizedCurrently),
                ICU = sum(inIcuCurrently),
                Ventilator = sum(onVentilatorCurrently))
    
    df3 <- as.xts(x = df2[-1], order.by = df2$date)
    
    dgraph <- dygraph(df3, main = "Daily count of cases hospitalized, in ICU and on ventilator") %>%
      dyAxis("y", label = "Total cases") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, drawGrid = TRUE) %>%
      dyRangeSelector() %>%
      dyLegend(show = "always", hideOnMouseOut = FALSE) 
    
    dgraph
    
  })
  
})
