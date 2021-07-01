test_that("data checks work", {
  # check palette --------------------------------------------------------------
  err <- rlang::catch_cnd(check_palette(2, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "character")
  expect_equal(err$not, "double")

  err <- rlang::catch_cnd(check_palette(NA_character_, "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "missing values")

  err <- rlang::catch_cnd(check_palette(c("#009fb7", "red"), "test_arg"))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "valid hexadecimal values")

  expect_identical(check_palette(c("#009fb7", "#fed766"), name = "test_arg"),
                   c("#009fb7", "#fed766"))
  expect_identical(check_palette(c("#009fb700", "#fed766ff"),
                                 name = "test_arg"),
                   c("#009fb700", "#fed766ff"))

  # check n --------------------------------------------------------------------
  err <- rlang::catch_cnd(check_n_range("a", "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "numeric")
  expect_equal(err$not, "character")

  err <- rlang::catch_cnd(check_n_range(NA_integer_, "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "non-missing")

  err <- rlang::catch_cnd(check_n_range(integer(), "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 0)

  err <- rlang::catch_cnd(check_n_range(c(2:3), "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "length of 1")
  expect_equal(err$not, 2)

  err <- rlang::catch_cnd(check_n_range(6, "test_arg", 1, 5))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "between 1 and 5")

  err <- rlang::catch_cnd(check_n_range(-1, "test_arg", 1, Inf))
  expect_s3_class(err, "error_bad_argument")
  expect_equal(err$arg, "test_arg")
  expect_match(err$message, "be at least 1")

  expect_identical(check_n_range(3, "test_arg", 1, 5), 3L)
  expect_identical(check_n_range(5L, "test_arg", 1, 5), 5L)
  expect_identical(check_n_range(10L, "test_arg", 1, Inf), 10L)
})

test_that("palette creation work", {
  expect_error(color_palette(c("red", "blue")), "hexadecimal")
  expect_error(color_palette(c("#990fb7", "#fed766"), n = 3, "jake"),
               'one of "discrete" or "continuous"')
  expect_error(color_palette(c("#990fb7", "#fed766"), n = 3), "1 and 2")

  wjake_colors <- c("#009fb7", "#fed766")
  wjake_palette <- color_palette(wjake_colors)
  wjake_big_palette <- color_palette(wjake_palette, n = 10, type = "continuous")
  expect_s3_class(wjake_palette, "taylor_color_palette")
  expect_s3_class(wjake_big_palette, "taylor_color_palette")
  expect_equal(length(wjake_palette), 2L)
  expect_equal(length(wjake_big_palette), 10L)
  expect_equal(wjake_colors, vec_cast(wjake_palette, character()))
  expect_equal(n_colors(wjake_palette), 2)
  expect_equal(n_colors(wjake_big_palette), 10)

  expect_true(is_color_palette(wjake_palette))
  expect_true(is_color_palette(wjake_big_palette))
  expect_false(is_color_palette(wjake_colors))
})

test_that("casting and coercion work", {
  wjake_colors <- c("#009fb7", "#fed766")
  wjake_palette <- color_palette(wjake_colors)

  # combining 2 palettes returns a palette
  expect_identical(c(wjake_palette, album_palettes$red),
                   color_palette(c("#009fb7", "#fed766", "#A91E47", "#201F39",
                                   "#7E6358", "#B0A49A", "#DDD8C9")))

  # combining a color palette and character should always return a character
  expect_type(c(wjake_palette, "#009fb7"), "character")
  expect_identical(c(wjake_palette, "#009fb7"),
                   c("#009fb7", "#fed766", "#009fb7"))
  expect_type(c("#009fb7", wjake_palette), "character")
  expect_identical(c("#009fb7", wjake_palette),
                   c("#009fb7", "#009fb7", "#fed766"))

  # casting
  expect_identical(vec_cast(wjake_palette, character()), wjake_colors)
  expect_identical(vec_cast(wjake_colors, color_palette()), wjake_palette)
  expect_identical(vec_cast(wjake_palette, color_palette()), wjake_palette)
})

test_that("various formatting works", {
  verify_output(test_path("test-print-color-palette-tibble.txt"), {
    df1 <- tibble::tibble(red = album_palettes$red,
                          evermore = album_palettes$evermore)
    print(df1)
  })

  verify_output(test_path("test-print-color-palette.txt"), {
    print(album_palettes$lover)

    print(album_palettes$folklore)
  })
})
