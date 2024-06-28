test_that("abort_bad_argument", {
  err <- rlang::catch_cnd(abort_bad_argument("size", must = "be an integer",
                                             call = rlang::caller_env()))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be an integer")

  err <- rlang::catch_cnd(abort_bad_argument("size", must = "be an integer",
                                             not = "character",
                                             call = rlang::caller_env()))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be an integer; not character")

  err <- rlang::catch_cnd(abort_bad_argument("size", must = "be an integer",
                                             extra = "please",
                                             call = rlang::caller_env()))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be an integer")
  expect_match(err$body, "please")

  err <- rlang::catch_cnd(abort_bad_argument("size", must = "be an integer",
                                             not = "character",
                                             extra = "required",
                                             call = rlang::caller_env()))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "be an integer; not character")
  expect_match(err$body, "required")

  err <- rlang::catch_cnd(abort_bad_argument("size", must = "be an integer",
                                             not = "character",
                                             extra = "required",
                                             custom = "A new error",
                                             call = rlang::caller_env()))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "A new error")
})

test_that("check palette works", {
  x <- 2
  err <- rlang::catch_cnd(check_palette(x))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`x` must be a character vector; not double")

  x <- NA_character_
  err <- rlang::catch_cnd(check_palette(x))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`x` must not contain missing values")

  x <- c("#009fb7", "firetruck")
  err <- rlang::catch_cnd(check_palette(x))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "valid hexadecimal values")

  expect_identical(check_palette(c("#009fb7", "#fed766")),
                   c(`#009fb7` = "#009fb7", `#fed766` = "#fed766"))
  expect_identical(check_palette(c("#009fb700", "#fed766ff")),
                   c(`#009fb700` = "#009fb700", `#fed766ff` = "#fed766ff"))
  expect_identical(check_palette(c("firebrick", "goldenrod", "navy")),
                   c(firebrick = "#B22222", goldenrod = "#DAA520",
                     navy = "#000080"))
  expect_identical(check_palette(c("firebrick", "#009fb7", "#FED766")),
                   c(firebrick = "#B22222", `#009fb7` = "#009fb7",
                     `#FED766` = "#FED766"))
})

test_that("check positive integer works", {
  blue <- "blue"
  err <- rlang::catch_cnd(check_pos_int(blue))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`blue` must be numeric; not character")

  taylor <- NA_integer_
  err <- rlang::catch_cnd(check_pos_int(taylor))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`taylor` must be non-missing")

  test <- integer()
  err <- rlang::catch_cnd(check_pos_int(test))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`test` must have length of 1; not 0")

  test <- c(2:3)
  err <- rlang::catch_cnd(check_pos_int(test))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "test` must have length of 1; not 2")

  err <- rlang::catch_cnd(check_pos_int(-2))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "greater than 0")

  expect_identical(check_pos_int(0), 0L)
  expect_identical(check_pos_int(3), 3L)
  expect_identical(check_pos_int(5L), 5L)
  expect_identical(check_pos_int(10L), 10L)
})

test_that("real range works", {
  taylor <- "a"
  err <- rlang::catch_cnd(check_real_range(taylor, 0, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`taylor` must be numeric; not character")

  travis <- NA_integer_
  err <- rlang::catch_cnd(check_real_range(travis, 1, 5))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`travis` must be non-missing")

  meredith <- integer()
  err <- rlang::catch_cnd(check_real_range(meredith, 1, 5))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`meredith` must have length of 1; not 0")

  olivia <- c(2:3)
  err <- rlang::catch_cnd(check_real_range(olivia, 1, 5))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`olivia` must have length of 1; not 2")

  benjamin <- 2
  err <- rlang::catch_cnd(check_real_range(benjamin, 0, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`benjamin` must be between 0 and 1")

  benjamin <- -1
  err <- rlang::catch_cnd(check_real_range(benjamin, 0, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`benjamin` must be between 0 and 1")

  expect_identical(check_real_range(0, 0, 1), 0)
  expect_identical(check_real_range(1, 0, 1), 1)
  expect_identical(check_real_range(0.5, 0, 1), 0.5)
})

test_that("check abs value of exact integer works", {
  taylor <- "a"
  err <- rlang::catch_cnd(check_exact_abs_int(taylor, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`taylor` must be numeric; not character")

  travis <- NA_integer_
  err <- rlang::catch_cnd(check_exact_abs_int(travis, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`travis` must be non-missing")

  meredith <- integer()
  err <- rlang::catch_cnd(check_exact_abs_int(meredith, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`meredith` must have length of 1; not 0")

  olivia <- c(2:3)
  err <- rlang::catch_cnd(check_exact_abs_int(olivia, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`olivia` must have length of 1; not 2")

  benjamin <- 3
  err <- rlang::catch_cnd(check_exact_abs_int(benjamin, 1))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`benjamin` must be 1 or -1")

  benjamin <- 3
  err <- rlang::catch_cnd(check_exact_abs_int(benjamin, 4))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`benjamin` must be 4 or -4")

  expect_identical(check_exact_abs_int(1, 1), 1L)
  expect_identical(check_exact_abs_int(-1, 1), -1L)
  expect_identical(check_exact_abs_int(1L, 1), 1L)
  expect_identical(check_exact_abs_int(-1L, 1), -1L)
})

test_that("character works", {
  taylor <- 1
  err <- rlang::catch_cnd(check_character(taylor))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`taylor` must be character; not double")

  travis <- NA_character_
  err <- rlang::catch_cnd(check_character(travis))
  expect_s3_class(err, "rlang_error")
  expect_match(err$message, "`travis` must be non-missing")

  expect_identical(check_character("string", "test_arg"), "string")
  expect_identical(check_character("String", "test_arg"), "String")
  expect_identical(check_character("STRING", "test_arg"), "STRING")
})
