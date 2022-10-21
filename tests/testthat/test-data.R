test_that("data has expected dimensions", {
  # all songs
  expect_equal(ncol(taylor_all_songs), 29L)
  expect_equal(ncol(taylor_all_songs$lyrics[[1]]), 4L)

  # album songs
  expect_equal(ncol(taylor_album_songs), 29L)
  expect_equal(ncol(taylor_album_songs$lyrics[[1]]), 4L)

  # albums
  expect_equal(ncol(taylor_albums), 5L)

  albums <-
    unique(taylor_all_songs[which((!taylor_all_songs$ep) &
                                    !is.na(taylor_all_songs$album_name)),
                            "album_name"])

  albums <- tolower(albums[[1]])
  albums <- gsub("\\ ", "_", albums)
  albums <- gsub("\\(taylor's_version\\)", "tv", albums)

  expect_equal(length(albums), length(album_palettes))
  expect_equal(length(albums), length(album_compare))
  expect_equal(length(album_palettes), length(album_compare))
  expect_equal(albums, names(album_palettes))
  expect_equal(albums, names(album_compare))
  expect_equal(names(album_palettes), names(album_compare))
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
  expect_equal(colnames(taylor_albums), c("album_name", "ep", "album_release",
                                          "metacritic_score", "user_score"))
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
