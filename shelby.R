library(tidyverse)

# vax data ---- 
age_group_levels <- c("<5", "5-11", "<12", "16-17", "18-24", 
                      "25-39", "40-49", "50-64", "65-74", "75+")

vax_data <- read_csv("data/COVID-19_Vaccination_Demographics_in_the_United_States_National (1).csv") %>% 
  filter(str_starts(Demographic_category, "Ages_")) %>% 
  rename(age_group = Demographic_category) %>% 
  mutate(
    Date = as.Date(Date, format = "%m/%d/%Y"),
    age_group=str_remove(age_group, "Ages_"),
    age_group=str_remove(age_group, "_yrs"),
    age_group=str_remove(age_group, "yrs")
  ) %>% 
  filter(!age_group %in% c("<12yrs", "<5yrs", "12-15", "16-17", "<12", "<5")) %>%
  mutate(age_group = factor(age_group, levels = age_group_levels)) %>%
  rename(
    per_vax = Series_Complete_Pop_pct_agegroup, 
    date = Date
  ) %>%
  select(date, age_group, per_vax) %>%
  print()

# vax line graph ----
#vax_line_graph <-

vax_data %>% 
  filter(date == as.Date("2022-01-01") | date == as.Date("2021-01-01")) %>%
  ggplot(aes(x = date, y = per_vax, color = age_group)) +
  labs(y="% Fully Vaccinated", 
       x="Date", 
       title="Vaccination Status Among  Age Groups (from Jan 2021 to Jan 2022)") +
  geom_line() +
  theme_gray(base_size = 16) %>% 
  print()



# cases ----
library(readxl)
cases_by_age <- 
  read_excel("data/Public-Dataset-Age (1).XLSX") %>% 
  select(-c(AR_TOTALPERCENT, AR_NEWCASES, 
            AR_NEWPERCENT, AR_TOTALDEATHS, AR_NEWDEATHS)) %>% 
  rename(date = DATE, age_range=AGE_RANGE, total_cases=AR_TOTALCASES) %>% 
  mutate(date = as.Date(date)) %>% 
  print()

# stat test for cases ----
chisq.test(table(cases_by_age$age_range, cases_by_age$total_cases))


# cases: multiple graphs ----
case_graph <-
cases_by_age %>% 
  filter(date == as.Date("2022-01-31") | date == as.Date("2021-12-01")) %>% 
  ggplot() +
  geom_col(mapping = aes(x = date, y = total_cases),
           fill = "#008B8B") +
  facet_wrap(~ age_range)+
  labs(y="Total Cases", x="Date", title = "COVID-19 Cases in the U.S. (from Dec 2021  to Jan 2022)")+
  theme_gray(base_size = 12)+
  theme(axis.text.x=element_text(size=rel(.8)))
