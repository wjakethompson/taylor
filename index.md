# taylor

## Overview

The goal of taylor is to provide easy access to a curated data set of
Taylor Swift songs, including lyrics and audio characteristics. Data
comes [Genius](https://genius.com/artists/Taylor-swift) and the
[SoundStat API](https://soundstat.info).

![GIF of Taylor saying
“yes”](https://media.giphy.com/media/2tg4k9pXNcGi7kZ9Pz/giphy.gif)

GIF of Taylor saying “yes”

## Installation

You can install the released version of taylor from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("taylor")
```

To install the development version from [GitHub](https://github.com/)
use:

``` r
# install.packages("remotes")
remotes::install_github("wjakethompson/taylor")
```

## Example

There are three main data sets. The first is `taylor_album_songs`, which
includes lyrics and audio features from the SoundStat API for all songs
on Taylor’s official studio albums. Notably this excludes singles
released separately from an album (e.g., “Only the Young”, “Christmas
Tree Farm”, etc.) and EPs (e.g., *Beautiful Eyes*). However, now that
Taylor [owns all her
masters](https://www.taylorswift.com/read-my-letter/), both the original
and Taylor’s Version are included for albums that were rerecorded (e.g.,
both *Fearless* and *Fearless (Taylor’s Version)* are present).

``` r
taylor_album_songs
#> # A tibble: 332 × 26
#>    album_name   ep    album_release track_number track_name     artist featuring
#>    <chr>        <lgl> <date>               <int> <chr>          <chr>  <chr>    
#>  1 Taylor Swift FALSE 2006-10-24               1 Tim McGraw     Taylo… <NA>     
#>  2 Taylor Swift FALSE 2006-10-24               2 Picture To Bu… Taylo… <NA>     
#>  3 Taylor Swift FALSE 2006-10-24               3 Teardrops On … Taylo… <NA>     
#>  4 Taylor Swift FALSE 2006-10-24               4 A Place In Th… Taylo… <NA>     
#>  5 Taylor Swift FALSE 2006-10-24               5 Cold As You    Taylo… <NA>     
#>  6 Taylor Swift FALSE 2006-10-24               6 The Outside    Taylo… <NA>     
#>  7 Taylor Swift FALSE 2006-10-24               7 Tied Together… Taylo… <NA>     
#>  8 Taylor Swift FALSE 2006-10-24               8 Stay Beautiful Taylo… <NA>     
#>  9 Taylor Swift FALSE 2006-10-24               9 Should've Sai… Taylo… <NA>     
#> 10 Taylor Swift FALSE 2006-10-24              10 Mary's Song (… Taylo… <NA>     
#> # ℹ 322 more rows
#> # ℹ 19 more variables: bonus_track <lgl>, promotional_release <date>,
#> #   single_release <date>, track_release <date>, danceability <dbl>,
#> #   energy <dbl>, loudness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   valence <dbl>, tempo <dbl>, duration_ms <int>, explicit <lgl>, key <int>,
#> #   mode <int>, key_name <chr>, mode_name <chr>, key_mode <chr>, lyrics <list>
```

You can access Taylor’s entire discography with `taylor_all_songs`. This
includes all of the songs in `taylor_album_songs` plus EPs, individual
singles, and songs where Taylor is credited as a featured artist or
writer.

``` r
taylor_all_songs
#> # A tibble: 384 × 26
#>    album_name   ep    album_release track_number track_name     artist featuring
#>    <chr>        <lgl> <date>               <int> <chr>          <chr>  <chr>    
#>  1 Taylor Swift FALSE 2006-10-24               1 Tim McGraw     Taylo… <NA>     
#>  2 Taylor Swift FALSE 2006-10-24               2 Picture To Bu… Taylo… <NA>     
#>  3 Taylor Swift FALSE 2006-10-24               3 Teardrops On … Taylo… <NA>     
#>  4 Taylor Swift FALSE 2006-10-24               4 A Place In Th… Taylo… <NA>     
#>  5 Taylor Swift FALSE 2006-10-24               5 Cold As You    Taylo… <NA>     
#>  6 Taylor Swift FALSE 2006-10-24               6 The Outside    Taylo… <NA>     
#>  7 Taylor Swift FALSE 2006-10-24               7 Tied Together… Taylo… <NA>     
#>  8 Taylor Swift FALSE 2006-10-24               8 Stay Beautiful Taylo… <NA>     
#>  9 Taylor Swift FALSE 2006-10-24               9 Should've Sai… Taylo… <NA>     
#> 10 Taylor Swift FALSE 2006-10-24              10 Mary's Song (… Taylo… <NA>     
#> # ℹ 374 more rows
#> # ℹ 19 more variables: bonus_track <lgl>, promotional_release <date>,
#> #   single_release <date>, track_release <date>, danceability <dbl>,
#> #   energy <dbl>, loudness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   valence <dbl>, tempo <dbl>, duration_ms <int>, explicit <lgl>, key <int>,
#> #   mode <int>, key_name <chr>, mode_name <chr>, key_mode <chr>, lyrics <list>
```

Finally, there is a small data set, `taylor_albums`, summarizing
Taylor’s album release history.

``` r
taylor_albums
#> # A tibble: 18 × 5
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
#> 18 The Life of a Showgirl        FALSE 2025-10-03                  69       NA
```

## Code of Conduct

Contributions are welcome. To ensure a smooth process, please review the
[Contributing
Guide](https://taylor.wjakethompson.com/CONTRIBUTING.html). Please note
that the taylor project is released with a [Contributor Code of
Conduct](https://taylor.wjakethompson.com/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
