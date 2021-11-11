test_that("check palette works", {
  err <- rlang::catch_cnd(check_palette(2, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "character")
  expect_equal(err$not, "double")

  err <- rlang::catch_cnd(check_palette(NA_character_, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "missing values")

  err <- rlang::catch_cnd(check_palette(c("#009fb7", "firetruck"), "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "valid hexadecimal values")

  expect_identical(check_palette(c("#009fb7", "#fed766"), name = "test_arg"),
                   c(`#009fb7` = "#009fb7", `#fed766` = "#fed766"))
  expect_identical(check_palette(c("#009fb700", "#fed766ff"),
                                 name = "test_arg"),
                   c(`#009fb700` = "#009fb700", `#fed766ff` = "#fed766ff"))
  expect_identical(check_palette(c("firebrick", "goldenrod", "navy"),
                                 name = "test_arg"),
                   c(firebrick = "#B22222", goldenrod = "#DAA520",
                     navy = "#000080"))
  expect_identical(check_palette(c("firebrick", "#009fb7", "#FED766"),
                                 name = "test_arg"),
                   c(firebrick = "#B22222", `#009fb7` = "#009fb7",
                     `#FED766` = "#FED766"))
})

test_that("check positive integer works", {
  err <- rlang::catch_cnd(check_pos_int("a", "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "numeric")
  expect_equal(err$not, "character")

  err <- rlang::catch_cnd(check_pos_int(NA_integer_, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "non-missing")

  err <- rlang::catch_cnd(check_pos_int(integer(), "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 0)

  err <- rlang::catch_cnd(check_pos_int(c(2:3), "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 2)

  err <- rlang::catch_cnd(check_pos_int(-2, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "greater than 0")

  expect_identical(check_pos_int(0, "test_arg"), 0L)
  expect_identical(check_pos_int(3, "test_arg"), 3L)
  expect_identical(check_pos_int(5L, "test_arg"), 5L)
  expect_identical(check_pos_int(10L, "test_arg"), 10L)
})

test_that("real range works", {
  err <- rlang::catch_cnd(check_real_range("a", "test_arg", 0, 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "numeric")
  expect_equal(err$not, "character")

  err <- rlang::catch_cnd(check_real_range(NA_integer_, "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "non-missing")

  err <- rlang::catch_cnd(check_real_range(integer(), "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 0)

  err <- rlang::catch_cnd(check_real_range(c(2:3), "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 2)

  err <- rlang::catch_cnd(check_real_range(2, "test_arg", 0, 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "between 0 and 1")

  err <- rlang::catch_cnd(check_real_range(-1, "test_arg", 0, 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "between 0 and 1")

  expect_identical(check_real_range(0, "test_arg", 0, 1), 0)
  expect_identical(check_real_range(1, "test_arg", 0, 1), 1)
  expect_identical(check_real_range(0.5, "test_arg", 0, 1), 0.5)
})

test_that("check abs value of exact integer works", {
  err <- rlang::catch_cnd(check_exact_abs_int("a", "test_arg", 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "numeric")
  expect_equal(err$not, "character")

  err <- rlang::catch_cnd(check_exact_abs_int(NA_integer_, "test_arg", 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "non-missing")

  err <- rlang::catch_cnd(check_exact_abs_int(integer(), "test_arg", 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 0)

  err <- rlang::catch_cnd(check_exact_abs_int(c(2:3), "test_arg", 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 2)

  err <- rlang::catch_cnd(check_exact_abs_int(3, "test_arg", 1))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "be 1 or -1")

  err <- rlang::catch_cnd(check_exact_abs_int(3, "test_arg", 4))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "be 4 or -4")

  expect_identical(check_exact_abs_int(1, "test_arg", 1), 1L)
  expect_identical(check_exact_abs_int(-1, "test_arg", 1), -1L)
  expect_identical(check_exact_abs_int(1L, "test_arg", 1), 1L)
  expect_identical(check_exact_abs_int(-1L, "test_arg", 1), -1L)
})

test_that("character works", {
  err <- rlang::catch_cnd(check_character(1, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "character")
  expect_equal(err$not, "double")

  err <- rlang::catch_cnd(check_character(NA_character_, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "non-missing")

  expect_identical(check_character("string", "test_arg"), "string")
  expect_identical(check_character("String", "test_arg"), "String")
  expect_identical(check_character("STRING", "test_arg"), "STRING")
})
