# Checkers ---------------------------------------------------------------------
abort_bad_argument <- function(arg,
                               must,
                               not = NULL,
                               info = NULL,
                               call = rlang::caller_env(),
                               .envir = parent.frame()) {
  if (is.null(not)) {
    msg <- "{.arg {arg}} must {must}"
  } else {
    msg <- "{.arg {arg}} must {must}; not {not}"
  }

  # Format info message based on caller's environment.
  if (!is.null(info)) {
    info <- cli::format_message(info, .envir = .envir)
  }


  cli::cli_abort(
    class = "error_bad_argument",
    message = c(msg, info),
    arg = arg,
    must = must,
    not = not,
    call = call
  )
}

check_palette <- function(x, name) {
  if (!is.character(x)) {
    abort_bad_argument(name, must = "be a character vector", not = typeof(x))
  }

  # make sure no missing values present
  if (anyNA(x)) {
    abort_bad_argument(name, must = "not contain missing values")
  }

  # look for R color specifications
  new_x <- x
  r_colors <- which(new_x %in% grDevices::colors())
  if (length(r_colors) > 0) {
    r_hex <- sapply(x[r_colors], function(.x) {
      r_rgb <- grDevices::col2rgb(.x)
      grDevices::rgb(red = r_rgb["red", 1], green = r_rgb["green", 1],
                     blue = r_rgb["blue", 1], maxColorValue = 255)
    })
    new_x[r_colors] <- r_hex
  }

  # make sure strings are valid hex codes
  valid_hex <- grepl("^#(?:[0-9a-fA-F]{6,8}){1}$", new_x)
  if (!all(valid_hex)) {
    abort_bad_argument(
      name,
      must = "be valid hexadecimal values or from `colors()`.",
      info = c(i = "Problematic value{?s}: {.val {x[!valid_hex]}}.")
    )
  }

  if (is.null(names(x))) {
    names(new_x) <- x
  } else {
    missing_nms <- which(names(x) == "")
    names(new_x)[missing_nms] <- x[missing_nms]
  }

  return(new_x)
}

check_pos_int <- function(x, name) {
  if (!is.numeric(x)) {
    abort_bad_argument(name, must = "be numeric", not = typeof(x))
  }

  if (length(x) != 1) {
    abort_bad_argument(name, must = "have length of 1", not = length(x))
  }
  x <- as.integer(x)

  if (is.na(x)) {
    abort_bad_argument(name, must = "be non-missing")
  } else if (x < 0) {
    abort_bad_argument(name, must = "be greater than 0")
  } else {
    x
  }
}

check_real_range <- function(x, name, lb, ub) {
  if (!is.numeric(x)) {
    abort_bad_argument(name, must = "be numeric", not = typeof(x))
  }

  if (length(x) != 1) {
    abort_bad_argument(name, must = "have length of 1", not = length(x))
  }

  if (is.na(x)) {
    abort_bad_argument(name, must = "be non-missing")
  } else if (x < lb || x > ub) {
    abort_bad_argument(name, must = cli::format_inline("be between {lb} and {ub}"))
  } else {
    x
  }
}

check_exact_abs_int <- function(x, name, value) {
  if (!is.numeric(x)) {
    abort_bad_argument(name, must = "be numeric", not = typeof(x))
  }

  if (length(x) != 1) {
    abort_bad_argument(name, must = "have length of 1", not = length(x))
  }
  x <- as.integer(x)

  if (is.na(x)) {
    abort_bad_argument(name, must = "be non-missing")
  } else if (abs(x) != value) {
    abort_bad_argument(name, must = cli::format_inline("be {value} or -{value}"))
  } else {
    x
  }
}

check_character <- function(x, name) {
  if (!is.character(x)) {
    abort_bad_argument(name, must = "be character", not = typeof(x))
  }

  if (is.na(x)) {
    abort_bad_argument(name, must = "be non-missing")
  }
  x
}
