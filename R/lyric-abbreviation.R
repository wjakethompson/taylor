#' Translate a friendship bracelet
#'
#' Receive a friendship bracelet at the Eras Tour but can't figure out what
#' lyrics the bracelet has abbreviated? Now you can find out!
#'
#' @param abbr The abbreviated lyrics (i.e., the first letter of each word).
#'
#' @return A character vector with the name of the song and the abbreviated
#'   line.
#' @export
#'
#' @examples
#' translate_bracelet("bykmosftvfw")
#'
#' translate_bracelet("kimbkiagkitbimhotw")
translate_bracelet <- function(abbr) {
  abbr <- check_character(abbr, name = "abbr")

  lyric_abbr <- vapply(taylor::taylor_all_songs$lyrics,
                       function(.x) {
                         lines <-
                           vapply(.x$lyric,
                                  function(.y) {
                                    clean <- gsub("[^a-z ]", "", tolower(.y))
                                    words <- strsplit(clean, split = " ")
                                    letters <- strsplit(words[[1]], split = "")
                                    start <- vapply(letters,
                                                    function(.z) {
                                                      .z[1]
                                                    },
                                                    character(1))
                                    paste(start, collapse = "")
                                  },
                                  character(1))
                         paste(lines, collapse = "")
                       },
                       character(1))

  songs <- taylor::taylor_all_songs[grep(abbr, lyric_abbr),
                                    c("album_name", "track_name", "lyrics")]

  songs$line <- vapply(songs$lyrics,
                       function(.x, abbr) {
                         words <- strsplit(paste(.x$lyric, collapse = " "),
                                           " ")[[1]]
                         letters <- vapply(words,
                                           function(.y) {
                                             clean <- gsub("[^a-z ]", "",
                                                           tolower(.y))
                                             word_letters <- strsplit(clean, "")
                                             start <- vapply(word_letters,
                                                             function(.z) {
                                                               .z[1]
                                                             },
                                                             character(1))
                                             return(start)
                                           },
                                           character(1))
                         full_string <- paste(letters, collapse = "")
                         position <- regexpr(abbr, full_string)

                         paste(words[position:(position + nchar(abbr) - 1)],
                               collapse = " ")
                       },
                       character(1),
                       abbr = abbr)

  if (any(grepl("Taylor's Version", songs$track_name))) {
    songs <- songs[grepl("Taylor's Version", songs$track_name), ]
  }

  glue::glue_data(songs,
                  "{track_name}: {line}\n\n")
}
