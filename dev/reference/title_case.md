# Convert string to title case

Capitalize the first letter of each word, and convert the remaining
string to lower case.

## Usage

``` r
title_case(string)
```

## Arguments

- string:

  String to modify.

## Value

A character string with the first letter of each word capitalized.

## Examples

``` r
title_case("taylor swift")
#> [1] "Taylor Swift"
title_case("Taylor Swift")
#> [1] "Taylor Swift"
title_case("TAYLOR SWIFT")
#> [1] "Taylor Swift"
```
