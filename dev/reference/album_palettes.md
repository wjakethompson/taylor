# Color palettes based on Taylor Swift's albums

Premade color palettes based on Taylor Swifts album covers. For details
on how to extend and shorten these palettes, or create your own color
palette, see
[`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md).

## Usage

``` r
album_palettes

album_compare
```

## Format

A list of length 15. Each element contains a color palette for one of
Taylor Swift's studio albums. The list elements are named according to
the name of the album.

An object of class `taylor_color_palette` (inherits from `vctrs_vctr`,
`character`) of length 15.

## Source

Colors derived from album covers using 'Colormind'.

## See also

[`color_palette()`](https://taylor.wjakethompson.com/dev/reference/color_palette.md)

## Examples

``` r
album_palettes
#> $taylor_swift
#> <color_palette[5]>
#>     #1D4737 
#>     #81A757 
#>     #1BAEC6 
#>     #523d28 
#>     #E7DBCC 
#> 
#> $fearless
#> <color_palette[5]>
#>     #6E4823 
#>     #976F34 
#>     #CBA863 
#>     #ECD59F 
#>     #E1D4C2 
#> 
#> $speak_now
#> <color_palette[5]>
#>     #2E1924 
#>     #6C3127 
#>     #833C63 
#>     #D1A0C7 
#>     #F5E8E2 
#> 
#> $red
#> <color_palette[5]>
#>     #201F39 
#>     #A91E47 
#>     #7E6358 
#>     #B0A49A 
#>     #DDD8C9 
#> 
#> $`1989`
#> <color_palette[5]>
#>     #5D4E5D 
#>     #846578 
#>     #92573C 
#>     #C6B69C 
#>     #D8D8CF 
#> 
#> $reputation
#> <color_palette[5]>
#>     #2C2C2C 
#>     #515151 
#>     #5B5B5B 
#>     #6E6E6E 
#>     #B9B9B9 
#> 
#> $lover
#> <color_palette[5]>
#>     #76BAE0 
#>     #8C4F66 
#>     #B8396B 
#>     #EBBED3 
#>     #FFF5CC 
#> 
#> $folklore
#> <color_palette[5]>
#>     #3E3E3E 
#>     #545454 
#>     #5C5C5C 
#>     #949494 
#>     #EBEBEB 
#> 
#> $evermore
#> <color_palette[5]>
#>     #160E10 
#>     #421E18 
#>     #D37F55 
#>     #85796D 
#>     #E0D9D7 
#> 
#> $fearless_tv
#> <color_palette[5]>
#>     #624324 
#>     #A47F45 
#>     #CAA462 
#>     #C5AA7C 
#>     #EEDBA9 
#> 
#> $red_tv
#> <color_palette[5]>
#>     #400303 
#>     #731803 
#>     #967862 
#>     #B38468 
#>     #C7C5B6 
#> 
#> $midnights
#> <color_palette[5]>
#>     #121D27 
#>     #5A658B 
#>     #6F86A2 
#>     #85A7BA 
#>     #AA9EB6 
#> 
#> $speak_now_tv
#> <color_palette[5]>
#>     #2A122C 
#>     #4a2454 
#>     #72325F 
#>     #874886 
#>     #96689A 
#> 
#> $`1989_tv`
#> <color_palette[5]>
#>     #487398 
#>     #659BBB 
#>     #8BB5D2 
#>     #AFC5D4 
#>     #E4DFD3 
#> 
#> $tortured_poets
#> <color_palette[5]>
#>     #1C160F 
#>     #3F3824 
#>     #635B3A 
#>     #ADA795 
#>     #F7F4F0 
#> 

album_compare
#> <color_palette[15]>
#>     taylor_swift 
#>     fearless 
#>     speak_now 
#>     red 
#>     1989 
#>     reputation 
#>     lover 
#>     folklore 
#>     evermore 
#>     fearless_tv 
#>     red_tv 
#>     midnights 
#>     speak_now_tv 
#>     1989_tv 
#>     tortured_poets 

album_palettes$evermore
#> <color_palette[5]>
#>     #160E10 
#>     #421E18 
#>     #D37F55 
#>     #85796D 
#>     #E0D9D7 
```
