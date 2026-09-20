### This script is for week 04-a assignment, which uses more of the penguin data###
### Created by Gabby Tapat ####
### Created on 2026-09-19 ###

### Load libraries ###

library(palmerpenguins)
library(tidyverse)
library(here)
library(ggplot2)

### Load data ###

#data is from library(palmerpenguins)
View(penguins) #see data frame

### Data analysis ###

#creates a data frame with calculated mean and variance of body mass by species, island, and sex without any NAs
penguin_calculations <- penguins |>
  drop_na(sex) |> #drop observations w/ NAs
  group_by(species, island, sex) |> 
  summarise(mean_body_mass = mean(body_mass, na.rm = TRUE),
            variance_body_mass = var(body_mass, na.rm = TRUE))

#creates a new data frame with female penguins only plus selected columns from OG data
female_penguins <- penguins |>
  drop_na(sex) |>
  filter(!sex == "male") |> #filters out male penguins
  mutate(log_body_mass = log(body_mass_g)) |> #calculates the log body mass into new column
  select(species, island, sex, log_body_mass) #select certain columns in new data frame

#Plotting log body mass by island and species
female_penguins <- ggplot(data = female_penguins,
       mapping = aes(x = species,
                     y = log_body_mass,
                     fill = species))+
  geom_boxplot(width=0.7, alpha=0.7) +
  scale_fill_viridis_d(option = "H") + #different types of palettes for color blindness A through H
  geom_jitter(size=0.7, alpha=0.5)+
  labs(title = "Log body mass of different female penguin species",
       x = "Species", y = "Log Body Mass", #log form means no units
       caption = "Palmer Station LTER / palmerpenguins package")+
  theme_bw()+
  theme(
    legend.position = "none",
    plot.title = element_text(size = 16),
      axis.title = element_text(color = "red",
                                size = 14,
                                face = "bold")
  )

#save plot
ggsave(here("week_04", "outputs", "female_penguins.png"))
