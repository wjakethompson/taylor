#' Analyze rhymes in song lyrics
#'
#' Detect assonance rhymes (matching vowel sounds) in lyrics and summarize how
#' densely the lyrics rhyme. This is an R implementation of
#' [Raplyzer](https://mining4meaning.com/2015/02/13/raplyzer/) by Eric Malmi.
#'
#' @details
#' Each word in the lyrics is converted to a sequence of vowel sounds using
#' the [CMU Pronouncing Dictionary](https://github.com/cmusphinx/cmudict).
#' Consonants are ignored. For each word, the algorithm looks back at the
#' previous `lookback` words and finds the longest matching sequence of vowels
#' that ends with both words. The match starts at the last vowel of each word
#' and continues backward, crossing word boundaries, until the first
#' mismatch. For example, "bad blood" and "mad love" share two vowel sounds
#' (the *a* in "bad" and "mad", and the *u* in "blood" and "love"), so they
#' form a rhyme of length 2. A word can't rhyme with an identical word, and a
#' match stops when it reaches a pair of identical words (e.g., "cold as you"
#' and "so as to" form a rhyme of length 1, because the match stops at the
#' repeated "as"). Rhymes shorter than `min_length` vowels are ignored.
#'
#' The rhyme density is the average rhyme length across all words, not
#' counting the first word. Higher values mean more (and longer) rhymes.
#' Raplyzer reported a rhyme density of 0.95 for Shakespeare's poems and 0.92
#' for the musical *Hamilton*. However, those values aren't directly
#' comparable to the values from this function, because of the differences
#' described below.
#'
#' This implementation differs from the original Raplyzer in a few ways:
#' * Pronunciations come from the CMU Pronouncing Dictionary instead of the
#'   eSpeak speech synthesizer. Words not in the dictionary get a rough
#'   pronunciation from their spelling. Numbers are ignored.
#' * Diphthongs (e.g., the vowel in "night") are treated as a single vowel, so
#'   "night" doesn't rhyme with "trap kit".
#' * Words are considered identical when they're spelled the same, rather than
#'   when they're pronounced the same.
#'
#' @param x Lyrics to analyze. Either a character vector, where each element
#'   is the full text of one song with lines separated by `"\n"`, or a data
#'   frame with a list-column of lyrics, such as [taylor_album_songs] or
#'   [taylor_all_songs]. Each element of the list-column should be a data
#'   frame with a `lyric` column, with one row per line.
#' @param lookback The number of previous words to search for a rhyme.
#' @param min_length The minimum number of matching vowels to count as a
#'   rhyme.
#' @param remove_duplicates Logical. Should duplicate lines (e.g., repeated
#'   choruses) be removed before analysis? Lines that are entirely within
#'   parentheses or brackets (e.g., backing vocals) are always removed.
#' @param lyrics_col If `x` is a data frame, the name of the list-column that
#'   contains the lyrics.
#'
#' @return A [tibble][tibble::tibble()]. If `x` is a character vector, there is
#'   one row per element of `x`, with a `text` column containing the lyrics.
#'   If `x` is a data frame, `x` is returned with additional columns. In both
#'   cases, the following columns are included:
#'   * `n_words`: The number of words analyzed. Words without a vowel sound
#'     (e.g., "the" or "hmm") are not included.
#'   * `total_rhymes`: The number of words that rhyme with a previous word.
#'   * `unique_rhymes`: The number of distinct rhyming word pairs. For
#'     example, if "night" rhymes with "tonight" three times, that is one
#'     unique rhyme.
#'   * `rhyme_density`: The average rhyme length per word.
#'   * `longest_rhyme_length`: The number of vowels in the longest rhyme.
#'   * `longest_rhyme`: The two parts of the longest rhyme, separated by `/`.
#'
#'   Songs without any lyrics have missing values for all columns.
#' @export
#'
#' @source Malmi, E. (2015). *Raplyzer*.
#'   <https://github.com/ekQ/raplysaattori>
#' @source Carnegie Mellon University. *The CMU Pronouncing Dictionary*.
#'   <https://github.com/cmusphinx/cmudict>
#'
#' @examples
#' bad_blood <- paste(
#'   "Cause, baby, now we got bad blood",
#'   "You know it used to be mad love",
#'   sep = "\n"
#' )
#' analyze_rhymes(bad_blood)
#'
#' fearless <- taylor_album_songs[taylor_album_songs$album_name == "Fearless", ]
#' analyze_rhymes(fearless)
analyze_rhymes <- function(
  x,
  lookback = 15,
  min_length = 2,
  remove_duplicates = TRUE,
  lyrics_col = "lyrics"
) {
  lookback <- check_pos_int(lookback)
  min_length <- check_pos_int(min_length)
  remove_duplicates <- check_logical(remove_duplicates)
  lyrics_col <- check_character(lyrics_col)
  if (lookback < 1) {
    abort_bad_argument("lookback", must = "be at least 1")
  }
  if (min_length < 1) {
    abort_bad_argument("min_length", must = "be at least 1")
  }

  song_stats <- function(lines) {
    if (is.null(lines) || all(is.na(lines))) {
      return(summarize_rhymes(NULL))
    }
    lines <- clean_lyric_lines(lines, remove_duplicates = remove_duplicates)
    summarize_rhymes(rhyme_detail(lines, lookback, min_length))
  }

  if (is.character(x)) {
    stats <- lapply(strsplit(x, "\n", fixed = TRUE), song_stats)
    return(vec_cbind(tibble::tibble(text = x), vec_rbind(!!!stats)))
  }

  if (!is.data.frame(x)) {
    abort_bad_argument(
      "x",
      must = "be a character vector or data frame",
      not = class(x)[1]
    )
  }
  if (!lyrics_col %in% names(x) || !is.list(x[[lyrics_col]])) {
    cli::cli_abort(
      "{.arg x} must have a list-column named {.val {lyrics_col}}."
    )
  }

  stats <- lapply(x[[lyrics_col]], function(.x) {
    if (is.data.frame(.x)) {
      .x <- .x$lyric
    }
    song_stats(.x)
  })
  stats <- vec_rbind(!!!stats)

  x <- tibble::as_tibble(x)
  x[names(stats)] <- stats
  x
}


# Rhyme detection --------------------------------------------------------------
# The rhyme detection algorithm is ported from Raplyzer
# (https://github.com/ekQ/raplysaattori), Copyright (c) 2014 ekQ (Eric Malmi),
# released under the MIT license. See inst/COPYRIGHTS.

#' Find the longest rhyme for each word
#'
#' @param lines A character vector of cleaned lyric lines.
#' @inheritParams analyze_rhymes
#'
#' @return A tibble with one row per word, containing the word, the length of
#'   its longest rhyme, and the word indices of the two parts of the rhyme.
#' @noRd
rhyme_detail <- function(lines, lookback = 15, min_length = 2) {
  words <- unlist(tokenize_words(lines))
  words <- words[words != ""]
  vowels <- lookup_pronunciation(words)

  # words without a vowel sound can't rhyme
  keep <- nchar(vowels) > 0
  words <- gsub("^'+|'+$", "", words[keep])
  vowels <- vowels[keep]

  n_words <- length(words)
  vow <- unlist(strsplit(vowels, ""))
  word_end <- cumsum(nchar(vowels))
  vow_word <- rep(seq_len(n_words), times = nchar(vowels))

  rhyme_length <- integer(n_words)
  end1 <- start1 <- start2 <- rep(NA_integer_, n_words)

  for (w2 in seq_len(n_words)[-1]) {
    p2 <- word_end[w2]

    # only previous words whose last vowel matches can rhyme
    w1s <- max(1L, w2 - lookback):(w2 - 1L)
    w1s <- w1s[vow[word_end[w1s]] == vow[p2] & words[w1s] != words[w2]]

    for (w1 in w1s) {
      p1 <- word_end[w1]
      l <- 0L
      while (vow[p1 - l] == vow[p2 - l]) {
        # don't count repeated words preceding the rhyme as part of the rhyme
        a <- vow_word[p1 - l]
        b <- vow_word[p2 - l]
        if (a < w1 && b < w2 && words[a] == words[b]) {
          break
        }

        l <- l + 1L
        if (p1 - l < 1 || p2 - l <= p1) {
          break
        }
      }
      if (l < min_length) {
        l <- 0L
      }

      if (l > rhyme_length[w2]) {
        rhyme_length[w2] <- l
        end1[w2] <- w1
        start1[w2] <- vow_word[p1 - l + 1L]
        start2[w2] <- vow_word[p2 - l + 1L]
      }
    }
  }

  tibble::tibble(
    word = words,
    rhyme_length = rhyme_length,
    start1 = start1,
    end1 = end1,
    start2 = start2
  )
}

#' Summarize word-level rhymes for a song
#'
#' @param detail Output from `rhyme_detail()`, or `NULL` for a song without
#'   lyrics.
#'
#' @return A one-row tibble of rhyme statistics.
#' @noRd
summarize_rhymes <- function(detail) {
  if (is.null(detail)) {
    return(tibble::tibble(
      n_words = NA_integer_,
      total_rhymes = NA_integer_,
      unique_rhymes = NA_integer_,
      rhyme_density = NA_real_,
      longest_rhyme_length = NA_integer_,
      longest_rhyme = NA_character_
    ))
  }

  n_words <- nrow(detail)
  rhymes <- which(detail$rhyme_length > 0)

  pairs <- vapply(
    rhymes,
    function(.x) {
      pair <- c(detail$word[.x], detail$word[detail$end1[.x]])
      paste(sort(pair), collapse = " ")
    },
    character(1)
  )

  longest_rhyme <- NA_character_
  longest_rhyme_length <- 0L
  if (length(rhymes) > 0) {
    w2 <- rhymes[which.max(detail$rhyme_length[rhymes])]
    longest_rhyme_length <- detail$rhyme_length[w2]
    longest_rhyme <- paste(
      paste(detail$word[detail$start1[w2]:detail$end1[w2]], collapse = " "),
      paste(detail$word[detail$start2[w2]:w2], collapse = " "),
      sep = " / "
    )
  }

  tibble::tibble(
    n_words = n_words,
    total_rhymes = length(rhymes),
    unique_rhymes = length(unique(pairs)),
    rhyme_density = if (n_words > 1) mean(detail$rhyme_length[-1]) else 0,
    longest_rhyme_length = longest_rhyme_length,
    longest_rhyme = longest_rhyme
  )
}


# Text processing --------------------------------------------------------------
#' Clean lyric lines before rhyme detection
#'
#' @param lines A character vector of lyric lines.
#' @inheritParams analyze_rhymes
#'
#' @return A character vector of cleaned lines.
#' @noRd
clean_lyric_lines <- function(lines, remove_duplicates = TRUE) {
  lines <- trimws(lines[!is.na(lines)])

  # drop lines that are entirely backing vocals, e.g., "(Oh, oh)"
  lines <- lines[!grepl("^(\\(.*\\)|\\[.*\\])$", lines)]
  lines <- lines[lines != ""]

  if (remove_duplicates) {
    key <- trimws(gsub("[^a-z0-9']+", " ", tolower(lines)))
    lines <- lines[!duplicated(key)]
  }

  lines
}

#' Split lyric lines into words
#'
#' @param lines A character vector of lyric lines.
#'
#' @return A list of character vectors, one per line, with lower case words.
#' @noRd
tokenize_words <- function(lines) {
  lines <- gsub("[\u2018\u2019]", "'", lines)
  # transliterate accented vowels (e.g., "cafe")
  accented <- paste0(
    "\u00e0\u00e1\u00e2\u00e4\u00e8\u00e9\u00ea\u00eb\u00ec\u00ed",
    "\u00ee\u00ef\u00f2\u00f3\u00f4\u00f6\u00f9\u00fa\u00fb\u00fc"
  )
  lines <- chartr(accented, "aaaaeeeeiiiioooouuuu", tolower(lines))
  words <- strsplit(lines, "[^a-z0-9']+")
  lapply(words, function(.x) .x[.x != "" & grepl("[a-z0-9]", .x)])
}


# Pronunciation ----------------------------------------------------------------
# Vowel sounds are coded as single letters (see data-raw/cmudict.R):
#   a: AA/AO (father, thought)   b: AE (trap)      c: AH (strut)
#   d: AW (mouth)                e: AY (price)     f: EH/EY (dress, face)
#   g: ER (nurse)                h: IH/IY (kit, fleece)
#   i: OW (goat)                 j: OY (choice)    k: UH (foot)
#   l: UW (goose)

# Subsetting `cmu_vowels` by name hashes all ~125,000 names on every call, so
# the dictionary is converted to a hashed environment once and cached.
dictionary <- new.env(parent = emptyenv())

dictionary_get <- function(words) {
  if (is.null(dictionary$vowels)) {
    dictionary$vowels <- list2env(as.list(cmu_vowels), hash = TRUE)
  }
  vowels <- rep(NA_character_, length(words))
  valid <- !is.na(words) & nzchar(words)
  vowels[valid] <- unlist(
    mget(words[valid], envir = dictionary$vowels, ifnotfound = NA_character_),
    use.names = FALSE
  )
  vowels
}

#' Look up the vowel sounds of words
#'
#' @param words A character vector of lower case words.
#'
#' @return A character vector of coded vowel sequences. Words not in the
#'   dictionary are guessed from their spelling.
#' @noRd
lookup_pronunciation <- function(words) {
  vowels <- lookup_dictionary(words)
  oov <- is.na(vowels)
  vowels[oov] <- vapply(
    words[oov],
    guess_vowels,
    character(1),
    USE.NAMES = FALSE
  )
  vowels
}

#' Look up the vowel sounds of words in the CMU Pronouncing Dictionary
#'
#' @param words A character vector of lower case words.
#'
#' @return A character vector of coded vowel sequences, or `NA` for words not
#'   in the dictionary.
#' @noRd
lookup_dictionary <- function(words) {
  vowels <- dictionary_get(words)

  variants <- list(
    function(.x) gsub("^'+|'+$", "", .x),
    function(.x) sub("in'$", "ing", .x),
    function(.x) sub("'s$", "", gsub("^'+", "", .x)),
    function(.x) sub("([^s])s$", "\\1", .x)
  )
  for (variant in variants) {
    missing <- is.na(vowels)
    if (!any(missing)) {
      break
    }
    vowels[missing] <- dictionary_get(variant(words[missing]))
  }

  missing <- is.na(vowels)
  vowels[missing] <- vapply(
    words[missing],
    lookup_compound,
    character(1),
    USE.NAMES = FALSE
  )

  vowels
}

#' Look up the vowel sounds of a compound word
#'
#' @param word A single lower case word, e.g., "teardrops".
#'
#' @return A coded vowel sequence, or `NA` if the word can't be split into two
#'   dictionary words.
#' @noRd
lookup_compound <- function(word) {
  n <- nchar(word)
  if (n < 6) {
    return(NA_character_)
  }

  # prefer the longest first word, with at least 3 letters in each part
  for (split in (n - 3):3) {
    first <- substr(word, 1, split)
    last <- substr(word, split + 1, n)
    last <- c(last, sub("([^s])s$", "\\1", last))
    vowels <- dictionary_get(c(first, last))
    if (!is.na(vowels[1]) && any(!is.na(vowels[-1]))) {
      return(paste0(vowels[1], vowels[-1][!is.na(vowels[-1])][1]))
    }
  }

  NA_character_
}

#' Guess the vowel sounds of a word from its spelling
#'
#' A rough fallback for words that aren't in the CMU Pronouncing Dictionary.
#'
#' @param word A single lower case word.
#'
#' @return A coded vowel sequence.
#' @noRd
guess_vowels <- function(word) {
  word <- gsub("[^a-z]", "", word)
  # "igh" is a long i, and initial y is a consonant (e.g., "yeah")
  word <- gsub("igh", "I", word, fixed = TRUE)
  word <- sub("^y", "", word)
  # silent final e (e.g., "hate"), when another vowel precedes it
  silent_e <- grepl("[aeiouyI][^aeiouyI]e$", word)
  if (silent_e) {
    word <- sub("e$", "", word)
  }

  # vowel letter groups, including a trailing w (e.g., "saw", "new")
  matches <- gregexpr("[aeiouyI]+(w(?![aeiouy]))?", word, perl = TRUE)
  groups <- regmatches(word, matches)[[1]]
  if (length(groups) == 0) {
    return("")
  }
  ends <- matches[[1]] + attr(matches[[1]], "match.length") - 1

  digraphs <- c(
    ee = "h", ea = "h", ie = "h", ey = "h", ei = "f",
    ay = "f", ai = "f", oo = "l", ou = "d", ow = "i",
    oa = "i", oe = "i", au = "a", aw = "a", oi = "j",
    oy = "j", ue = "l", ew = "l", ui = "l"
  )
  short <- c(a = "b", e = "f", i = "h", o = "a", u = "c", y = "h", I = "e")
  long <- c(a = "f", e = "h", i = "e", o = "i", u = "l", y = "e", I = "e")

  codes <- vapply(
    seq_along(groups),
    function(.i) {
      group <- groups[.i]
      if (nchar(group) > 1) {
        code <- digraphs[substr(group, 1, 2)]
        return(if (is.na(code)) short[[substr(group, 1, 1)]] else code[[1]])
      }
      is_last <- .i == length(groups)
      # long vowel before a silent e, or a final open vowel (e.g., "my", "go")
      if (is_last && (silent_e || ends[.i] == nchar(word))) {
        if (group == "y" && length(groups) > 1) {
          return("h")
        }
        return(long[[group]])
      }
      short[[group]]
    },
    character(1)
  )

  paste(codes, collapse = "")
}
