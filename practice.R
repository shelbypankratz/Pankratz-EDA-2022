# map graph??
install.packages("devtools")
devtools::install_github("UrbanInstitute/urbnmapr")

mn_counties_vax <- read_csv("data/county_level_vaccination_data_for_minnesota (3).csv") %>% 
  print()

# mn county map
library(tidyverse)
library(urbnmapr)

counties_sf <- get_urbn_map("counties", sf = TRUE)

counties_sf %>% 
  filter(state_name == "Minnesota") %>%
  ggplot(aes()) +
  geom_sf(fill = "cornflowerblue", color = "#00FFFF")
