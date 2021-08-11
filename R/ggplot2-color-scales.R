#' Taylor Swift colour scales based on album cover palettes
#'
#' @inheritParams scales::viridis_pal
#' @inheritParams scales::gradient_n_pal
#' @inheritParams ggplot2::continuous_scale
#' @param ... Other arguments passed on to [ggplot2::discrete_scale()],
#' [ggplot2::continuous_scale()], or [ggplot2::binned_scale()] to control name,
#'   limits, breaks, labels and so forth.
#' @param album A character string indicating the album that should be used for
#'   the palette.
#' @param aesthetics Character string or vector of character strings listing the
#'   name(s) of the aesthetic(s) that this scale works with. This can be useful,
#'   for example, to apply colour settings to the `colour` and `fill` aesthetics
#'   at the same time, via `aesthetics = c("colour", "fill")`.
#' @rdname scale_taylor
#' @return A color scale for use in plots created with [ggplot2::ggplot()].
#' @export
#' @examples
#' # use taylor_d with discrete data
#' library(ggplot2)
#' (p <- ggplot(taylor_album_songs, aes(x = valence, y = energy)) +
#'    geom_point(aes(color = mode_name), size = 2) +
#'    theme_bw())
#' p + scale_color_taylor_d()
#'
#' # change scale label
#' p + scale_fill_taylor_d("Mode of Track")
#'
#' # select album palette to use, see ?taylor::album_palettes for more details
#' lover <- subset(taylor_album_songs, album_name == "Lover")
#' (p <- ggplot(lover, aes(x = valence, y = track_name)) +
#'    geom_col(aes(fill = track_name)) +
#'    theme_minimal())
#' p + scale_fill_taylor_d(album = "Lover")
#' p + scale_fill_taylor_d(album = "evermore")
#'
#' # use taylor_c with continuous data
#' (p <- ggplot(taylor_album_songs, aes(valence, energy)) +
#'    geom_point(aes(color = danceability)) +
#'    theme_minimal())
#' p + scale_color_taylor_c(album = "Fearless")
#' p + scale_color_taylor_c(album = "folklore")
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

#' @export
#' @rdname scale_taylor
scale_colour_taylor_b <- function(..., alpha = 1, begin = 0, end = 1,
                                  direction = 1, album = "Lover", values = NULL,
                                  space = "Lab", na.value = "grey50",
                                  guide = "coloursteps",
                                  aesthetics = "colour") {
  ggplot2::binned_scale(
    aesthetics,
    "taylor_b",
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
scale_color_taylor_b <- scale_colour_taylor_b

#' @export
#' @rdname scale_taylor
scale_fill_taylor_b <- function(..., alpha = 1, begin = 0, end = 1,
                                direction = 1, album = "Lover", values = NULL,
                                space = "Lab", na.value = "grey50",
                                guide = "coloursteps", aesthetics = "fill") {
  ggplot2::binned_scale(
    aesthetics,
    "taylor_b",
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


#' Taylor Swift colour scale for album comparisons
#'
#' A convenience wrapper for comparing albums with color. In contrast to
#' [`scale_fill_taylor_d()`] and [`scale_colour_taylor_d()`],
#' `scale_fill_albums()` and `scale_colour_albums()` use a single palette, with
#' one color per album. Specifically, the [`album_compare`] palette is used to
#' apply a color associated with each album.
#'
#' @inheritParams ggplot2::discrete_scale
#' @param ... Other arguments to be passed to [ggplot2::discrete_scale()]
#'
#' @rdname scale_albums
#' @return A color scale for use in plots created with [ggplot2::ggplot()].
#' @export
#' @examples
#' library(ggplot2)
#' studio <- subset(taylor_albums, !is.na(metacritic_score))
#'
#' # create a plot that we want to color or fill by album
#' ggplot(studio, aes(x = metacritic_score, y = album_name)) +
#'   geom_col(aes(fill = album_name))
#'
#' # apply a color inspired by each album cover
#' ggplot(studio, aes(x = metacritic_score, y = album_name)) +
#'   geom_col(aes(fill = album_name)) +
#'   scale_fill_albums()
#'
#' # even when the axis or levels are rearranged, the correct color is applied
#' studio$album_name <- factor(studio$album_name, levels = album_levels)
#' ggplot(studio, aes(x = metacritic_score, y = album_name)) +
#'   geom_col(aes(fill = album_name)) +
#'   scale_fill_albums()
scale_fill_albums <- function(..., aesthetics = "fill", breaks = waiver(),
                              limits = force, na.value = NA) {
  album_pal <- vec_data(taylor::album_compare)
  names(album_pal) <- taylor::album_levels

  ggplot2::scale_fill_manual(values = album_pal, aesthetics = aesthetics,
                             breaks = breaks, limits = limits,
                             na.value = na.value, ...)
}

#' @rdname scale_albums
#' @export
scale_colour_albums <- function(..., aesthetics = "colour", breaks = waiver(),
                                limits = force, na.value = NA) {
  album_pal <- vec_data(taylor::album_compare)
  names(album_pal) <- taylor::album_levels

  ggplot2::scale_colour_manual(values = album_pal, aesthetics = aesthetics,
                               breaks = breaks, limits = limits,
                               na.value = na.value, ...)
}

#' @rdname scale_albums
#' @export
scale_color_albums <- scale_colour_albums
