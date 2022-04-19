library(tidyverse)

vax_data <- 
  read_csv("data/COVID-19_Vaccination_Demographics_in_the_United_States_National (1).csv") %>% 
  filter(
    str_starts(Demographic_category, "Ages_")
  ) %>% 
  mutate(
    Date = as.Date(Date, format = "%m/%d/%Y"),
    age_group=str_remove(Demographic_category, "Ages_"),
    age_group=str_remove(age_group, "_yrs"),
  ) %>% 
  filter(!age_group %in% c("<12yrs", "<5yrs", "12-15", "16-17")) %>% 
  mutate(age_group = factor(age_group, levels = order)) %>%
  rename(
    per_vax = Series_Complete_Pop_pct_agegroup, 
    date = Date
  ) %>% 
  select(date, age_group, per_vax) %>%
  print()


citation(rstudio)
