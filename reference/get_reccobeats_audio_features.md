# Reccobeats audio features

Access the Reccobeats API to get audio features for tracks.

## Usage

``` r
get_reccobeats_audio_features(track_id)
```

## Arguments

- track_id:

  The Spotify ID for a track.

## Value

- `get_reccobeats_audio_features()` returns a
  [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
  with track audio features, including:

  - `danceability`: Suitability for dancing (0.0 to 1.0). Higher values
    indicate more rhythmically engaging tracks.

  - `energy`: Intensity and liveliness (0.0 to 1.0). Higher values
    indicate more energetic tracks.

  - `loudness`: Average loudness in decibels (dB). Typically ranges
    between -60 and 0 dB.

  - `speechiness`: Presence of spoken words (0.0 to 1.0). Values above
    0.66 indicate mostly speech.

  - `acousticness`: Confidence (0.0 to 1.0) that the track is acoustic.
    Higher values indicate more natural sounds.

  - `instrumentalness`: Likelihood of no vocals (0.0 to 1.0). Values
    above 0.5 suggest instrumental tracks.

  - `liveness`: Probability of a live audience (0.0 to 1.0). Values
    above 0.8 strongly suggest a live track.

  - `valence`: Emotional tone (0.0 to 1.0). Higher values indicate a
    happier mood, lower values a sadder one.

  - `tempo`: Estimated tempo in beats per minute (BPM). Typically ranges
    between 0 and 250.

  - `key`: The key the track is in. Integers map to pitches using
    standard Pitch Class notation. If no key was detected, the value is
    -1.

  - `mode`: Mode indicates the modality (major or minor) of a track.
    Major is represented by 1 and minor is 0.

  - `key_name`: Corresponds directly to the key, but the integer is
    converted to the key name using Pitch Class notation (e.g., 0
    becomes `C`).

  - `mode_name`: Corresponds directly to the mode, but the integer is
    converted to the mode name (e.g., 0 becomes `minor`).

  - `key_mode`: A combination of the `key_name` and `mode_name`
    variables (e.g., `C minor`).

## See also

Other API access:
[`get_soundstat_audio_features()`](https://taylor.wjakethompson.com/reference/get_soundstat_audio_features.md),
[`get_spotify_track_info()`](https://taylor.wjakethompson.com/reference/get_spotify_track_info.md)

## Examples

``` r
# So High School
get_reccobeats_audio_features(track_id = "7Mts0OfPorF4iwOomvfqn1")
#> # A tibble: 1 × 14
#>   danceability energy loudness speechiness acousticness instrumentalness
#>          <dbl>  <dbl>    <dbl>       <dbl>        <dbl>            <dbl>
#> 1        0.366  0.866    -4.51      0.0466       0.0274       0.00000307
#> # ℹ 8 more variables: liveness <dbl>, valence <dbl>, tempo <dbl>, key <int>,
#> #   mode <int>, key_name <chr>, mode_name <chr>, key_mode <chr>
```
