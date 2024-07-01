test_that("capitalization works", {
  expect_snapshot(error = TRUE, {
    title_case(2)
    title_case(NA_character_)
  })

  expect_identical(title_case("taylor swift"), "Taylor Swift")
  expect_identical(title_case("TAYLOR SWIFT"), "Taylor Swift")
  expect_identical(title_case(c("fearless", "red", "1989")),
                   c("Fearless", "Red", "1989"))
  expect_identical(title_case("fearless (taylor's version)"),
                   "Fearless (Taylor's Version)")
  expect_identical(title_case("taylor-swift"), "Taylor-swift")
})
