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
