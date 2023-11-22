library(tidyverse)
library(readxl)
library(here)

devtools::load_all()

eras_tour_surprise <- read_xlsx(here("data-raw", "surprise-songs.xlsx")) %>%
  mutate(date = as_date(date),
         night = as.integer(night)) %>%
  filter(date < today())


# QC data file -----------------------------------------------------------------
# Check for track names are consistent. Should be 0 rows.
(bad_name <- eras_tour_surprise %>%
   filter(!(song %in% taylor_all_songs$track_name)))

# Check that we're using Taylor's Version when possible. Should be 0 rows.
(not_tv <- eras_tour_surprise %>%
   left_join(taylor_all_songs %>%
               filter(is.na(ep) | !ep) %>%
               distinct(track_name, album_name),
             join_by(song == track_name),
             relationship = "many-to-one") %>%
   filter(!is.na(album_name),
          !album_name %in% taylor_album_songs$album_name) %>%
   distinct(song, album_name))

use_data(eras_tour_surprise, overwrite = TRUE)
