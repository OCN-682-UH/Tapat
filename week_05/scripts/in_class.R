####Purpose of script to do in-class activites
###Created by Gabby Tapat
###Created on 2026-09-22

###Load libraries
library(tidyverse)
library(here)
library(readr)

#Load data
CondData <- read_csv(here("week_05","data", "CondData.csv"))|>
  mutate(datetime = mdy_hms(date))

site_characteristics_data <- read_csv(here("week_05", "data", "site.characteristics.data.csv")) |>
  pivot_wider(names_from = parameter.measured,
              values_from = values)

Topt_data <- read_csv(here("week_05", "data", "Topt_data.csv"))

full <-full_join(site_characteristics_data, Topt_data)


#Creating tibbles
T1 <- tibble(
  site.id = c("A", "B","C", "D"),
  temperature = c(14.1, 16.7, 15.3, 12.8)
)

T2 <- tibble(
  site.id = c("A", "B","D", "E"),
  pH = c(7.3, 7.8, 8.1, 7.9)
)

left_join(T1, T2)

right_join(T1, T2)

inner_join(T1, T2)

full_join(T1,T2)

semi_join(T1, T2)

anti_join(T1, T2)

T3 <- tibble(
  siteid = c("A", "B", "C", "D"),
  chlorophyll = c(2.3, 3.1, 1.9, 2.8)
)

left_join(T1, T3, by = c("site.id" = "siteid"))


T4 <- tibble(
  site.id = c("A", "A", "B", "B"),
  year = c (2020, 2021, 2020, 2021),
  biomass = c(12.5, 15.3, 18.2, 16.9)
)

T5 <- tibble(
  siteid = c("A", "A", "B"),
  year = c(2020, 2021, 2021),
  nutrients = c(8.2, 7.9, 9.1)
)

T6 <- tibble(
  site.id = c("A", "B", "C"),
  notes = c("pristine", "degraded", "moderately impaired")
)

T7 <- tibble(
  site.id = c("A", "B", "D"),
  notes = c("sunny", "shaded", "partially shaded"),
  quality = c("good", "fair", "poor")
)

#timestamp time zone
now(tzone = "US/Hawaii")

#just the date function
today()

#lubridate has to be in characters

mdy("02/24/2021")
mdy("Feb 24 2021")

ymd_hms("2021-02-24 10:22:00")


datetimes <- c(
  "02/24/2021 22:22:20",
  "02/25/2021 11:21:10",
  "02/26/2021 8:01:52"
)

datetimes <- mdy_hms(datetimes)
month(datetimes)
month(datetimes, label = TRUE, abbr = FALSE)
wday(datetimes, label = TRUE)
datetimes + hours(4)
datetimes + days(2)
round_date(datetimes, "minute")

# Create a datetime w/ no timezone info
datetime_naive <- mdy_hms("02/24/2021 10:22:20")
datetime_naive

# Assume the naive time is in Hawaii
hawaii_time <- with_tz(datetime_naive, tzone = "US/Hawaii")
hawaii_time

# Claim this was collected in Hawaii (though it was naive)
force_hawaii <- force_tz(datetime_naive, tzone = "US/Hawaii")
force_hawaii



