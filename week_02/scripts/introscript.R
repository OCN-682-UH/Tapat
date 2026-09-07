### This is my first script, learning how to import data ###
### Created by Gabby Tapat ####
### Created on 2026-09-05 ###

### Load libraries ###
library(tidyverse)
library(here)
library(ggplot2)

### Load data ###

weight_data <- read.csv(here("week_02", "data", "weightdata.csv"))

### Data analysis ###

head(weight_data)
tail(weight_data)
view(weight_data)


plot <- ggplot(data = weight_data, aes(x = Treatment, Weight))+
  geom_boxplot(fill= "blue", alpha = 0.7)+
  theme_minimal()+
  ggsave(filename = here("week_02", "outputs", "plot.png"))

