test_that("palette creation work", {
  expect_error(color_palette(c("firetruck", "ocean")), "hexadecimal")
  expect_error(color_palette(c("#00ZVPQ", "#IOBNOB")), "hexadecimal")
  expect_error(color_palette(c("#00ZVPQ", "red")), "hexadecimal")
  expect_error(color_palette(c("#990fb7", "#fed766"), n = 3, "jake"),
               'one of "discrete" or "continuous"')
  expect_error(color_palette(c("#990fb7", "#fed766"), n = 3), "1 and 2")

  wjake_colors <- c("#009fb7", "#fed766")
  wjake_palette <- color_palette(wjake_colors)
  wjake_big_palette <- color_palette(wjake_palette, n = 10, type = "continuous")
  expect_s3_class(wjake_palette,
                  c("taylor_color_palette", "vctrs_vctr", "character"))
  expect_s3_class(wjake_big_palette,
                  c("taylor_color_palette", "vctrs_vctr", "character"))
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
                   color_palette(c("#009fb7", "#fed766", "#201F39", "#A91E47",
                                   "#7E6358", "#B0A49A", "#DDD8C9")))
  expect_s3_class(c(wjake_palette, album_palettes$red),
                  c("taylor_color_palette", "vctrs_vctr", "character"),
                  exact = TRUE)

  # combining a color palette and character should always return a character
  ## these two are calling vec_ptype2.taylor_color_palette.character
  expect_type(c(wjake_palette, "#009fb7"), "character")
  expect_identical(c(wjake_palette, "#009fb7"),
                   c("#009fb7", "#fed766", "#009fb7"))

  ## what are these calling?
  expect_type(c("#009fb7", wjake_palette), "character")
  expect_identical(c("#009fb7", wjake_palette),
                   c("#009fb7", "#009fb7", "#fed766"))

  expect_identical(vec_ptype2(color_palette(), character()), character())
  expect_identical(vec_ptype2(character(), color_palette()), character())
  expect_identical(vec_ptype2(color_palette(), color_palette()),
                   color_palette())

  # casting
  expect_identical(vec_cast(wjake_palette, character()), wjake_colors)
  expect_identical(vec_cast(wjake_colors, color_palette()), wjake_palette)
  expect_identical(vec_cast(wjake_palette, color_palette()), wjake_palette)

  # bad combos
  expect_error(vec_c(wjake_palette, 1L),
               class = "vctrs_error_incompatible_type")
  expect_error(vec_c(wjake_palette, 1.0),
               class = "vctrs_error_incompatible_type")
  expect_error(vec_ptype2(color_palette(), double()),
               class = "vctrs_error_incompatible_type")
  expect_error(vec_ptype2(color_palette(), integer()),
               class = "vctrs_error_incompatible_type")
  expect_error(vec_ptype2(color_palette(), logical()),
               class = "vctrs_error_incompatible_type")
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
