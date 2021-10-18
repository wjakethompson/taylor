#' Create a custom color palette
#'
#' This creates a character vector that represents palettes so when it is
#' printed, it displays the palette colors.
#'
#' @param pal
#'  * For `color_palette()`: A character vector of hexadecimal codes
#'  * For `is_color_palette()`: An object to test
#' @param n The number of colors
#' @param type `r lifecycle::badge("deprecated")` `type` is no longer supported;
#'  this function will automatically interpolate additional or subset values
#'  based on whether `n` is greater or less than `length(pal)`.
#'
#' @return A color palette object.
#' @export
#' @examples
#' # use color_palette() to extend or shorten an existing palette
#' color_palette(album_palettes$lover, n = 10)
#'
#' color_palette(album_palettes$fearless, n = 10)
#'
#' color_palette(album_palettes$red, n = 3)
#'
#' # you can also define your own color palette
#' (my_pal <- color_palette(pal = c("#264653", "#2A9D8F", "#E9C46A",
#'                                  "#F4A261", "#E76F51")))
#'
#' # and then use that palette for plotting
#' library(ggplot2)
#' ggplot(faithfuld) +
#'   geom_tile(aes(waiting, eruptions, fill = density)) +
#'   scale_fill_gradientn(colours = my_pal) +
#'   theme_minimal()
color_palette <- function(pal = character(), n = length(pal),
                          type = deprecated()) {
  if (is_present(type)) {
    deprecate_warn(
      when = "1.0.0",
      what = "color_palette(type)",
      details = glue::glue("Ability to specify palette type is no longer ",
                           "supported. Interpolation of additional values or ",
                           "subsetting happens automatically based on `n` ",
                           "and the length of `pal`.")
    )
  }

  # check palette and cast to character
  pal <- check_palette(pal, name = "pal")
  pal <- vec_cast(pal, character())

  # check n
  n <- check_pos_int(n, name = "n")

  new_color_palette(pal = pal, n = n)
}

new_color_palette <- function(pal = character(), n = length(pal)) {
  vec_assert(pal, ptype = character())
  vec_assert(n, ptype = integer(), size = 1)

  out <- if (length(pal) == 0) {
    pal
  } else if (n > length(pal)) {
    grDevices::colorRampPalette(pal)(n)
  } else {
    pal[as.integer(seq(1, length(pal), length.out = n))]
  }

  nms <- if (is.null(names(out))) out else names(out)

  new_vctr(out,
           n_colors = n,
           names = nms,
           class = "taylor_color_palette",
           inherit_base_type = TRUE)
}

n_colors <- function(x) attr(x, "n_colors")

# for compatibility with the S4 system
methods::setOldClass(c("taylor_color_palette", "vctrs_vctr"))

# nolint start
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
  styles <- lapply(pal, crayon::make_style, bg = TRUE)
  invisible(
    mapply(
      function(.x, .y) {
        cat("", .y("  "), .x, "\n")
        return(invisible(.x))
      },
      vec_names(pal), styles,
      USE.NAMES = FALSE
    )
  )
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
# nolint end
