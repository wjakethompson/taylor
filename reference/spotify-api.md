# Spotify API helpers

Set and retrieve Spotify client information.

## Usage

``` r
get_spotify_access_token()

set_spotify_api_key(id = NULL, secret = NULL)
```

## Arguments

- id:

  A Spotify Client ID.

- secret:

  A Spotify Client Secret.

## Value

- `get_spotify_api_key()` returns a previously stored Client ID and
  Secret.

- `set_spotify_api_key()` is called for side effects only.

## Examples

``` r
get_spotify_access_token()
#> $client_id
#> [1] "c7935f85f8b0447ea7d77c92364d0dd2"
#> 
#> $client_secret
#> [1] "dc409a6ff5844a26b3a43d909aea7380"
#> 
```
