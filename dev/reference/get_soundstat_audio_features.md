# SoundStat audio features

Access the SoundStat API to get audio features for tracks.

## Usage

``` r
get_soundstat_audio_features(
  track_id,
  convert_values = FALSE,
  api_key = get_soundstat_api_key()
)
```

## Arguments

- track_id:

  The Spotify ID for a track.

- convert_values:

  Logical. For SoundStat features, should audio features be converted to
  the Spotify scale. See details for conversion formulas.

- api_key:

  A SoundStat API key, e.g.,
  [`get_soundstat_api_key()`](https://taylor.wjakethompson.com/dev/reference/soundstat-api.md).

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with track audio features, including:

- `danceability`: Danceability score (0-1).

- `energy`: Energy level (0-1).

- `loudness`: Loudness level (0-1).

- `acousticness`: Acousticness score (0-1).

- `instrumentalness`: Instrumentalness score (0-1).

- `valence`: Mood/positiveness (0-1).

- `tempo`: Track tempo in beats per minute (BPM).

- `key`: Track key (0-11).

- `mode`: Mode (0 - minor, 1 - major).

- `key_name`: Corresponds directly to the key, but the integer is
  converted to the key name using Pitch Class notation (e.g., 0 becomes
  `C`).

- `mode_name`: Corresponds directly to the mode, but the integer is
  converted to the mode name (e.g., 0 becomes `minor`).

- `key_mode`: A combination of the `key_name` and `mode_name` variables
  (e.g., `C minor`).

## Details

Due to differences in algorithms and methodologies, the SoundStat audio
features are on a slightly different scale than the Spotify audio
features that were originally included in
[taylor](https://taylor.wjakethompson.com/dev/reference/taylor-package.md)
prior the [changes to the
SpotifyAPI](https://taylor.wjakethompson.com/dev/reference/changes%20to%20the%20SpotifyAPI).
We can convert the SoundStat values to the Spotify scale using the
formulas in the [SoundStat
docs](https://soundstat.info/article/Understanding-Audio-Analysis.html):

    acousticness = sound_value * 0.005
    energy = sound_value * 2.25
    instrumentalness = sound_value * 0.03
    loudness = -(1 - sound_value) * 14

To automatically perform these conversions, set `convert_values = TRUE`.

## See also

Other API access:
[`get_reccobeats_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_reccobeats_audio_features.md),
[`get_spotify_track_info()`](https://taylor.wjakethompson.com/dev/reference/get_spotify_track_info.md)

## Examples

``` r
get_soundstat_audio_features(track_id = "7Mts0OfPorF4iwOomvfqn1")
#> Error in get_soundstat_api_key(): No API key found, please supply with `api_key` argument or with the
#> `SOUNDSTAT_KEY` env var (`?get_soundstat_api_key()`)
```
