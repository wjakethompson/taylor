#' Color palettes
#'
#'
#' Colors derived from album covers at <http://colormind.io/image/>.
#' @export
album_palettes <- purrr::map(list(
  taylor_swift = c("#1BAEC6", "#1D4737", "#523d28", "#AD8562", "#E7DBCC"),
  fearless     = c("#E1D4C2", "#CBA863", "#976F34", "#776456", "#6B5E57"),
  speak_now    = c("#F5E8E2", "#D1A0C7", "#833C63", "#6C3127", "#2E1924"),
  red          = c("#A91E47", "#201F39", "#7E6358", "#B0A49A", "#DDD8C9"),
  `1989`       = c("#D8D8CF", "#C6B69C", "#92573C", "#846578", "#5D4E5D"),
  reputation   = c("#B9B9B9", "#6E6E6E", "#5B5B5B", "#515151", "#2C2C2C"),
  lover        = c("#EBBED3", "#9C8083", "#8C4F66", "#847262", "#6098B6"),
  folklore     = c("#EBEBEB", "#949494", "#5C5C5C", "#545454", "#3E3E3E"),
  evermore     = c("#E0D9D7", "#D37F55", "#85796D", "#421E18", "#160E10")
), color_palette)

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
                   taylor_swift = album_palettes[["taylor_swift"]],
                   fearless     = album_palettes[["fearless"]],
                   speak_now    = album_palettes[["speak_now"]],
                   red          = album_palettes[["red"]],
                   `1989`       = album_palettes[["1989"]],
                   reputation   = album_palettes[["reputation"]],
                   lover        = album_palettes[["lover"]],
                   folklore     = album_palettes[["folklore"]],
                   evermore     = album_palettes[["evermore"]],
                   {rlang::warn(paste0("Album '", album, "' does not exist. ",
                                       "Defaulting to 'Lover'."))
                     album_palettes[["lover"]]})

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
