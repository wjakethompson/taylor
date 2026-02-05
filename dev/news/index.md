# Changelog

## taylor (development version)

### Breaking changes

- `taylor_all_songs` and `taylor_album_songs` now use audio features
  from the [SoundStat API](https://soundstat.info) due to Spotify
  [removing
  access](https://developer.spotify.com/blog/2024-11-27-changes-to-the-web-api)
  to their audio features endpoint.
  - Lost columns: `liveness`, `speechiness`, `time_signature`.
  - Data may be slightly different due to differences between the
    Spotify and new SoundStat API
    ([conversions](https://soundstat.info/article/Understanding-Audio-Analysis.html)
    available if desired through the `convert_values` argument to
    [`get_soundstat_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_soundstat_audio_features.md)).
- *Fearless*, *Speak Now*, *Red*, and *1989* have been added back to
  `taylor_album_songs` now that Taylor [owns all of her
  masters](https://www.taylorswift.com/read-my-letter). Both the
  originals and Taylor’s Version’s are now included in the dataset.

### New features

#### New data

- New data and visualization tools have been added for *The Life of a
  Showgirl*.
  - Added lyrics and SoundState audio features to `taylor_all_songs` and
    `taylor_album_songs`.
  - Added composite critic score from Metacritic to `taylor_albums`.
  - Added a new themed color palette to `album_palettes`.
  - Added a new single color to `album_compare`.
- Two new songs added where Taylor is credited as a writer
  - “Bein’ With My Baby” from Shea Fisher’s *Shea*
  - “This Is Really Happening” from Britni Hoover’s *Country Strong*

#### API access

- [`get_spotify_track_info()`](https://taylor.wjakethompson.com/dev/reference/get_spotify_track_info.md)
  is now exported to use for gathering track metadata.

- [`get_soundstat_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_soundstat_audio_features.md)
  and
  [`get_reccobeats_audio_features()`](https://taylor.wjakethompson.com/dev/reference/get_reccobeats_audio_features.md)
  have been added to provide access to audio features through the
  [SoundStat](https://soundstat.info) and
  [ReccoBeats](https://reccobeats.com/) APIs, respectively.

- New helper functions for setting up API configuration.

  - [`set_spotify_api_key()`](https://taylor.wjakethompson.com/dev/reference/spotify-api.md)
    / `get_spotify_api_key()`
  - [`set_soundstat_api_key()`](https://taylor.wjakethompson.com/dev/reference/soundstat-api.md)
    /
    [`get_soundstat_api_key()`](https://taylor.wjakethompson.com/dev/reference/soundstat-api.md)

- [`taylor_sitrep()`](https://taylor.wjakethompson.com/dev/reference/taylor_sitrep.md)
  can be used to quickly check the configuration of API keys.

### Minor improvements and fixes

- [`scale_color_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
  and
  [`scale_fill_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
  now recognize alternate capitalization (e.g., *Folklore* instead of
  *folklore*) and common nicknames (e.g., *Debut* for *Taylor Swift*)
  when mapping `album_compare` to album names.

## taylor 3.2.0

CRAN release: 2025-01-07

### New features

- `taylor_all_songs` has been updated to include the new feature, “us.”,
  from Gracie Abrams’s *The Secret of Us*.

- `taylor_all_songs` has been updated to include songs for which Taylor
  has written (but didn’t record or feature on). This includes:

  - “1 step forward, 3 steps back” and “deja vu” from Olivia Rodrigo’s
    *SOUR*
  - “Best Days Of Your Life” from Kellie Pickler’s self-titled album
  - “Better Man” from Little Big Town’s *The Breaker*
  - “This is What You Came For” by Calvin Harris (feat. Rihanna)
  - “TMZ” from Weird Al Yankovic’s *Apocalypse*
  - “You’ll Always Find Your Way Back Home” from Miley Cyrus on the
    *Hannah Montana: The Movie* soundtrack

### Minor improvements and fixes

- Error messages have been improved display the function that was
  called, rather than function where the error appeared
  ([@olivroy](https://github.com/olivroy),
  [\#49](https://github.com/wjakethompson/taylor/issues/49)).

- Color palettes are now displayed using cli instead of crayon
  ([@olivroy](https://github.com/olivroy),
  [\#49](https://github.com/wjakethompson/taylor/issues/49)).

- Spotify data for John Mayer’s “Half Of My Heart,” has been removed, as
  the version featuring Taylor Swift is no longer available.

- `eras_tour_surprise` has been updated to include surprise songs from
  the European and final North American legs of the tour.

## taylor 3.1.0

CRAN release: 2024-05-08

### New features

- New data and visualization tools have been added for *THE TORTURED
  POETS DEPARTMENT*.

  - Added lyrics and Spotify audio features to `taylor_all_songs` and
    `taylor_album_songs`.
  - Added composite critic score from Metacritic to `taylor_albums`.
  - Added a new themed color palette to `album_palettes`.
  - Added a new single color to `album_compare`.

- Spotify data for “You’re Losing Me (From The Vault)” has been added.

- Surprise songs from the South American and Asia-Pacific legs of the
  tour have been added to `eras_tour_surprise`.

### Minor improvements and fixes

- Fixed installation instructions in README
  ([@scarioscia](https://github.com/scarioscia),
  [\#37](https://github.com/wjakethompson/taylor/issues/37)).

- Corrected non-ASCII characters in `data-raw/lyrics/`
  ([@ericwu17](https://github.com/ericwu17),
  [\#44](https://github.com/wjakethompson/taylor/issues/44),
  [\#45](https://github.com/wjakethompson/taylor/issues/45)).

- Updated documentation with additional vignettes.

  - [`vignette("taylor")`](https://taylor.wjakethompson.com/dev/articles/taylor.md)
    provides and overview of the package and links to example analyses.
  - `vigentte("lyrics")` describes different methods for accessing
    lyrics in a nested list column
    ([\#35](https://github.com/wjakethompson/taylor/issues/35)).

## taylor 3.0.0

CRAN release: 2023-11-06

### Breaking changes

- *Speak Now (Taylor’s Version)* has replaced *Speak Now* in
  `taylor_album_songs`
  ([\#25](https://github.com/wjakethompson/taylor/issues/25)).

- *1989 (Taylor’s Version)* has replaced *1989* in `taylor_album_songs`
  ([\#30](https://github.com/wjakethompson/taylor/issues/30)).

### New features

- A new data set, `eras_tour_surprise` has been added that includes
  information on all of the surprise songs played on the first North
  American leg of The Eras Tour.

- A new function,
  [`translate_bracelet()`](https://taylor.wjakethompson.com/dev/reference/translate_bracelet.md)
  can be used to find the song and line from the first letter of each
  word, as is common on the Eras Tour friendship bracelets.

### Minor improvements and fixes

- New color palettes added to `album_palettes` for *Speak Now (Taylor’s
  Version)* and *1989 (Taylor’s Version)*.

- New single colors added to `album_compare` for *Speak Now (Taylor’s
  Version)* and *1989 (Taylor’s Version)*.

- Metacritic scores for *Speak Now (Taylor’s Version)* and *1989
  (Taylor’s Version)* have been added to `taylor_albums`.

- Hex logo and pkgdown website have been updated to have a *1989
  (Taylor’s Version)* theme.

- Added Spotify data for “Hits Different” after it was released to
  streaming as part of *Midnights (The Til Dawn Edition)*.

- Added “Snow on the Beach (More Lana Del Rey)” and “Karma (Remix)” from
  *Midnights (The Til Dawn Edition)*.

- Added “The Alcott” from The National’s *First Two Pages of
  Frankenstein* to `taylor_all_songs`.

- Added Era’s Tour promotional singles “All of the Girls You Loved
  Before,” “If This Was a Movie (Taylor’s Version),” “Eyes Open
  (Taylor’s Version),” and “Safe & Sound (Taylor’s Version).”

- “This Love (Taylor’s Version)” and “Wildest Dreams (Taylor’s Version)”
  have been moved from non-album singles to *1989 (Taylor’s Version)*.

- The `type` argument of
  [`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
  has been removed. This argument was previously deprecated with a
  warning in version 1.0.0.

## taylor 2.0.1

CRAN release: 2023-03-08

### Minor improvements and fixes

- Fixed S3 generic/method consistency issue for **vctrs** classes that
  was creating a warning in r-devel on CRAN.

- Updated Metacritic user ratings.

## taylor 2.0.0

CRAN release: 2022-11-08

### Breaking changes

- Added *Midnights* to `taylor_all_songs` and `taylor_album_songs`.

- Spotify updated audio data for songs on *Red (Taylor’s Version)*.
  These changes are reflected in `taylor_all_songs` and
  `taylor_album_songs`.

- Spotify updated audio data for “Renegade”. These changes are reflected
  in `taylor_all_songs` and `taylor_album_songs`.

### New features

- A new `user_score` column for user ratings from Metacritic was added
  to `taylor_albums`.

- Added “Lover (Remix)” with Shawn Mendes, Taylor’s cover of Earth,
  Wind, and Fire’s “September,” and “Three Sad Virgins” from Saturday
  Night Live to `taylor_all_songs`.

- Added “Carolina” from the *Where the Crawdads Sing* soundtrack to
  `taylor_all_songs`.

- “This Love (Taylor’s Version)” has been added as a non-album single.
  Presumably this will eventually move to *1989 (Taylor’s Version)*.

- Added “The Joker and the Queen” from Ed Sheeran’s *=* to
  `taylor_all_songs`.

### Minor improvements and fixes

- New color palette added to `album_palettes` for *Midnights*.

- New single color added to `album_compare` for *Midnights*.

- Metacritic score for *Midnights* has been added to `taylor_albums`.

- Fixed some additional non-ASCII characters in the lyrics for all
  albums ([@ericwu17](https://github.com/ericwu17),
  [\#16](https://github.com/wjakethompson/taylor/issues/16)).

- Minor tweaks to the color palettes for each album to better capture
  the vibes, rather than just pulling from album artwork.

## taylor 1.0.0

CRAN release: 2021-12-14

### Breaking changes

- *Red (Taylor’s Version)* has replaced *Red* in `taylor_album_songs`
  ([\#9](https://github.com/wjakethompson/taylor/issues/9)).

- The `type` argument of
  [`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
  is deprecated and will be removed in a future release. Previously, if
  you wanted to interpolate more colors between those originally
  specified, you needed to specify `type = "continuous"`. This was
  misleading, because
  [`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
  still returned a discrete number of colors (`n`). Now, interpolation
  happens automatically if `n` is greater than `length(pal)`.

  ``` r
  my_colors <- c(ku_blue = "#0051ba", "firebrick", "#ffc82d")
  my_palette <- color_palette(my_colors)

  # old
  color_palette(my_palette, n = 10, type = "continuous")
  color_palette(my_palette, n = 2, type = "discrete")

  # new
  color_palette(my_palette, n = 10)
  color_palette(my_palette, n = 2)
  ```

### Minor improvements and fixes

- New color palette added to `album_palettes` for *Red (Taylor’s
  Version)*.

- New single color added to `album_compare` for *Red (Taylor’s
  Version)*.

- Metacritic score for *Red (Taylor’s Version)* has been added to
  `taylor_albums`.

- “Wildest Dreams (Taylor’s Version)” has been added as a non-album
  single. Presumably this will eventually move to *1989 (Taylor’s
  Version)*.

- Hex logo and pkgdown website have been updated to have a *Red
  (Taylor’s Version)* theme.

- Fix the majority of non-ASCII characters in song lyrics. Remaining
  characters are en/em dashes and letters with accent marks.

- [`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
  now preserves color names, either through R color specifications
  (i.e., [`colors()`](https://rdrr.io/r/grDevices/colors.html)) or a
  named vector supplied to `pal`
  ([\#12](https://github.com/wjakethompson/taylor/issues/12)).

  ``` r
  my_colors <- c(ku_blue = "#0051ba", "firebrick", "#ffc82d")
  color_palette(my_colors)
  ```

## taylor 0.2.1

CRAN release: 2021-09-23

- Added “Birch” from Big Red Machine’s *How Long Do You Think It’s Gonna
  Last?* to `taylor_all_songs`.

- Updated tests for the upcoming release of testthat
  ([@hadley](https://github.com/hadley),
  [\#10](https://github.com/wjakethompson/taylor/issues/10)).

## taylor 0.2.0

CRAN release: 2021-08-17

- Added a `NEWS.md` file to track changes to the package.
