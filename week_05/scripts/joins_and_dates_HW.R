### Purpose of this script is for the Week 5 HW using conductivity & depth data given ###
### Created by Gabby Tapat ###
### Created on 2026-09-27 ####

### Load libraires ###
library(tidyverse)
library(here)
library(lubridate)
library(patchwork)

### Read in data ###

cond <- read_csv(here("week_05", "data", "CondData.csv"))
head(cond)

depth <- read_csv(here("week_05", "data", "DepthData.csv")) |>
  rename(dateTime = date) #changed later to match column name for inner_join() 
head(depth)

###Analysis ###

#convert date columns
class(depth$date) #check if already in correct format...is in POSIXct
class(cond$date) #check if already in correct format...is in character

cond <- cond |>
  mutate(dateTime = mdy_hms(date)) |>
  mutate(dateTime = round_date(dateTime, "10 seconds")) |> #round to nearest 10 seconds
  inner_join(depth) #join the 2 data frames

# calculate avg of date, depth, temp & salinity by minute

cond_avg <- cond |> #make a new data frame for calculations
  mutate(dateTime_min = round_date(dateTime, "minute")) |>
  group_by(dateTime_min) |>
  summarise(mean_temp = mean(Temperature, na.rm = TRUE),
            mean_salinity = mean(Salinity, na.rm = TRUE),
            mean_depth = mean(Depth, na.rm = TRUE),
            mean_date = mean(dateTime, na.rm = TRUE)) 

#Plot avg data
#I'm assuming the unit measurements for depth in meters & salinity in ppt
#Using patchwork b/c no shared factors 
#change colors of y axis titles to differentiate the parameters

p1 <- cond_avg |>
  ggplot(aes(x = mean_date, y = mean_salinity)) +
  geom_line(color = "darkorange", linewidth = 1) +
  labs(x = "Time", y = "Salinity (ppt)") +
  theme_minimal() +
  theme(
    axis.title.y = element_text(color = "darkorange",
                              size = 12,
                              face = "bold")
  )


p2 <- cond_avg |>
  ggplot(aes(x = mean_date, y = mean_temp)) +
  geom_line(color = "darkcyan", , linewidth = 1) +
  labs(x = "Time", y = "Temperature (°C)") +
  theme_minimal()+
  theme(
    axis.title.y = element_text(color = "darkcyan",
                              size = 12,
                              face = "bold")
  )


p3 <- cond_avg |>
  ggplot(aes(x = mean_date, y = mean_depth)) +
  geom_line(color = "blue", , linewidth = 1) +
  labs(x = "Time", y = "Depth (m)") +
  theme_minimal()+
  theme(
    axis.title.y  = element_text(color = "blue",
                              size = 12,
                              face = "bold")
  )


p4 <- p3 + p2 + p1 + 
  plot_layout(axis_titles = "collect") + #has shared name for x-axis
  plot_annotation(title = "Average depth, temperature, and salinity measurement taken on May 5, 2021",
                  theme = theme(
                    plot.title = element_text(
                      size = 16
                    )
                  ))

ggsave(here("week_05", "outputs", "avg_cond.png"))
