library(taylor)

#' The {taylor} package has been updated to include all of {album name}! The
#' development version with all the updates can be installed from GitHub:
#' github.com/wjakethompson/taylor
#'
#' Some highlights:


#' Lyrics and Spotify audio data for {num tracks} {album} tracks have been
#' added.

taylor::taylor_all_songs |>
  dplyr::filter(album_name == "Speak Now (Taylor's Version)")

# copy console to: https://carbon.vercel.app/
# Night Owl theme, R language, export/download png

# Alt text: A scrrenshot of the new Speak Now (Taylor's Version) data. Code:


#' A new color palette has been added to match the {album} aesthetic:

library(tidyverse)
library(taylor)

taylor_album_songs |>
  filter(album_name == "Speak Now (Taylor's Version)", !is.na(energy)) |>
  mutate(track_name = fct_inorder(track_name)) |>
  ggplot(aes(x = energy, y = fct_rev(track_name))) +
  geom_col(aes(fill = track_name), show.legend = FALSE) +
  scale_fill_taylor_d(album = "Speak Now (Taylor's Version)") +
  labs(x = "Song energy", y = NULL) +
  theme_minimal() +
  theme(axis.text = element_text(size = 20),
        axis.title = element_text(size = 24)) -> p

ggsave(filename = "song-energy.png", plot = p, path = "~/Desktop",
       width = 20, height = 20 * 0.618, units = "in", dpi = 320)

# copy console to: https://carbon.vercel.app/
# Night Owl theme, R language, export/download png

# Alt text 1: A horizontal bar graph with song titles on the y-axis and song energy on the x-axis. The bars are filled with colors in a gradient from x to x.
# Alt text 2: Code to create the bar graph. {insert code}


#' And perhaps most importantly, a new hex sticker!

# Alt text: The {taylor} hex logo. The image is an abstract version of the {album} album cover, with text {Taylor} overlayed.


#' Please check out the updates and open any issues on the GitHub repo!
#' You can find updated documentation (complete with a new {album} theme) at:
#' taylor.wjakethompson.com/dev
