library(tidyverse)
library(readxl)
library(here)

devtools::load_all()

eras_tour_surprise <- read_xlsx(here("data-raw", "surprise-songs.xlsx")) %>%
  mutate(date = as_date(date),
         night = as.integer(night)) %>%
  filter(date <= today())


# QC data file -----------------------------------------------------------------
# Check for track names are consistent. Should be 0 rows.
(bad_name <- eras_tour_surprise %>%
   filter(!(song %in% taylor_all_songs$track_name)))

# Check that we're using Taylor's Version when possible. Should be 0 rows.
(not_tv <- eras_tour_surprise %>%
    filter(!str_detect(song, fixed("Taylor's Version"))) %>%
    mutate(tv = map(song,
                    \(x) {
                      taylor_all_songs %>%
                        filter(str_detect(track_name, x)) %>%
                        filter(str_detect(track_name,
                                          fixed("Taylor's Version"))) %>%
                        select(album_name, track_name)
                    })) %>%
    filter(map_lgl(tv, \(x) nrow(x) > 0)) %>%
    select(song, tv) %>%
    unnest(tv))

use_data(eras_tour_surprise, overwrite = TRUE)
