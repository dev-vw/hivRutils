# this is a script with a function that pulls NAOMI spectrum data iteratively by building download urls
library(tidyverse)
options(scipen = 999)

# Variables of interest ----

# Countries: PEPFAR countries
# Areas: 0, 1, 2
# Sex: M
# Ages: 15-19; 20-24; 25-34; 35-49; 50-64; 65+
# Period: December 2022
# Indicators: Population; HIV prevalence; HIV incidence per 1000; New infections; PLHIV; Number PLHIV aware; Number Aware PLHIV (ART catchment); ART number (residents); ART number (attending)
# store a function that pulls and labels a data frame for a set of variable inputs

# define function ----
get_data_from_remote <- function(period, country, indicator, age, sex) {
  url <- paste0("https://naomi2023.azurewebsites.net/api/v1/data?period=",
                period,
                "&country=",
                country, 
                "&areaLevel=0&areaLevel=1&areaLevel=2&areaLevel=3", 
                "&indicator=", 
                indicator, 
                "&ageGroup=", 
                age, 
                "&sex=", 
                sex)
  print(url)
  data_pull <- read.csv(as.character(url)) %>%
    mutate(country = country) %>%
    mutate(indicator = indicator) %>%
    mutate(age = age) %>%
    mutate(sex = sex)
  
  return(data_pull)
}

pull_hiv_df <- function(periods, countries_included, ages, indicators, sex) {
  
  # set paramter value combinations
  params <- expand.grid(countries_included = countries_included, 
                        indicators = indicators, 
                        ages = ages, 
                        sex = sex)
  
  # iteratively pull data using params
  data_lst <- apply(params, 1, 
                    function(param_combo) {
                      period <- periods[param_combo[1]]
                      new_data <- get_data_from_remote(period,
                                                       param_combo[1], 
                                                       param_combo[2], 
                                                       param_combo[3], 
                                                       param_combo[4])
                      print(new_data)
                    })
  
  # bind the list of dfs
  all_data <- bind_rows(data_lst)
  
  return(all_data)
}

filter_data <- function(df, iso3, adm_level) {
  df <- dplyr::filter(df, country == iso3)
  df <- dplyr::filter(df, level == adm_level)
  
  df <- df %>% select(-lower, -upper)
  df <- pivot_wider(df, names_from = indicator, values_from = mean)
  df <- pivot_wider(df, 
                    names_from = sex, 
                    values_from = c(prevalence, incidence, plhiv, art_coverage))
  
  return(df)
}

save_data <- function(df, outname) {
  write_csv(df, paste0("output/hiv-data/"))
}