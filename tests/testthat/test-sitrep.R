test_that("sitrep works", {
  withr::local_envvar(list(
    "SPOTIFY_CLIENT_ID" = spotify_testing_key()$client_id,
    "SPOTIFY_CLIENT_SECRET" = spotify_testing_key()$client_secret,
    "SOUNDSTAT_KEY" = soundstat_testing_key()
  ))
  expect_snapshot(taylor_sitrep())

  withr::local_envvar(list(
    "SPOTIFY_CLIENT_ID" = "",
    "SPOTIFY_CLIENT_SECRET" = "",
    "SOUNDSTAT_KEY" = soundstat_testing_key()
  ))
  expect_snapshot(taylor_sitrep())
})
