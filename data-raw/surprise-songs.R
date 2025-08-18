library(tidyverse)
library(readxl)
library(here)

devtools::load_all()

eras_tour_surprise <- read_xlsx(here("data-raw", "surprise-songs.xlsx")) %>%
  mutate(date = as_date(date), night = as.integer(night)) %>%
  filter(date <= today())


# QC data file -----------------------------------------------------------------
# Check that all past dates have been filled in. Should be 0 rows.
(missing_dates <- eras_tour_surprise %>%
  filter(is.na(song) | is.na(dress)))

# Check that track names are consistent. Should be 0 rows.
(bad_name <- eras_tour_surprise %>%
  select(song, mashup) %>%
  separate_longer_delim(mashup, delim = "; ") %>%
  pivot_longer(cols = everything(), names_to = "type", values_to = "song") %>%
  filter(!is.na(song)) %>%
  filter(!(song %in% taylor_all_songs$track_name)) %>%
  filter(
    !(song %in%
      c(
        "Thinking Out Loud",
        "Espresso",
        "Please Please Please",
        "I Love You, I'm Sorry"
      ))
  ))

# Check that we're using Taylor's Version when possible. Should be 0 rows.
(not_tv <- eras_tour_surprise %>%
  select(song, mashup) %>%
  separate_longer_delim(mashup, delim = "; ") %>%
  pivot_longer(cols = everything(), names_to = "type", values_to = "song") %>%
  filter(!is.na(song)) %>%
  filter(!str_detect(song, fixed("Taylor's Version"))) %>%
  mutate(
    tv = map(song, \(x) {
      taylor_all_songs %>%
        filter(str_detect(track_name, fixed(x))) %>%
        filter(str_detect(track_name, fixed("Taylor's Version"))) %>%
        select(album_name, track_name)
    })
  ) %>%
  filter(map_lgl(tv, \(x) nrow(x) > 0)) %>%
  select(type, song, tv) %>%
  unnest(tv) %>%
  distinct())

use_data(eras_tour_surprise, overwrite = TRUE)
