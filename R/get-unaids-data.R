# this is a script that read in and tidies UNAIDS data from the unaids website


# landing page: https://www.unaids.org/en/resources/fact-sheet

library(tidyverse)
library(readxl)

# get excel file ----

url <- "https://www.unaids.org/sites/default/files/media_asset/HIV_estimates_from_1990-to-present.xlsx"

# Download the Excel file
download.file(url, "HIV_estimates_from_1990-to-present.xlsx", mode = "wb")

# prepare column names ----

unaids_dd <- read.csv("https://raw.githubusercontent.com/dev-vw/hivRutils/dev/data-documentation/data-dictionary_UNAIDS.csv")

hiv_colnames <- unaids_dd$element

# Import and tidy HIV estimates by year ----

# Read the first sheet of the downloaded Excel file into R

hiv_estimates_by_year <- read_excel("HIV_estimates_from_1990-to-present.xlsx",
                       sheet = 1,
                       range = "A7:AY5980")

colnames(hiv_estimates_by_year) <- hiv_colnames

# Import and tidy HIV estimates by area ----

# Read the first sheet of the downloaded Excel file into R

hiv_estimates_by_area <- read_excel("HIV_estimates_from_1990-to-present.xlsx",
                                    sheet = 2,
                                    range = "A7:AY5980")

colnames(hiv_estimates_by_area) <- hiv_colnames

