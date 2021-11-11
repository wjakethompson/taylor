# taylor (development version)

## Breaking changes

* The `type` argument of `color_palette()` is deprecated and will be removed in
  a future release. Previously, if you wanted to interpolate more colors between
  those originally specified, you needed to specify `type = "continuous"`. This
  was misleading, because `color_palette()` still returned a discrete number of
  colors (`n`). Now, interpolation happens automatically if `n` is greater than
  `length(pal)`.
  
  ```r
  my_colors <- c(ku_blue = "#0051ba", "firebrick", "#ffc82d")
  my_palette <- color_palette(my_colors)
  
  # old
  color_palette(my_palette, n = 10, type = "continuous")
  color_palette(my_palette, n = 2, type = "discrete")
  
  # new
  color_palette(my_palette, n = 10)
  color_palette(my_palette, n = 2)
  ```

## Minor improvements and fixes

* Fix the majority of non-ASCII characters in song lyrics. Remaining characters
  are en/em dashes and letters with accent marks.

* `color_palette()` now preserves color names, either through R color
  specifications (i.e., `colors()`) or a named vector supplied to `pal` (#12).
  
  ```r
  my_colors <- c(ku_blue = "#0051ba", "firebrick", "#ffc82d")
  color_palette(my_colors)
  ```

# taylor 0.2.1

* Added "Birch" from Big Red Machine's *How Long Do You Think It's Gonna Last?*
  to `taylor_all_songs`.

* Updated tests for the upcoming release of testthat (@hadley, #10).

# taylor 0.2.0

* Added a `NEWS.md` file to track changes to the package.
