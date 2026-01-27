# The Eras Tour Surprise Songs

A data set containing all of the surprise songs played on The Eras Tour
through the first North American leg of the tour.

## Usage

``` r
eras_tour_surprise
```

## Format

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with 298 rows and 9 variables:

- `leg`: The leg of the tour (e.g., North America, South America, etc.).

- `date`: The date of the show in ISO 8601 format (yyyy-mm-dd).

- `city`: The location of the show. For US shows, the location is the
  city and state. For international shows, the location is the city and
  country.

- `night`: The show number within each city.

- `dress`: The color of the dress Taylor wore on the given night.

- `instrument`: The instrument used to play the song (guitar or piano).

- `song`: The track name of the primary surprise song.

- `mashup`: Additional songs included in a mashup with the primary song.

- `guest`: The special guest (if any) that joined Taylor to play the
  song.
