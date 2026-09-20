### Created by Gabby Tapat ###
### Purpose: in-class work w/ penguin data ###

### Load libraries ###
library(palmerpenguins)
library(tidyverse)
library(here)

### Load data ###
glimpse(penguins)

head(penguins)

filter(penguins, sex == "female")

filter(penguins, year == 2008)

filter(penguins, body_mass_g > 5000)

#don't need quotes if it's a number

filter(penguins, sex == "female", body_mass_g > 5000)

filter(penguins, year == 2008 |year == 2009)

filter(penguins, island != "Dream")

filter(penguins, !(island == "Dream"))

penguins |>
  filter(species %in% c("Adelie", "Gentoo"))

#mutate

mutate(penguins,
       body_mass_kg = body_mass_g / 1000)

penguins_1 <- mutate(penguins,
                     flipper_body_mass = flipper_length_mm + body_mass_g,
                     des_size = if_else(body_mass_g > 4000, "big", "small")
)

