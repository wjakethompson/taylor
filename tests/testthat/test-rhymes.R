test_that("pronunciations are found", {
  # dictionary words
  expect_equal(lookup_pronunciation(c("night", "love")), c("e", "c"))

  # contractions, possessives, and compounds
  expect_equal(lookup_pronunciation("nothin'"), lookup_pronunciation("nothing"))
  expect_equal(lookup_pronunciation("taylor's"), lookup_pronunciation("taylor"))
  expect_equal(
    lookup_pronunciation("teardrops"),
    paste0(lookup_pronunciation("tear"), lookup_pronunciation("drop"))
  )

  # words without a vowel sound
  expect_equal(lookup_pronunciation(c("the", "mmm", "22")), c("", "", ""))

  # words not in the dictionary are guessed from their spelling
  expect_true(is.na(lookup_dictionary("blorptastic")))
  expect_equal(lookup_pronunciation("blorptastic"), "abh")
  expect_equal(guess_vowels("hate"), "f")
  expect_equal(guess_vowels("my"), "e")
  expect_equal(guess_vowels("saw"), "a")
  expect_equal(guess_vowels("mmm"), "")
})

test_that("lyric lines are cleaned", {
  lines <- c(
    "Cause, baby, now we got bad blood",
    "(Hey!)",
    "[Chorus]",
    "",
    "Cause baby now we got bad blood",
    NA
  )
  expect_equal(
    clean_lyric_lines(lines),
    "Cause, baby, now we got bad blood"
  )
  expect_equal(
    clean_lyric_lines(lines, remove_duplicates = FALSE),
    c("Cause, baby, now we got bad blood", "Cause baby now we got bad blood")
  )

  expect_equal(
    tokenize_words(c("I'm nothin' like you", "Caf\u00e9, 22!")),
    list(c("i'm", "nothin'", "like", "you"), c("cafe", "22"))
  )
})

test_that("rhyme lengths are calculated", {
  detail <- rhyme_detail(c("bad blood", "mad love"))
  expect_equal(detail$word, c("bad", "blood", "mad", "love"))
  expect_equal(detail$rhyme_length, c(0, 0, 0, 2))
  expect_equal(detail$start1[4], 1)
  expect_equal(detail$end1[4], 2)
  expect_equal(detail$start2[4], 3)

  # rhymes can span multiple words
  detail <- rhyme_detail(c("when you were fifteen", "caught in between"))
  expect_equal(detail$rhyme_length[7], 2)
  expect_equal(detail$start1[7], 4)
  expect_equal(detail$start2[7], 7)

  detail <- rhyme_detail(c("you got bad blood", "and it's mad love"))
  expect_equal(detail$rhyme_length[7], 2)
  expect_equal(detail$start1[7], 3)
  expect_equal(detail$start2[7], 6)

  # single vowel rhymes are ignored by default
  expect_equal(rhyme_detail(c("night", "light"))$rhyme_length, c(0, 0))
  expect_equal(
    rhyme_detail(c("night", "light"), min_length = 1)$rhyme_length,
    c(0, 1)
  )

  # identical words don't rhyme
  expect_equal(rhyme_detail("love love")$rhyme_length, c(0, 0))
  expect_equal(
    rhyme_detail(c("cold as you", "so as to"))$rhyme_length,
    rep(0, 6)
  )

  # rhymes must be within the lookback window
  lines <- c("bad blood one two three four five six", "mad love")
  expect_equal(max(rhyme_detail(lines, lookback = 3)$rhyme_length), 0)
  expect_equal(max(rhyme_detail(lines, lookback = 15)$rhyme_length), 2)
})

test_that("character vectors are analyzed", {
  res <- analyze_rhymes(
    "Cause, baby, now we got bad blood\nYou know it used to be mad love"
  )
  expect_s3_class(res, "tbl_df")
  expect_equal(
    names(res),
    c(
      "text",
      "n_words",
      "total_rhymes",
      "unique_rhymes",
      "rhyme_density",
      "longest_rhyme_length",
      "longest_rhyme"
    )
  )
  expect_equal(res$n_words, 15)
  expect_equal(res$total_rhymes, 1)
  expect_equal(res$unique_rhymes, 1)
  expect_equal(res$rhyme_density, 2 / 14)
  expect_equal(res$longest_rhyme_length, 2)
  expect_equal(res$longest_rhyme, "bad blood / mad love")

  # repeated rhymes are only unique once
  text <- "bad blood\nmad love\nbad blood\nmad love"
  res <- analyze_rhymes(text, remove_duplicates = FALSE)
  expect_equal(res$total_rhymes, 5)
  expect_equal(res$unique_rhymes, 2)
  expect_equal(analyze_rhymes(text)$total_rhymes, 1)

  # multiple songs, including missing lyrics
  res <- analyze_rhymes(c("bad blood\nmad love", NA, "", "night\nlight", "the"))
  expect_equal(nrow(res), 5)
  expect_equal(res$total_rhymes, c(1, NA, NA, 0, 0))
  expect_equal(res$rhyme_density, c(2 / 3, NA, NA, 0, 0))
  expect_equal(
    res$longest_rhyme,
    c("bad blood / mad love", NA, NA, NA, NA)
  )
})

test_that("data frames are analyzed", {
  songs <- taylor_album_songs[1:3, ]
  songs$lyrics[2] <- list(NULL)
  songs$lyrics[3] <- list(songs$lyrics[[3]][0, ])

  res <- analyze_rhymes(songs)
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 3)
  expect_equal(names(res)[seq_along(songs)], names(songs))
  expect_equal(res$track_name, songs$track_name)
  expect_false(is.na(res$rhyme_density[1]))
  expect_true(all(is.na(res$rhyme_density[2:3])))

  # custom list-column
  lyric_text <- tibble::tibble(
    song = c("a", "b"),
    words = list(c("bad blood", "mad love"), NULL)
  )
  res <- analyze_rhymes(lyric_text, lyrics_col = "words")
  expect_equal(res$total_rhymes, c(1, NA))

  expect_snapshot(
    taylor_all_songs |>
      dplyr::filter(track_name %in% c("Tim McGraw", "Anti-Hero", "Karma")) |>
      analyze_rhymes() |>
      dplyr::select("track_name", "n_words":"longest_rhyme") |>
      as.data.frame()
  )
})

test_that("bad arguments error", {
  expect_error(analyze_rhymes(1:3), "character vector or data frame")
  expect_error(analyze_rhymes(taylor_albums), "list-column named")
  expect_error(analyze_rhymes("text", lookback = 0), "at least 1")
  expect_error(analyze_rhymes("text", lookback = "a"), "numeric")
  expect_error(analyze_rhymes("text", min_length = 0), "at least 1")
  expect_error(analyze_rhymes("text", remove_duplicates = "yes"), "logical")
  expect_error(analyze_rhymes("text", lyrics_col = 1), "character")
})
