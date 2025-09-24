key_lookup <- tibble::tibble(
  key = 0:11,
  key_name = c("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
)

# spotify ----------------------------------------------------------------------

#' Spotify track information
#'
#' Access the Spotify API to get metadata for audio tracks.
#'
#' @param track_id The Spotify ID for a track.
#' @param api_key A Spotify access token, from
#'   [get_spotify_access_token()].
#'
#' @returns A [tibble][tibble::tibble-package] with track metadata, including:
#'   * `album_name`: The name of the album the track appears on (if relevant).
#'   * `track_name`: The name of the track.
#'   * `artist`: The artist of the track.
#'   * `featuring`: The artist(s) featured on the track (if relevant).
#'   * `duration_ms`: Duration of the track in milliseconds.
#'   * `explicit`: Logical. Does the track contain explicit lyrics (`TRUE`) or
#'     not (`FALSE`).
#' @export
#' @family API access
#'
#' @examplesIf taylor_examples()
#' # So High School
#' get_spotify_track_info(track_id = "7Mts0OfPorF4iwOomvfqn1")
get_spotify_track_info <- function(
  track_id,
  api_key = get_spotify_access_token()
) {
  check_character(track_id)
  check_character(api_key)

  spotify_track <- spotifyr::get_track(track_id, authorization = api_key)

  tibble::tibble(
    duration_ms = spotify_track$duration_ms,
    explicit = spotify_track$explicit
  ) |>
    tibble::add_column(
      album_name = spotify_track$album$name,
      track_name = spotify_track$name,
      artist = paste(spotify_track$artists$name, collapse = ", "),
      .before = 1
    ) |>
    tidyr::separate_wider_delim(
      cols = "artist",
      delim = ", ",
      names = c("artist", "featuring"),
      too_few = "align_start",
      too_many = "merge"
    )
}

#' Spotify API helpers
#'
#' This is a wrapper around [spotifyr::get_spotify_access_token()] to create a
#' Spotify access token from stored environment variables.
#'
#' @returns The Spotify access token.
#' @export
#'
#' @examplesIf taylor_examples()
#' \donttest{get_spotify_access_token()}
get_spotify_access_token <- function() {
  client_id <- Sys.getenv("SPOTIFY_CLIENT_ID")
  client_secret <- Sys.getenv("SPOTIFY_CLIENT_SECRET")
  if (!any(identical(client_id, ""), identical(client_secret, ""))) {
    token <- spotifyr::get_spotify_access_token(
      client_id = client_id,
      client_secret = client_secret
    )
    return(token)
  }

  if (is_testing() || is_pkgdown()) {
    return(spotify_testing_key())
  } else {
    cli::cli_abort(
      cli::format_message(
        c("No access token found, please see",
          "{.fun spotifyr::get_spotify_access_token}")
      )
    )
  }
}

spotify_testing_key <- function() {
  spotifyr::get_spotify_access_token(
    client_id = httr2::secret_decrypt(
      "UOF5NVolAFuZUfPsrqB6zRGiuT2U6kZTly16hmop_vkzywAmTyHJaDuWl13gymsI",
      "TAYLOR_KEY"
    ),
    client_secret = httr2::secret_decrypt(
      "LZneUpdwTawqZOBb6Qx481OvOL9U9Jxz9QZhm9FwUQ6QsPLkQTV1FbMweVKFKUR9",
      "TAYLOR_KEY"
    )
  )
}


# soundstat --------------------------------------------------------------------

#' SoundStat audio features
#'
#' Access the SoundStat API to get audio features for tracks.
#'
#' @param track_id The Spotify ID for a track.
#' @param convert_values Logical. For SoundStat features, should audio features
#'   be converted to the Spotify scale. See details for conversion formulas.
#' @param api_key A SoundStat API key, e.g., [get_soundstat_api_key()].
#'
#' @details
#' Due to differences in algorithms and methodologies, the SoundStat audio
#' features are on a slightly different scale than the Spotify audio features
#' that were originally included in [taylor] prior the [changes to the Spotify
#' API](). We can convert the SoundStat values to the Spotify scale using the
#' formulas in the [SoundStat
#' docs](https://soundstat.info/article/Understanding-Audio-Analysis.html):
#'
#' ```
#' acousticness = sound_value * 0.005
#' energy = sound_value * 2.25
#' instrumentalness = sound_value * 0.03
#' loudness = -(1 - sound_value) * 14
#' ```
#'
#' To automatically perform these conversions, set `convert_values = TRUE`.
#'
#' @returns A [tibble][tibble::tibble-package] with track audio features,
#'   including:
#'   * `danceability`: Danceability score (0-1).
#'   * `energy`: Energy level (0-1).
#'   * `loudness`: Loudness level (0-1).
#'   * `acousticness`: Acousticness score (0-1).
#'   * `instrumentalness`: Instrumentalness score (0-1).
#'   * `valence`: Mood/positiveness (0-1).
#'   * `tempo`: Track tempo in beats per minute (BPM).
#'   * `key`: Track key (0-11).
#'   * `mode`: Mode (0 - minor, 1 - major).
#'   * `key_name`: Corresponds directly to the key, but the integer is
#'     converted to the key name using Pitch Class notation (e.g., 0 becomes
#'     `C`).
#'   * `mode_name`: Corresponds directly to the mode, but the integer is
#'     converted to the mode name (e.g., 0 becomes `minor`).
#'   * `key_mode`: A combination of the `key_name` and `mode_name` variables
#'     (e.g., `C minor`).
#' @export
#' @family API access
#'
#' @examplesIf taylor_examples()
#' get_soundstat_audio_features(track_id = "7Mts0OfPorF4iwOomvfqn1")
get_soundstat_audio_features <- function(
  track_id,
  convert_values = FALSE,
  api_key = get_soundstat_api_key()
) {
  check_character(track_id, allow_na = TRUE)
  check_logical(convert_values)
  check_character(api_key)

  if (is.na(track_id) || track_id == "") {
    no_info <- tibble::tibble(
      danceability = NA_real_,
      energy = NA_real_,
      loudness = NA_real_,
      acousticness = NA_real_,
      instrumentalness = NA_real_,
      valence = NA_real_,
      tempo = NA_real_,
      key = NA_integer_,
      mode = NA_integer_,
      key_name = NA_character_,
      mode_name = NA_character_,
      key_mode = NA_character_
    )

    return(no_info)
  }

  resp <- httr2::request("https://soundstat.info/api/v1") |>
    httr2::req_url_path_append("/track") |>
    httr2::req_url_path_append(track_id) |>
    httr2::req_headers(`x-api-key` = api_key) |>
    httr2::req_retry(
      max_seconds = 300,
      is_transient = \(resp) httr2::resp_status(resp) %in% c(429, 503, 202)
    ) |>
    httr2::req_perform()

  raw_dat <- httr2::resp_body_json(resp)
  raw_dat$features$segments <- NULL
  raw_dat$features$beats <- NULL

  tibble::as_tibble(raw_dat$features) |>
    dplyr::select(
      "danceability",
      "energy",
      "loudness",
      "acousticness",
      "instrumentalness",
      "valence",
      "tempo",
      "key",
      "mode"
    ) |>
    dplyr::mutate(
      acousticness = .data$acousticness * 0.005,
      energy = .data$energy * 2.25,
      instrumentalness = .data$instrumentalness * 0.03,
      loudness = -1 * (1 - .data$loudness) * 14
    ) |>
    dplyr::left_join(key_lookup, by = "key") |>
    dplyr::mutate(
      mode_name = dplyr::case_when(
        .data$mode == 0L ~ "minor",
        .data$mode == 1L ~ "major"
      ),
      key_mode = paste(.data$key_name, .data$mode_name)
    )
}

#' SoundStat API helpers
#'
#' Set and retrieve a SoundStat API key
#'
#' @param key A SoundStat API key.
#'
#' @returns
#'   * `get_soundstat_api_key()` returns a previously stored API key.
#'   * `set_soundstat_api_key()` is called for side effects only.
#' @name soundstat-api
#' @export
#'
#' @examplesIf taylor_examples()
#' \donttest{get_soundstat_api_key()}
get_soundstat_api_key <- function() {
  key <- Sys.getenv("SOUNDSTAT_KEY")
  if (!identical(key, "")) {
    return(key)
  }

  if (is_testing()) {
    return(soundstat_testing_key())
  } else {
    cli::cli_abort(
      cli::format_message(
        c("No API key found, please supply with {.arg api_key} argument or",
          "with the",
          "{.help [{.envvar SOUNDSTAT_KEY} env var](get_soundstat_api_key)}")
      )
    )
  }
}

#' @export
#' @rdname soundstat-api
set_soundstat_api_key <- function(key = NULL) {
  check_character(key, allow_null = TRUE)

  if (is.null(key)) {
    key <- askpass::askpass("Please enter your API key")
    if (is.null(key)) {
      cli::cli_abort("API key not provided")
    }
  }
  Sys.setenv("SOUNDSTAT_KEY" = key)
}

soundstat_testing_key <- function() {
  httr2::secret_decrypt(
    paste0("cFg1OO1frsH8Up0AhTQu09k86iUHZmK-rtok8wcVJMCfChKc6Oyc5GRqhVQJ_",
           "s34RFw8qdhKJZY0aco"),
    "TAYLOR_KEY"
  )
}


# reccobeats -------------------------------------------------------------------

#' Reccobeats audio features
#'
#' Access the Reccobeats API to get audio features for tracks.
#'
#' @param track_id The Spotify ID for a track.
#'
#' @returns
#'   * `get_reccobeats_audio_features()` returns a
#'     [tibble][tibble::tibble-package] with track audio features, including:
#'     * `danceability`: Suitability for dancing (0.0 to 1.0). Higher values
#'       indicate more rhythmically engaging tracks.
#'     * `energy`: Intensity and liveliness (0.0 to 1.0). Higher values indicate
#'       more energetic tracks.
#'     * `loudness`: Average loudness in decibels (dB). Typically ranges between
#'       -60 and 0 dB.
#'     * `speechiness`: Presence of spoken words (0.0 to 1.0). Values above 0.66
#'       indicate mostly speech.
#'     * `acousticness`: Confidence (0.0 to 1.0) that the track is acoustic.
#'       Higher values indicate more natural sounds.
#'     * `instrumentalness`: Likelihood of no vocals (0.0 to 1.0). Values above
#'       0.5 suggest instrumental tracks.
#'     * `liveness`: Probability of a live audience (0.0 to 1.0). Values above
#'       0.8 strongly suggest a live track.
#'     * `valence`: Emotional tone (0.0 to 1.0). Higher values indicate a
#'       happier mood, lower values a sadder one.
#'     * `tempo`: Estimated tempo in beats per minute (BPM). Typically ranges
#'       between 0 and 250.
#'     * `key`: The key the track is in. Integers map to pitches using standard
#'       Pitch Class notation. If no key was detected, the value is -1.
#'     * `mode`: Mode indicates the modality (major or minor) of a track.
#'       Major is represented by 1 and minor is 0.
#'     * `key_name`: Corresponds directly to the key, but the integer is
#'       converted to the key name using Pitch Class notation (e.g., 0 becomes
#'       `C`).
#'     * `mode_name`: Corresponds directly to the mode, but the integer is
#'       converted to the mode name (e.g., 0 becomes `minor`).
#'     * `key_mode`: A combination of the `key_name` and `mode_name` variables
#'       (e.g., `C minor`).
#' @export
#' @family API access
#'
#' @examplesIf taylor_examples()
#' # So High School
#' get_reccobeats_audio_features(track_id = "7Mts0OfPorF4iwOomvfqn1")
get_reccobeats_audio_features <- function(track_id) {
  check_character(track_id, allow_na = TRUE)

  no_info <- tibble::tibble(
    danceability = NA_real_,
    energy = NA_real_,
    loudness = NA_real_,
    speechiness = NA_real_,
    acousticness = NA_real_,
    instrumentalness = NA_real_,
    liveness = NA_real_,
    valence = NA_real_,
    tempo = NA_real_,
    key = NA_integer_,
    mode = NA_integer_,
    key_name = NA_character_,
    mode_name = NA_character_,
    key_mode = NA_character_
  )

  if (is.na(track_id) || track_id == "") {
    return(no_info)
  }

  resp <- httr2::request("https://api.reccobeats.com/v1") |>
    httr2::req_url_path_append("/audio-features") |>
    httr2::req_url_query(ids = track_id) |>
    httr2::req_retry(max_tries = 10) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (identical(resp$content, list())) {
    return(no_info)
  }

  resp$content[[1]] |>
    tibble::as_tibble() |>
    dplyr::select(
      "danceability",
      "energy",
      "loudness",
      "speechiness",
      "acousticness",
      "instrumentalness",
      "liveness",
      "valence",
      "tempo",
      "key",
      "mode"
    ) |>
    dplyr::left_join(key_lookup, by = "key") |>
    dplyr::mutate(
      mode_name = dplyr::case_when(
        .data$mode == 0L ~ "minor",
        .data$mode == 1L ~ "major"
      ),
      key_mode = paste(.data$key_name, .data$mode_name)
    )
}


# testing helpers --------------------------------------------------------------

#' Determine if code is executed interactively or in pkgdown
#'
#' Used for determining examples that shouldn't be run on CRAN, but can be run
#' for the pkgdown website.
#'
#' @return A logical value indicating whether or not the examples should be run.
#'
#' @export
#' @examples
#' taylor_examples()
taylor_examples <- function() {
  httr2::secret_has_key("TAYLOR_KEY") && is_pkgdown()
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

is_pkgdown <- function() {
  identical(Sys.getenv("IN_PKGDOWN"), "true")
}
