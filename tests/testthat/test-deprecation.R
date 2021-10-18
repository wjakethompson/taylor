test_that("type is deprecated", {
  err <- rlang::catch_cnd(color_palette(c("#009fb7", "#fed766"),
                                        type = "discrete"))
  expect_equal(err$arg, "type")
  expect_match(err$message, "is deprecated")
  expect_equal(err$stage, "deprecated")
  expect_equal(err$package, "lifecycle")

  err <- rlang::catch_cnd(color_palette(c("#009fb7", "#fed766"),
                                        type = "continuous"))
  expect_equal(err$arg, "type")
  expect_match(err$message, "is deprecated")
  expect_equal(err$stage, "deprecated")
  expect_equal(err$package, "lifecycle")
})
