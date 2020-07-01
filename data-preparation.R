# The COVID Tracking Project
# Data Source: https://covidtracking.com/data/download
setwd("G:/Initiatives/covid/covid-tracking")
covid <- read.csv('daily.csv', stringsAsFactors = F)

library(dplyr)
library(lubridate)
library(openintro)

# Remove deprecated columns
deprecated_columns <- c('deathIncrease', 'hospitalized', 'hospitalizedIncrease', 'lastModified',
                        'negativeIncrease', 'posNeg', 'positiveIncrease', 'total',
                        'totalTestResults', 'totalTestResultsIncrease')

covid <- covid[,!(names(covid) %in% deprecated_columns)]

# Convert date column to date
covid$date <- ymd(covid$date)

# Convert state abbreviations to full names
covid <- rename(covid, state.abbr = state)
covid$state <- abbr2state(covid$state.abbr)
covid$state[covid$state.abbr == 'AS'] <- 'American Samoa'
covid$state[covid$state.abbr == 'FM'] <- 'Federated States of Micronesia'
covid$state[covid$state.abbr == 'GU'] <- 'Guam'
covid$state[covid$state.abbr == 'MH'] <- 'Marshall Islands'
covid$state[covid$state.abbr == 'MP'] <- 'Northern Mariana Islands'
covid$state[covid$state.abbr == 'PR'] <- 'Puerto Rico'
covid$state[covid$state.abbr == 'PW'] <- 'Palau'
covid$state[covid$state.abbr == 'VI'] <- 'U.S. Virgin Islands'
covid$state[covid$state.abbr == 'UM'] <- 'U.S. Minor Outlying Islands'


# Remove columns that are not relevant
irrelevant_columns <- c('commercialScore', 'negativeRegularScore', 'negativeScore',
                        'positiveScore', 'score', 'grade', 'fips', 'dataQualityGrade',
                        'totalTestsViral', 'positiveTestsViral', 'negativeTestsViral',
                        'positiveCasesViral')

covid <- covid[,!(names(covid) %in% irrelevant_columns)]

NROW(covid)
sum(complete.cases(covid$positive))
sum(complete.cases(covid$negative))
sum(complete.cases(covid$recovered))
sum(complete.cases(covid$death))

covid.df <- covid %>% 
  group_by(state) %>%
  arrange(desc(date)) %>%
  mutate(Positive_Increase = lag(positive) - positive)


write.csv(covid.df, 'covid_processed_data.csv')

