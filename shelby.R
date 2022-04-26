library(tidyverse)

# citation for RStudio (needs to be in References in GitHub)
citation()
citation("tidyverse")

if (!dir.exists("figs")) dir.create("figs")

age_group_levels <- c("<5", "5-11", "<12", "16-17", "18-24", 
                      "25-39", "40-49", "50-64", "65-74", "75+")

## vaccination data ----
# raw data ----
vax_data <- 
  read_csv("data/COVID-19_Vaccination_Demographics_in_the_United_States_National (1).csv") %>% 
  filter(str_starts(Demographic_category, "Ages_")) %>%
rename(age_group = Demographic_Category) %>% 
  mutate(
    Date = as.Date(Date, format = "%m/%d/%Y"),
    age_group=str_remove(age_group, "Ages_"),
    age_group=str_remove(age_group, "_yrs"),
    age_group=str_remove(age_group, "yrs")
  ) %>% 
  filter(!age_group %in% c("<12yrs", "<5yrs", "12-15", "16-17")) %>% 
  mutate(age_group = factor(age_group, levels = age_group_levels)) %>%
  rename(
    per_vax = Series_Complete_Pop_pct_agegroup, 
    date = Date
  ) %>% 
  select(date, age_group, per_vax) %>%
  print()

#column graph ----
vax_data %>% 
  filter(date == max(date)) %>% 
  ggplot()+
  geom_col(mapping = aes(x=age_group, y=per_vax), 
           fill = "#a6192e") +
  labs(y="% Fully Vaccinated", x="Age Range", title = "Vaccination Status as of March 27, 2022")+
  theme_gray(base_size = 16)
ggsave("figs/vax data.png", height = 6, width = 10, units="in", dpi=600)

# line graph ----
vax_data %>% 
  ggplot(aes(x = date, y = per_vax, color = age_group)) +
  geom_line() +
  theme_gray(base_size = 16)
ggsave("figs/line vax data.png", height = 6, width = 10, units="in", dpi=600)


## cases ----
# raw data ----
library(readxl)
cases_by_age <- 
  read_excel("data/Public-Dataset-Age (1).XLSX") %>% 
  select(-c(AR_TOTALPERCENT, AR_NEWCASES, 
            AR_NEWPERCENT, AR_TOTALDEATHS, AR_NEWDEATHS)) %>% 
  rename(date = DATE, age_range=AGE_RANGE, total_cases=AR_TOTALCASES) %>% 
  mutate(date = as.Date(date)) %>% 
  print()

# column graph ----
cases_by_age %>%
  # filter(date == max(date)) %>%    # choose the last date
  filter(date == as.Date("2022-03-26") | date == as.Date("2021-12-01")) %>%   # choose a particular date
  ggplot()+
  geom_col(mapping = aes(x=age_range, y=total_cases, fill=as.factor(date)),
           position="dodge2") +
  labs(y="# of Cases", x="Age Range", title="COVID-19 Cases Among  Age Groups") 

# multiple graphs ----
cases_by_age %>% 
  filter(date == as.Date("2022-03-26") | date == as.Date("2021-03-01")) %>% 
  ggplot() +
  geom_col(mapping = aes(x = date, y = total_cases),
           fill = "#a6192e") +
  facet_wrap(~ age_range)+
  theme_gray(base_size = 16)+
  theme(axis.text.x=element_text(size=rel(.8)))
ggsave("figs/case data.png", height = 8, width = 12, units="in", dpi=600)

# implications
  # having public data available

# make sure to insert a picture