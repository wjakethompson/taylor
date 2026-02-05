# Package index

## Data sets

- [`taylor_all_songs`](https://taylor.wjakethompson.com/dev/reference/taylor_songs.md)
  [`taylor_album_songs`](https://taylor.wjakethompson.com/dev/reference/taylor_songs.md)
  : Data for Taylor Swift songs
- [`taylor_albums`](https://taylor.wjakethompson.com/dev/reference/taylor_albums.md)
  : Data for Taylor Swift's studio albums and EPs
- [`eras_tour_surprise`](https://taylor.wjakethompson.com/dev/reference/eras_tour_surprise.md)
  : The Eras Tour Surprise Songs

## Plotting

### Color palettes

The color palettes can be used to create custom color palettes, which
can then be used in plots. Also included are some pre-made color
palettes based on Taylor Swift’s album covers. To see these functions in
action, see
[`vignette("palettes")`](https://taylor.wjakethompson.com/dev/articles/palettes.md).

- [`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
  [`is_color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
  : Create a custom color palette
- [`album_palettes`](https://taylor.wjakethompson.com/dev/reference/album_palettes.md)
  [`album_compare`](https://taylor.wjakethompson.com/dev/reference/album_palettes.md)
  : Color palettes based on Taylor Swift's albums

### ggplot2 scales

Color scales functions can be used to easily give plots made with
ggplot2 a Taylor Swift theme. These functions use the color palettes
based on Taylor Swift’s album covers to give an album-based theme to
plot objects. For example usage, see
[`vignette("plotting")`](https://taylor.wjakethompson.com/dev/articles/plotting.md).

- [`scale_fill_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
  [`scale_colour_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
  [`scale_color_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
  : Taylor Swift colour scale for album comparisons
- [`scale_colour_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_color_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_fill_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_colour_taylor_c()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_color_taylor_c()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_fill_taylor_c()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_colour_taylor_b()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_color_taylor_b()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  [`scale_fill_taylor_b()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  : Taylor Swift colour scales based on album cover palettes

## Helpers

- [`album_levels`](https://taylor.wjakethompson.com/dev/reference/album_levels.md)
  : Correct ordering of Taylor Swift's albums
- [`title_case()`](https://taylor.wjakethompson.com/dev/reference/title_case.md)
  : Convert string to title case

## Audio API access

- [`get_soundstat_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_soundstat_audio_features.md)
  : SoundStat audio features
- [`get_soundstat_api_key()`](https://taylor.wjakethompson.com/dev/reference/soundstat-api.md)
  [`set_soundstat_api_key()`](https://taylor.wjakethompson.com/dev/reference/soundstat-api.md)
  : SoundStat API helpers
- [`get_spotify_access_token()`](https://taylor.wjakethompson.com/dev/reference/spotify-api.md)
  [`set_spotify_api_key()`](https://taylor.wjakethompson.com/dev/reference/spotify-api.md)
  : Spotify API helpers
- [`get_spotify_track_info()`](https://taylor.wjakethompson.com/dev/reference/get_spotify_track_info.md)
  : Spotify track information
- [`get_reccobeats_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_reccobeats_audio_features.md)
  : Reccobeats audio features
- [`taylor_sitrep()`](https://taylor.wjakethompson.com/dev/reference/taylor_sitrep.md)
  : Situation report for APIs

## Miscellaneous

- [`translate_bracelet()`](https://taylor.wjakethompson.com/dev/reference/translate_bracelet.md)
  : Translate a friendship bracelet
