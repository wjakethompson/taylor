library(tidyverse)
library(spotifyr)
library(stringi)
library(readxl)
library(here)
library(fs)

release_dates <- read_xlsx(here("data-raw", "releases.xlsx"),
                           col_types = c("text", "text", "date", "date")) %>%
  mutate(promotional_release = lubridate::ymd(promotional_release),
         release_date = lubridate::ymd(release_date))

albums <- release_dates %>%
  filter(is.na(track_name)) %>%
  rename(album_release = release_date) %>%
  mutate(ep = album_name %in% c("The Taylor Swift Holiday Collection",
                                "Beautiful Eyes")) %>%
  select(album_name, ep, album_release)

singles <- release_dates %>%
  filter(!is.na(track_name)) %>%
  rename(single_release = release_date) %>%
  select(album_name, track_name, promotional_release, single_release)

lyrics <- dir_ls(here("data-raw", "lyrics"), type = "file", recurse = TRUE) %>%
  as_tibble() %>%
  mutate(album = path_file(path_dir(value)),
         track = path_file(value)) %>%
  separate(album, c(NA, "album_name"), sep = "_", fill = "left") %>%
  separate(track, c("track_number", "track_name"), sep = "_", convert = TRUE,
           fill = "left") %>%
  mutate(lyrics = map(value,
                      function(.x) {
                        read_lines(.x) %>%
                          as_tibble() %>%
                          mutate(
                            element = str_extract(value, "(?<=^\\[).*(?=\\]$)")
                          ) %>%
                          separate(element, c("element", "element_artist"),
                                   sep = ": ", fill = "right") %>%
                          replace_na(list(element_artist = "Taylor Swift")) %>%
                          fill(element, element_artist) %>%
                          filter(value != "",
                                 !str_detect(value, "^\\[.*\\]$")) %>%
                          rowid_to_column("line") %>%
                          select(line, lyric = value, element,
                                 element_artist) %>%
                          mutate(lyric = str_replace_all(lyric, "’", "'"),
                                 lyric = str_replace_all(lyric, "‘", "'"),
                                 lyric = str_replace_all(lyric, "…", "..."),
                                 lyric = str_replace_all(lyric, "е", "e"),
                                 lyric = str_replace_all(lyric, " ", " "),
                                 lyric = str_replace_all(lyric, " ", " "),
                                 lyric = str_replace_all(lyric, "​", ""),
                                 lyric = str_replace_all(lyric, "”", "\""),
                                 lyric = str_replace_all(lyric, "“", "\""))
                      }))

base_info <- lyrics %>%
  mutate(bonus_track = str_detect(album_name, "deluxe|platinum|3am|target")) %>%
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
      album_name == "Midnights 3am Edition" ~ "Midnights (3am Edition)",
      album_name == "Midnights Target Exclusive" ~
        "Midnights (Target Exclusive)",
      TRUE ~ album_name
    ),
    album_name = na_if(album_name, "Non Album"),
    album_name = na_if(album_name, "Features")) %>%
  left_join(albums, by = "album_name") %>%
  select(album_name, ep, album_release, track_number, track_name, bonus_track,
         lyrics) %>%
  # standard file name changes
  mutate(track_name = path_ext_remove(track_name),
         track_name = str_replace_all(track_name, "-", " "),
         track_name = case_when(str_detect(album_name, "folklore|evermore") ~
                                  str_to_lower(track_name),
                                TRUE ~ str_to_title(track_name))) %>%
  # edits for Taylor Swift
  mutate(track_name = str_replace_all(track_name, "Mcgraw", "McGraw"),
         track_name = str_replace_all(track_name, "Shouldve", "Should've"),
         track_name = str_replace_all(track_name, "Marys Song",
                                      "Mary's Song (Oh My My My)"),
         track_name = str_replace_all(track_name, "Im", "I'm"),
         track_name = str_replace_all(track_name, "Popv", "(Pop Version)")) %>%
  # edits for Beautiful Eyes
  mutate(track_name = str_replace_all(track_name, "Altv",
                                      "(Alternate Version)"),
         track_name = str_replace_all(track_name, "Acousticv",
                                      "(Acoustic Version)"),
         track_name = str_replace_all(track_name, "Radioe", "(Radio Edit)"),
         track_name = str_replace_all(track_name, "I Heart", "I Heart ?")) %>%
  # edits for Fearless
  mutate(track_name = str_replace_all(track_name, "Youre", "You're"),
         track_name = str_replace_all(track_name, " N ", " & "),
         track_name = str_replace_all(track_name, "Pianov", "(Piano Version)"),
         track_name = str_replace_all(track_name, "Superstar", "SuperStar")) %>%
  # edits for Red
  mutate(track_name = str_replace_all(track_name, "I Knew You Were Trouble",
                                      "I Knew You Were Trouble"),
         track_name = str_replace_all(track_name, "Come Back Be Here",
                                      "Come Back...Be Here"),
         track_name = str_replace_all(track_name, "Odr",
                                      "(Original Demo Recording)")) %>%
  # edits for reputation
  mutate(track_name = str_replace_all(track_name, "Ready For It",
                                      "...Ready For It?"),
         track_name = str_replace_all(track_name, "New Years Day",
                                      "New Year's Day"),
         track_name = str_replace_all(track_name, "So It Goes",
                                      "So It Goes..."),
         track_name = str_replace_all(track_name, "Dont", "Don't"),
         track_name = str_replace_all(track_name, "Cant", "Can't")) %>%
  # edits for Lover
  mutate(track_name = str_replace_all(track_name, "Youll", "You'll"),
         track_name = str_replace_all(track_name, "^Me$", "ME!"),
         track_name = str_replace_all(track_name, "Its Nice", "It's Nice")) %>%
  # edits for evermore
  mutate(track_name = str_replace_all(track_name, "its time", "it's time"),
         track_name = str_replace_all(track_name, "tis the damn",
                                      "'tis the damn"),
         track_name = str_replace_all(track_name, "no body no crime",
                                      "no body, no crime")) %>%
  # edits for Fearless (Taylor's Version)
  mutate(track_name = str_replace_all(track_name, "^Mr ", "Mr. "),
         track_name = str_replace_all(track_name, "^Thats ", "That's ")) %>%
  # edits for Red (Taylor's Version)
  mutate(
    track_name = str_replace_all(track_name, "10mv", "(10 Minute Version)")
    ) %>%
  # edits for midnights
  mutate(track_name = str_replace_all(track_name, "Anti Hero", "Anti-Hero"),
         track_name = str_replace_all(track_name, "Youre", "You're"),
         track_name = str_replace_all(track_name, "You're On Your Own Kid",
                                      "You're On Your Own, Kid"),
         track_name = str_replace_all(track_name, "Question", "Question...?"),
         track_name = str_replace_all(track_name, "Wouldve", "Would've"),
         track_name = str_replace_all(track_name, "Couldve", "Could've"),
         track_name = str_replace_all(track_name, "Would've Could've Should've",
                                      "Would've, Could've, Should've"),
         track_name = str_replace_all(track_name, "Stringrmx",
                                      "(Strings Remix)"),
         track_name = str_replace_all(track_name, "Pianormx",
                                      "(Piano Remix)")) %>%
  # edits for general Taylor's Version and vault tracks
  mutate(track_name = str_replace_all(track_name, "(?<=\\)\\ )Tv",
                                      "[Taylor's Version]"),
         track_name = str_replace_all(track_name, "Tv Ftv",
                                      "(Taylor's Version) [From The Vault]"),
         track_name = str_replace_all(track_name, "(?<=\\)\\ )Tv",
                                      "[Taylor's Version]"),
         track_name = str_replace_all(track_name, "Tv",
                                      "(Taylor's Version)"),
         track_name = str_replace_all(track_name, "Ftv",
                                      "[From The Vault]")) %>%
  # edits for singles
  mutate(track_name = str_replace_all(track_name, "Rmx", "(Remix)")) %>%
  left_join(singles, by = c("album_name", "track_name")) %>%
  rowwise() %>%
  mutate(track_release = min(album_release, promotional_release, single_release,
                             na.rm = TRUE)) %>%
  ungroup() %>%
  # set up album names for Spotify
  mutate(album_name = case_when(
    album_name == "Taylor Swift (Deluxe)" ~ "Taylor Swift",
    album_name == "Fearless (Platinum Edition)" ~ "Fearless",
    album_name == "Speak Now (Deluxe)" ~ "Speak Now",
    album_name == "Red (Deluxe Edition)" ~ "Red",
    album_name == "1989 (Deluxe)" ~ "1989",
    album_name == "folklore (deluxe edition)" ~ "folklore",
    album_name == "evermore (deluxe edition)" ~ "evermore",
    album_name == "Midnights (3am Edition)" ~ "Midnights",
    album_name == "Midnights (Target Exclusive)" ~ "Midnights",
    TRUE ~ album_name
  )) %>%
  select(album_name, ep, album_release, track_number, track_name, bonus_track,
         promotional_release, single_release, track_release, lyrics)


# Get Spotify information ------------------------------------------------------
access_token <- get_spotify_access_token()

key_lookup <- tibble(key = 0:11,
                     key_name = c("C", "C#", "D", "D#", "E", "F", "F#", "G",
                                  "G#", "A", "A#", "B"))

single_uri <- tribble(
  ~track_name,                         ~track_uri,
  "American Girl",                     "",
  "Bad Blood (Remix)",                 "6xsEAm6w9oMQYYg3jkEkMT",
  "Beautiful Ghosts",                  "2evEoQAhIMaa9PfjTT5skG",
  "Carolina",                          "4axSuOg3BqsowKjRpj59RU",
  "Christmas Tree Farm",               "2mvabkN1i2gLnGAPUVdwek",
  "Crazier",                           "5vyxXfD5gLlyPxGZMEjtmd",
  "Eyes Open",                         "6KEemo78n0RnCQWKkeOdXz",
  "I Don't Wanna Live Forever",        "2y5aJvzXhHPA94U5GFAcXe",
  "Lover (Remix)",                     "3i9UVldZOE0aD0JnyfAZZ0",
  "Only The Young",                    "2slqvGLwzZZYsT4K4Y1GBC",
  "Ronan",                             "0Nw8hv79MLJa1yjtsEgz08",
  "Safe & Sound",                      "0z9UVN8VBHJ9HdfYsOuuNf",
  "September",                         "5eGX87IiKsGuzS3iw4CfCX",
  "Sweeter Than Fiction",              "0RFCHlNuTeUHIB36VuVbOL",
  "This Love (Taylor's Version)",      "4d1CG5ei1E2vGbvmgf5KKv",
  "Today Was A Fairytale",             "4pFvEWbjBpPUdYRQly0THs",
  "Wildest Dreams (Taylor's Version)", "1Ov37jtRQ2YNAe8HzfczkL"
)

feature_uri <- tribble(
  ~track_name,                  ~track_uri,
  "Babe",                       "7FFfYM4JE1vj5n4rhHxg8q",
  "Birch",                      "7wo2UNeQBowm28hfAJsEMz",
  "Both Of Us",                 "3r9bgSJlJz2zlevcBRYXko",
  "Gasoline (Remix)",           "645Exr2lJIO45Guht3qyIa",
  "Half Of My Heart",           "7hR5toSPEgwFZ78jfHdANM",
  "Highway Don't Care",         "4wFUdSCer8bdQsrp1M90sa",
  "Renegade",                   "1aU1wpYBSpP0M6IiihY5Ue",
  "Two Is Better Than One",     "1MaqkdFNIKPdpQGDzme5ss",
  "The Joker and the Queen",    "6N1K5OVVCopBjGViHs2IvP"
)

spotify <- tribble(
  ~album_name,                           ~album_uri,
  "Taylor Swift",                        "7mzrIsaAjnXihW3InKjlC3",
  "The Taylor Swift Holiday Collection", "7vzYp7FrKnTRoktBYsx9SF",
  "Fearless",                            "43OpbkiiIxJO8ktIB777Nn",
  "Fearless (Taylor's Version)",         "4hDok0OAJd57SGIT8xuWJH",
  "Speak Now",                           "5EpMjweRD573ASl7uNiHym",
  "Red",                                 "1KlU96Hw9nlvqpBPlSqcTV",
  "Red (Taylor's Version)",              "6kZ42qRrzov54LcAk4onW9",
  "1989",                                "34OkZVpuzBa9y40DCy0LPR",
  "reputation",                          "6DEjYFkNZh67HP7R9PSZvv",
  "Lover",                               "1NAmidJlEaVgA3MpcPFYGq",
  "folklore",                            "1pzvBxYgT6OVwJLtHkrdQK",
  "evermore",                            "6AORtDjduMM3bupSWzbTSG",
  "Midnights",                           "3lS1y25WAhcqJDATJK70Mq"
) %>%
  mutate(track = map(album_uri,
                     function(.x) {
                       album <- get_album(.x)

                       album$tracks$items %>%
                         as_tibble() %>%
                         select(track_name = name, track_uri = id)
                     })) %>%
  unnest(track) %>%
  bind_rows(single_uri, feature_uri) %>%
  mutate(spotify = map(track_uri,
                       function(.x, key_lookup) {
                         if (.x == "") return(NULL)
                         track <- get_track(.x)
                         feat <- get_track_audio_features(.x)

                         feat %>%
                           left_join(key_lookup, by = "key") %>%
                           mutate(explicit = track$explicit,
                                  mode_name = case_when(
                                    mode == 0L ~ "minor",
                                    mode == 1L ~ "major"
                                  ),
                                  key_mode = paste(key_name, mode_name)) %>%
                           select(danceability:tempo, time_signature,
                                  duration_ms, explicit, key_name,
                                  mode_name, key_mode) %>%
                           mutate(artist = paste(track$artists$name,
                                                 collapse = ", "),
                                  .before = 1) %>%
                           separate(artist, c("artist", "featuring"),
                                    sep = ", ", extra = "merge", fill = "right")
                       },
                       key_lookup = key_lookup)) %>%
  unnest(spotify)

spotify_join <- spotify %>%
  select(album_name, track_name, artist:tempo, time_signature,
         duration_ms, explicit, key_name, mode_name, key_mode) %>%
  # general formatting
  mutate(track_name = case_when(str_detect(album_name, "folklore|evermore") ~
                                  track_name,
                                TRUE ~ str_to_title(track_name)),
         track_name = str_replace_all(track_name, "’", "'")) %>%
  # edits for Taylor Swift
  mutate(track_name = str_replace_all(track_name, "Mcgraw", "McGraw"),
         track_name = str_replace(track_name,
                                  "Teardrops On My Guitar - Radio Single Remix",
                                  "Teardrops On My Guitar"),
         track_name = str_replace(track_name,
                                  "Teardrops On My Guitar - Pop Version",
                                  "Teardrops On My Guitar (Pop Version)")) %>%
  # edits for Fearless
  mutate(track_name = str_replace_all(track_name,
                                      "Forever & Always - Piano Version",
                                      "Forever & Always (Piano Version)"),
         track_name = str_replace_all(track_name, "Superstar", "SuperStar")) %>%
  # edits for Fearless (Taylor's Version)
  mutate(track_name = str_replace(track_name,
                                  "\\ \\([f|F]eat\\.\\ [^\\(\\)]*\\)",
                                  ""),
         track_name = str_replace_all(track_name,
                                      "(?<=\\)\\ )\\(Taylor's Version\\)",
                                      "[Taylor's Version]"),
         track_name = str_replace_all(track_name, fixed("(From The Vault)"),
                                      "[From The Vault]")) %>%
  # edits for Red
  mutate(track_name = str_replace_all(track_name, "I Knew You Were Trouble.",
                                      "I Knew You Were Trouble"),
         track_name = str_replace_all(track_name, " - Original Demo Recording",
                                      " (Original Demo Recording)"),
         track_name = str_replace_all(track_name, " - Acoustic Version",
                                      " (Acoustic Version)"),
         track_name = str_replace_all(track_name, " - Acoustic",
                                      " (Acoustic Version)")) %>%
  # edits for Lover
  mutate(track_name = str_replace_all(track_name, "Me!", "ME!")) %>%
  # edits for folklore
  mutate(track_name = str_replace_all(track_name, " - bonus track", "")) %>%
  # edits for evermore
  mutate(track_name = str_replace_all(track_name, "‘", "'")) %>%
  # edits for Red (Taylor's Version)
  mutate(
    track_name = str_replace_all(track_name, "Trouble\\(", "Trouble (")
    ) %>%
  # export data for joining
  write_csv(here("data-raw", "spotify-data.csv")) %>%
  nest(spotify = -c(album_name, track_name))


# QC for data ------------------------------------------------------------------
# Check for tracks missing from Spotify
# Ideally should return 0 rows. 11 rows currently expected:
# 1-3 Three Midnights bonus tracks exclusive to Target are not on Spotify
# 4-9 Beautiful Eyes is not currently available on Spotify or any service
# 10 American Girl is exclusive to Napster
# 11 Three Sad Virgins not available on Spotify
(missing <- base_info %>%
   left_join(spotify_join, by = c("album_name", "track_name")) %>%
   filter(map_lgl(spotify, is.null)) %>%
   select(album_name, track_name))

# Check for tracks with multiple records. Should be 0 rows.
(dups <- spotify_join %>%
  mutate(rows = map_int(spotify, nrow)) %>%
  filter(rows > 1))

# Check for songs in Spotify not in base_info. 6 rows currently expected:
# 1-3 Bonus tracks from Speak Now with no lyrics on Genius
# 4-6 Voice memos from 1989
(extra <- spotify_join %>%
  anti_join(base_info, by = c("album_name", "track_name")))

# Check for non-ASCII characters. 17 errors (4 rows) expected:
# 14 é
# 1 í
# 1 ï
# 1 ó
base_info %>%
  select(where(is.character), lyrics) %>%
  unnest(lyrics) %>%
  mutate(across(where(is.character), stringi::stri_enc_isascii,
                .names = "{.col}_ascii")) %>%
  filter(!if_all(ends_with("ascii"))) %>%
  select(album_name, track_name, line, lyric) %>%
  mutate(ascii_flag = map(lyric,
                          .f = function(.x) {
                            str_split(.x, "") %>%
                              flatten_chr() %>%
                              enframe() %>%
                              mutate(ascii = map_lgl(value,
                                                     stri_enc_isascii)) %>%
                              filter(!ascii) %>%
                              select(value, ascii)
  })) %>%
  unnest(ascii_flag) %>%
  count(value)


# Write data files -------------------------------------------------------------
taylor_all_songs <- base_info %>%
  left_join(spotify_join, by = c("album_name", "track_name")) %>%
  relocate(spotify, .before = lyrics) %>%
  unnest(spotify, keep_empty = TRUE) %>%
  group_by(album_name) %>%
  mutate(album_release = min(album_release)) %>%
  ungroup() %>%
  mutate(bonus_track = case_when(is.na(album_name) ~ NA,
                                 TRUE ~ bonus_track)) %>%
  relocate(artist, featuring, .after = track_name)

taylor_album_songs <- taylor_all_songs %>%
  filter(album_name %in% c("Taylor Swift", "Fearless (Taylor's Version)",
                           "Speak Now", "Red (Taylor's Version)", "1989",
                           "reputation", "Lover", "folklore", "evermore",
                           "Midnights"))

metacritic <- tribble(
  ~album_name,                           ~metacritic_score, ~user_score,
  "Midnights",                           85L,               8.3,
  "Red (Taylor's Version)",              91L,               9.0,
  "Fearless (Taylor's Version)",         82L,               8.9,
  "evermore",                            85L,               8.9,
  "folklore",                            88L,               9.0,
  "Lover",                               79L,               8.4,
  "reputation",                          71L,               8.3,
  "1989",                                76L,               8.2,
  "Red",                                 77L,               8.6,
  "Speak Now",                           77L,               8.7,
  "Fearless",                            73L,               8.4,
  "Taylor Swift",                        67L,               9.1
)

taylor_albums <- taylor_all_songs %>%
  distinct(album_name, ep, album_release) %>%
  filter(!is.na(album_name)) %>%
  left_join(metacritic, by = "album_name") %>%
  arrange(album_release)

use_data(taylor_all_songs, taylor_album_songs, taylor_albums, overwrite = TRUE)
