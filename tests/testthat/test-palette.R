test_that("palette creation work", {
  expect_snapshot(error = TRUE, {
    color_palette(c("firetruck", "ocean"))
    color_palette(c("#00ZVPQ", "#IOBNOB"))
    color_palette(c("#00ZVPQ", "red"))
  })

  wjake_colors <- c("#009fb7", "#fed766")
  wjake_palette <- color_palette(wjake_colors)
  wjake_big_palette <- color_palette(wjake_palette, n = 10)
  wjake_small_palette <- color_palette(wjake_big_palette, n = 5)
  expect_s3_class(wjake_palette,
                  c("taylor_color_palette", "vctrs_vctr", "character"))
  expect_s3_class(wjake_big_palette,
                  c("taylor_color_palette", "vctrs_vctr", "character"))
  expect_s3_class(wjake_small_palette,
                  c("taylor_color_palette", "vctrs_vctr", "character"))
  expect_equal(length(wjake_palette), 2L)
  expect_equal(length(wjake_big_palette), 10L)
  expect_equal(length(wjake_small_palette), 5L)
  expect_equal(c(`#009fb7` = "#009fb7", `#fed766` = "#fed766"),
               vec_cast(wjake_palette, character()))
  expect_equal(n_colors(wjake_palette), 2)
  expect_equal(n_colors(wjake_big_palette), 10)
  expect_equal(n_colors(wjake_small_palette), 5)

  expect_true(is_color_palette(wjake_palette))
  expect_true(is_color_palette(wjake_big_palette))
  expect_true(is_color_palette(wjake_small_palette))
  expect_false(is_color_palette(wjake_colors))
})

test_that("palette is named", {
  col1 <- c("wheat", "firebrick", "navy")
  col2 <- c("#009fb7", "#fed766", "#696773")
  col3 <- c("goldenrod", "#85898a")
  col4 <- c(ku_blue = "#0051ba", ku_crimson = "#e8000d", "#ffc82d")

  pal1 <- color_palette(col1)
  pal2 <- color_palette(col2)
  pal3 <- color_palette(col3)
  pal4 <- color_palette(col4)

  expect_identical(names(pal1), c("wheat", "firebrick", "navy"))
  expect_identical(names(pal2), c("#009fb7", "#fed766", "#696773"))
  expect_identical(names(pal3), c("goldenrod", "#85898a"))
  expect_identical(names(pal4), c("ku_blue", "ku_crimson", "#ffc82d"))
})

test_that("casting and coercion work", {
  wjake_colors <- c("#009fb7", "#fed766")
  wjake_names <- c(`#009fb7` = "#009fb7", `#fed766` = "#fed766")
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
                   c(`#009fb7` = "#009fb7", `#fed766` = "#fed766", "#009fb7"))

  ## what are these calling?
  expect_type(c("#009fb7", wjake_palette), "character")
  expect_identical(c("#009fb7", wjake_palette),
                   c("#009fb7", `#009fb7` = "#009fb7", `#fed766` = "#fed766"))

  expect_identical(vec_ptype2(color_palette(), character()), character())
  expect_identical(vec_ptype2(character(), color_palette()), character())
  expect_identical(vec_ptype2(color_palette(), color_palette()),
                   color_palette())

  # casting
  expect_identical(vec_cast(wjake_palette, character()), wjake_names)
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
  df1 <- tibble::tibble(
    red = album_palettes$red,
    evermore = album_palettes$evermore
  )
  expect_snapshot(df1)

  expect_snapshot(album_palettes$lover)
  expect_snapshot(album_palettes$folklore)

  col1 <- c("wheat", "firebrick", "navy")
  col2 <- c("#009fb7", "#fed766", "#696773")
  col3 <- c("goldenrod", "#85898a")
  col4 <- c(ku_blue = "#0051ba", ku_crimson = "#e8000d", "#ffc82d")

  expect_snapshot({
    color_palette(col1)
    color_palette(col2)
    color_palette(col3)
    color_palette(col4)
  })
})
