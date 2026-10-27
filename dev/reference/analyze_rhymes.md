# Analyze rhymes in song lyrics

Detect assonance rhymes (matching vowel sounds) in lyrics and summarize
how densely the lyrics rhyme. This is an R implementation of
[Raplyzer](https://mining4meaning.com/2015/02/13/raplyzer/) by Eric
Malmi.

## Usage

``` r
analyze_rhymes(
  x,
  lookback = 15,
  min_length = 2,
  remove_duplicates = TRUE,
  lyrics_col = "lyrics",
  pronunciation = c("auto", "espeak", "cmudict")
)
```

## Source

Malmi, E. (2015). *Raplyzer*. <https://github.com/ekQ/raplysaattori>

Carnegie Mellon University. *The CMU Pronouncing Dictionary*.
<https://github.com/cmusphinx/cmudict>

*eSpeak NG*. <https://github.com/espeak-ng/espeak-ng>

## Arguments

- x:

  Lyrics to analyze. Either a character vector, where each element is
  the full text of one song with lines separated by `"\n"`, or a data
  frame with a list-column of lyrics, such as
  [taylor_album_songs](https://taylor.wjakethompson.com/dev/reference/taylor_songs.md)
  or
  [taylor_all_songs](https://taylor.wjakethompson.com/dev/reference/taylor_songs.md).
  Each element of the list-column should be a data frame with a `lyric`
  column, with one row per line.

- lookback:

  The number of previous words to search for a rhyme.

- min_length:

  The minimum number of matching vowels to count as a rhyme.

- remove_duplicates:

  Logical. Should duplicate lines (e.g., repeated choruses) be removed
  before analysis? Lines that are entirely within parentheses or
  brackets (e.g., backing vocals) are always removed.

- lyrics_col:

  If `x` is a data frame, the name of the list-column that contains the
  lyrics.

- pronunciation:

  Where pronunciations come from. One of `"auto"` (the default; eSpeak
  if it's installed, and otherwise the CMU Pronouncing Dictionary),
  `"espeak"`, or `"cmudict"`. See Details.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html). If `x`
is a character vector, there is one row per element of `x`, with a
`text` column containing the lyrics. If `x` is a data frame, `x` is
returned with additional columns. In both cases, the following columns
are included:

- `n_words`: The number of words analyzed. Words without a vowel sound
  (e.g., "the" or "hmm") are not included.

- `total_rhymes`: The number of words that rhyme with a previous word.

- `unique_rhymes`: The number of distinct rhyming word pairs. For
  example, if "night" rhymes with "tonight" three times, that is one
  unique rhyme.

- `rhyme_density`: The average rhyme length per word.

- `longest_rhyme_length`: The number of vowels in the longest rhyme.

- `longest_rhyme`: The two parts of the longest rhyme, separated by `/`.

Songs without any lyrics have missing values for all columns.

## Details

Each word in the lyrics is converted to a sequence of vowel sounds.
Consonants are ignored. For each word, the algorithm looks back at the
previous `lookback` words and finds the longest matching sequence of
vowels that ends with both words. The match starts at the last vowel of
each word and continues backward, crossing word boundaries, until the
first mismatch. For example, "bad blood" and "mad love" share two vowel
sounds (the *a* in "bad" and "mad", and the *u* in "blood" and "love"),
so they form a rhyme of length 2. A word can't rhyme with an identical
word, and a match stops when it reaches a pair of identical words (e.g.,
"cold as you" and "so as to" form a rhyme of length 1, because the match
stops at the repeated "as"). Rhymes shorter than `min_length` vowels are
ignored.

The rhyme density is the average rhyme length across all words, not
counting the first word. Higher values mean more (and longer) rhymes.
Raplyzer reported a rhyme density of 0.95 for Shakespeare's poems and
0.92 for the musical *Hamilton*. However, those values aren't directly
comparable to the values from this function, because of the differences
described below.

### Pronunciation

Like the original Raplyzer, pronunciations can come from the
[eSpeak](https://github.com/espeak-ng/espeak-ng) speech synthesizer,
which must be installed separately. If eSpeak isn't installed,
pronunciations come from the [CMU Pronouncing
Dictionary](https://github.com/cmusphinx/cmudict), which is included in
the package. Words not in the dictionary get a rough pronunciation from
their spelling. By default (`pronunciation = "auto"`), eSpeak is used if
it's installed. The two sources mostly agree, but results can differ
slightly, so set `pronunciation` explicitly if you need results that are
reproducible across computers. eSpeak is found by looking for
`espeak-ng` and then `espeak` on the `PATH`, or you can set the path
with `options(taylor.espeak = "path/to/espeak")`.

With either source, numbers are first converted to words the way they
are typically spoken (e.g., "22" becomes "twenty two", "1989" becomes
"nineteen eighty nine", and "2AM" becomes "two eh em").

### Differences from Raplyzer

This implementation differs from the original Raplyzer in a few ways:

- Each word is transcribed by itself, rather than in the context of the
  full lyrics, and similar vowels are grouped the same way for both
  pronunciation sources.

- Diphthongs (e.g., the vowel in "night") are treated as a single vowel,
  so "night" doesn't rhyme with "trap kit".

- Words are considered identical when they're spelled the same, rather
  than when they're pronounced the same.

## Examples

``` r
bad_blood <- paste(
  "Cause, baby, now we got bad blood",
  "You know it used to be mad love",
  sep = "\n"
)
analyze_rhymes(bad_blood)
#> # A tibble: 1 × 7
#>   text     n_words total_rhymes unique_rhymes rhyme_density longest_rhyme_length
#>   <chr>      <int>        <int>         <int>         <dbl>                <int>
#> 1 "Cause,…      15            1             1         0.143                    2
#> # ℹ 1 more variable: longest_rhyme <chr>

fearless <- taylor_album_songs[taylor_album_songs$album_name == "Fearless", ]
analyze_rhymes(fearless)
#> # A tibble: 19 × 32
#>    album_name ep    album_release track_number track_name       artist featuring
#>    <chr>      <lgl> <date>               <int> <chr>            <chr>  <chr>    
#>  1 Fearless   FALSE 2008-11-11               1 Fearless         Taylo… NA       
#>  2 Fearless   FALSE 2008-11-11               2 Fifteen          Taylo… NA       
#>  3 Fearless   FALSE 2008-11-11               3 Love Story       Taylo… NA       
#>  4 Fearless   FALSE 2008-11-11               4 Hey Stephen      Taylo… NA       
#>  5 Fearless   FALSE 2008-11-11               5 White Horse      Taylo… NA       
#>  6 Fearless   FALSE 2008-11-11               6 You Belong With… Taylo… NA       
#>  7 Fearless   FALSE 2008-11-11               7 Breathe          Taylo… Colbie C…
#>  8 Fearless   FALSE 2008-11-11               8 Tell Me Why      Taylo… NA       
#>  9 Fearless   FALSE 2008-11-11               9 You're Not Sorry Taylo… NA       
#> 10 Fearless   FALSE 2008-11-11              10 The Way I Loved… Taylo… NA       
#> 11 Fearless   FALSE 2008-11-11              11 Forever & Always Taylo… NA       
#> 12 Fearless   FALSE 2008-11-11              12 The Best Day     Taylo… NA       
#> 13 Fearless   FALSE 2008-11-11              13 Change           Taylo… NA       
#> 14 Fearless   FALSE 2008-11-11              14 Jump Then Fall   Taylo… NA       
#> 15 Fearless   FALSE 2008-11-11              15 Untouchable      Taylo… NA       
#> 16 Fearless   FALSE 2008-11-11              16 Forever & Alway… Taylo… NA       
#> 17 Fearless   FALSE 2008-11-11              17 Come In With Th… Taylo… NA       
#> 18 Fearless   FALSE 2008-11-11              18 SuperStar        Taylo… NA       
#> 19 Fearless   FALSE 2008-11-11              19 The Other Side … Taylo… NA       
#> # ℹ 25 more variables: bonus_track <lgl>, promotional_release <date>,
#> #   single_release <date>, track_release <date>, danceability <dbl>,
#> #   energy <dbl>, loudness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   valence <dbl>, tempo <dbl>, duration_ms <int>, explicit <lgl>, key <int>,
#> #   mode <int>, key_name <chr>, mode_name <chr>, key_mode <chr>, lyrics <list>,
#> #   n_words <int>, total_rhymes <int>, unique_rhymes <int>,
#> #   rhyme_density <dbl>, longest_rhyme_length <int>, longest_rhyme <chr>
```
