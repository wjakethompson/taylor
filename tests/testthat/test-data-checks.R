test_that("abort_bad_argument() is informative.", {
  expect_error(
    abort_bad_argument("size", "be an integer"),
    regexp = "be an integer",
    class = "rlang_error"
  )
  expect_snapshot(error = TRUE, {
    abort_bad_argument("size", "be an integer", not = "character")
    abort_bad_argument("size", must = "be an integer", not = "character",
                       footer = c(i = "please"))
    abort_bad_argument("size", must = "be an integer", not = "character",
                       footer = "required", custom = "A new error")
  })
})

test_that("abort_bad_argument() can add inline markup to footer", {
  expect_snapshot(error = TRUE, {
    a_local_variable <- "local var"
    footer <- cli::format_message(c("x" = "Look at {.val {a_local_variable}}"))
    abort_bad_argument("size", "be an integer", footer = footer)
  })
})


test_that("check_palette() throws informative error.", {
  expect_snapshot(error = TRUE, {
    check_palette(2)
    check_palette(NA_character_)
  })

  expect_snapshot(error = TRUE, {
    x <- c("#009fb7", "firetruck")
    check_palette(x)
  })
})

test_that("check_palette() works", {
  expect_identical(
    check_palette(c("#009fb7", "#fed766")),
    c(`#009fb7` = "#009fb7", `#fed766` = "#fed766")
  )
  expect_identical(
    check_palette(c("#009fb700", "#fed766ff")),
    c(`#009fb700` = "#009fb700", `#fed766ff` = "#fed766ff")
  )
  expect_identical(
    check_palette(c("firebrick", "goldenrod", "navy")),
    c(
      firebrick = "#B22222", goldenrod = "#DAA520",
      navy = "#000080"
    )
  )
  expect_identical(
    check_palette(c("firebrick", "#009fb7", "#FED766")),
    c(
      firebrick = "#B22222", `#009fb7` = "#009fb7",
      `#FED766` = "#FED766"
    )
  )
})

test_that("check_pos_int() errors well", {
  expect_snapshot(error = TRUE, {
    check_pos_int("blue")
    check_pos_int(NA_integer_, "taylor")
    check_pos_int(integer(0L))
    check_pos_int(2:3)
    check_pos_int(-2)
  })
})

test_that("check positive integer works", {
  expect_identical(check_pos_int(0), 0L)
  expect_identical(check_pos_int(3), 3L)
  expect_identical(check_pos_int(5L), 5L)
  expect_identical(check_pos_int(10L), 10L)
})

test_that("check_real_range() works", {
  expect_snapshot(error = TRUE, {
    check_real_range("a", 0, 1, "taylor")
    check_real_range(NA_integer_, 1, 5)
    check_real_range(integer(0L), 1, 5)
    check_real_range(2:3, 0, 1)
    check_real_range(2, 0, 1)
    check_real_range(-1, 0, 1)
  })
})

test_that("real range works", {
  expect_identical(check_real_range(0, 0, 1), 0)
  expect_identical(check_real_range(1, 0, 1), 1)
  expect_identical(check_real_range(0.5, 0, 1), 0.5)
})

test_that("check_exact_abs_int() errors well", {
  expect_snapshot(error = TRUE, {
    check_exact_abs_int("a", 1)
    check_exact_abs_int(NA_integer_, 1)
    check_exact_abs_int(integer(0), 1)
    check_exact_abs_int(2:3, 1)
    check_exact_abs_int(3, 1)
    check_exact_abs_int(3, 4)
  })
})

test_that("check abs value of exact integer works", {
  expect_identical(check_exact_abs_int(1, 1), 1L)
  expect_identical(check_exact_abs_int(-1, 1), -1L)
  expect_identical(check_exact_abs_int(1L, 1), 1L)
  expect_identical(check_exact_abs_int(-1L, 1), -1L)
})

test_that("check_character() errors well", {
  expect_snapshot(error = TRUE, {
    check_character(1, arg = "taylor")
    check_character(NA_character_)
  })
})

test_that("character works", {
  expect_identical(check_character("string", "test_arg"), "string")
  expect_identical(check_character("String", "test_arg"), "String")
  expect_identical(check_character("STRING", "test_arg"), "STRING")
})
