# this builds age pyramids for mozambique

library(tidyverse)

# load data ----

load("moz.Rda")

moz <- df
rm(df)

# clean up data ----

# create age labels

moz <- moz %>%
  mutate(age_label = case_when(
    age == "Y000_014" ~ "0-14",
    age == "Y015_024" ~ "15-24",
    age == "Y025_034" ~ "25-34",
    age == "Y035_049" ~ "35-49",
    age == "Y050_999" ~ "50+"
  )
)


# select only national level

moz_national <- moz %>%
  filter(level == "0")


# get rid of redundant columns

moz_national <- moz_national %>%
  select(-country, -level, -area)

# generate the 1- inverse variables and label accordingly

generate_unaware <- moz_national %>%
  filter(indicator == "aware_plhiv_prop") %>%
  mutate(indicator = "unaware_plhiv_prop") %>%
  mutate(mean = 1-mean) %>%
  mutate(lower = 1-lower) %>%
  mutate(upper = 1-upper)

generate_notonART <- moz_national %>%
  filter(indicator == "art_coverage") %>%
  mutate(indicator = "non_art_coverage") %>%
  mutate(mean = 1-mean) %>%
  mutate(lower = 1-lower) %>%
  mutate(upper = 1-upper)

moz_national_full <- rbind(moz_national, generate_unaware, generate_notonART)


# save and export data ----

write.csv(moz_national_full, file = "moz_naomi_data.csv")




# make plots ----

# subset data

moz_plhiv_female <- moz_national_full %>%
  filter(indicator == "plhiv" & sex == "female")

# begin ggplot

ggplot(moz_plhiv_female, aes(x = mean, y = age_label), stat = mean) +
  geom_bar(stat = "identity", fill = "#C25432")

# subset data
moz_plhiv_male <- moz_national_full %>%
  filter(indicator == "plhiv" & sex == "male")

# begin ggplot

ggplot(moz_plhiv_male, aes(x = mean, y = age_label), stat = mean) +
  geom_bar(stat = "identity", fill = "#004851")



# Total PLHIV: generate full population pyramid ----

moz_plhiv <- moz_national_full %>%
  filter(indicator == "plhiv")


basic_plot <-  ggplot(
  moz_plhiv,
  aes(
    x = age_label,
    fill = sex,
    y = ifelse(
      test = sex == "male",
      yes = -mean,
      no = mean
    )
  )
) +
  scale_fill_manual(values = c("#C25432", "#004851")) +
  geom_bar(stat = "identity")

basic_plot

population_pyramid <- basic_plot +
  scale_y_continuous(
    labels = abs,
    limits = max(moz_plhiv$mean) * c(-1,1)
  ) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age",
    y = "Population",
    fill = "Sex",
    title = "Total PLHIV"
  )

population_pyramid

# Percentage unaware of HIV status ----

moz_unaware_status <- moz_national_full %>%
  filter(indicator == "unaware_plhiv_prop")


basic_plot <-  ggplot(
  moz_unaware_status,
  aes(
    x = age_label,
    fill = sex,
    y = ifelse(
      test = sex == "male",
      yes = -mean,
      no = mean
    )
  )
) +
  geom_bar(stat = "identity")

basic_plot

population_pyramid <- basic_plot +
  scale_y_continuous(
    labels = abs,
    limits = max(moz_unaware_status$mean) * c(-1,1)
  ) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age",
    y = "Proportion",
    fill = "Sex",
    title = "Percent of PLHIV unaware of status"
  )

population_pyramid


# Percent of PLHIV not on ART ----

moz_notonART <- moz_national_full %>%
  filter(indicator == "non_art_coverage")


basic_plot <-  ggplot(
  moz_notonART,
  aes(
    x = age_label,
    fill = sex,
    y = ifelse(
      test = sex == "male",
      yes = -mean,
      no = mean
    )
  )
) +
  geom_bar(stat = "identity")

basic_plot

population_pyramid <- basic_plot +
  scale_y_continuous(
    labels = abs,
    limits = max(moz_notonART$mean) * c(-1,1)
  ) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age",
    y = "Proportion",
    fill = "Sex",
    title = "Percent of PLHIV not on ART"
  )

population_pyramid


# Number of PLHIV not on ART ----

moz_untreatednum <- moz_national_full %>%
  filter(indicator == "untreated_plhiv_num")


basic_plot <-  ggplot(
  moz_untreatednum,
  aes(
    x = age_label,
    fill = sex,
    y = ifelse(
      test = sex == "male",
      yes = -mean,
      no = mean
    )
  )
) +
  geom_bar(stat = "identity", fill = c(""))

basic_plot

population_pyramid <- basic_plot +
  scale_y_continuous(
    labels = abs,
    limits = max(moz_untreatednum$mean) * c(-1,1)
  ) +
  coord_flip() +
  theme_minimal() +
  labs(
    x = "Age",
    y = "Population",
    fill = "Sex",
    title = "Number of PLHIV not on ART"
  )

population_pyramid

# FUNCTION ----


# input: indicator
# output: agepop pyramid

generate_pyramid <- function(indicator_input, pop_or_prop, title_input){

  df <- moz_national_full %>%
    filter(indicator == indicator_input)

  basic_plot <-  ggplot(
    df,
    aes(
      x = age_label,
      fill = sex,
      y = ifelse(
        test = sex == "male",
        yes = -mean,
        no = mean
      )
    )
  ) +
    scale_fill_manual(values = c("#C25432", "#004851")) +
    geom_bar(stat = "identity")

  p <- basic_plot +
    scale_y_continuous(
      labels = abs,
      limits = max(df$mean) * c(-1,1)
    ) +
    coord_flip() +
    theme_minimal() +
    labs(
      x = "Age",
      y = pop_or_prop,
      fill = "Sex",
      title = title_input
    )

 return(p)

}


# FUTURE WORK ----

# mods if time permits

# more axis tick marks
# trim axis edges to fit visual range
# add commas to numbers
# eventually: add values into graph, rounded
# check 508 compliance; standardize with style guide
