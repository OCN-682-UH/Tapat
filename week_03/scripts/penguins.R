### This script is for week 03 assignment, which is to plot penguin data###
### Created by Gabby Tapat ####
### Created on 2026-09-13 ###
### Updated on 2026-09-14 ###

### Load libraries ###

library(palmerpenguins)
library(tidyverse)
library(here)
library(beyonce)
library(ggthemes)
library(ggridges)

### Load data ###

#data is from library(palmerpenguins)

### Data analysis ###

glimpse(penguins)
#8 columns: species, island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex, year
View(penguins) #see dataframe

#Plot of species, island, body_mass_g
#Used https://www.datanovia.com/learn/data-visualization/ggplot2/boxplot as reference

penguin <- ggplot(data=penguins, 
       mapping = aes(x = factor(species),
                     y = body_mass_g,
                     fill = factor(species)
                     )) +
  geom_boxplot() +
  scale_fill_viridis_d(alpha = 0.8)+
  facet_wrap(~ island, scales = "free_x")+ #some species don't exist in certain islands therefore remove
  labs(title = "Body Mass of Penguin Species by Island",
       x = "Penguin Species", y = "Body Mass (g)", fill ="species",
       caption = "Source: Palmer Station LTER / palmerpenguins package")+
  theme_minimal()+
  theme(strip.text = element_text(face = "bold", size = 10))
  theme(legend.position = "top")

#save plot
ggsave(here("week_03", "outputs", "penguin.png"))