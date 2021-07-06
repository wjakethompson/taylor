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
      slice_max(order_by = height, n = 1) |>
      pull(url)
    save_name <- str_to_lower(album_name) |>
      str_replace_all("\\(taylor's version\\)", "tv") |>
      str_replace_all("\\ ", "-")
    download.file(cover, here("inst", "album-covers", glue("{save_name}.jpeg")))
  })


# Palette sorter ---------------------------------------------------------------
library(tidyverse)

codes <- c("#1D111B", "#8E4272", "#CB9DCD", "#F2DFD1", "#803F2D")
scales::show_col(codes)

new_codes <- map_dfr(codes, function(x) {
  col2rgb(x) |>
    as_tibble(.name_repair = ~"value", rownames = "color") |>
    pivot_wider(names_from = color, values_from = value) |>
    mutate(hex = x, .before = 1)
}) |>
  arrange(red, green, blue) |>
  pull(hex)

scales::show_col(new_codes)

dput(new_codes)
