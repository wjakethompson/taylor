#' Convert string to title case
#'
#' Capitalize the first letter of each word, and convert the remaining string to
#' lower case.
#'
#' @param string String to modify.
#'
#' @return A character string with the first letter of each word capitalized.
#' @export
#'
#' @examples
#' title_case("taylor swift")
#' title_case("Taylor Swift")
#' title_case("TAYLOR SWIFT")
title_case <- function(string) {
  string <- check_character(string, name = "string")

  string <- tolower(string)
  s <- strsplit(string, " ")[[1]]

  ret <- paste(sub("\\b([a-z])", "\\U\\1", s, perl = TRUE),
               sep = "", collapse = " ")
  return(ret)
}
title_case <- Vectorize(title_case, USE.NAMES = FALSE)
