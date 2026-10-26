#' Analyze rhymes in song lyrics
#'
#' Detect assonance rhymes (matching vowel sounds) in lyrics and summarize how
#' densely the lyrics rhyme. This is an R implementation of
#' [Raplyzer](https://mining4meaning.com/2015/02/13/raplyzer/) by Eric Malmi.
#'
#' @details
#' Each word in the lyrics is converted to a sequence of vowel sounds.
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
#' ## Pronunciation
#' Like the original Raplyzer, pronunciations can come from the
#' [eSpeak](https://github.com/espeak-ng/espeak-ng) speech synthesizer, which
#' must be installed separately. If eSpeak isn't installed, pronunciations come
#' from the [CMU Pronouncing Dictionary](https://github.com/cmusphinx/cmudict),
#' which is included in the package. Words not in the dictionary get a rough
#' pronunciation from their spelling. By default (`pronunciation = "auto"`),
#' eSpeak is used if it's installed. The two sources mostly agree, but results
#' can differ slightly, so set `pronunciation` explicitly if you need results
#' that are reproducible across computers. eSpeak is found by looking for
#' `espeak-ng` and then `espeak` on the `PATH`, or you can set the path with
#' `options(taylor.espeak = "path/to/espeak")`.
#'
#' With either source, numbers are first converted to words the way they are
#' typically spoken (e.g., "22" becomes "twenty two", "1989" becomes "nineteen
#' eighty nine", and "2AM" becomes "two eh em").
#'
#' ## Differences from Raplyzer
#' This implementation differs from the original Raplyzer in a few ways:
#' * Each word is transcribed by itself, rather than in the context of the
#'   full lyrics, and similar vowels are grouped the same way for both
#'   pronunciation sources.
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
#' @param pronunciation Where pronunciations come from. One of `"auto"` (the
#'   default; eSpeak if it's installed, and otherwise the CMU Pronouncing
#'   Dictionary), `"espeak"`, or `"cmudict"`. See Details.
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
#' @source *eSpeak NG*. <https://github.com/espeak-ng/espeak-ng>
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
  lyrics_col = "lyrics",
  pronunciation = c("auto", "espeak", "cmudict")
) {
  lookback <- check_pos_int(lookback)
  min_length <- check_pos_int(min_length)
  remove_duplicates <- check_logical(remove_duplicates)
  lyrics_col <- check_character(lyrics_col)
  pronunciation <- rlang::arg_match(pronunciation)
  if (lookback < 1) {
    abort_bad_argument("lookback", must = "be at least 1")
  }
  if (min_length < 1) {
    abort_bad_argument("min_length", must = "be at least 1")
  }

  if (is.character(x)) {
    songs <- strsplit(x, "\n", fixed = TRUE)
  } else if (is.data.frame(x)) {
    if (!lyrics_col %in% names(x) || !is.list(x[[lyrics_col]])) {
      cli::cli_abort(
        "{.arg x} must have a list-column named {.val {lyrics_col}}."
      )
    }
    songs <- lapply(x[[lyrics_col]], function(.x) {
      if (is.data.frame(.x)) .x$lyric else .x
    })
  } else {
    abort_bad_argument(
      "x",
      must = "be a character vector or data frame",
      not = class(x)[1]
    )
  }

  songs <- lapply(songs, function(.x) {
    if (is.null(.x) || all(is.na(.x))) {
      return(NULL)
    }
    clean_lyric_lines(.x, remove_duplicates = remove_duplicates)
  })
  pronounce <- pronunciation_engine(
    pronunciation,
    words = unique(unlist(lapply(songs, tokenize_words)))
  )

  stats <- lapply(songs, function(.x) {
    if (is.null(.x)) {
      return(summarize_rhymes(NULL))
    }
    summarize_rhymes(rhyme_detail(.x, lookback, min_length, pronounce))
  })
  stats <- vec_rbind(!!!stats)

  if (is.character(x)) {
    return(vec_cbind(tibble::tibble(text = x), stats))
  }
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
#' @param pronounce A function that takes a character vector of words and
#'   returns their coded vowel sequences.
#' @inheritParams analyze_rhymes
#'
#' @return A tibble with one row per word, containing the word, the length of
#'   its longest rhyme, and the word indices of the two parts of the rhyme.
#' @noRd
rhyme_detail <- function(
  lines,
  lookback = 15,
  min_length = 2,
  pronounce = lookup_pronunciation
) {
  words <- unlist(tokenize_words(lines))
  words <- words[words != ""]
  vowels <- pronounce(words)

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
  # times are spoken as letters, e.g., "2AM" or "2 a.m.", using spellings
  # that both pronunciation sources code with the same vowels
  lines <- gsub("([0-9]) ?a\\.? ?m\\b\\.?", "\\1 eh em", lines, perl = TRUE)
  lines <- gsub("([0-9]) ?p\\.? ?m\\b\\.?", "\\1 pee em", lines, perl = TRUE)
  words <- strsplit(lines, "[^a-z0-9']+")
  lapply(words, function(.x) {
    .x <- .x[.x != "" & grepl("[a-z0-9]", .x)]
    has_digit <- grepl("[0-9]", .x)
    if (!any(has_digit)) {
      return(.x)
    }
    .x <- as.list(.x)
    .x[has_digit] <- lapply(.x[has_digit], number_to_words)
    unlist(.x, use.names = FALSE)
  })
}

#' Convert a word containing numbers to words
#'
#' Numbers are converted the way they are typically spoken in lyrics, using
#' the english package for the number names. For example, "22" becomes
#' "twenty two", "1989" becomes "nineteen eighty nine", "'90s" becomes
#' "nineties", and "16th" becomes "sixteenth".
#'
#' @param word A single lower case word that contains at least one digit.
#'
#' @return A character vector of words.
#' @noRd
number_to_words <- function(word) {
  word <- gsub("^'+|'+$", "", word)

  # split into runs of digits and letters, e.g., "g5" or "16th"
  parts <- regmatches(word, gregexpr("[0-9]+|[a-z']+", word))[[1]]
  words <- character(0)
  i <- 1
  while (i <= length(parts)) {
    part <- parts[i]
    if (!grepl("^[0-9]+$", part)) {
      words <- c(words, part)
      i <- i + 1
      next
    }

    suffix <- if (i < length(parts)) parts[i + 1] else ""
    if (suffix %in% c("st", "nd", "rd", "th")) {
      words <- c(words, spell_number(part, ordinal = TRUE))
      i <- i + 2
    } else if (suffix == "s") {
      # decades, e.g., "1950s" or "90s"
      spelled <- spell_number(part)
      last <- length(spelled)
      plural <- if (grepl("x$", spelled[last])) "es" else "s"
      spelled[last] <- paste0(sub("y$", "ie", spelled[last]), plural)
      words <- c(words, spelled)
      i <- i + 2
    } else {
      words <- c(words, spell_number(part))
      i <- i + 1
    }
  }

  as.character(unlist(strsplit(words, "[^a-z']+"), use.names = FALSE))
}

#' Spell out a string of digits
#'
#' @param digits A single string of digits, e.g., "22".
#' @param ordinal Logical. Should the number be spelled as an ordinal (e.g.,
#'   "sixteenth")?
#'
#' @return A character vector of words.
#' @noRd
spell_number <- function(digits, ordinal = FALSE) {
  # very long digit strings aren't spoken as numbers
  if (nchar(digits) > 15) {
    return(character(0))
  }

  n <- as.numeric(digits)
  spell <- function(.n, ordinal = FALSE) {
    words <- if (ordinal) english::ordinal(.n) else english::as.english(.n)
    strsplit(as.character(words), "[^a-z]+")[[1]]
  }

  # leading zeros are spoken as "oh", e.g., the "05" in "8:05"
  if (nchar(digits) == 2 && startsWith(digits, "0")) {
    return(if (n == 0) "o'clock" else c("oh", spell(n, ordinal)))
  }

  # years are spoken in pairs, e.g., "nineteen eighty nine"
  is_year <- nchar(digits) == 4 &&
    ((n >= 1100 && n <= 1999) || (n >= 2010 && n <= 2099))
  if (is_year) {
    low <- n %% 100
    low_words <- if (low == 0) {
      if (ordinal) "hundredth" else "hundred"
    } else if (low < 10) {
      c("oh", spell(low, ordinal))
    } else {
      spell(low, ordinal)
    }
    return(c(spell(n %/% 100), low_words))
  }

  spell(n, ordinal)
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
    # `cmu_vowels` is internal data in R/sysdata.rda, which lintr can't see
    # nolint start: object_usage_linter
    dictionary$vowels <- list2env(as.list(cmu_vowels), hash = TRUE)
    # nolint end
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
    ee = "h",
    ea = "h",
    ie = "h",
    ey = "h",
    ei = "f",
    ay = "f",
    ai = "f",
    oo = "l",
    ou = "d",
    ow = "i",
    oa = "i",
    oe = "i",
    au = "a",
    aw = "a",
    oi = "j",
    oy = "j",
    ue = "l",
    ew = "l",
    ui = "l"
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


# Pronunciation sources --------------------------------------------------------
#' Choose how words are converted to vowel sounds
#'
#' @param pronunciation One of `"auto"`, `"espeak"`, or `"cmudict"`.
#' @param words All words that will be pronounced. For eSpeak, these are
#'   transcribed in a single call up front.
#' @param call The calling environment, for error messages.
#'
#' @return A function that takes a character vector of words and returns their
#'   coded vowel sequences.
#' @noRd
pronunciation_engine <- function(
  pronunciation = c("auto", "espeak", "cmudict"),
  words = character(0),
  call = rlang::caller_env()
) {
  pronunciation <- rlang::arg_match(pronunciation, error_call = call)
  if (pronunciation == "cmudict") {
    return(lookup_pronunciation)
  }

  path <- espeak_path()
  if (!nzchar(path)) {
    if (pronunciation == "espeak") {
      cli::cli_abort(
        c(
          "eSpeak could not be found.",
          "i" = "Install eSpeak NG from
                 {.url https://github.com/espeak-ng/espeak-ng}, or set
                 {.code options(taylor.espeak = \"path/to/espeak\")}."
        ),
        call = call
      )
    }
    return(lookup_pronunciation)
  }

  vowels <- tryCatch(
    espeak_pronunciation(words, path = path),
    error = function(e) {
      if (pronunciation == "espeak") {
        cli::cli_abort("eSpeak failed.", parent = e, call = call)
      }
      cli::cli_warn(
        "eSpeak failed, so the CMU Pronouncing Dictionary was used instead.",
        parent = e,
        call = call
      )
      NULL
    }
  )
  if (is.null(vowels)) {
    return(lookup_pronunciation)
  }

  function(words) espeak_pronunciation(words, path = path)
}

#' Find the eSpeak program
#'
#' Uses the `taylor.espeak` option if set, and otherwise looks for
#' `espeak-ng` and then `espeak` on the `PATH`.
#'
#' @return The path to eSpeak, or `""` if it isn't installed.
#' @noRd
espeak_path <- function() {
  path <- getOption("taylor.espeak", default = "")
  if (nzchar(path)) {
    return(unname(Sys.which(path)))
  }
  for (program in c("espeak-ng", "espeak")) {
    path <- unname(Sys.which(program))
    if (nzchar(path)) {
      return(path)
    }
  }
  ""
}

#' Look up the vowel sounds of words with eSpeak
#'
#' Transcriptions are cached for the session, so each word is only sent to
#' eSpeak once. Words that eSpeak can't transcribe fall back to
#' `lookup_pronunciation()`.
#'
#' @param words A character vector of lower case words.
#' @param path The path to eSpeak.
#'
#' @return A character vector of coded vowel sequences.
#' @noRd
espeak_pronunciation <- function(words, path = espeak_path()) {
  if (is.null(dictionary$espeak)) {
    dictionary$espeak <- new.env(hash = TRUE, parent = emptyenv())
  }
  cache <- dictionary$espeak

  new_words <- unique(words[nzchar(words)])
  new_words <- new_words[!vapply(new_words, exists, logical(1), envir = cache)]
  if (length(new_words) > 0) {
    # eSpeak misreads dropped g's (e.g., "fadin'"), which don't change vowels
    spelled <- sub("in'$", "ing", gsub("^'+", "", new_words))
    vowels <- espeak_to_vowels(run_espeak(spelled, path = path))
    # an isolated "a" is read as the letter, but in lyrics it's a schwa
    vowels[new_words == "a"] <- ""
    missing <- is.na(vowels)
    vowels[missing] <- lookup_pronunciation(new_words[missing])
    list2env(as.list(stats::setNames(vowels, new_words)), envir = cache)
  }

  vowels <- rep("", length(words))
  valid <- nzchar(words)
  vowels[valid] <- unlist(mget(words[valid], envir = cache), use.names = FALSE)
  vowels
}

#' Transcribe words with eSpeak
#'
#' @param words A character vector of words.
#' @param path The path to eSpeak.
#'
#' @return A character vector of eSpeak phoneme mnemonics, one per word.
#' @noRd
run_espeak <- function(words, path = espeak_path()) {
  input <- tempfile(fileext = ".txt")
  on.exit(unlink(input), add = TRUE)
  # one word per line; the period makes each line a separate clause
  writeLines(paste0(words, "."), input, useBytes = TRUE)

  output <- suppressWarnings(system2(
    path,
    args = c("-q", "-x", "-v", "en-us", "-f", shQuote(input)),
    stdout = TRUE,
    stderr = FALSE
  ))
  status <- attr(output, "status")
  if (!is.null(status) && status != 0) {
    cli::cli_abort("eSpeak exited with status {status}.")
  }
  if (length(output) != length(words)) {
    cli::cli_abort(
      "eSpeak returned {length(output)} transcription{?s} for
       {length(words)} word{?s}."
    )
  }

  trimws(output)
}

#' Convert eSpeak phonemes to coded vowel sequences
#'
#' eSpeak phonemes are mapped to the same vowel codes used for the CMU
#' Pronouncing Dictionary (see `data-raw/cmudict.R`), so results are similar
#' regardless of the pronunciation source. Schwas are dropped, and
#' diphthongs are a single vowel.
#'
#' @param phonemes A character vector of eSpeak phoneme mnemonics (from
#'   `espeak -x`), one per word.
#'
#' @return A character vector of coded vowel sequences, or `NA` for empty
#'   transcriptions.
#' @noRd
espeak_to_vowels <- function(phonemes) {
  # longer phonemes are listed first, so they're matched before their prefixes
  espeak_vowels <- c(
    "aI@" = "eg",
    "aU@" = "dg",
    "i@3" = "h",
    "A:" = "a",
    "A@" = "a",
    "O:" = "a",
    "O@" = "a",
    "o@" = "a",
    "3:" = "g",
    "i:" = "h",
    "i@" = "h",
    "I#" = "h",
    "I2" = "h",
    "e@" = "f",
    "eI" = "f",
    "aI" = "e",
    "aU" = "d",
    "oU" = "i",
    "OI" = "j",
    "u:" = "l",
    "U:" = "l",
    "U@" = "k",
    "aa" = "b",
    "a#" = "",
    "@2" = "",
    "@5" = "",
    "@L" = "",
    "a" = "b",
    "A" = "a",
    "0" = "a",
    "O" = "a",
    "o" = "i",
    "E" = "f",
    "e" = "f",
    "I" = "h",
    "i" = "h",
    "V" = "c",
    "U" = "k",
    "u" = "l",
    "3" = "g",
    "@" = ""
  )
  pattern <- paste0(
    "(",
    paste(gsub("([@#:])", "\\\\\\1", names(espeak_vowels)), collapse = "|"),
    ")"
  )

  # stress, syllable, and pause marks don't affect the vowels
  phonemes <- gsub("[',%=_|-]", "", phonemes)
  vapply(
    phonemes,
    function(.x) {
      if (is.na(.x) || !nzchar(.x)) {
        return(NA_character_)
      }
      matches <- regmatches(.x, gregexpr(pattern, .x, perl = TRUE))[[1]]
      paste(espeak_vowels[matches], collapse = "")
    },
    character(1),
    USE.NAMES = FALSE
  )
}
