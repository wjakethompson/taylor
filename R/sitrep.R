#' Situation report for APIs
#'
#' Something...
#'
#' @export
#' @examplesIf taylor_examples()
#' taylor_sitrep()
taylor_sitrep <- function() {
  cli::cli_h1("taylor Situation Report")

  display_heading("Spotify Configuration")
  display_status("SPOTIFY_CLIENT_ID", name = "Client ID")
  display_status("SPOTIFY_CLIENT_SECRET", name = "Client Secret", n = NULL)

  display_heading("SoundStat Configuration")
  display_status("SOUNDSTAT_KEY", name = "API Key")
}


has_key <- function(key) {
  nzchar(Sys.getenv(key))
}

display_key <- function(key, n = 6) {
  cli::format_message("{.strong {substr(Sys.getenv(key), 1, n)}}...")
}

display_status <- function(key, name, n = 6) {
  if (has_key(key) && !is.null(n)) {
    cli::cli_alert_success("{name}: {display_key(key, n = n)}")
  } else if (has_key(key) && is.null(n)) {
    cli::cli_alert_success("{name}: {.strong Found}")
  } else {
    cli::cli_alert_danger("{name}: {.strong Not found}")
  }
}

display_heading <- function(text) {
  cli::cli_div(theme = list(h2 = list(`margin-bottom` = 0)))
  cli::cli_h2(text)
  cli::cli_end()
}
