#' Color palettes based on Taylor Swift's albums
#'
#' Premade color palettes based on Taylor Swifts album covers. For details on
#' how to extend and shorten these palettes, or create your own color palette,
#' see [color_palette()].
#'
#' @format A list of length `r length(album_palettes)`. Each element contains a
#'   color palette for one of Taylor Swift's studio albums. The list elements
#'   are named according to the name of the album.
#'
#' @source Colors derived from album covers using 'Colormind'.
#' @seealso [color_palette()]
#' @export
#' @examples
#' album_palettes
#'
#' album_compare
#'
#' album_palettes$evermore
album_palettes <- lapply(list(
  taylor_swift = c("#1D4737", "#1BAEC6", "#523d28", "#AD8562", "#E7DBCC"),
  fearless     = c("#6B5E57", "#776456", "#976F34", "#CBA863", "#E1D4C2"),
  fearless_tv  = c("#624324", "#A47F45", "#CAA462", "#C5AA7C", "#EEDBA9"),
  speak_now    = c("#2E1924", "#6C3127", "#833C63", "#D1A0C7", "#F5E8E2"),
  red          = c("#201F39", "#A91E47", "#7E6358", "#B0A49A", "#DDD8C9"),
  `1989`       = c("#5D4E5D", "#846578", "#92573C", "#C6B69C", "#D8D8CF"),
  reputation   = c("#2C2C2C", "#515151", "#5B5B5B", "#6E6E6E", "#B9B9B9"),
  lover        = c("#8C4F66", "#9C8083", "#847262", "#6098B6", "#EBBED3"),
  folklore     = c("#3E3E3E", "#545454", "#5C5C5C", "#949494", "#EBEBEB"),
  evermore     = c("#160E10", "#421E18", "#D37F55", "#85796D", "#E0D9D7")
), color_palette)

#' @rdname album_palettes
#' @export
album_compare <- color_palette(
  c(taylor_swift = "#1BAEC6",
    fearless     = "#976F34",
    fearless_tv  = "#624324",
    speak_now    = "#833C63",
    red          = "#A91E47",
    `1989`       = "#846578",
    reputation   = "#2C2C2C",
    lover        = "#EBBED3",
    folklore     = "#949494",
    evermore     = "#421E18")
)


#' Correct ordering of Taylor Swift's albums
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
  lookup_pal <- gsub("\\(taylor's_version\\)", "tv", lookup_pal)

  option <- switch(EXPR = lookup_pal,
                   taylor_swift = taylor::album_palettes[["taylor_swift"]],
                   fearless     = taylor::album_palettes[["fearless"]],
                   fearless_tv  = taylor::album_palettes[["fearless_tv"]],
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
