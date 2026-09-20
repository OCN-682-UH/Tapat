### This script is for week 04-b assignment, which uses chemistry data and tidyr###
### Created by Gabby Tapat ####
### Created on 2026-09-19 ###

### Load libraries ###
library(tidyverse)
library(here)

### Load data ###

ChemData <- read_csv(here("week_04", "data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)

### Data analysis ###

ChemData_clean_summary <- ChemData |>
  drop_na() |> #Remove all the NAs
  #Separate the Tide_time column into appropriate columns
  separate_wider_delim(cols = Tide_time, #which column to separate
                       delim = "_", #separate by their underscore
                       names = c("Tide", "Time"),
                       cols_remove = FALSE) |> #keep the OG column
  #Filter out a subset of data
  filter(Season == "SPRING", Time == "Night" ) |>
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variable",
               values_to = "Value") |>
  group_by(Site, Variable) |>
  #Calculate some summary statistics
  summarise(mean_values = mean(Value, na.rm = TRUE),
                               median_values = median(Value, na.rm = TRUE)) |>
  #export summary stats in csv file into output folder
  write_csv(here("week_04", "outputs", "ChemData_clean_summary.csv"))


#Certain water quality parameters & rxns are temperature dependent 
#Test with pH readings in the different SGD zones during the spring time
#Plot
ChemData |>
  drop_na() |> #Remove all the NAs
  #Separate the Tide_time column into appropriate columns
  separate_wider_delim(cols = Tide_time, #which column to separate
                       delim = "_", #separate by their underscore
                       names = c("Tide", "Time"),
                       cols_remove = FALSE) |> #keep the OG column
  #Filter out a subset of data
  filter(Season == "SPRING", !(Zone == "Offshore")) |> #Taking out offshore data b/c data points are small
  ggplot(aes(x = Temp_in, 
             y= pH,
             group = Zone,
             color = Zone)) +
  geom_point(size = 2) +
  scale_colour_viridis_d(option = "C")+
  geom_smooth(method = "lm") +
  facet_wrap(~Zone, nrow = 3)+ #Forces plots to be on top of one another, shares x-axis
  guides(color = "none")+
  theme_dark()+
  labs(title = "pH levels corresponding to temperature in SGD zones during spring season",
       x = "Temperature (°C)",
       y = "pH",
       caption = "Silbiger et al., 2020 / Proceedings of the Royal Society B")+
  theme(plot.title = element_text(size = 16),
         axis.title = element_text(size = 12,
                                   face = "bold")
       )

#Save plot
ggsave(here("week_04", "outputs", "pH_SGD.png"), width = 10, height = 7)
#had to adjust size of output b/c title was cut off using default settings
#Reference: https://ggplot2.tidyverse.org/reference/ggsave.html
  