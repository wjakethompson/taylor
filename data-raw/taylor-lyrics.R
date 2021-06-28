library(tidyverse)
library(here)
library(fs)

release_dates <- read_csv(here("data-raw", "releases.csv"),
                          col_types = cols(track_name = col_character(),
                                           release_date = col_date()))

albums <- release_dates |>
  filter(is.na(track_name)) |>
  rename(album_release = release_date) |>
  mutate(ep = album_name %in% c("The Taylor Swift Holiday Collection",
                                "Beautiful Eyes")) |>
  select(album_name, ep, album_release)

singles <- release_dates |>
  filter(!is.na(track_name)) |>
  rename(single_release = release_date) %>%
  select(album_name, track_name, single_release)

lyrics <- dir_ls(here("data-raw", "lyrics"), type = "file", recurse = TRUE) |>
  as_tibble() |>
  mutate(album = path_file(path_dir(value)),
         track = path_file(value)) |>
  separate(album, c(NA, "album_name"), sep = "_", fill = "left") |>
  separate(track, c("track_number", "track_name"), sep = "_", convert = TRUE,
           fill = "left") |>
  mutate(lyrics = map(value,
                      function(.x) {
                        read_lines(.x) |>
                          as_tibble() |>
                          mutate(
                            element = str_extract(value, "(?<=^\\[).*(?=\\]$)")
                          ) |>
                          separate(element, c("element", "element_artist"),
                                   sep = ": ", fill = "right") |>
                          replace_na(list(element_artist = "Taylor Swift")) |>
                          fill(element, element_artist) |>
                          filter(value != "",
                                 !str_detect(value, "^\\[.*\\]$")) |>
                          rowid_to_column("line") |>
                          select(line, lyric = value, element, element_artist)
                      }))


lyrics |>
  mutate(bonus_track = str_detect(album_name, "deluxe|platinum")) |>
  mutate(album_name = str_replace_all(album_name, "-", " "),
         album_name = str_to_title(album_name),
         album_name = case_when(
           album_name == "Taylor Swift Deluxe" ~ "Taylor Swift",
           album_name == "Fearless Platinum Edition" ~ "Fearless",
           album_name == "Speak Now Deluxe" ~ "Speak Now",
           album_name == "Red Deluxe Edition" ~ "Red",
           album_name == "1989 Deluxe" ~ "1989",
           album_name == "Reputation" ~ "reputation",
           TRUE ~ album_name
         ),
         album_name = na_if(album_name, "Non Album")) |>
  left_join(albums, by = "album_name") |>
  select(album_name, ep, album_release, track_number, track_name, bonus_track,
         lyrics) |>
  mutate(track_name = path_ext_remove(track_name),
         track_name = str_replace_all(track_name, "-", " "),
         track_name = str_to_title(track_name),
         track_name = str_replace_all(track_name, "Mcgraw", "McGraw"),
         track_name = str_replace_all(track_name, "Shouldve", "Should've"),
         track_name = str_replace_all(track_name, "Marys Song",
                                      "Mary's Song (Oh My My My)"),
         track_name = str_replace_all(track_name, "Im", "I'm"),
         track_name = str_replace_all(track_name, "Popv", "(Pop Version)"),
         track_name = str_replace_all(track_name, "Altv", "(Alternate Version)"),
         track_name = str_replace_all(track_name, "Acousticv", "(Acoustic Version)"),
         track_name = str_replace_all(track_name, "Radioe", "(Radio Edit)"),
         track_name = str_replace_all(track_name, "I Heart", "I Heart ?"),
         track_name = str_replace_all(track_name, "Youre", "You're"),
         track_name = str_replace_all(track_name, " N ", " & "),
         track_name = str_replace_all(track_name, "Pianov", "(Piano Version)"),
         track_name = str_replace_all(track_name, "Superstar", "SuperStar"),
         track_name = str_replace_all(track_name, "I Knew You Were Trouble",
                                      "I Knew You Were Trouble."),
         track_name = str_replace_all(track_name, "Come Back Be Here",
                                      "Come Back... Be Here"),
         track_name = str_replace_all(track_name, "Odr", "(Original Demo Recording)"),
         track_name = str_replace_all(track_name, "Rmx", "(Remix)"),
         track_name = str_replace_all(track_name, "Ready For It", "...Ready For It?"),
         track_name = str_replace_all(track_name, "New Years Day", "New Year's Day"),
         track_name = str_replace_all(track_name, "Dont", "Don't"),
         track_name = str_replace_all(track_name, "Cant", "Can't"),
         track_name = str_replace_all(track_name, "So It Goes", "So It Goes...")) |>
  left_join(singles, by = c("album_name", "track_name")) |>
  mutate(original_release = case_when(is.na(single_release) ~ album_release,
                                      album_release < single_release ~ album_release,
                                      TRUE ~ single_release)) |>
  select(album_name, ep, album_release, track_number, track_name, bonus_track,
         original_release, single_release, lyrics) |>
  View()


# use_data(taylor_lyrics, overwrite = TRUE)