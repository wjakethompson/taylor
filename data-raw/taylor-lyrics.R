library(tidyverse)
library(spotifyr)
library(readxl)
library(here)
library(fs)

release_dates <- read_xlsx(here("data-raw", "releases.xlsx"),
                           col_types = c("text", "text", "date", "date")) |>
  mutate(promotional_release = lubridate::ymd(promotional_release),
         release_date = lubridate::ymd(release_date))

albums <- release_dates |>
  filter(is.na(track_name)) |>
  rename(album_release = release_date) |>
  mutate(ep = album_name %in% c("The Taylor Swift Holiday Collection",
                                "Beautiful Eyes")) |>
  select(album_name, ep, album_release)

singles <- release_dates |>
  filter(!is.na(track_name)) |>
  rename(single_release = release_date) %>%
  select(album_name, track_name, promotional_release, single_release)

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

base_info <- lyrics |>
  mutate(bonus_track = str_detect(album_name, "deluxe|platinum")) |>
  mutate(
    album_name = str_replace_all(album_name, "-", " "),
    album_name = str_to_title(album_name),
    album_name = case_when(
      album_name == "Taylor Swift Deluxe" ~ "Taylor Swift (Deluxe)",
      album_name == "Fearless Platinum Edition" ~ "Fearless (Platinum Edition)",
      album_name == "Fearless Taylors Version" ~ "Fearless (Taylor's Version)",
      album_name == "Speak Now Deluxe" ~ "Speak Now (Deluxe)",
      album_name == "Red Deluxe Edition" ~ "Red (Deluxe Edition)",
      album_name == "Red Taylors Version" ~ "Red (Taylor's Version)",
      album_name == "1989 Deluxe" ~ "1989 (Deluxe)",
      album_name == "Reputation" ~ "reputation",
      album_name == "Folklore" ~ "folklore",
      album_name == "Folklore Deluxe Edition" ~ "folklore (deluxe edition)",
      album_name == "Evermore" ~ "evermore",
      album_name == "Evermore Deluxe Edition" ~ "evermore (deluxe edition)",
      TRUE ~ album_name
    ),
    album_name = na_if(album_name, "Non Album")) |>
  left_join(albums, by = "album_name") |>
  select(album_name, ep, album_release, track_number, track_name, bonus_track,
         lyrics) |>
  # standard file name changes
  mutate(track_name = path_ext_remove(track_name),
         track_name = str_replace_all(track_name, "-", " "),
         track_name = case_when(str_detect(album_name, "folklore|evermore") ~
                                  str_to_lower(track_name),
                                TRUE ~ str_to_title(track_name))) |>
  # edits for Taylor Swift
  mutate(track_name = str_replace_all(track_name, "Mcgraw", "McGraw"),
         track_name = str_replace_all(track_name, "Shouldve", "Should've"),
         track_name = str_replace_all(track_name, "Marys Song",
                                      "Mary's Song (Oh My My My)"),
         track_name = str_replace_all(track_name, "Im", "I'm"),
         track_name = str_replace_all(track_name, "Popv", "(Pop Version)")) |>
  # edits for Beautiful Eyes
  mutate(track_name = str_replace_all(track_name, "Altv",
                                      "(Alternate Version)"),
         track_name = str_replace_all(track_name, "Acousticv",
                                      "(Acoustic Version)"),
         track_name = str_replace_all(track_name, "Radioe", "(Radio Edit)"),
         track_name = str_replace_all(track_name, "I Heart", "I Heart ?")) |>
  # edits for Fearless
  mutate(track_name = str_replace_all(track_name, "Youre", "You're"),
         track_name = str_replace_all(track_name, " N ", " & "),
         track_name = str_replace_all(track_name, "Pianov", "(Piano Version)"),
         track_name = str_replace_all(track_name, "Superstar", "SuperStar")) |>
  # edits for Red
  mutate(track_name = str_replace_all(track_name, "I Knew You Were Trouble",
                                      "I Knew You Were Trouble."),
         track_name = str_replace_all(track_name, "Come Back Be Here",
                                      "Come Back... Be Here"),
         track_name = str_replace_all(track_name, "Odr",
                                      "(Original Demo Recording)")) |>
  # edits for reputation
  mutate(track_name = str_replace_all(track_name, "Ready For It",
                                      "...Ready For It?"),
         track_name = str_replace_all(track_name, "New Years Day",
                                      "New Year's Day"),
         track_name = str_replace_all(track_name, "So It Goes",
                                      "So It Goes..."),
         track_name = str_replace_all(track_name, "Dont", "Don't"),
         track_name = str_replace_all(track_name, "Cant", "Can't")) |>
  # edits for Lover
  mutate(track_name = str_replace_all(track_name, "Youll", "You'll"),
         track_name = str_replace_all(track_name, "^Me$", "ME!"),
         track_name = str_replace_all(track_name, "Its Nice", "It's Nice")) |>
  # edits for evermore
  mutate(track_name = str_replace_all(track_name, "its time", "it's time"),
         track_name = str_replace_all(track_name, "tis the damn",
                                      "'tis the damn"),
         track_name = str_replace_all(track_name, "no body no crime",
                                      "no body, no crime")) |>
  # edits for Fearless (Taylor's Version)
  mutate(track_name = str_replace_all(track_name, "^Mr ", "Mr. "),
         track_name = str_replace_all(track_name, "^Thats ", "That's "),
         track_name = str_replace_all(track_name, "Tv Ftv",
                                      "(Taylor's Version) [From The Vault]"),
         track_name = str_replace_all(track_name, "(?<=\\)\\ )Tv",
                                      "[Taylor's Version]"),
         track_name = str_replace_all(track_name, "Tv",
                                      "(Taylor's Version)")) |>
  # edits for singles
  mutate(track_name = str_replace_all(track_name, "Rmx", "(Remix)")) |>
  left_join(singles, by = c("album_name", "track_name")) |>
  rowwise() |>
  mutate(track_release = min(album_release, promotional_release, single_release,
                             na.rm = TRUE)) |>
  ungroup() |>
  # set up album names for Spotify
  mutate(album_name = case_when(
    album_name == "Taylor Swift (Deluxe)" ~ "Taylor Swift",
    album_name == "Fearless (Platinum Edition)" ~ "Fearless",
    album_name == "Speak Now (Deluxe)" ~ "Speak Now",
    album_name == "Red (Deluxe Edition)" ~ "Red",
    album_name == "1989 (Deluxe)" ~ "1989",
    album_name == "folklore (deluxe edition)" ~ "folklore",
    album_name == "evermore (deluxe edition)" ~ "evermore",
    TRUE ~ album_name
  )) |>
  select(album_name, ep, album_release, track_number, track_name, bonus_track,
         promotional_release, single_release, track_release, lyrics)


# Get Spotify information ------------------------------------------------------
access_token <- get_spotify_access_token()

key_lookup <- tibble(key = 0:11,
                     key_name = c("C", "C#", "D", "D#", "E", "F", "F#", "G",
                                  "G#", "A", "A#", "B"))

single_uri <- tribble(
  ~track_name,                  ~track_uri,
  "American Girl",              "",
  "Bad Blood (Remix)",          "6xsEAm6w9oMQYYg3jkEkMT",
  "Beautiful Ghosts",           "2evEoQAhIMaa9PfjTT5skG",
  "Christmas Tree Farm",        "2mvabkN1i2gLnGAPUVdwek",
  "Crazier",                    "5vyxXfD5gLlyPxGZMEjtmd",
  "Eyes Open",                  "6KEemo78n0RnCQWKkeOdXz",
  "I Don't Wanna Live Forever", "2y5aJvzXhHPA94U5GFAcXe",
  "Only The Young",             "2slqvGLwzZZYsT4K4Y1GBC",
  "Ronan",                      "0Nw8hv79MLJa1yjtsEgz08",
  "Safe & Sound",               "0z9UVN8VBHJ9HdfYsOuuNf",
  "Sweeter Than Fiction",       "0RFCHlNuTeUHIB36VuVbOL",
  "Today Was A Fairytale",      "4pFvEWbjBpPUdYRQly0THs"
)

spotify <- tribble(
  ~album_name,                           ~album_uri,
  "Taylor Swift",                        "7mzrIsaAjnXihW3InKjlC3",
  "The Taylor Swift Holiday Collection", "7vzYp7FrKnTRoktBYsx9SF",
  "Fearless",                            "43OpbkiiIxJO8ktIB777Nn",
  "Fearless (Taylor's Version)",         "4hDok0OAJd57SGIT8xuWJH",
  "Speak Now",                           "5EpMjweRD573ASl7uNiHym",
  "Red",                                 "1KlU96Hw9nlvqpBPlSqcTV",
  "1989",                                "34OkZVpuzBa9y40DCy0LPR",
  "reputation",                          "6DEjYFkNZh67HP7R9PSZvv",
  "Lover",                               "1NAmidJlEaVgA3MpcPFYGq",
  "folklore",                            "1pzvBxYgT6OVwJLtHkrdQK",
  "evermore",                            "6AORtDjduMM3bupSWzbTSG"
) |>
  mutate(track = map(album_uri,
                     function(.x) {
                       album <- get_album(.x)

                       album$tracks$items |>
                         as_tibble() |>
                         select(track_name = name, track_uri = id)
                     })) |>
  unnest(track) |>
  bind_rows(single_uri) |>
  mutate(spotify = map(track_uri,
                       function(.x, key_lookup) {
                         if (.x == "") return(NULL)
                         track <- get_track(.x)
                         feat <- get_track_audio_features(.x)

                         feat |>
                           left_join(key_lookup, by = "key") |>
                           mutate(explicit = track$explicit,
                                  mode_name = case_when(
                                    mode == 0L ~ "minor",
                                    mode == 1L ~ "major"
                                  ),
                                  key_mode = paste(key_name, mode_name)) |>
                           select(danceability:tempo, time_signature,
                                  duration_ms, explicit, key_name,
                                  mode_name, key_mode)
                       },
                       key_lookup = key_lookup)) |>
  unnest(spotify)

spotify_join <- spotify |>
  select(album_name, track_name, danceability:tempo, time_signature,
         duration_ms, explicit, key_name, mode_name, key_mode) |>
  # general formatting
  mutate(track_name = case_when(str_detect(album_name, "folklore|evermore") ~
                                  track_name,
                                TRUE ~ str_to_title(track_name)),
         track_name = str_replace_all(track_name, "’", "'")) |>
  # edits for Taylor Swift
  mutate(track_name = str_replace_all(track_name, "Mcgraw", "McGraw"),
         track_name = str_replace(track_name,
                                  "Teardrops On My Guitar - Radio Single Remix",
                                  "Teardrops On My Guitar"),
         track_name = str_replace(track_name,
                                  "Teardrops On My Guitar - Pop Version",
                                  "Teardrops On My Guitar (Pop Version)")) |>
  # edits for Fearless
  mutate(track_name = str_replace_all(track_name,
                                      "Forever & Always - Piano Version",
                                      "Forever & Always (Piano Version)"),
         track_name = str_replace_all(track_name, "Superstar", "SuperStar")) |>
  # edits for Fearless (Taylor's Version)
  mutate(track_name = str_replace(track_name,
                                  "\\ \\([f|F]eat\\.\\ [^\\(\\)]*\\)",
                                  ""),
         track_name = str_replace_all(track_name,
                                      "(?<=\\)\\ )\\(Taylor's Version\\)",
                                      "[Taylor's Version]"),
         track_name = str_replace_all(track_name, fixed("(From The Vault)"),
                                      "[From The Vault]")) |>
  # edits for Red
  mutate(track_name = str_replace_all(track_name, "Come Back...Be Here",
                                      "Come Back... Be Here"),
         track_name = str_replace_all(track_name, " - Original Demo Recording",
                                      " (Original Demo Recording)"),
         track_name = str_replace_all(track_name, " - Acoustic Version",
                                      " (Acoustic Version)")) |>
  # edits for Lover
  mutate(track_name = str_replace_all(track_name, "Me!", "ME!")) |>
  # edits for folklore
  mutate(track_name = str_replace_all(track_name, " - bonus track", "")) |>
  # edits for evermore
  mutate(track_name = str_replace_all(track_name, "‘", "'")) |>
  # export data for joining
  write_csv(here("data-raw", "spotify-data.csv")) |>
  nest(spotify = -c(album_name, track_name))


# QC for data ------------------------------------------------------------------
# Ideally should return 0 rows. 7 rows currently expected:
# 1-6 Beautiful Eyes is not currently available on Spotify or any service
# 7 American Girl is exclusive to Napster
(missing <- base_info |>
   left_join(spotify_join, by = c("album_name", "track_name")) |>
   filter(map_lgl(spotify, is.null)) |>
   select(album_name, track_name))

# Check for tracks with multiple records. Should be 0 rows.
(dups <- spotify_join |>
  mutate(rows = map_int(spotify, nrow)) |>
  filter(rows > 1))

# Check for songs in Spotify that are not in base_info
(extra <- spotify_join |>
  anti_join(base_info, by = c("album_name", "track_name")))


# Write data files -------------------------------------------------------------
tswift_all_songs <- base_info |>
  left_join(spotify_join, by = c("album_name", "track_name")) |>
  relocate(spotify, .before = lyrics) |>
  unnest(spotify, keep_empty = TRUE) |>
  group_by(album_name) |>
  mutate(album_release = min(album_release)) |>
  ungroup() |>
  mutate(bonus_track = case_when(is.na(album_name) ~ NA,
                                 TRUE ~ bonus_track))

tswift_album_songs <- tswift_all_songs |>
  filter(album_name %in% c("Taylor Swift", "Fearless (Taylor's Version)",
                           "Speak Now", "Red", "1989", "reputation", "Lover",
                           "folklore", "evermore"))

tswift_albums <- tswift_all_songs |>
  distinct(album_name, ep, album_release) |>
  filter(!is.na(album_name)) |>
  arrange(album_release)

use_data(tswift_all_songs, tswift_album_songs, tswift_albums, overwrite = TRUE)
