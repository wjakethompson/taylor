# Spotify track information

Access the Spotify API to get metadata for audio tracks.

## Usage

``` r
get_spotify_track_info(track_id, api_key = get_spotify_access_token())
```

## Arguments

- track_id:

  The Spotify ID for a track.

- api_key:

  A Spotify access token, from
  [`get_spotify_access_token()`](https://taylor.wjakethompson.com/reference/spotify-api.md).

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with track metadata, including:

- `album_name`: The name of the album the track appears on (if
  relevant).

- `track_name`: The name of the track.

- `artist`: The artist of the track.

- `featuring`: The artist(s) featured on the track (if relevant).

- `duration_ms`: Duration of the track in milliseconds.

- `explicit`: Logical. Does the track contain explicit lyrics (`TRUE`)
  or not (`FALSE`).

## See also

Other API access:
[`get_reccobeats_audio_features()`](https://taylor.wjakethompson.com/reference/get_reccobeats_audio_features.md),
[`get_soundstat_audio_features()`](https://taylor.wjakethompson.com/reference/get_soundstat_audio_features.md)

## Examples

``` r
# So High School
get_spotify_track_info(track_id = "7Mts0OfPorF4iwOomvfqn1")
#> # A tibble: 1 × 5
#>   artist       featuring spotify_album                      duration_ms explicit
#>   <chr>        <chr>     <chr>                                    <int> <lgl>   
#> 1 Taylor Swift NA        THE TORTURED POETS DEPARTMENT: TH…      228800 FALSE   
```
