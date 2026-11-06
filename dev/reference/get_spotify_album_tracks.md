# Spotify album information

Access the Spotify API to get a track listing for an album.

## Usage

``` r
get_spotify_album_tracks(album_id, api_key = get_spotify_access_token())
```

## Arguments

- album_id:

  The Spotify ID for an album.

- api_key:

  A Spotify access token, from
  [`get_spotify_access_token()`](https://taylor.wjakethompson.com/dev/reference/spotify-api.md).

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with containing the track listing with 1 row per track:

- `track_name`: The name of the track.

- `track_uri`: The Spotify track ID.

## See also

Other API access:
[`get_reccobeats_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_reccobeats_audio_features.md),
[`get_soundstat_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_soundstat_audio_features.md),
[`get_spotify_track_info()`](https://taylor.wjakethompson.com/dev/reference/get_spotify_track_info.md)

## Examples

``` r
# 1989 (Taylor's Version)
get_spotify_album_tracks(album_id = "1o59UpKw81iHR0HPiSkJR0")
#> # A tibble: 22 × 2
#>    track_name                                    track_uri             
#>    <chr>                                         <chr>                 
#>  1 Welcome To New York (Taylor's Version)        4WUepByoeqcedHoYhSNHRt
#>  2 Blank Space (Taylor's Version)                0108kcWLnn2HlH2kedi1gn
#>  3 Style (Taylor's Version)                      3Vpk1hfMAQme8VJ0SNRSkd
#>  4 Out Of The Woods (Taylor's Version)           1OcSfkeCg9hRC2sFKB4IMJ
#>  5 All You Had To Do Was Stay (Taylor's Version) 2k0ZEeAqzvYMcx9Qt5aClQ
#>  6 Shake It Off (Taylor's Version)               50yNTF0Od55qnHLxYsA5Pw
#>  7 I Wish You Would (Taylor's Version)           3FxJDucHWdw6caWTKO5b23
#>  8 Bad Blood (Taylor's Version)                  7oZONwFiFIErZcXAtTu7FY
#>  9 Wildest Dreams (Taylor's Version)             27exgla7YBw9DUNNcTIpjy
#> 10 How You Get The Girl (Taylor's Version)       733OhaXQIHY7BKtY3vnSkn
#> # ℹ 12 more rows
```
