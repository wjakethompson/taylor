# Taylor Swift colour scale for album comparisons

A convenience wrapper for comparing albums with color. In contrast to
[`scale_fill_taylor_d()`](https://taylor.wjakethompson.com/reference/scale_taylor.md)
and
[`scale_colour_taylor_d()`](https://taylor.wjakethompson.com/reference/scale_taylor.md),
`scale_fill_albums()` and `scale_colour_albums()` use a single palette,
with one color per album. Specifically, the
[`album_compare`](https://taylor.wjakethompson.com/reference/album_palettes.md)
palette is used to apply a color associated with each album.

## Usage

``` r
scale_fill_albums(
  ...,
  aesthetics = "fill",
  breaks = waiver(),
  limits = force,
  na.value = NA
)

scale_colour_albums(
  ...,
  aesthetics = "colour",
  breaks = waiver(),
  limits = force,
  na.value = NA
)

scale_color_albums(
  ...,
  aesthetics = "colour",
  breaks = waiver(),
  limits = force,
  na.value = NA
)
```

## Arguments

- ...:

  Other arguments to be passed to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)

- aesthetics:

  The names of the aesthetics that this scale works with.

- breaks:

  One of:

  - `NULL` for no breaks

  - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
    for the default breaks (the scale limits)

  - A character vector of breaks

  - A function that takes the limits as input and returns breaks as
    output. Also accepts rlang
    [lambda](https://rlang.r-lib.org/reference/as_function.html)
    function notation.

- limits:

  One of:

  - `NULL` to use the default scale values

  - A character vector that defines possible values of the scale and
    their order

  - A function that accepts the existing (automatic) values and returns
    new ones. Also accepts rlang
    [lambda](https://rlang.r-lib.org/reference/as_function.html)
    function notation.

- na.value:

  If `na.translate = TRUE`, what aesthetic value should the missing
  values be displayed as? Does not apply to position scales where `NA`
  is always placed at the far right.

## Value

A color scale for use in plots created with
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

## Examples

``` r
library(ggplot2)
studio <- subset(taylor_albums, !is.na(metacritic_score))

# create a plot that we want to color or fill by album
ggplot(studio, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name))


# apply a color inspired by each album cover
ggplot(studio, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name)) +
  scale_fill_albums()


# even when the axis or levels are rearranged, the correct color is applied
studio$album_name <- factor(studio$album_name, levels = album_levels)
ggplot(studio, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name)) +
  scale_fill_albums()
```
