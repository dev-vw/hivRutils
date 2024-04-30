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

# OR: could pull this from

# store UNAIDS countries ----

### will pull this from UNAIDS dataframe TBD


# import ISO abbrevs

country_iso <- read.csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")

country_iso <- country_iso %>%
  select(name, alpha.2, alpha.3) %>%
  rename(country_name = name, ISO_alpha_2 = alpha.2, ISO_alpha_3 = alpha.3)

