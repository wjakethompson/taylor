#' Data for Taylor Swift songs
#'
#' A data set containing lyrics to and characteristics of all officially
#' released Taylor Swift songs. This includes albums, EPs, and individually
#' released singles.
#'
#' @format A [tibble][tibble::tibble-package] with `r nrow(taylor_all_songs)`
#' rows and `r ncol(taylor_all_songs)` variables. Each row is one song.
#' * `album_name`: The name of the album. `NA` if the song was released
#'   separately from one of Taylor's studio albums or EPs.
#' * `ep`: Logical. Is the album a full studio album (`FALSE`) or an extended
#'   play (`TRUE`).
#' * `album_release`: The date the album was released, in the ISO-8601 format
#'   (YYYY-MM-DD).
#' * `track_number`: The order of the song on the album or EP.
#' * `track_name`: The name of the song.
#' * `artist`: The name of the song artist. Usually Taylor Swift, but will show
#'   other artists for songs that Taylor is only featured on.
#' * `featuring`: Any artists that are featured on the track.
#' * `bonus_track`: Logical. Is the track only present on a deluxe edition of
#'   the album (`TRUE`) or is does it also appear on the standard version
#'   (`FALSE`).
#' * `promotional_release`: The date the song was released as a promotional
#'   single, in the ISO-8601 format (YYYY-MM-DD).. `NA` if the song was never
#'   released as a promotional single.
#' * `single_release`: The date the song was released as an official single, in
#'   the ISO-8601 format (YYYY-MM-DD). `NA` if the song was never released as an
#'   official single.
#' * `track_release`: The date the song was first publicly released. This is the
#'   earliest of `album_release`, `promotional_release`, and `single_release`.
#'
#' The next set of variables come from the Spotify API. See the documentation at
#' <https://developer.spotify.com/documentation/web-api/reference/> for complete
#' details.
#' * `danceability`: How suitable a track is for dancing. `0.0` = least
#'   danceable, `1.0` = most danceable.
#' * `energy`: Perceptual measure of intensity and activity. `0.0` = least
#'   energy, `1.0` = most energy.
#' * `key`: The key the track is in. Integer maps to standard Pitch Class
#'   notation.
#' * `loudness`: Loudness of track in decibels (dB), averaged across the track.
#' * `mode`: Modality of a track (major/minor). `0` = minor, `1` = major.
#' * `speechiness`: The presence of spoken words in a track. Values above `0.66`
#'   indicate that the track is probably made entirely of spoken words. Values
#'   between `0.33` and `0.66` indicate both music and speech. Values less than
#'   `0.33` indicate the track is probably music or other non-speech tracks.
#' * `acousticness`: Confidence that the track is acoustic. `0.0` = low
#'   confidence, `1.0` = high confidence.
#' * `instrumentalness`: Confidence that the track is an instrumental track
#'   (i.e., no vocals). `0.0` = low confidence, `1.0` = high confidence.
#' * `liveness`: Confidence that the track is a live recording (i.e., an
#'   audience is present). `0.0` = low confidence, `1.0` = high confidence.
#' * `valence`: Musical positiveness conveyed by the track. `0.0` = low valence
#'   (e.g., sad, depressed, angry), `1.0` = high valence (e.g., happy, cheerful,
#'   euphoric).
#' * `tempo`: Estimated tempo of the track in beats per minute (BPM).
#' * `time_signature`: Estimated overall time signature.
#' * `duration_ms`: Duration of the track in milliseconds.
#' * `explicit`: Logical. Does the track contain explicit lyrics (`TRUE`) or not
#'  (`FALSE`).
#'
#' Finally, the last set of variables include those calculated from the Spotify
#' API data, and a list column containing song lyrics.
#' * `key_name`: Corresponds directly to the `key`, but the integer is converted
#'   to the key name using Pitch Class notation (e.g., `0` becomes `C`).
#' * `mode_name`: Corresponds directly to the `mode`, but the integer is
#'   converted to the mode name (e.g., `0` becomes `minor`).
#' * `key_mode`: A combination of the `key_name` and `mode_name` variables
#'   (e.g., `C minor`).
#' * `lyrics`: A list column containing the lyrics to each song. Each element is
#'   a data frame with 4 variables:
#'   * `line`: The line number of the song.
#'   * `lyric`: The lyric for the given line.
#'   * `element`: The element of the song the line and lyric belong to, as
#'     defined by <https://genius.com/> (e.g., `Verse 1`, `Chorus`, etc.).
#'   * `element_artist`: The artist performing the element. Usually
#'     `Taylor Swift`, but other artists appear if they are featured on the
#'     track (e.g., `HAIM` is featured on *No Body, No Crime*).
#'
#' @details
#' Lyrics come from Genius, and songs characteristics come from the Spotify API.
#' Some data is known to be missing. The Beautiful Eyes EP is not available on
#' any streaming service, and therefore has no data from the Spotify API.
#' Similarly, the song *American Girl*, a cover of the Tom Petty original, was
#' released exclusively on Rhapsody (now Napster), and therefore also does not
#' have data from the Spotify API.
#'
#' For songs released separately from Taylor's official albums or EPs, album
#' information is not included. For example, *I Don't Wanna Live Forever* was
#' released as part of the *Fifty Shades Darker* movie soundtrack. However, the
#' `album_name` column for this song is `NA`, indicating that it does not appear
#' on one of Taylor's albums.
#'
#' Songs are only included one time. For example, if a song appears on both the
#' standard and deluxe version of an album, there is only one record of the
#' song in the data set. Similarly, compilations are not included. For example,
#' following the release of *folklore*, Taylor released several EPs that were
#' subsets of the original *folklore* album (e.g., *folklore: the escapism
#' chapter*, *folklore: the sleepless nights chapter*, etc.). These are not
#' included. Finally, all bonus tracks (with the exception of voice
#' memos or similar) are included; however, for consistency, the album name is
#' always the shortened, common name. For example, *the lakes* is a bonus track
#' from *folklore (deluxe edition)*, but the `album_name` is listed only as
#' *folklore*. The `bonus_track` variable can be used to determine which songs
#' appeared on the standard version of an album vs. a deluxe or platinum
#' edition.
#'
#' @source \url{https://genius.com/artists/Taylor-swift}
#' @source \url{https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02}
"taylor_all_songs"

#' Data for songs on Taylor Swift's official studio albums
#'
#' A data set containing lyrics to and characteristics of songs on all of
#' Taylor's official studio albums. Thus, this is a subset of
#' [`taylor_all_songs`], with EPs and individual singles excluded. Critically,
#' this subset also only includes versions owned by Taylor when possible,
#' because we stan artists owning their own work. This means that although both
#' *Fearless* and *Fearless (Taylor's Version)* appear in full
#' [`taylor_all_songs`] data, only *Fearless (Taylor's Version)* appears in this
#' subset. This also means that this data set will change as additional
#' re-releases are made available (i.e., *Red* will soon be replaced with
#' *Red (Taylor's Version)*).
#'
#' @format A [tibble][tibble::tibble-package] with `r nrow(taylor_album_songs)`
#' rows and `r ncol(taylor_album_songs)` variables. This is a subset of the
#' [`taylor_all_songs`] data set. Please see that documentation for a complete
#' description of all the included fields.
"taylor_album_songs"

#' Data for Taylor Swift's studio albums and EPs
#'
#' A data set containing the names of Taylor's official releases, the album
#' type, and release date.
#'
#' @format A [tibble][tibble::tibble-package] with `r nrow(taylor_albums)` rows
#' and `r ncol(taylor_albums)` variables:
#' * `album_name`: The name of the album. `NA` if the song was released
#'   separately from one of Taylor's studio albums or EPs.
#' * `ep`: Logical. Is the album a full studio album (`FALSE`) or an extended
#'   play (`TRUE`).
#' * `album_release`: The date the album was released, in the ISO-8601 format
#'   (YYYY-MM-DD).
#' * `metacritic_score`: The official album rating from metacritic.
#'
#' @details
#' This data set includes all official studio albums and EPs with new tracks.
#' This means that compilations or EPs that are a subset of the original albums
#' are not included (e.g., *folklore: the escapism chapter*,
#' *folklore: the sleepless nights chapter*, etc.)
#'
#' @source \url{https://en.wikipedia.org/wiki/Taylor_Swift_albums_discography}
#' @source \url{https://www.metacritic.com/person/taylor-swift}
"taylor_albums"
