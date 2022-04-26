library(tidyverse)

age_group_levels <- c("<5", "5-11", "<12", "16-17", "18-24", 
                      "25-39", "40-49", "50-64", "65-74", "75+")

read_csv("data/COVID-19_Vaccination_Demographics_in_the_United_States_National (1).csv") %>% 
  filter(str_starts(Demographic_category, "Ages_")) %>% 
  rename(age_group = Demographic_category) %>% 
  mutate(
    Date = as.Date(Date, format = "%m/%d/%Y"),
    age_group=str_remove(age_group, "Ages_"),
    age_group=str_remove(age_group, "_yrs"),
    age_group=str_remove(age_group, "yrs")
  ) %>% 
  print()
  
  filter(!age_group %in% c("<12yrs", "<5yrs", "12-15", "16-17")) %>% 
  mutate(age_group = factor(age_group, levels = age_group_levels)) %>%
  rename(
    per_vax = Series_Complete_Pop_pct_agegroup, 
    date = Date
  ) %>%
  select(date, age_group, per_vax) %>%
print()




install.packages("devtools")
devtools::install_github("UrbanInstitute/urbnmapr")

county_data <- read_csv("data/United_States_COVID-19_Community_Levels_by_County.csv") %>% 
  filter(-c)
  print()

# mn county map
library(tidyverse)
library(urbnmapr)

counties_sf <- get_urbn_map("counties", sf = TRUE)

counties_sf %>% 
  filter(state_name == "Minnesota") %>%
  ggplot(aes()) +
  geom_sf(fill = "cornflowerblue", color = "#00FFFF")



