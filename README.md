
<!-- README.md is generated from README.Rmd. Please edit that file -->

# taylor <a href='https://taylor.wjakethompson.com'><img src='man/figures/logo.png' align="right" height="138" /></a>

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/wjakethompson)
[![R-CMD-check](https://github.com/wjakethompson/taylor/workflows/R-CMD-check/badge.svg)](https://github.com/wjakethompson/taylor/actions)
[![codecov](https://codecov.io/gh/wjakethompson/taylor/branch/main/graph/badge.svg?token=TECvfoOYHh)](https://codecov.io/gh/wjakethompson/taylor)
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
<!-- badges: end -->

The goal of {taylor} is to provide easy access to a curated data set of
Taylor Swift songs, including lyrics and audio characteristics. Data
comes [Genius](https://genius.com/artists/Taylor-swift) and the [Spotify
API](https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02).

![](https://media.giphy.com/media/2tg4k9pXNcGi7kZ9Pz/giphy.gif)

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("wjakethompson/taylor")
```

## Example

There are three main data sets. The first is `taylor_album_songs`, which
includes lyrics and audio features from the Spotify API for all songs on
Taylor’s official studio albums. Notably this excludes singles released
separately from an album (e.g., *Only the Young*, *Christmas Tree Farm*,
etc.), and non-Taylor-owned albums that have a Taylor-owned alternative
(e.g., *Fearless* is excluded in favor of *Fearless (Taylor’s
Version)*). We stan artists owning their own songs.

``` r
taylor_album_songs
#> # A tibble: 163 × 29
#>    album_name  ep    album_release track_number track_name     artist  featuring
#>    <chr>       <lgl> <date>               <int> <chr>          <chr>   <chr>    
#>  1 Taylor Swi… FALSE 2006-10-24               1 Tim McGraw     Taylor… <NA>     
#>  2 Taylor Swi… FALSE 2006-10-24               2 Picture To Bu… Taylor… <NA>     
#>  3 Taylor Swi… FALSE 2006-10-24               3 Teardrops On … Taylor… <NA>     
#>  4 Taylor Swi… FALSE 2006-10-24               4 A Place In Th… Taylor… <NA>     
#>  5 Taylor Swi… FALSE 2006-10-24               5 Cold As You    Taylor… <NA>     
#>  6 Taylor Swi… FALSE 2006-10-24               6 The Outside    Taylor… <NA>     
#>  7 Taylor Swi… FALSE 2006-10-24               7 Tied Together… Taylor… <NA>     
#>  8 Taylor Swi… FALSE 2006-10-24               8 Stay Beautiful Taylor… <NA>     
#>  9 Taylor Swi… FALSE 2006-10-24               9 Should've Sai… Taylor… <NA>     
#> 10 Taylor Swi… FALSE 2006-10-24              10 Mary's Song (… Taylor… <NA>     
#> # … with 153 more rows, and 22 more variables: bonus_track <lgl>,
#> #   promotional_release <date>, single_release <date>, track_release <date>,
#> #   danceability <dbl>, energy <dbl>, key <int>, loudness <dbl>, mode <int>,
#> #   speechiness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   liveness <dbl>, valence <dbl>, tempo <dbl>, time_signature <int>,
#> #   duration_ms <int>, explicit <lgl>, key_name <chr>, mode_name <chr>,
#> #   key_mode <chr>, lyrics <list>
```

You can access Taylor’s entire discography with `taylor_all_songs`. This
includes all of the songs in `taylor_album_songs` plus EPs, individual
singles, and the original versions of albums that have been re-released
as *Taylor’s Version*.

``` r
taylor_all_songs
#> # A tibble: 213 × 29
#>    album_name  ep    album_release track_number track_name     artist  featuring
#>    <chr>       <lgl> <date>               <int> <chr>          <chr>   <chr>    
#>  1 Taylor Swi… FALSE 2006-10-24               1 Tim McGraw     Taylor… <NA>     
#>  2 Taylor Swi… FALSE 2006-10-24               2 Picture To Bu… Taylor… <NA>     
#>  3 Taylor Swi… FALSE 2006-10-24               3 Teardrops On … Taylor… <NA>     
#>  4 Taylor Swi… FALSE 2006-10-24               4 A Place In Th… Taylor… <NA>     
#>  5 Taylor Swi… FALSE 2006-10-24               5 Cold As You    Taylor… <NA>     
#>  6 Taylor Swi… FALSE 2006-10-24               6 The Outside    Taylor… <NA>     
#>  7 Taylor Swi… FALSE 2006-10-24               7 Tied Together… Taylor… <NA>     
#>  8 Taylor Swi… FALSE 2006-10-24               8 Stay Beautiful Taylor… <NA>     
#>  9 Taylor Swi… FALSE 2006-10-24               9 Should've Sai… Taylor… <NA>     
#> 10 Taylor Swi… FALSE 2006-10-24              10 Mary's Song (… Taylor… <NA>     
#> # … with 203 more rows, and 22 more variables: bonus_track <lgl>,
#> #   promotional_release <date>, single_release <date>, track_release <date>,
#> #   danceability <dbl>, energy <dbl>, key <int>, loudness <dbl>, mode <int>,
#> #   speechiness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   liveness <dbl>, valence <dbl>, tempo <dbl>, time_signature <int>,
#> #   duration_ms <int>, explicit <lgl>, key_name <chr>, mode_name <chr>,
#> #   key_mode <chr>, lyrics <list>
```

Finally, there is a small data set, `taylor_albums`, summarizing
Taylor’s album release history.

``` r
taylor_albums
#> # A tibble: 12 × 4
#>    album_name                          ep    album_release metacritic_score
#>    <chr>                               <lgl> <date>                   <int>
#>  1 Taylor Swift                        FALSE 2006-10-24                  NA
#>  2 The Taylor Swift Holiday Collection TRUE  2007-10-14                  NA
#>  3 Beautiful Eyes                      TRUE  2008-07-15                  NA
#>  4 Fearless                            FALSE 2008-11-11                  73
#>  5 Speak Now                           FALSE 2010-10-25                  77
#>  6 Red                                 FALSE 2012-10-22                  77
#>  7 1989                                FALSE 2014-10-27                  76
#>  8 reputation                          FALSE 2017-11-10                  71
#>  9 Lover                               FALSE 2019-08-23                  79
#> 10 folklore                            FALSE 2020-07-24                  88
#> 11 evermore                            FALSE 2020-12-11                  85
#> 12 Fearless (Taylor's Version)         FALSE 2021-04-09                  82
```

## Code of Conduct

Please note that the {taylor} project is released with a [Contributor
Code of Conduct](https://taylor.wjakethompson.com/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
