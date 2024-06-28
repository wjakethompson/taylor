# Checkers ---------------------------------------------------------------------
abort_bad_argument <- function(arg, must = NULL, not = NULL, footer = NULL,
                               custom = NULL, call = rlang::caller_env()) {
  msg <- "{.arg {arg}} must {must}"
  if (!is.null(not)) {
    msg <- paste0(msg, "; not {not}")
  }
  if (!is.null(custom)) {
    msg <- custom
    footer <- NULL
  }

  cli::cli_abort(msg, footer = footer, call = call)
}

check_palette <- function(x, arg = rlang::caller_arg(x),
                          call = rlang::caller_env()) {
  if (!is.character(x)) {
    abort_bad_argument(arg = arg, must = "be a character vector",
                       not = typeof(x), call = call)
  }

  # make sure no missing values present
  if (anyNA(x) || !rlang::is_atomic(x)) {
    abort_bad_argument(arg = arg, must = "not contain missing values",
                       call = call)
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
      arg = arg,
      must = "be valid hexadecimal values or from `colors()`.",
      footer = cli::format_message(
        c(i = "Problematic value{?s}: {.val {x[!valid_hex]}}.")
      ),
      call = call
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

check_pos_int <- function(x, arg = rlang::caller_arg(x),
                          call = rlang::caller_env()) {
  if (!is.numeric(x)) {
    abort_bad_argument(arg = arg, must = "be numeric", not = typeof(x),
                       call = call)
  }

  if (length(x) != 1) {
    abort_bad_argument(arg = arg, must = "have length of 1", not = length(x),
                       call = call)
  }

  if (is.na(x)) {
    abort_bad_argument(arg = arg, must = "be non-missing", call = call)
  }
  x <- as.integer(x)

  if (x < 0) {
    abort_bad_argument(arg = arg, must = "be greater than 0", call = call)
  } else {
    x
  }
}

check_real_range <- function(x, lb, ub, arg = rlang::caller_arg(x),
                             call = rlang::caller_env()) {
  if (!is.numeric(x)) {
    abort_bad_argument(arg = arg, must = "be numeric", not = typeof(x),
                       call = call)
  }

  if (length(x) != 1) {
    abort_bad_argument(arg = arg, must = "have length of 1", not = length(x),
                       call = call)
  }

  if (is.na(x)) {
    abort_bad_argument(arg = arg, must = "be non-missing", call = call)
  } else if (x < lb || x > ub) {
    abort_bad_argument(arg = arg,
                       must = cli::format_inline("be between {lb} and {ub}"),
                       call = call)
  } else {
    x
  }
}

check_exact_abs_int <- function(x, value, arg = rlang::caller_arg(x),
                                call = rlang::caller_env()) {
  if (!is.numeric(x)) {
    abort_bad_argument(arg = arg, must = "be numeric", not = typeof(x),
                       call = call)
  }

  if (length(x) != 1) {
    abort_bad_argument(arg = arg, must = "have length of 1", not = length(x),
                       call = call)
  }

  if (is.na(x)) {
    abort_bad_argument(arg = arg, must = "be non-missing", call = call)
  }

  if (abs(x) != value) {
    abort_bad_argument(arg = arg,
                       must = cli::format_inline("be {value} or -{value}"),
                       call = call)
  } else {
    as.integer(x)
  }
}

check_character <- function(x, arg = rlang::caller_arg(x),
                            call = rlang::caller_env()) {
  if (!is.character(x)) {
    abort_bad_argument(arg = arg, must = "be character", not = typeof(x),
                       call = call)
  }

  if (is.na(x)) {
    abort_bad_argument(arg = arg, must = "be non-missing",
                       call = call)
  }
  x
}
