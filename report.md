## Correlation Between COVID Cases and Vaccination Status Among Different Age Groups in the U.S.

Shelby Pankratz

Minnesota State University Moorhead Biosciences Department

## Abstract

This is an exploratory data analysis using two datasets from the CDC website. The first is comparing percentage of fully vaccinated individuals among different age groups in the U.S. over a certain period of time, and the second is comparing COVID-19 cases among different age groups in the U.S. over a certain period of time. RStudio was used to filter raw data to use specifically for this study to create tables and graphs to display certain variables. Although it was hard to relate the two datasets to each other because of the difference in age groups, a Chi-Squared test was used to compare among the different age groups in the case dataset. It was found that cases among different age groups varied greatly, as seen in Fig. 2. This was probably due to a variety of outside factors, but the 21-30 year old age group had the highest increase in COVID-19 cases in the designated time period, and the 18-24 year old age group had the lowest percentage of vaccination (not including the 5-11 year old age group, as they were not approved until later for the vaccine).

## Introduction

COVID-19 vaccinations in the U.S. first became available to select populations, such as the elderly and immunocompromised, back in June 2020, right after COVID-19 broke out in March. Fast forward to present day where vaccinations are available to everyone, along with the development of a booster shot. However, since then, vaccines have become a very controversial topic. A handful of reasons that people have been deferring vaccination are concerns about side effects and safety of the vaccine, lack of trust in the government, and the vaccine being developed too quickly (Nguyen, et al.). In the United States, it's been seen that longer testing and increased efficacy and development of a vaccine have a significant impact on vaccination acceptance (Pogue et al.). This has led to many people wondering, how effective are these vaccines?

This project will be demonstrating an exploratory data analysis on the relationship between the number of COVID-19 cases and the number of people vaccinated. This will help to show the effectiveness of the vaccine. Data will be used from COVID Data Tracker, which is a website managed by the CDC, to look for relationships between positive COVID-19 cases and vaccination status among different age groups. The whole population of the U.S. will be looked at to get more accurate information on the effectiveness of the COVID-19 vaccine. If the vaccine is effective, we should see that as the number of vaccinated people goes up, the amount of COVID-19 cases will go down.

## Methods

Data acquisition of the data sets from the CDC website is listed in the steps below.

### Data Acquisition

COVID data: Cases

1.  Go to <https://covid.cdc.gov/covid-data-tracker/#demographics>
2.  Scroll to "View Data"
3.  Click on the Export Tab
4.  Click on CSV
5.  Save to data folder (Public_Dataset_Age_1\_)

COVID data: Vaccination Status

1.  Go to <https://data.cdc.gov/Vaccinations/COVID-19-Vaccination-and-Case-Trends-by-Age-Group-/gxj9-t96f>

2.  Scroll to "View Data"

3.  Click on the Export Tab

4.  Click on CSV

5.  Save to data folder (COVID_19_Vaccination_and_Case_Trends_by_Age_Group_United_States_1\_.csv)

After downloading the data, the first step is to run the tidyverse code, then rename the data set, starting with the vaccination data set.

    library(tidyverse)

    vax_data <- read_csv("data/COVID-19_Vaccination_Demographics_in_the_United_States_National (1).csv")

To get rid of the unwanted variables and to make the variables that are to be kept a little easier to read, the rename, filter, and mutate functions are used to get the desired table. This line of code specifically works on renaming and mutating the column that deals with the age groups.

    filter(str_starts(Demographic_category, "Ages_")) %>% 
      rename(age_group = Demographic_category) %>% 
      mutate(
        Date = as.Date(Date, format = "%m/%d/%Y"),
        age_group=str_remove(age_group, "Ages_"),
        age_group=str_remove(age_group, "_yrs"),
        age_group=str_remove(age_group, "yrs")
      ) %>% 

The next step that took place was making sure that all the age groups were included in the table. Because of this, a line of code had to be added beforehand to make sure that R could read the age data

    age_group_levels <- c("<5", "5-11", "<12", "16-17", "18-24", 
                          "25-39", "40-49", "50-64", "65-74", "75+")

After this code, R is able to recognize the data set "age_group_levels" and the mutate function is used to factor the age groups.

    mutate(age_group = factor(age_group, levels = age_group_levels)) %>%

In this data set, there were a couple of age groups that overlapped with each other, or ones that weren't needed. The filter function was used to get remove them from the table as well.

    filter(!age_group %in% c("<12yrs", "<5yrs", "12-15", "16-17", "<12", "<5")) %>%

After that, rename the other columns so they make sense and select the variables that we want to be displayed on the table and use the print function to show the data.

     rename(
        per_vax = Series_Complete_Pop_pct_agegroup, 
        date = Date
      ) %>%
      select(date, age_group, per_vax) %>%
      print()

## Results

```{r vax, echo=FALSE}
vax_data %>% 
  filter(date == as.Date("2022-01-01") | date == as.Date("2021-01-01")) %>%
  ggplot(aes(x = date, y = per_vax, color = age_group)) +
  labs(y="% Fully Vaccinated", 
       x="Date", 
       title="Vaccination Status Among  Age Groups (Jan 2021-Jan2022)") +
  geom_line() +
  theme_gray(base_size = 10)

http://127.0.0.1:43185/chunk_output/s/6D67F2D2/cm2seb2z82a3x/00000c.png?resize=14
```

    ```{r cases, echo=FALSE}
    cases_by_age %>% 
      filter(date == as.Date("2022-01-31") | date == as.Date("2021-12-01")) %>% 
      ggplot() +
      geom_col(mapping = aes(x = date, y = total_cases),
               fill = "#008B8B") +
      facet_wrap(~ age_range)+
      labs(y="Total Cases", x="Date", title = "COVID-19 Cases in the U.S. (from Dec 2021  to Jan 2022)")+
      theme_gray(base_size = 12)+
      theme(axis.text.x=element_text(size=rel(.8)))
    ```
