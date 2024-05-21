# this is a script that merges ISO codes into a DREAMS data file 

# set up environment

library(tidyverse)
library(readxl)

iso_codes <- read.csv("https://raw.githubusercontent.com/dev-vw/hivRutils/dev/data-documentation/pepfar_countries.csv")


dreams_reached_msd <- read_excel("DREAMS_AGYW_Reached_MSD_PSNU_IM_DREAMS_FY22-24_20240315_v2_1_12h36.xlsx",
                                 sheet = 2)

# merge in ISO codes

iso_codes <- iso_codes %>%
  select(country_name, ISO_alpha_3) %>%
  rename(country = country_name)


dreams_reached_msd_iso <- left_join(dreams_reached_msd, iso_codes, by = "country") %>%
  select(ISO_alpha_3, everything())


write.csv(dreams_reached_msd_iso, file = "dreams_reached_msd_iso.csv")

# NOTE: this had to be manually reopened and saved as an .xlsx file. For some reason there were huge delays in trying to use write.xlsx from the "xlsx" package. would be great to resolve this
