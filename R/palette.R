new_palette <- function(pal = character(), n = integer(),
                        type = c("discrete", "continuous")) {
  vec_assert(pal, ptype = character())
  vec_assert(n, ptype = integer(), size = 1)

  index <- seq(1, length(pal), by = length(pal) / n)

  out <- switch(type,
                continuous = grDevices::colorRampPalette(pal)(n),
                discrete = pal[index])

  styles <- purrr::map(out, crayon::make_style, bg = TRUE)

  new_vctr(out,
           style = styles,
           class = "taylor_palette",
           inherit_base_type = TRUE)
}

# for compatibility with the S4 system
methods::setOldClass(c("taylor_palette", "vctrs_vctr"))


#' `palette` vector
#'
#' This creates a character vector that represents palettes so when it is
#' printed, it displays the palette colors.
#'
#' @param pal
#'  * For `create_palette()`: A character vector of hex codes
#'  * For `is_palette()`: An object to test
#' @param n The number of colors
#' @param type The type of palette, either `discrete` or `continuous`
#' @export
#' @examples
#' create_palette(pal = c("#842000", "#EC9B01", "#3F5D91"), n = 3L)
create_palette <- function(pal, n = length(pal),
                           type = c("discrete", "continuous")) {
  pal <- vec_cast(pal, character())

  type <- rlang::arg_match(type)
  new_palette(pal = pal, n = n, type = type)
}



#' @export
#' @rdname create_palette
is_palette <- function(pal) {
  inherits(pal, "taylor_palette")
}

palette_style <- purrr::attr_getter("style")

#' @method obj_print_data taylor_palette
#' @export
obj_print_data.taylor_palette <- function(pal, ...) {
  UseMethod("obj_print_data.taylor_palette", pal)
}

#' @method obj_print_data.taylor_palette default
#' @export
obj_print_data.taylor_palette.default <- function(pal, ...) {
  styles <- palette_style(pal)
  purrr::walk2(vec_data(pal), styles, ~cat("", .y("  "), .x, "\n"))
}

#' @export
vec_ptype_abbr.taylor_palette <- function(pal, ...) {
  "tpal"
}

# Casting and coercion ---------------------------------------------------------
#' @export
vec_ptype2.taylor_palette.taylor_palette <- function(x, y, ...) new_palette()
#' @export
vec_ptype2.taylor_palette.character <- function(x, y, ...) character()
#' @export
vec_ptype2.character.taylor_palette <- function(x, y, ...) character()

#' @export
vec_cast.taylor_palette.taylor_palette <- function(x, to, ...) x
#' @export
vec_cast.taylor_palette.character <- function(x, to, ...) create_palette(x)
#' @export
vec_cast.character.taylor_palette <- function(x, to, ...) vec_data(x)
