get_soundstat_audio_features <- function(
  track_id,
  spotify_access = spotifyr::get_spotify_access_token(),
  soundstat_access = Sys.getenv("SOUNDSTAT_API_KEY")
) {
  spotify_track <- spotifyr::get_track(track_id, authorization = spotify_access)
  res <- httr::GET(
    url = glue::glue("https://soundstat.info/api/v1/track/{track_id}"),
    config = httr::add_headers(`x-api-key` = soundstat_access)
  )

  raw_dat <- jsonlite::fromJSON(rawToChar(res$content))
  raw_dat$features$segments <- NULL
  raw_dat$features$beats <- NULL

  tibble::as_tibble(raw_dat$features) |>
    select(
      danceability,
      energy,
      key,
      loudness,
      mode,
      acousticness,
      instrumentalness,
      valence,
      tempo
    ) |>
    mutate(
      acousticness = acousticness * 0.005,
      energy = energy * 2.25,
      instrumentalness = instrumentalness * 0.03,
      loudness = -1 * (1 - loudness) * 14,
      duration_ms = spotify_track$duration_ms,
      explicit = spotify_track$explicit
    ) |>
    dplyr::left_join(key_lookup, by = "key") |>
    dplyr::mutate(
      mode_name = dplyr::case_when(mode == 0L ~ "minor", mode == 1L ~ "major"),
      key_mode = paste(key_name, mode_name)
    ) |>
    tibble::add_column(
      album_name = spotify_track$album$name,
      track_name = spotify_track$name,
      artist = paste(spotify_track$artists$name, collapse = ", "),
      .before = 1
    ) |>
    tidyr::separate_wider_delim(
      cols = artist,
      delim = ", ",
      names = c("artist", "featuring"),
      too_few = "align_start",
      too_many = "merge"
    )
}


get_reccobeats_track_ids <- function(album_id) {
  album_res <- httr::GET(
    url = glue::glue(
      "https://api.reccobeats.com/v1/album?ids={album_id}"
    )
  )
  raw_dat <- jsonlite::fromJSON(rawToChar(album_res$content))
  album_id <- raw_dat$content$id

  track_res <- httr::GET(
    url = glue::glue("https://api.reccobeats.com/v1/album/{album_id}/track")
  )
  raw_dat <- jsonlite::fromJSON(rawToChar(track_res$content))

  raw_dat$content |>
    tibble::as_tibble() |>
    dplyr::select(track_name = "trackTitle", track_id = "id")
}


get_reccobeats_audio_features <- function(track_id) {
  track_res <- httr::GET(
    url = glue::glue("https://api.reccobeats.com/v1/track?ids={track_id}")
  )
  raw_dat <- jsonlite::fromJSON(rawToChar(track_res$content))

  res <- httr::GET(
    url = glue::glue(
      "https://api.reccobeats.com/v1/audio-features?ids={track_id}"
    )
  )
  raw_dat <- jsonlite::fromJSON(rawToChar(res$content))
}


key_lookup <- tibble(
  key = 0:11,
  key_name = c("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
)
