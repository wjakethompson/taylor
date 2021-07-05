test_that("data has expected dimensions", {
  # all songs
  expect_equal(ncol(taylor_all_songs), 29L)
  expect_equal(ncol(taylor_all_songs$lyrics[[1]]), 4L)

  # album songs
  expect_equal(ncol(taylor_album_songs), 29L)
  expect_equal(ncol(taylor_album_songs$lyrics[[1]]), 4L)

  # albums
  expect_equal(ncol(taylor_albums), 3L)
})

test_that("column names match documentation expectation", {
  data_cols <- c("album_name", "ep", "album_release", "track_number",
                 "track_name", "artist", "featuring", "bonus_track",
                 "promotional_release", "single_release", "track_release",
                 "danceability", "energy", "key", "loudness", "mode",
                 "speechiness", "acousticness", "instrumentalness", "liveness",
                 "valence", "tempo", "time_signature", "duration_ms",
                 "explicit", "key_name", "mode_name", "key_mode", "lyrics")

  # all songs
  expect_equal(colnames(taylor_all_songs), data_cols)
  expect_equal(colnames(taylor_all_songs$lyrics[[1]]), c("line", "lyric",
                                                         "element",
                                                         "element_artist"))

  # album songs
  expect_equal(colnames(taylor_album_songs), data_cols)
  expect_equal(colnames(taylor_album_songs$lyrics[[1]]), c("line", "lyric",
                                                           "element",
                                                           "element_artist"))

  # albums
  expect_equal(colnames(taylor_albums), c("album_name", "ep", "album_release"))
})

test_that("non-TV versions are excluded when possible", {
  albums <- unique(taylor_all_songs$album_name)
  albums <- albums[!is.na(albums)]

  no_tv <- gsub("\\ \\(Taylor's Version\\)", "", albums)
  counts <- as.data.frame(table(no_tv))
  exclude_albums <- c(
    taylor_albums$album_name[which(taylor_albums$ep)],
    as.character(counts$no_tv[which(counts$Freq > 1)])
  )

  expect_false(any(exclude_albums %in% taylor_album_songs$album_name))
})
