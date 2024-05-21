# this is a script that pulls in ALL country ISO abbrevs and then tags countries that:
## 1) are PEPFAR countries
## 2) have UNAIDS data
## 3) have Naomi data

# load packages

library(tidyverse)
library(readxl)
library(janitor)

# store PEPFAR countries ----

pepfar_countries <- c("Angola",
                      "Botswana",
                      "Burundi",
                      "Cameroon",
                      "Cote d'Ivoire",
                      "Dominican Republic",
                      "Democratic Republic of Congo",
                      "Eswatini",
                      "Ethiopia",
                      "Haiti",
                      "Kenya",
                      "Lesotho",
                      "Malawi",
                      "Mozambique",
                      "Namibia",
                      "Nigeria",
                      "Rwanda",
                      "South Africa",
                      "South Sudan",
                      "Tanzania",
                      "Uganda",
                      "Ukraine",
                      "Vietnam",
                      "Zambia",
                      "Zimbabwe"
                      )

asia_region <- c("Burma",
                 "Cambodia",
                 "India",
                 "Indonesia",
                 "Kazakhstan",
                 "Kyrgyz Republic",
                 "Laos",
                 "Nepal",
                 "Papua New Guinea",
                 "Philippines",
                 "Tajikistan",
                 "Thailand")

west_africa_region <- c("Burkina Faso",
                        "Ghana",
                        "Liberia",
                        "Mali",
                        "Sierra Leone",
                        "Senegal",
                        "Togo")

western_hemisphere_region <- c("Barbados",
                               "Brazil",
                               "El Salvador",
                               "Guatemala",
                               "Guyana",
                               "Honduras",
                               "Jamaica",
                               "Nicaragua",
                               "Panama",
                               "Trinidad & Tobago",
                               "Suriname")

# create dataframe ----

pepfar_countries <- data.frame(pepfar_countries)

pepfar_countries <- pepfar_countries %>%
  mutate(pepfar_region = NA) %>%
  rename(country_name = pepfar_countries)

asia_region <- data.frame(asia_region) %>%
  mutate(pepfar_region = "Asia Region") %>%
  rename(country_name = asia_region)

west_africa_region <- data.frame(west_africa_region) %>%
  mutate(pepfar_region = "West Africa Region") %>%
  rename(country_name = west_africa_region)

western_hemisphere_region <- data.frame(western_hemisphere_region) %>%
  mutate(pepfar_region = "Western Hemisphere Region") %>%
  rename(country_name = western_hemisphere_region)

pepfar_countries <- rbind(pepfar_countries, asia_region, west_africa_region, western_hemisphere_region)



# import ISO abbrevs ----

country_iso <- read.csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")

country_iso <- country_iso %>%
  select(name, alpha.2, alpha.3) %>%
  rename(country_name = name, ISO_alpha_2 = alpha.2, ISO_alpha_3 = alpha.3)

pepfar_countries <- left_join(pepfar_countries, country_iso, by = "country_name")

# note that some don't merge - inspect and resolve missing items

inspect_missing <- pepfar_countries %>%
  filter(is.na(ISO_alpha_3))

# ISO names that are different
## Congo, Democratic Republic of the
## Cote d'Ivoire (special character)
## Tanzania, United Republic of
## Viet Nam
## Kyrgyzstan
## Myanmar
## Lao People's Democratic Republic
## Trinidad and Tobago

country_iso_rev <- country_iso %>%
  mutate(country_name = gsub("Congo, Democratic Republic of the", "Democratic Republic of Congo", country_name)) %>%
  mutate(country_name = gsub("Tanzania, United Republic of", "Tanzania", country_name)) %>%
  mutate(country_name = gsub("Viet Nam", "Vietnam", country_name)) %>%
  mutate(country_name = gsub("Kyrgyzstan", "Kyrgyz Republic", country_name)) %>%
  mutate(country_name = gsub("Myanmar", "Burma", country_name)) %>%
  mutate(country_name = gsub("Lao People's Democratic Republic", "Laos", country_name)) %>%
  mutate(country_name = gsub("Trinidad and Tobago", "Trinidad & Tobago", country_name)) %>%
  mutate(country_name = gsub("Côte", "Cote", country_name))

# redo merge with corrected country names

pepfar_countries <- pepfar_countries %>%
  select(-ISO_alpha_2, -ISO_alpha_3)

pepfar_countries <- left_join(pepfar_countries, country_iso_rev, by = "country_name")

# save csv of PEPFAR countries and ISO codes ----

write.csv(pepfar_countries, file = "pepfar_countries.csv")



# store Naomi countries ----

naomi_countries <- c("Angola",
                     "Benin",
                     "Botswana",
                     "Burkina Faso",
                     "Burundi",
                     "Cameroon",
                     "Central African Republic",
                     "Chad",
                     "Congo",
                     "Cote d'Ivoire",
                     "Democratic Republic of the Congo",
                     "Equatorial Guinea",
                     "Eswatini",
                     "Ethiopia",
                     "Gabon",
                     "Gambia",
                     "Ghana",
                     "Guinea",
                     "Guinea Bissau",
                     "Haiti",
                     "Kenya",
                     "Lesotho",
                     "Liberia",
                     "Malawi",
                     "Mali",
                     "Mozambique",
                     "Namibia",
                     "Niger",
                     "Rwanda",
                     "Sao Tome and Principe",
                     "Senegal",
                     "Sierra Leone",
                     "South Africa",
                     "Togo",
                     "Uganda",
                     "United Republic of Tanzania",
                     "Zambia",
                     "Zimbabwe")



