library(tidyverse)
library(spotifyr)
library(here)
library(glue)
library(fs)


tribble(
  ~album_name,                   ~album_uri,
  "Taylor Swift",                "7mzrIsaAjnXihW3InKjlC3",
  "Fearless",                    "2dqn5yOQWdyGwOpOIi9O4x",
  "Fearless (Taylor's Version)", "4hDok0OAJd57SGIT8xuWJH",
  "Speak Now",                   "5MfAxS5zz8MlfROjGQVXhy",
  "Red",                         "1EoDsNmgTLtmwe1BDAVxV5",
  "1989",                        "2QJmrSgbdM35R67eoGQo4j",
  "reputation",                  "6DEjYFkNZh67HP7R9PSZvv",
  "Lover",                       "1NAmidJlEaVgA3MpcPFYGq",
  "folklore",                    "2fenSS68JI1h4Fo296JfGr",
  "evermore",                    "2Xoteh7uEpea4TohMxjtaq"
) |>
  pwalk(function(album_name, album_uri) {
    album <- get_album(album_uri)
    cover <- album$images |>
      slice_max(order_by = height, n = 1) %>%
      pull(url)
    save_name <- str_to_lower(album_name) |>
      str_replace_all("\\(taylor's version\\)", "tv") |>
      str_replace_all("\\ ", "-")
    download.file(cover, here("inst", "album-covers", glue("{save_name}.jpeg")))
  })
