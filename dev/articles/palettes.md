# Using and creating color palettes

The taylor package comes with it’s own class of color palettes, inspired
by the work of [Josiah Parry](https://josiah.rs/) in the
[cpcinema](https://github.com/JosiahParry/cpcinema) package.

## Creating palettes

taylor uses [vctrs](https://vctrs.r-lib.org/) to create a special vector
class of color palettes that can be used to create and visualize
palettes. We can create a palette using the
[`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
function. We only have to pass a vector of hexadecimal values or valid R
color (from [`colors()`](https://rdrr.io/r/grDevices/colors.html)), and
a palette is created that will print a preview of the colors.

``` r
library(taylor)

my_pal <- color_palette(c("firebrick", "turquoise", "#0051ba"))
my_pal
#> <color_palette[3]>
#>     firebrick 
#>     turquoise 
#>     #0051ba
```

We can also use
[`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)
on an existing palette to interpolate additional values, by specifying
that we want more colors than were originally specified.

``` r
my_big_pal <- color_palette(my_pal, n = 10)
my_big_pal
#> <color_palette[10]>
#>     #B22222 
#>     #984C48 
#>     #7F766F 
#>     #66A096 
#>     #4CCABC 
#>     #38D0CD 
#>     #2AB0C8 
#>     #1C90C3 
#>     #0E70BE 
#>     #0051BA
```

Similarly, if we have a large color palette, we can select just a few
representative colors.

``` r
my_small_pal <- color_palette(my_big_pal, n = 5)
my_small_pal
#> <color_palette[5]>
#>     #B22222 
#>     #7F766F 
#>     #4CCABC 
#>     #2AB0C8 
#>     #0051BA
```

## Built-in palettes

The taylor package comes with a few palettes built-in, based on Taylor
Swift’s album covers. They can be viewed using
[`?album_palettes`](https://taylor.wjakethompson.com/dev/reference/album_palettes.md).

``` r
album_palettes
#> $taylor_swift
#> <color_palette[5]>
#>     #1D4737 
#>     #81A757 
#>     #1BAEC6 
#>     #523d28 
#>     #E7DBCC 
#> 
#> $fearless
#> <color_palette[5]>
#>     #6E4823 
#>     #976F34 
#>     #CBA863 
#>     #ECD59F 
#>     #E1D4C2 
#> 
#> $speak_now
#> <color_palette[5]>
#>     #2E1924 
#>     #6C3127 
#>     #833C63 
#>     #D1A0C7 
#>     #F5E8E2 
#> 
#> $red
#> <color_palette[5]>
#>     #201F39 
#>     #A91E47 
#>     #7E6358 
#>     #B0A49A 
#>     #DDD8C9 
#> 
#> $`1989`
#> <color_palette[5]>
#>     #5D4E5D 
#>     #846578 
#>     #92573C 
#>     #C6B69C 
#>     #D8D8CF 
#> 
#> $reputation
#> <color_palette[5]>
#>     #2C2C2C 
#>     #515151 
#>     #5B5B5B 
#>     #6E6E6E 
#>     #B9B9B9 
#> 
#> $lover
#> <color_palette[5]>
#>     #76BAE0 
#>     #8C4F66 
#>     #B8396B 
#>     #EBBED3 
#>     #FFF5CC 
#> 
#> $folklore
#> <color_palette[5]>
#>     #3E3E3E 
#>     #545454 
#>     #5C5C5C 
#>     #949494 
#>     #EBEBEB 
#> 
#> $evermore
#> <color_palette[5]>
#>     #160E10 
#>     #421E18 
#>     #D37F55 
#>     #85796D 
#>     #E0D9D7 
#> 
#> $fearless_tv
#> <color_palette[5]>
#>     #624324 
#>     #A47F45 
#>     #CAA462 
#>     #C5AA7C 
#>     #EEDBA9 
#> 
#> $red_tv
#> <color_palette[5]>
#>     #400303 
#>     #731803 
#>     #967862 
#>     #B38468 
#>     #C7C5B6 
#> 
#> $midnights
#> <color_palette[5]>
#>     #121D27 
#>     #5A658B 
#>     #6F86A2 
#>     #85A7BA 
#>     #AA9EB6 
#> 
#> $speak_now_tv
#> <color_palette[5]>
#>     #2A122C 
#>     #4a2454 
#>     #72325F 
#>     #874886 
#>     #96689A 
#> 
#> $`1989_tv`
#> <color_palette[5]>
#>     #487398 
#>     #659BBB 
#>     #8BB5D2 
#>     #AFC5D4 
#>     #E4DFD3 
#> 
#> $tortured_poets
#> <color_palette[5]>
#>     #1C160F 
#>     #3F3824 
#>     #635B3A 
#>     #ADA795 
#>     #F7F4F0 
#> 
#> $showgirl
#> <color_palette[5]>
#>     #C44615 
#>     #EB8246 
#>     #F0CD92 
#>     #6CAE90 
#>     #3E5C38
```

Or we can access a single palette.

``` r
album_palettes$fearless_tv
#> <color_palette[5]>
#>     #624324 
#>     #A47F45 
#>     #CAA462 
#>     #C5AA7C 
#>     #EEDBA9
```

Also included is a palette that includes one representative color from
each album,
[`?album_compare`](https://taylor.wjakethompson.com/dev/reference/album_palettes.md).

``` r
album_compare
#> <color_palette[16]>
#>     taylor_swift 
#>     fearless 
#>     speak_now 
#>     red 
#>     1989 
#>     reputation 
#>     lover 
#>     folklore 
#>     evermore 
#>     fearless_tv 
#>     red_tv 
#>     midnights 
#>     speak_now_tv 
#>     1989_tv 
#>     tortured_poets 
#>     showgirl
```

## Using color palettes with ggplot2

The taylor package comes with a set of functions built in for plotting
in ggplot2 with the album palettes. For example, we can use
[`scale_fill_taylor_c()`](https://taylor.wjakethompson.com/dev/reference/scale_taylor.md)
to create a continuous scale based on one of the album palettes. For
more details on how to use the scale functions included in taylor, check
out
[`vignette("plotting")`](https://taylor.wjakethompson.com/dev/articles/plotting.md).

``` r

library(ggplot2)

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
combinations.](palettes_files/figure-html/unnamed-chunk-8-1.png)

You can also use your custom palettes with ggplot2. For example, we can
create a palette of greens, and then use
[`ggplot2::scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
or
[`ggplot2::scale_color_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
to use the palette.

``` r

green_pal <- color_palette(c("#E5F5E0", "#A1D99B", "#31A354"))
green_pal
#> <color_palette[3]>
#>     #E5F5E0 
#>     #A1D99B 
#>     #31A354

ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_gradientn(colors = green_pal) +
  theme_minimal()
```

![The same heatmap as the previous figure, but instead of the fill using
a palette based on Fearless (Taylor's Version), the color palette goes
from light green to dark
green.](palettes_files/figure-html/unnamed-chunk-9-1.png)

Finally, if we have a discrete scale, we can use
[`ggplot2::scale_fill_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html)
or
[`ggplot2::scale_color_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html).
Here, we use the [`?penguins`](https://rdrr.io/r/datasets/penguins.html)
data to map our palette to the species of penguin.

``` r

penguin_pal <- color_palette(c(
  Adelie = "firebrick",
  Chinstrap = "goldenrod",
  Gentoo = "navy"
))
penguin_pal
#> <color_palette[3]>
#>     Adelie 
#>     Chinstrap 
#>     Gentoo

ggplot(penguins, aes(x = bill_len, y = bill_dep)) +
  geom_point(aes(shape = species, color = species), size = 3) +
  scale_color_manual(values = penguin_pal) +
  theme_minimal()
```

![A scatter plot with bill length on the x-axis and bill depth on the
y-axis. The shape and color of the points correspond to the species of
penguin, with colors derived from our custom color palette. Adelie
penguins are shown in red circles, Chinstrap penguins in yellow
triangles, and Gentoo penguins in blue
squares.](palettes_files/figure-html/unnamed-chunk-10-1.png)
