# Give your ggplots a Taylor Swift theme

In addition to data sets, taylor also includes a few helper functions
for easily making plots created with
[ggplot2](https://ggplot2.tidyverse.org) have a Taylor Swift theme. For
this vignette, I’m assuming you are already familiar with ggplot2 and
can make basic plots.

Once you have a ggplot created, you can add album-themed color palettes
to your plots using the family of `scale_taylor` functions:

- Discrete scales:
  - [`scale_color_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  - [`scale_fill_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
- Continuous scales
  - [`scale_color_taylor_c()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  - [`scale_fill_taylor_c()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
- Binned scales
  - [`scale_color_taylor_b()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
  - [`scale_fill_taylor_b()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)

## Discrete scales

First, let’s make a bar graph showing the valence of each song on
*evermore*.

``` r
library(taylor)
library(ggplot2)

evermore <- subset(taylor_album_songs, album_name == "evermore")
evermore$track_name <- factor(evermore$track_name, levels = evermore$track_name)

p <- ggplot(evermore, aes(x = valence, y = track_name, fill = track_name)) +
  geom_col(show.legend = FALSE) +
  expand_limits(x = c(0, 1)) +
  labs(y = NULL) +
  theme_minimal()
p
```

![A bar graph with song valence on the x-axis and song title on the
y-axis. Each bar is a different color, with colors following a
rainbow-like palette.](plotting_files/figure-html/unnamed-chunk-2-1.png)

We can then add some *evermore*-inspired colors using
[`scale_fill_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md).

``` r
p + scale_fill_taylor_d(album = "evermore")
```

![The same bar graph as the previous figure, but the colors of the bars
have been updated to use a palette inspired by the album cover of
evermore. The palette starts with a dark brown, moving to orange, and
finally to a light
gray.](plotting_files/figure-html/unnamed-chunk-3-1.png)

The `album` argument can be changed to use a different Taylor-inspired
palette. For example, we can switch to *Speak Now* using
`album = "Speak Now"`.

``` r
p + scale_fill_taylor_d(album = "Speak Now")
```

![The same bar graph as the previous two figures, but the colros of the
bars have been updated to use a palette inspired by the album cover of
Speak Now. The palette starts with a dark burnt red and then moves to
purple and finally a light
pink.](plotting_files/figure-html/unnamed-chunk-4-1.png)

We can also use these functions for non-Taylor Swift data. For example,
here we use
[`scale_color_taylor_d()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
to plot some data about
[`?penguins`](https://rdrr.io/r/datasets/penguins.html).

``` r
ggplot(penguins, aes(x = bill_len, y = bill_dep)) +
  geom_point(aes(shape = species, color = species), size = 3) +
  scale_color_taylor_d(album = "Lover") +
  theme_minimal()
```

![A scatter plot with bill length on the x-axis and bill depth on the
y-axis. The shape and color of the points correspond to the species of
penguin, with colors derived from the color palette for
Lover.](plotting_files/figure-html/unnamed-chunk-5-1.png)

## Continuous and binned scales

When using a continuous scale, values are interpolated between the
colors defined in each palette. The *Fearless (Taylor’s Version)*
palette is a particularly good use case for this. To illustrate, we’ll
use the classic example included in the ggplot2 package of the eruptions
of the Old Faithful geyser and the duration of the eruptions.

``` r
p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  theme_minimal()

p + scale_fill_taylor_c(album = "Fearless (Taylor's Version)")
```

![A heatmap showing a positive relationship between the waiting time
between eruptions and the length of eruptions at the Old Faithful
geyser. The heat map is colored using the palette based on Fearless
(Taylor's Version), which moves from a dark golden brown for low density
combinations up to bright gold for high density
combinations.](plotting_files/figure-html/unnamed-chunk-6-1.png)

Similarly, both the *reputation* and *folklore* palettes work great for
gray scale images.

``` r
p + scale_fill_taylor_c(album = "reputation")
```

![The same heatmap as the previous figure, but the color palette has
been changed to use colors inspired by reputation. Less frequent values
are show in dark grey, and more common values appear as
white.](plotting_files/figure-html/unnamed-chunk-7-1.png)

``` r
p + scale_fill_taylor_c(album = "folklore")
```

![The same heatmap as the previous two figures, but the color palette
has been changed to use colors inspired by folklore. Less frequent
values are show in dark grey, and more common values appear as
white.](plotting_files/figure-html/unnamed-chunk-7-2.png)

Just like with other ggplot2 scales, we can also use the `_b` variants
to create a binned color scale.

``` r
p + scale_fill_taylor_b(album = "evermore")
```

![The same heat map as the previous figures, but instead of a smooth
continuous color scale, values have been binned into four categories,
with color inspired by the evermore album
cover.](plotting_files/figure-html/unnamed-chunk-8-1.png)

## Album scales

Finally, there is an album scale that can be used when plotting data
from multiple albums. Take for example the
[Metacritic](https://www.metacritic.com/person/taylor-swift) ratings of
Taylor’s albums, stored in
[`taylor::taylor_albums`](https://taylor.wjakethompson.com/dev/reference/taylor_albums.md).

``` r
taylor_albums
#> # A tibble: 17 × 5
#>    album_name                    ep    album_release metacritic_score user_score
#>    <chr>                         <lgl> <date>                   <int>      <dbl>
#>  1 Taylor Swift                  FALSE 2006-10-24                  67        8.4
#>  2 The Taylor Swift Holiday Col… TRUE  2007-10-14                  NA       NA  
#>  3 Beautiful Eyes                TRUE  2008-07-15                  NA       NA  
#>  4 Fearless                      FALSE 2008-11-11                  73        8.4
#>  5 Speak Now                     FALSE 2010-10-25                  77        8.6
#>  6 Red                           FALSE 2012-10-22                  77        8.6
#>  7 1989                          FALSE 2014-10-27                  76        8.3
#>  8 reputation                    FALSE 2017-11-10                  71        8.3
#>  9 Lover                         FALSE 2019-08-23                  79        8.4
#> 10 folklore                      FALSE 2020-07-24                  88        9  
#> 11 evermore                      FALSE 2020-12-11                  85        8.9
#> 12 Fearless (Taylor's Version)   FALSE 2021-04-09                  82        8.9
#> 13 Red (Taylor's Version)        FALSE 2021-11-12                  91        8.9
#> 14 Midnights                     FALSE 2022-10-21                  85        8.3
#> 15 Speak Now (Taylor's Version)  FALSE 2023-07-07                  81        9.2
#> 16 1989 (Taylor's Version)       FALSE 2023-10-27                  90       NA  
#> 17 THE TORTURED POETS DEPARTMENT FALSE 2024-04-19                  76       NA
```

Let’s create a bar graph showing the rating of each album. We’ll first
make the album name a factor variable. A convenience variable,
[`taylor::album_levels`](https://taylor.wjakethompson.com/dev/reference/album_levels.md),
is included in the package that will let us easily order the factor by
album release date.[¹](#fn1) Metacritic doesn’t have a rating for
Taylor’s debut album, *Taylor Swift*, so I will manually assign a value
so that we can see the full scale in action. We’ll give each bar its own
color to add some pizzazz to the plot.

``` r
metacritic <- taylor_albums

# Not Taylor's best work, so we'll give it a 72
metacritic$metacritic_score[1] <- 72L
metacritic <- subset(metacritic, !is.na(metacritic_score))
metacritic$album_name <- factor(metacritic$album_name,
                                levels = album_levels)

ggplot(metacritic, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name), show.legend = FALSE) +
  labs(x = "Metacritic Rating", y = NULL) +
  theme_minimal()
```

![A bar graph with the Metacritic rating on the x-axis and the album
name on the y-axis. Color has been assigned to each bar such that each
bar is filled with a color. The colors follow the ggplot2 default,
resulting in a rainbow-like
palette.](plotting_files/figure-html/unnamed-chunk-10-1.png)

This is nice, but wouldn’t it be better if each color was related to the
album? Enter
[`scale_fill_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)!

``` r
ggplot(metacritic, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name), show.legend = FALSE) +
  scale_fill_albums() +
  labs(x = "Metacritic Rating", y = NULL) +
  theme_minimal()
```

![The same bar graph as the previous image, instead of using the default
colors, each bar for each album is filled with a color from that album's
cover.](plotting_files/figure-html/unnamed-chunk-11-1.png)

The
[`scale_fill_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
and
[`scale_color_albums()`](https://taylor.wjakethompson.com/dev/reference/scale_albums.md)
functions automatically assign color based on the album name. These are
wrappers around
[`ggplot2::scale_fill_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html)
and
[`ggplot2::scale_color_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html),
respectively. This means that the colors will still be assigned
correctly, even if the ordering of the albums changes, or not all levels
are present.

``` r
rand_critic <- metacritic[sample(seq_len(nrow(metacritic)), 5), ]
rand_critic$album_name <- factor(rand_critic$album_name,
                                 levels = sample(rand_critic$album_name,
                                                 size = nrow(rand_critic)))

ggplot(rand_critic, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name), show.legend = FALSE) +
  scale_fill_albums() +
  labs(x = "Metacritic Rating", y = NULL) +
  theme_minimal()
```

![The same bar graph as the previous image, but only showing five
albums, and the ordering of the y-axis has been made random. However,
the fill of the bar for each album still corresponds to that album's
cover.](plotting_files/figure-html/unnamed-chunk-12-1.png)

However, this also means that album names must match the expected names.
That is, if you change or reformat an album name, the fill colors won’t
be found. For example, if we use title case for all the album titles,
the fill color will be missing for *reputation*, *folklore*, and
*evermore*, which are stylized in all lower case, as well as *THE
TORTURED POETS DEPARTMENT*, which is stylized in all upper case. The
expected names are defined in the
[`taylor::album_levels`](https://taylor.wjakethompson.com/dev/reference/album_levels.md)
object.

``` r
upper_critic <- metacritic
upper_critic$album_name <- factor(upper_critic$album_name,
                                  levels = album_levels,
                                  labels = title_case(album_levels))

ggplot(upper_critic, aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name), show.legend = FALSE) +
  scale_fill_albums() +
  labs(x = "Metacritic Rating", y = NULL) +
  theme_minimal()
```

![A bar graph with the Metacritic rating on the x-axis and the album
name on the y-axis. Color has been assigned to each bar such that each
bar is filled with a color. The colors for each bar a based on the ablum
cover. On y-axis, evermore, folklore, and repuation, have been spelled
in title case, rather than lower case, resulting in no bar showing for
these albums.](plotting_files/figure-html/unnamed-chunk-13-1.png)

------------------------------------------------------------------------

1.  Albums are not precisely in release order. Re-releases are ordered
    next to the original release. See
    [`?taylor::album_levels`](https://taylor.wjakethompson.com/dev/reference/album_levels.md)
    for details.
