# Working with lyrics data

The `taylor_all_songs` and `taylor_album_songs` data sets contain the
lyrics for each of Taylor Swift’s songs, as well as audio
characteristics. In each data set, the lyrics are stored as a
list-column.

``` r
library(taylor)
library(dplyr)

track_lyrics <- taylor_album_songs |>
  select(album_name, track_name, lyrics)

track_lyrics
#> # A tibble: 320 × 3
#>    album_name   track_name                 lyrics           
#>    <chr>        <chr>                      <list>           
#>  1 Taylor Swift Tim McGraw                 <tibble [55 × 4]>
#>  2 Taylor Swift Picture To Burn            <tibble [33 × 4]>
#>  3 Taylor Swift Teardrops On My Guitar     <tibble [36 × 4]>
#>  4 Taylor Swift A Place In This World      <tibble [27 × 4]>
#>  5 Taylor Swift Cold As You                <tibble [24 × 4]>
#>  6 Taylor Swift The Outside                <tibble [37 × 4]>
#>  7 Taylor Swift Tied Together With A Smile <tibble [36 × 4]>
#>  8 Taylor Swift Stay Beautiful             <tibble [51 × 4]>
#>  9 Taylor Swift Should've Said No          <tibble [44 × 4]>
#> 10 Taylor Swift Mary's Song (Oh My My My)  <tibble [38 × 4]>
#> # ℹ 310 more rows
```

In other words, both `taylor_all_songs` and `taylor_ablum_songs` are
[nested data frames](https://tidyr.tidyverse.org/articles/nest.html).
Each has one row per track, and the lyrics for each track are are stored
in another data frame nested within each row.

There are three primary ways to access data from a nested list-column.
The first is to extract individual list elements. For example, if we
want to see the lyrics for “Cruel Summer,” we can look up which row of
the data set contains “Cruel Summer” and then access that element of the
list.

``` r
track_row <- which(track_lyrics$track_name == "Cruel Summer")
track_lyrics$lyrics[[track_row]]
#> # A tibble: 62 × 4
#>     line lyric                                            element element_artist
#>    <int> <chr>                                            <chr>   <chr>         
#>  1     1 (Yeah, yeah, yeah, yeah)                         Intro   Taylor Swift  
#>  2     2 Fever dream high in the quiet of the night       Verse 1 Taylor Swift  
#>  3     3 You know that I caught it (Oh yeah, you're righ… Verse 1 Taylor Swift  
#>  4     4 Bad, bad boy, shiny toy with a price             Verse 1 Taylor Swift  
#>  5     5 You know that I bought it (Oh yeah, you're righ… Verse 1 Taylor Swift  
#>  6     6 Killing me slow, out the window                  Pre-Ch… Taylor Swift  
#>  7     7 I'm always waiting for you to be waiting below   Pre-Ch… Taylor Swift  
#>  8     8 Devils roll the dice, angels roll their eyes     Pre-Ch… Taylor Swift  
#>  9     9 What doesn't kill me makes me want you more      Pre-Ch… Taylor Swift  
#> 10    10 And it's new, the shape of your body             Chorus  Taylor Swift  
#> # ℹ 52 more rows
```

As expected, this returns another data frame, with one row for each line
in the song. However, this approach only allows us to unnest one track
at a time. A more efficient method for extracting data in a nested
list-column is to use
[`tidyr::unnest()`](https://tidyr.tidyverse.org/reference/unnest.html).
This approach unnests all of the data in a list-column at once. Rather
than having a data set that is one row per song, we now have a data set
that is one row per line per song.

``` r
library(tidyr)

track_lyrics |>
  unnest(lyrics)
#> # A tibble: 15,986 × 6
#>    album_name   track_name  line lyric                    element element_artist
#>    <chr>        <chr>      <int> <chr>                    <chr>   <chr>         
#>  1 Taylor Swift Tim McGraw     1 "He said the way my blu… Verse 1 Taylor Swift  
#>  2 Taylor Swift Tim McGraw     2 "Put those Georgia star… Verse 1 Taylor Swift  
#>  3 Taylor Swift Tim McGraw     3 "I said, \"That's a lie… Verse 1 Taylor Swift  
#>  4 Taylor Swift Tim McGraw     4 "Just a boy in a Chevy … Verse 1 Taylor Swift  
#>  5 Taylor Swift Tim McGraw     5 "That had a tendency of… Verse 1 Taylor Swift  
#>  6 Taylor Swift Tim McGraw     6 "On backroads at night"  Verse 1 Taylor Swift  
#>  7 Taylor Swift Tim McGraw     7 "And I was right there … Verse 1 Taylor Swift  
#>  8 Taylor Swift Tim McGraw     8 "And then the time we w… Verse 1 Taylor Swift  
#>  9 Taylor Swift Tim McGraw     9 "But when you think Tim… Chorus  Taylor Swift  
#> 10 Taylor Swift Tim McGraw    10 "I hope you think my fa… Chorus  Taylor Swift  
#> # ℹ 15,976 more rows
```

If we are interested in the lyrics for only a specific album or a
specific song, we can always use
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
to include only the data we are interested in.

``` r
track_lyrics |>
  filter(track_name == "Cruel Summer") |>
  unnest(lyrics)
#> # A tibble: 62 × 6
#>    album_name track_name    line lyric                    element element_artist
#>    <chr>      <chr>        <int> <chr>                    <chr>   <chr>         
#>  1 Lover      Cruel Summer     1 (Yeah, yeah, yeah, yeah) Intro   Taylor Swift  
#>  2 Lover      Cruel Summer     2 Fever dream high in the… Verse 1 Taylor Swift  
#>  3 Lover      Cruel Summer     3 You know that I caught … Verse 1 Taylor Swift  
#>  4 Lover      Cruel Summer     4 Bad, bad boy, shiny toy… Verse 1 Taylor Swift  
#>  5 Lover      Cruel Summer     5 You know that I bought … Verse 1 Taylor Swift  
#>  6 Lover      Cruel Summer     6 Killing me slow, out th… Pre-Ch… Taylor Swift  
#>  7 Lover      Cruel Summer     7 I'm always waiting for … Pre-Ch… Taylor Swift  
#>  8 Lover      Cruel Summer     8 Devils roll the dice, a… Pre-Ch… Taylor Swift  
#>  9 Lover      Cruel Summer     9 What doesn't kill me ma… Pre-Ch… Taylor Swift  
#> 10 Lover      Cruel Summer    10 And it's new, the shape… Chorus  Taylor Swift  
#> # ℹ 52 more rows
```

Finally, sometimes we want to perform a calculation on each element of a
list-column. In this case, we don’t necessarily need to unnest each
element. Instead, we can use a combination of
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
and [`purrr::map()`](https://purrr.tidyverse.org/reference/map.html) to
apply a function to each element of the list-column. For example, we if
want to know the number of lines in each song, we can apply
[`nrow()`](https://rdrr.io/r/base/nrow.html) to each element of the list
column. Because [`nrow()`](https://rdrr.io/r/base/nrow.html) returns and
integer value, we’ll use
[`vapply()`](https://rdrr.io/r/base/lapply.html) (we could also use
[`purrr::map_int()`](https://purrr.tidyverse.org/reference/map.html)).

``` r
track_lyrics |>
  filter(album_name == "Lover") |>
  mutate(lines = vapply(lyrics, nrow, integer(1)))
#> # A tibble: 18 × 4
#>    album_name track_name                             lyrics            lines
#>    <chr>      <chr>                                  <list>            <int>
#>  1 Lover      I Forgot That You Existed              <tibble [45 × 4]>    45
#>  2 Lover      Cruel Summer                           <tibble [62 × 4]>    62
#>  3 Lover      Lover                                  <tibble [33 × 4]>    33
#>  4 Lover      The Man                                <tibble [48 × 4]>    48
#>  5 Lover      The Archer                             <tibble [45 × 4]>    45
#>  6 Lover      I Think He Knows                       <tibble [65 × 4]>    65
#>  7 Lover      Miss Americana & The Heartbreak Prince <tibble [62 × 4]>    62
#>  8 Lover      Paper Rings                            <tibble [65 × 4]>    65
#>  9 Lover      Cornelia Street                        <tibble [53 × 4]>    53
#> 10 Lover      Death By A Thousand Cuts               <tibble [60 × 4]>    60
#> 11 Lover      London Boy                             <tibble [58 × 4]>    58
#> 12 Lover      Soon You'll Get Better                 <tibble [46 × 4]>    46
#> 13 Lover      False God                              <tibble [50 × 4]>    50
#> 14 Lover      You Need To Calm Down                  <tibble [40 × 4]>    40
#> 15 Lover      Afterglow                              <tibble [48 × 4]>    48
#> 16 Lover      ME!                                    <tibble [64 × 4]>    64
#> 17 Lover      It's Nice To Have A Friend             <tibble [28 × 4]>    28
#> 18 Lover      Daylight                               <tibble [59 × 4]>    59
```

The resulting data frame is still one row per song, because we have not
unnested the lyrics. However, our summary statistic has been added as an
additional column.
