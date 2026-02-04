test_that("sitrep works", {
  expect_snapshot(taylor_sitrep())

  withr::local_envvar(list(
    "SPOTIFY_CLIENT_ID" = "",
    "SPOTIFY_CLIENT_SECRET" = ""
  ))
  expect_snapshot(taylor_sitrep())
})
