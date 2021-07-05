#' Taylor Swift colour scales based on album cover palettes
#'
#' @inheritParams scales::viridis_pal
#' @inheritParams scales::gradient_n_pal
#' @inheritParams ggplot2::continuous_scale
#' @param ... Other arguments passed on to [ggplot2::discrete_scale()] or
#' [ggplot2::continuous_scale()] to control name, limits, breaks, labels and
#'   so forth.
#' @param album A character string indicating the album that should be used for
#'   the palette.
#' @param aesthetics Character string or vector of character strings listing the
#'   name(s) of the aesthetic(s) that this scale works with. This can be useful,
#'   for example, to apply colour settings to the `colour` and `fill` aesthetics
#'   at the same time, via `aesthetics = c("colour", "fill")`.
#' @rdname scale_taylor
#' @export
#' @examples
#' # use taylor_d with discrete data
#' lover <- subset(taylor_album_songs, album_name == "Lover")
#' (p <- ggplot(data = lover, aes(x = valence, y = track_name)) +
#'    geom_col(aes(fill = track_name)))
#' p + scale_fill_taylor_d()
#'
#' # change scale label
#' p + scale_fill_taylor_d("")
scale_colour_taylor_d <- function(..., alpha = 1, begin = 0, end = 1,
                                  direction = 1, album = "Lover",
                                  aesthetics = "colour") {
  ggplot2::discrete_scale(
    aesthetics,
    "taylor_d",
    taylor_pal(alpha, begin, end, direction, album),
    ...
  )
}

#' @export
#' @rdname scale_taylor
scale_color_taylor_d <- scale_colour_taylor_d

#' @export
#' @rdname scale_taylor
scale_fill_taylor_d <- function(..., alpha = 1, begin = 0, end = 1,
                                direction = 1, album = "Lover",
                                aesthetics = "fill") {
  ggplot2::discrete_scale(
    aesthetics,
    "taylor_d",
    taylor_pal(alpha, begin, end, direction, album),
    ...
  )
}

#' @export
#' @rdname scale_taylor
scale_colour_taylor_c <- function(..., alpha = 1, begin = 0, end = 1,
                                  direction = 1, album = "Lover", values = NULL,
                                  space = "Lab", na.value = "grey50",
                                  guide = "colourbar", aesthetics = "colour") {
  ggplot2::continuous_scale(
    aesthetics,
    "taylor_c",
    scales::gradient_n_pal(
      taylor_pal(alpha, begin, end, direction, album)(6),
      values,
      space
    ),
    na.value = na.value,
    guide = guide,
    ...
  )
}

#' @export
#' @rdname scale_taylor
scale_color_taylor_c <- scale_colour_taylor_c

#' @export
#' @rdname scale_taylor
scale_fill_taylor_c <- function(..., alpha = 1, begin = 0, end = 1,
                                direction = 1, album = "Lover", values = NULL,
                                space = "Lab", na.value = "grey50",
                                guide = "colourbar", aesthetics = "fill") {
  ggplot2::continuous_scale(
    aesthetics,
    "taylor_c",
    scales::gradient_n_pal(
      taylor_pal(alpha, begin, end, direction, album)(6),
      values,
      space
    ),
    na.value = na.value,
    guide = guide,
    ...
  )
}
