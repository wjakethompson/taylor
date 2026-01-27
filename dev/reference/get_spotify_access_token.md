# Spotify API helpers

This is a wrapper around
[`spotifyr::get_spotify_access_token()`](https://rdrr.io/pkg/spotifyr/man/get_spotify_access_token.html)
to create a Spotify access token from stored environment variables.

## Usage

``` r
get_spotify_access_token()
```

## Value

The Spotify access token.

## Examples

``` r
get_spotify_access_token()
#> [1] "BQA8xdaIC_s-vq5reKZs9eV4l2RJYeMECe_5C-DAxQ87hLnw2blAhno66TayJoYKZfIfW7Yixm4_pvJPr2SiefKFbpLEh_q4svIIbnUub8MlxfwJG3GYNDrPUNAQ9e8FrJgrkiuht5s"
```
