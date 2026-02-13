# Data for Taylor Swift's studio albums and EPs

A data set containing the names of Taylor's official releases, the album
type, and release date.

## Usage

``` r
taylor_albums
```

## Format

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with 18 rows and 5 variables:

- `album_name`: The name of the album. `NA` if the song was released
  separately from one of Taylor's studio albums or EPs.

- `ep`: Logical. Is the album a full studio album (`FALSE`) or an
  extended play (`TRUE`).

- `album_release`: The date the album was released, in the ISO-8601
  format (YYYY-MM-DD).

- `metacritic_score`: The official album rating from metacritic.

- `user_score`: The user rating from metacritic.

## Source

<https://en.wikipedia.org/wiki/Taylor_Swift_albums_discography>

<https://www.metacritic.com/person/taylor-swift>

## Details

This data set includes all official studio albums and EPs with new
tracks. This means that compilations or EPs that are a subset of the
original albums are not included (e.g., *folklore: the escapism
chapter*, *folklore: the sleepless nights chapter*, etc.)
