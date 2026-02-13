# Translate a friendship bracelet

Receive a friendship bracelet at the Eras Tour but can't figure out what
lyrics the bracelet has abbreviated? Now you can find out!

## Usage

``` r
translate_bracelet(abbr)
```

## Arguments

- abbr:

  The abbreviated lyrics (i.e., the first letter of each word).

## Value

A character vector with the name of the song and the abbreviated line.

## Examples

``` r
translate_bracelet("bykmosftvfw")
#> All Too Well (Taylor's Version): But you keep my old scarf from that very first week
#> 
#> All Too Well (10 Minute Version) [Taylor's Version] [From The Vault]: But you keep my old scarf from that very first week
#> 

translate_bracelet("kimbkiagkitbimhotw")
#> Karma: karma is my boyfriend Karma is a god Karma is the breeze in my hair on the weekend
#> 
#> Karma (Remix): karma is my boyfriend Karma is a god Karma is the breeze in my hair on the weekend
#> 
```
