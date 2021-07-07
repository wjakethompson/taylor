#' Taylor Swift album palettes
#'
#' Premade color palettes based on Taylor Swifts album covers. For details on
#' how to extend and shorten these palettes, or create your own color palette,
#' see [color_palette()].
#'
#' @format A list of length `r length(album_palettes)`. Each element contains a
#'   color palette for one of Taylor Swift's studio albums. The list elements
#'   are named according to the name of the album.
#'
#' @source Colors derived from album covers at <http://colormind.io/image/>.
#' @seealso [color_palette()]
#' @export
#' @examples
#' album_palettes
#'
#' album_compare
#'
#' album_palettes$evermore
album_palettes <- lapply(list(
  taylor_swift = c("#1BAEC6", "#1D4737", "#523d28", "#AD8562", "#E7DBCC"),
  fearless     = c("#E1D4C2", "#CBA863", "#976F34", "#776456", "#6B5E57"),
  fearless_tv  = c("#624324", "#A47F45", "#C5AA7C", "#CAA462", "#EEDBA9"),
  speak_now    = c("#F5E8E2", "#D1A0C7", "#833C63", "#6C3127", "#2E1924"),
  red          = c("#A91E47", "#201F39", "#7E6358", "#B0A49A", "#DDD8C9"),
  `1989`       = c("#D8D8CF", "#C6B69C", "#92573C", "#846578", "#5D4E5D"),
  reputation   = c("#B9B9B9", "#6E6E6E", "#5B5B5B", "#515151", "#2C2C2C"),
  lover        = c("#EBBED3", "#9C8083", "#8C4F66", "#847262", "#6098B6"),
  folklore     = c("#EBEBEB", "#949494", "#5C5C5C", "#545454", "#3E3E3E"),
  evermore     = c("#E0D9D7", "#D37F55", "#85796D", "#421E18", "#160E10")
), color_palette)

#' @rdname album_palettes
#' @export
album_compare <- color_palette(
  c(taylor_swift = "#1D4737",
    fearless     = "#976F34",
    fearless_tv  = "#A47F45",
    speak_now    = "#833C63",
    red          = "#A91E47",
    `1989`       = "#C6B69C",
    reputation   = "#2C2C2C",
    lover        = "#6098B6",
    folklore     = "#949494",
    evermore     = "#D37F55")
)


#' Taylor Swift album ordering
#'
#' Easily create a factor variable for Taylor Swift's albums. Rather than
#' specifying each album individually, you can use this shortcut vector that has
#' already specified the ordering.
#'
#' @format A vector of length `r length(album_levels)`. Each element is an album
#'   name, in an order that can be used for making factor variables.
#'
#' @details
#' Albums are listed in release order, with one notable exception. The
#' "Taylor's Version" releases are list directly following the original. That
#' is, *Fearless (Taylor's Version)* comes directly after *Fearless*, rather
#' than after *evermore*, when it was released. This is because
#' "Taylor's Version" is often a stand-in for the original, as in
#' [`taylor_album_songs`]. Thus, it more often makes more sense for the album to
#' be placed with the original, rather than in the actual release order.
#' @export
#' @examples
#' library(ggplot2)
#' studio_albums <- subset(taylor_albums, !ep)
#'
#' # by default, albums get plotted in alphabetical order
#' ggplot(studio_albums, aes(x = metacritic_score, y = album_name)) +
#'   geom_col()
#'
#' # use `album_levels` to create a sensible factor variable
#' studio_albums$album_name <- factor(studio_albums$album_name,
#'                                    levels = album_levels)
#' ggplot(studio_albums, aes(x = metacritic_score, y = album_name)) +
#'   geom_col()
album_levels <- c("Taylor Swift", "Fearless", "Fearless (Taylor's Version)",
                  "Speak Now", "Red", "1989", "reputation", "Lover", "folklore",
                  "evermore")


# Scale functions --------------------------------------------------------------
taylor_col <- function(n, alpha = 1, begin = 0, end = 1, direction = 1,
                       album = "Lover") {
  begin <- check_real_range(begin, name = "begin", lb = 0, ub = 1)
  end <- check_real_range(end, name = "end", lb = 0, ub = 1)
  direction <- check_exact_abs_int(direction, name = "direction", value = 1)

  if (n == 0) {
    return(character(0))
  }
  if (direction == -1) {
    tmp <- begin
    begin <- end
    end <- tmp
  }

  lookup_pal <- tolower(album)
  lookup_pal <- gsub("\\ ", "_", lookup_pal)

  option <- switch(EXPR = lookup_pal,
                   taylor_swift = taylor::album_palettes[["taylor_swift"]],
                   fearless     = taylor::album_palettes[["fearless"]],
                   speak_now    = taylor::album_palettes[["speak_now"]],
                   red          = taylor::album_palettes[["red"]],
                   `1989`       = taylor::album_palettes[["1989"]],
                   reputation   = taylor::album_palettes[["reputation"]],
                   lover        = taylor::album_palettes[["lover"]],
                   folklore     = taylor::album_palettes[["folklore"]],
                   evermore     = taylor::album_palettes[["evermore"]], {
                     rlang::warn(paste0("Album '", album, "' does not exist. ",
                                        "Defaulting to 'Lover'."))
                     taylor::album_palettes[["lover"]]
                   })

  fn_cols <- grDevices::colorRamp(option, space = "Lab",
                                  interpolate = "spline")
  cols <- fn_cols(seq(begin, end, length.out = n)) / 255
  grDevices::rgb(cols[, 1], cols[, 2], cols[, 3], alpha = alpha)
}

taylor_pal <- function(alpha = 1, begin = 0, end = 1, direction = 1,
                       album = "Lover") {
  function(n) {
    taylor_col(n, alpha, begin, end, direction, album)
  }
}
