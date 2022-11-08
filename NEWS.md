# taylor (development version)

# taylor 2.0.0

## Breaking changes

* Added *Midnights* to `taylor_all_songs` and `taylor_album_songs`.

* Spotify updated audio data for songs on *Red (Taylor's Version)*.
  These changes are reflected in `taylor_all_songs` and `taylor_album_songs`.

* Spotify updated audio data for "Renegade".
  These changes are reflected in `taylor_all_songs` and `taylor_album_songs`.

## New features
  
* A new `user_score` column for user ratings from Metacritic was added to `taylor_albums`.

* Added "Lover (Remix)" with Shawn Mendes, Taylor's cover of Earth, Wind, and Fire's "September," and "Three Sad Virgins" from Saturday Night Live to `taylor_all_songs`.

* Added "Carolina" from the *Where the Crawdads Sing* soundtrack to `taylor_all_songs`.

* "This Love (Taylor's Version)" has been added as a non-album single.
  Presumably this will eventually move to *1989 (Taylor's Version)*.
  
* Added "The Joker and the Queen" from Ed Sheeran's *=* to `taylor_all_songs`.

## Minor improvements and fixes
  
* New color palette added to `album_palettes` for *Midnights*.

* New single color added to `album_compare` for *Midnights*.

* Metacritic score for *Midnights* has been added to
  `taylor_albums`.

* Fixed some additional non-ASCII characters in the lyrics for all albums (@EricWu2003, #16).

* Minor tweaks to the color palettes for each album to better capture the vibes,
  rather than just pulling from album artwork.

# taylor 1.0.0

## Breaking changes

* *Red (Taylor's Version)* has replaced *Red* in `taylor_album_songs` (#9).

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

* New color palette added to `album_palettes` for *Red (Taylor's Version)*.

* New single color added to `album_compare` for *Red (Taylor's Version)*.

* Metacritic score for *Red (Taylor's Version)* has been added to
  `taylor_albums`.

* "Wildest Dreams (Taylor's Version)" has been added as a non-album single.
  Presumably this will eventually move to *1989 (Taylor's Version)*.
  
* Hex logo and pkgdown website have been updated to have a
  *Red (Taylor's Version)* theme.

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
