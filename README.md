
<!-- README.md is generated from README.Rmd. Please edit that file -->

# taylor

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![CRAN
status](https://www.r-pkg.org/badges/version/taylor)](https://CRAN.R-project.org/package=taylor)
[![R-CMD-check](https://github.com/wjakethompson/taylor/workflows/R-CMD-check/badge.svg)](https://github.com/wjakethompson/taylor/actions)
[![codecov](https://codecov.io/gh/wjakethompson/taylor/branch/main/graph/badge.svg?token=TECvfoOYHh)](https://app.codecov.io/gh/wjakethompson/taylor)
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg) [![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/wjakethompson)
<!-- badges: end -->

## Overview <img src="man/figures/logo.png" align="right" width="120" />

The goal of {taylor} is to provide easy access to a curated data set of
Taylor Swift songs, including lyrics and audio characteristics. Data
comes [Genius](https://genius.com/artists/Taylor-swift) and the [Spotify
API](https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02).

![](https://media.giphy.com/media/2tg4k9pXNcGi7kZ9Pz/giphy.gif)

## Installation

You can install the released version of {taylor} from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages(taylor)
```

To install the development version from [GitHub](https://github.com/)
use:

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
#> # A tibble: 194 × 29
#>    album_name ep    album_re…¹ track…² track…³ artist featu…⁴ bonus…⁵ promotio…⁶
#>    <chr>      <lgl> <date>       <int> <chr>   <chr>  <chr>   <lgl>   <date>    
#>  1 Taylor Sw… FALSE 2006-10-24       1 Tim Mc… Taylo… <NA>    FALSE   NA        
#>  2 Taylor Sw… FALSE 2006-10-24       2 Pictur… Taylo… <NA>    FALSE   NA        
#>  3 Taylor Sw… FALSE 2006-10-24       3 Teardr… Taylo… <NA>    FALSE   NA        
#>  4 Taylor Sw… FALSE 2006-10-24       4 A Plac… Taylo… <NA>    FALSE   NA        
#>  5 Taylor Sw… FALSE 2006-10-24       5 Cold A… Taylo… <NA>    FALSE   NA        
#>  6 Taylor Sw… FALSE 2006-10-24       6 The Ou… Taylo… <NA>    FALSE   NA        
#>  7 Taylor Sw… FALSE 2006-10-24       7 Tied T… Taylo… <NA>    FALSE   NA        
#>  8 Taylor Sw… FALSE 2006-10-24       8 Stay B… Taylo… <NA>    FALSE   NA        
#>  9 Taylor Sw… FALSE 2006-10-24       9 Should… Taylo… <NA>    FALSE   NA        
#> 10 Taylor Sw… FALSE 2006-10-24      10 Mary's… Taylo… <NA>    FALSE   NA        
#> # … with 184 more rows, 20 more variables: single_release <date>,
#> #   track_release <date>, danceability <dbl>, energy <dbl>, key <int>,
#> #   loudness <dbl>, mode <int>, speechiness <dbl>, acousticness <dbl>,
#> #   instrumentalness <dbl>, liveness <dbl>, valence <dbl>, tempo <dbl>,
#> #   time_signature <int>, duration_ms <int>, explicit <lgl>, key_name <chr>,
#> #   mode_name <chr>, key_mode <chr>, lyrics <list>, and abbreviated variable
#> #   names ¹​album_release, ²​track_number, ³​track_name, ⁴​featuring, …
```

You can access Taylor’s entire discography with `taylor_all_songs`. This
includes all of the songs in `taylor_album_songs` plus EPs, individual
singles, and the original versions of albums that have been re-released
as *Taylor’s Version*.

``` r
taylor_all_songs
#> # A tibble: 274 × 29
#>    album_name ep    album_re…¹ track…² track…³ artist featu…⁴ bonus…⁵ promotio…⁶
#>    <chr>      <lgl> <date>       <int> <chr>   <chr>  <chr>   <lgl>   <date>    
#>  1 Taylor Sw… FALSE 2006-10-24       1 Tim Mc… Taylo… <NA>    FALSE   NA        
#>  2 Taylor Sw… FALSE 2006-10-24       2 Pictur… Taylo… <NA>    FALSE   NA        
#>  3 Taylor Sw… FALSE 2006-10-24       3 Teardr… Taylo… <NA>    FALSE   NA        
#>  4 Taylor Sw… FALSE 2006-10-24       4 A Plac… Taylo… <NA>    FALSE   NA        
#>  5 Taylor Sw… FALSE 2006-10-24       5 Cold A… Taylo… <NA>    FALSE   NA        
#>  6 Taylor Sw… FALSE 2006-10-24       6 The Ou… Taylo… <NA>    FALSE   NA        
#>  7 Taylor Sw… FALSE 2006-10-24       7 Tied T… Taylo… <NA>    FALSE   NA        
#>  8 Taylor Sw… FALSE 2006-10-24       8 Stay B… Taylo… <NA>    FALSE   NA        
#>  9 Taylor Sw… FALSE 2006-10-24       9 Should… Taylo… <NA>    FALSE   NA        
#> 10 Taylor Sw… FALSE 2006-10-24      10 Mary's… Taylo… <NA>    FALSE   NA        
#> # … with 264 more rows, 20 more variables: single_release <date>,
#> #   track_release <date>, danceability <dbl>, energy <dbl>, key <int>,
#> #   loudness <dbl>, mode <int>, speechiness <dbl>, acousticness <dbl>,
#> #   instrumentalness <dbl>, liveness <dbl>, valence <dbl>, tempo <dbl>,
#> #   time_signature <int>, duration_ms <int>, explicit <lgl>, key_name <chr>,
#> #   mode_name <chr>, key_mode <chr>, lyrics <list>, and abbreviated variable
#> #   names ¹​album_release, ²​track_number, ³​track_name, ⁴​featuring, …
```

Finally, there is a small data set, `taylor_albums`, summarizing
Taylor’s album release history.

``` r
taylor_albums
#> # A tibble: 14 × 5
#>    album_name                          ep    album_release metacritic_…¹ user_…²
#>    <chr>                               <lgl> <date>                <int>   <dbl>
#>  1 Taylor Swift                        FALSE 2006-10-24               67     9.1
#>  2 The Taylor Swift Holiday Collection TRUE  2007-10-14               NA    NA  
#>  3 Beautiful Eyes                      TRUE  2008-07-15               NA    NA  
#>  4 Fearless                            FALSE 2008-11-11               73     8.4
#>  5 Speak Now                           FALSE 2010-10-25               77     8.7
#>  6 Red                                 FALSE 2012-10-22               77     8.6
#>  7 1989                                FALSE 2014-10-27               76     8.2
#>  8 reputation                          FALSE 2017-11-10               71     8.3
#>  9 Lover                               FALSE 2019-08-23               79     8.4
#> 10 folklore                            FALSE 2020-07-24               88     9  
#> 11 evermore                            FALSE 2020-12-11               85     8.9
#> 12 Fearless (Taylor's Version)         FALSE 2021-04-09               82     8.9
#> 13 Red (Taylor's Version)              FALSE 2021-11-12               91     9  
#> 14 Midnights                           FALSE 2022-10-21               85     8.3
#> # … with abbreviated variable names ¹​metacritic_score, ²​user_score
```

## Code of Conduct

Please note that the {taylor} project is released with a [Contributor
Code of Conduct](https://taylor.wjakethompson.com/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
