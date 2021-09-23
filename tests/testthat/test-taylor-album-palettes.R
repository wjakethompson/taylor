test_that("palettes have expected length", {
  noep <- subset(taylor_albums, !ep)

  expect_equal(nrow(noep), length(album_palettes))
  expect_equal(nrow(noep), length(album_compare))
  expect_equal(length(album_palettes), length(album_compare))

  expect_equal(length(album_levels), nrow(noep))
  expect_equal(length(album_levels), length(album_palettes))
  expect_equal(length(album_levels), length(album_compare))

  # all album palettes contain 5 colors
  expect_true(all(lapply(album_palettes, length) == 5))

  # all album compare colors are in their respective full palette
  expect_true(
    all(mapply(function(x, y) {
      x %in% y
    },
               album_compare, album_palettes)))

  # palette and factor names
  short_names <- tolower(album_levels)
  short_names <- gsub("\\ ", "_", short_names)
  short_names <- gsub("\\(taylor's_version\\)", "tv", short_names)

  expect_identical(sort(album_levels), sort(noep$album_name))
  expect_identical(short_names, names(album_palettes))
  expect_identical(short_names, names(album_compare))
  expect_identical(names(album_palettes), names(album_compare))
})

test_that("we get errors", {
  expect_error(taylor_col(5, begin = -1), "between 0 and 1")
  expect_error(taylor_col(5, begin = 2), "between 0 and 1")
  expect_error(taylor_col(5, end = -1), "between 0 and 1")
  expect_error(taylor_col(5, end = 2), "between 0 and 1")

  expect_error(taylor_col(5, direction = 2), "be 1 or -1")
  expect_error(taylor_col(5, direction = -3), "be 1 or -1")
})

test_that("no colors works", {
  expect_identical(taylor_col(n = 0), character())
  expect_identical(taylor_col(n = 0, album = "evermore"), character())
})

test_that("direction works", {
  dir1 <- taylor_col(5)
  expect_identical(taylor_col(5, direction = -1), rev(dir1))

  dir2 <- taylor_col(10, album = "Red")
  expect_identical(taylor_col(10, direction = -1, album = "Red"), rev(dir2))
})

test_that("bad album warns", {
  expect_warning(taylor_col(5, album = "sour"), "does not exist")
  expect_warning(
    expect_identical(taylor_col(5, album = "sour"),
                     taylor_col(5, album = "Lover"))
  )
})

test_that("we get expected values", {
  expect_identical(taylor_col(5),
                   paste0(vec_cast(album_palettes$lover, character()), "FF"))

  expect_identical(taylor_col(5, album = "folklore"),
                   paste0(vec_cast(album_palettes$folklore, character()), "FF"))
})
