# Checkers ---------------------------------------------------------------------
abort_bad_argument <- function(arg, must, not = NULL) {
  msg <- glue::glue("`{arg}` must {must}")
  if (!is.null(not)) {
    msg <- glue::glue("{msg}; not {not}")
  }

  rlang::abort("error_bad_argument",
               message = msg,
               arg = arg,
               must = must,
               not = not)
}

check_palette <- function(x, name) {
  if (!is.character(x)) {
    abort_bad_argument(name, must = "be a character vector", not = typeof(x))
  }

  # make sure no missing values present
  if (any(rlang::are_na(x))) {
    abort_bad_argument(name, must = "not contain missing values")
  }

  # make sure strings are valid hex codes
  valid_hex <- grepl("^#(?:[0-9a-fA-F]{6,8}){1}$", x)
  if (!all(valid_hex)) {
    bad_val <- x[!valid_hex]
    abort_bad_argument(name,
                       must = glue::glue("be valid hexadecimal values.\n",
                                         "Problematic values: ",
                                         "{paste(bad_val, collapse = ', ')}"))
  } else {
    x
  }
}

check_n_range <- function(x, name, lb, ub) {
  if (!is.numeric(x)) {
    abort_bad_argument(name, must = "be numeric", not = typeof(x))
  }

  if (length(x) != 1) {
    abort_bad_argument(name, must = "have length of 1", not = length(x))
  }
  x <- as.integer(x)

  if (is.na(x)) {
    abort_bad_argument(name, must = "be non-missing")
  } else if ((x < lb | x > ub) & ub != Inf) {
    abort_bad_argument(name, must = glue::glue("be between {lb} and {ub} when ",
                                               "using a discrete palette"))
  } else if (x < lb & ub == Inf) {
    abort_bad_argument(name, must = glue::glue("be at least {lb}"))
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
  } else if (x < lb | x > ub) {
    abort_bad_argument(name, must = glue::glue("be between {lb} and {ub}"))
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
    abort_bad_argument(name, must = glue::glue("be {value} or -{value}"))
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
