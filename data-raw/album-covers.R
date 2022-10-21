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
  "Red (Taylor's Version)",      "6kZ42qRrzov54LcAk4onW9",
  "1989",                        "2QJmrSgbdM35R67eoGQo4j",
  "reputation",                  "6DEjYFkNZh67HP7R9PSZvv",
  "Lover",                       "1NAmidJlEaVgA3MpcPFYGq",
  "folklore",                    "2fenSS68JI1h4Fo296JfGr",
  "evermore",                    "2Xoteh7uEpea4TohMxjtaq",
  "Midnights",                   "151w1FgRZfnKZA9FEcg9Z3"
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

codes <- c("#B8396B", "#8C4F66", "#FFF5CC", "#76BAE0", "#EBBED3")
scales::show_col(codes)

new_codes <- purrr::map_dfr(codes, function(x) {
  col2rgb(x) |>
    tibble::as_tibble(.name_repair = ~"value", rownames = "color") |>
    tidyr::pivot_wider(names_from = color, values_from = value) |>
    dplyr::mutate(hex = x, .before = 1)
}) |>
  dplyr::arrange(red, green, blue) |>
  dplyr::pull(hex)

scales::show_col(new_codes)

dput(new_codes)
