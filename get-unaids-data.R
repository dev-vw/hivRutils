# this is a script that read in UNAIDS data from the unaids website


# landing page: https://www.unaids.org/en/resources/fact-sheet

library(tidyverse)
library(readxl)

url <- "https://www.unaids.org/sites/default/files/media_asset/HIV_estimates_from_1990-to-present.xlsx"

# Download the Excel file
download.file(url, "HIV_estimates_from_1990-to-present.xlsx", mode = "wb")

# Read the first sheet of the downloaded Excel file into R

hiv_estimates_by_year <- read_excel("HIV_estimates_from_1990-to-present.xlsx",
                       sheet = 1,
                       range = "A5:AY5980")


# still needs a lot of tidying...would be great to save this all as a csv when done and/or build out package

