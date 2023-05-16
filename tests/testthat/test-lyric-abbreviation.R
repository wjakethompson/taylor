test_that("translation works", {
  atw <- tibble::tibble(
    track = c(
      "All Too Well (Taylor's Version)",
      "All Too Well (10 Minute Version) [Taylor's Version] [From The Vault]"
    ),
    line = "But you keep my old scarf from that very first week"
  )
  expect_equal(translate_bracelet("bykmosftvfw"),
               glue::glue_data(atw, "{track}: {line}\n\n"))

  expect_equal(translate_bracelet("kimbkiagkitbimhotw"),
               glue::glue("Karma: karma is my boyfriend Karma is a god Karma ",
                          "is the breeze in my hair on the weekend\n\n"))
})
