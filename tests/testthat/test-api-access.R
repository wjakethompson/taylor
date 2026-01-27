test_that("spotify api", {
  client_id <- httr2::secret_decrypt(
    "UOF5NVolAFuZUfPsrqB6zRGiuT2U6kZTly16hmop_vkzywAmTyHJaDuWl13gymsI",
    "TAYLOR_KEY"
  )
  client_secret = httr2::secret_decrypt(
    "LZneUpdwTawqZOBb6Qx481OvOL9U9Jxz9QZhm9FwUQ6QsPLkQTV1FbMweVKFKUR9",
    "TAYLOR_KEY"
  )

  # with known envvars ---------------------------------------------------------
  withr::local_envvar(list(
    "SPOTIFY_CLIENT_ID" = client_id,
    "SPOTIFY_CLIENT_SECRET" = client_secret
  ))
  so_high_school <- get_spotify_track_info(track_id = "7Mts0OfPorF4iwOomvfqn1")

  expect_equal(
    colnames(so_high_school),
    c(
      "artist",
      "featuring",
      "spotify_album",
      "duration_ms",
      "explicit"
    )
  )

  expect_equal(so_high_school$artist, "Taylor Swift")
  expect_equal(so_high_school$featuring, NA_character_)

  expect_null(get_spotify_track_info(track_id = ""))
  expect_null(get_spotify_track_info(track_id = NA_character_))

  # nothing saved to renviron --------------------------------------------------
  withr::local_envvar(list("SPOTIFY_CLIENT_ID" = ""))
  without_local <- get_spotify_track_info(track_id = "7Mts0OfPorF4iwOomvfqn1")
  expect_identical(so_high_school, without_local)

  # no keys found --------------------------------------------------------------
  withr::local_envvar(list("SPOTIFY_CLIENT_ID" = "", "TESTTHAT" = "false"))
  err <- rlang::catch_cnd(
    get_spotify_track_info(track_id = "7Mts0OfPorF4iwOomvfqn1")
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "No access token found")
})

test_that("soundstat api", {
  soundstat_key <- httr2::secret_decrypt(
    paste0(
      "cFg1OO1frsH8Up0AhTQu09k86iUHZmK-rtok8wcVJMCfChKc6Oyc5GRqhVQJ_",
      "s34RFw8qdhKJZY0aco"
    ),
    "TAYLOR_KEY"
  )

  # with known envvars ---------------------------------------------------------
  withr::local_envvar(list("SOUNDSTAT_KEY" = soundstat_key))
  so_high_school <- get_soundstat_audio_features("7Mts0OfPorF4iwOomvfqn1")

  expect_equal(
    colnames(so_high_school),
    c(
      "danceability",
      "energy",
      "loudness",
      "acousticness",
      "instrumentalness",
      "valence",
      "tempo",
      "key",
      "mode",
      "key_name",
      "mode_name",
      "key_mode"
    )
  )

  expect_equal(
    so_high_school |>
      dplyr::mutate(
        dplyr::across(dplyr::everything(), is.na),
        missing = sum(dplyr::c_across(dplyr::everything()))
      ) |>
      dplyr::pull("missing"),
    0L
  )

  expect_null(get_soundstat_audio_features(track_id = ""))
  expect_null(get_soundstat_audio_features(track_id = NA_character_))

  # nothing saved to renviron --------------------------------------------------
  withr::local_envvar(list("SOUNDSTAT_KEY" = ""))
  without_local <- get_soundstat_audio_features(
    track_id = "7Mts0OfPorF4iwOomvfqn1",
    convert_values = TRUE
  )
  expect_identical(
    dplyr::mutate(
      so_high_school,
      acousticness = .data$acousticness * 0.005,
      energy = .data$energy * 2.25,
      instrumentalness = .data$instrumentalness * 0.03,
      loudness = -1 * (1 - .data$loudness) * 14
    ),
    without_local
  )

  # no keys found --------------------------------------------------------------
  withr::local_envvar(list("SOUNDSTAT_KEY" = "", "TESTTHAT" = "false"))
  err <- rlang::catch_cnd(
    get_soundstat_audio_features(track_id = "7Mts0OfPorF4iwOomvfqn1")
  )
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "No API key found")
})

test_that("setting soundstat envvar", {
  withr::local_envvar(list("SOUNDSTAT_KEY" = ""))
  set_soundstat_api_key(key = "my-api-key")
  expect_equal(Sys.getenv("SOUNDSTAT_KEY"), "my-api-key")

  withr::local_envvar(list("SOUNDSTAT_KEY" = ""))
  err <- rlang::catch_cnd(set_soundstat_api_key())
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "API key not provided")
})

test_that("reccobeats api", {
  so_high_school <- get_reccobeats_audio_features("7Mts0OfPorF4iwOomvfqn1")

  expect_equal(
    colnames(so_high_school),
    c(
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
      "mode",
      "key_name",
      "mode_name",
      "key_mode"
    )
  )

  expect_equal(
    so_high_school |>
      dplyr::mutate(
        dplyr::across(dplyr::everything(), is.na),
        missing = sum(dplyr::c_across(dplyr::everything()))
      ) |>
      dplyr::pull("missing"),
    0L
  )

  expect_null(get_reccobeats_audio_features(track_id = ""))
  expect_null(get_reccobeats_audio_features(track_id = NA_character_))
  expect_null(get_reccobeats_audio_features(track_id = "so-high-school"))
})

test_that("api testing helpers", {
  withr::local_envvar(list("IN_PKGDOWN" = "true", "TESTTHAT" = "true"))
  expect_true(taylor_examples())
  expect_true(is_testing())
  expect_true(is_pkgdown())

  withr::local_envvar(list("IN_PKGDOWN" = "false", "TESTTHAT" = "true"))
  expect_false(taylor_examples())
  expect_true(is_testing())
  expect_false(is_pkgdown())

  withr::local_envvar(list("IN_PKGDOWN" = "true", "TESTTHAT" = "false"))
  expect_true(taylor_examples())
  expect_false(is_testing())
  expect_true(is_pkgdown())

  withr::local_envvar(list("IN_PKGDOWN" = "false", "TESTTHAT" = "false"))
  expect_false(taylor_examples())
  expect_false(is_testing())
  expect_false(is_pkgdown())

  withr::local_envvar(
    list("IN_PKGDOWN" = "true", "TESTTHAT" = "true", "TAYLOR_KEY" = "")
  )
  expect_false(taylor_examples())
  expect_true(is_testing())
  expect_true(is_pkgdown())
})
