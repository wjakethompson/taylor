new_color_palette <- function(pal = character(), n = length(pal),
                        type = c("discrete", "continuous")) {
  vec_assert(pal, ptype = character())
  vec_assert(n, ptype = integer(), size = 1)
  type <- rlang::arg_match(type)

  if (length(pal) > 0) {
    index <- seq(1, length(pal), by = length(pal) / n)

    out <- switch(type,
                  continuous = grDevices::colorRampPalette(pal)(n),
                  discrete = pal[index])
  } else {
    out <- pal
  }

  new_vctr(out,
           n_colors = n,
           class = "taylor_color_palette",
           inherit_base_type = TRUE)
}

#' `palette` vector
#'
#' This creates a character vector that represents palettes so when it is
#' printed, it displays the palette colors.
#'
#' @param pal
#'  * For `color_palette()`: A character vector of hex codes
#'  * For `is_color_palette()`: An object to test
#' @param n The number of colors
#' @param type The type of palette, either `discrete` or `continuous`
#' @export
#' @examples
#' color_palette(pal = c("#842000", "#EC9B01", "#3F5D91"), n = 3)
color_palette <- function(pal = character(), n = length(pal),
                          type = c("discrete", "continuous")) {
  # check palette and cast to character
  pal <- check_palette(pal, name = "pal")
  pal <- vec_cast(pal, character())

  # check type
  type <- rlang::arg_match(type)

  # check n
  min_color <- ifelse(length(pal) == 0, 0L, 1L)
  max_color <- ifelse(type == "discrete", length(pal), Inf)
  n <- check_n_range(n, name = "n", lb = min_color, ub = max_color)

  new_color_palette(pal = pal, n = n, type = type)
}

n_colors <- function(x) attr(x, "n_colors")

# for compatibility with the S4 system
methods::setOldClass(c("taylor_color_palette", "vctrs_vctr"))


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


# Additional helpers -----------------------------------------------------------
#' @export
#' @rdname color_palette
is_color_palette <- function(pal) {
  inherits(pal, "taylor_color_palette")
}

#' @export
vec_ptype_abbr.taylor_color_palette <- function(pal, ...) {
  "clpal"
}

#' @export
vec_ptype_full.taylor_color_palette <- function(pal, ...) {
  paste0("color_palette")
}


# Printing methods -------------------------------------------------------------
#' @method obj_print_data taylor_color_palette
#' @export
obj_print_data.taylor_color_palette <- function(pal, ...) {
  UseMethod("obj_print_data.taylor_color_palette", pal)
}

#' @method obj_print_data.taylor_color_palette default
#' @export
obj_print_data.taylor_color_palette.default <- function(pal, ...) {
  styles <- purrr::map(pal, crayon::make_style, bg = TRUE)
  purrr::walk2(vec_data(pal), styles, ~cat("", .y("  "), .x, "\n"))
}


# Coercion ---------------------------------------------------------------------
#' @export
vec_ptype2.taylor_color_palette.taylor_color_palette <- function(x, y, ...) {
  new_color_palette(pal = c(vec_data(x), vec_data(y)),
                    n = sum(n_colors(x), n_colors(y)))
}

#' @export
vec_ptype2.taylor_color_palette.character <- function(x, y, ...) character()

#' @export
vec_ptype2.character.taylor_color_palette <- function(x, y, ...) character()


# Casting ----------------------------------------------------------------------
#' @export
vec_cast.taylor_color_palette.taylor_color_palette <- function(x, to, ...) {
  new_color_palette(vec_data(x), n = n_colors(x))
}

#' @export
vec_cast.taylor_color_palette.character <- function(x, to, ...) {
  new_color_palette(x, n = length(x))
}

#' @export
vec_cast.character.taylor_color_palette <- function(x, to, ...) vec_data(x)