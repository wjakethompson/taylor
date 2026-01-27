# Determine if code is executed interactively or in pkgdown

Used for determining examples that shouldn't be run on CRAN, but can be
run for the pkgdown website.

## Usage

``` r
taylor_examples()
```

## Value

A logical value indicating whether or not the examples should be run.

## Examples

``` r
taylor_examples()
#> [1] TRUE
```
