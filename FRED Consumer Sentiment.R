
suppressWarnings(suppressPackageStartupMessages(library(fredr)))
suppressWarnings(suppressPackageStartupMessages(library(dplyr)))
suppressWarnings(suppressPackageStartupMessages(library(ggplot2)))
suppressWarnings(suppressPackageStartupMessages(library(purrr)))
suppressWarnings(suppressPackageStartupMessages(library(lubridate)))

startingDate <- as.Date("1978-02-01")
endingDate <- as.Date(format(Sys.Date() - days(day(Sys.Date())), "%Y-%m-01"))

umcsent_change <- fredr(
    series_id = "UMCSENT",
    observation_start = startingDate,
    observation_end = endingDate,
    frequency = "m",
    units = "chg"
) %>%
    select(1, 3)

umcsent_change

umcsent <- fredr(
    series_id = "umcsent",
    observation_start = startingDate,
    observation_end = endingDate
) %>%
    mutate(change = (value - lag(value)) / lag(value)) %>%
    select(1, 3, 6)

umcsent

# monthly results
ggplot(data = umcsent, mapping = aes(x = date, y = value)) +
    geom_line() +
    theme_minimal() +
    ggtitle("University of Michigan: Consumer Sentiment") +
    labs(x = "Year", y = "Monthly Index",
         caption = "Blue Hen Analytics - Data from Federal Reserve Economic Database",
         subtitle = "Base Year is 1966 for the index of 100") +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle=element_text(hjust = 0.5),
          plot.caption=element_text(hjust = 1))

# monthly change
ggplot(data = umcsent_change, mapping = aes(x = date, y = value)) +
    geom_line() +
    theme_minimal() +
    ggtitle("University of Michigan: Consumer Sentiment Monthly Change") +
    labs(x = "Year", y = "Monthly Index Change",
         caption = "Blue Hen Analytics - Data from Federal Reserve Economic Database",
         subtitle = "Base Year is 1966 for the index of 100") +
    theme(plot.title = element_text(hjust = 0.5),
          plot.subtitle=element_text(hjust = 0.5),
          plot.caption=element_text(hjust = 1))

