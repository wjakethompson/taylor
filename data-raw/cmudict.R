library(tidyverse)

devtools::load_all()

# Pronunciations come from the CMU Pronouncing Dictionary (BSD-2 license),
# pinned to a specific commit for reproducibility.
cmudict_commit <- "74790861f652b15e4ac49015a90074ad62a27690"
cmudict_url <- paste0(
  "https://raw.githubusercontent.com/cmusphinx/cmudict/",
  cmudict_commit,
  "/cmudict.dict"
)

cmudict_raw <- read_lines(cmudict_url)

# Each line is "word PH1 PH2 ...", optionally followed by "# comment".
# Alternate pronunciations are listed as "word(2)"; keep only the first.
cmudict <- tibble(raw = cmudict_raw) |>
  mutate(raw = str_remove(raw, "\\s*#.*$")) |>
  separate_wider_regex(raw, c(word = "^\\S+", "\\s+", phones = ".*$")) |>
  filter(!str_detect(word, "\\(\\d+\\)$"))

# Vowel coding -----------------------------------------------------------------
# Mirrors the vowel handling in raplyzer's phonetics.py:
#   * unstressed schwa (AH0) is dropped, as raplyzer ignores eSpeak's `@`
#   * similar vowels are merged (AO -> AA, IH -> IY, EH -> EY), matching
#     raplyzer's 0/O -> o, I -> i, and E -> e
#   * diphthongs (AW, AY, OW, OY) are kept as single vowels
# Each vowel is stored as a single ASCII letter so the data compresses well.
vowel_codes <- c(
  AA = "a",
  AO = "a",
  AE = "b",
  AH = "c",
  AW = "d",
  AY = "e",
  EH = "f",
  EY = "f",
  ER = "g",
  IH = "h",
  IY = "h",
  OW = "i",
  OY = "j",
  UH = "k",
  UW = "l"
)

code_vowels <- function(phones) {
  purrr::map_chr(stringr::str_split(phones, " "), function(ph) {
    ph <- ph[ph != "AH0"]
    ph <- stringr::str_remove(ph, "\\d$")
    paste(vowel_codes[ph[ph %in% names(vowel_codes)]], collapse = "")
  })
}

cmu_vowels <- cmudict |>
  mutate(vowels = code_vowels(phones)) |>
  select(word, vowels) |>
  deframe()


# QC ---------------------------------------------------------------------------
# Every pronunciation should code to ASCII letters only.
stopifnot(all(grepl("^[a-l]*$", cmu_vowels)))

# How much of Taylor's vocabulary is covered by the dictionary?
lyric_words <- taylor_all_songs$lyrics |>
  map(\(x) x$lyric) |>
  unlist() |>
  clean_lyric_lines(remove_duplicates = FALSE) |>
  tokenize_words() |>
  unlist()

lyric_vocab <- unique(lyric_words)
oov <- lyric_vocab[is.na(lookup_dictionary(lyric_vocab))]

cat(
  "Out-of-vocabulary rate:",
  scales::percent(mean(is.na(lookup_dictionary(lyric_words))), 0.01),
  "of tokens;",
  scales::percent(length(oov) / length(lyric_vocab), 0.01),
  "of unique words\n"
)
sort(oov)


# Save -------------------------------------------------------------------------
usethis::use_data(
  cmu_vowels,
  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)
