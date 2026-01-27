# SoundStat API helpers

Set and retrieve a SoundStat API key

## Usage

``` r
get_soundstat_api_key()

set_soundstat_api_key(key = NULL)
```

## Arguments

- key:

  A SoundStat API key.

## Value

- `get_soundstat_api_key()` returns a previously stored API key.

- `set_soundstat_api_key()` is called for side effects only.

## Examples

``` r
get_soundstat_api_key()
#> Error in get_soundstat_api_key(): No API key found, please supply with `api_key` argument or with the
#> `SOUNDSTAT_KEY` env var (`?get_soundstat_api_key()`)
```
