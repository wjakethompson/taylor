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

  krm <- tibble::tibble(
    track = c("Karma", "Karma (Remix)"),
    line = paste0("karma is my boyfriend Karma is a god Karma is the breeze ",
                  "in my hair on the weekend")
  )
  expect_equal(translate_bracelet("kimbkiagkitbimhotw"),
               glue::glue_data(krm, "{track}: {line}\n\n"))

  expect_equal(translate_bracelet("ymtotcd"),
               glue::glue("champagne problems: Your Midas touch on the ",
                          "Chevy door\n\n"))
})
