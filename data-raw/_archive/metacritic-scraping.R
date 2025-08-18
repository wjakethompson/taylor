# Manual metacritic - boo!
metacritic <- tribble(
  ~album_name,                           ~metacritic_score, ~user_score,
  "1989 (Taylor's Version)",             100L,              NA_real_,
  "Speak Now (Taylor's Version)",        81L,               9.2,
  "Midnights",                           85L,               8.3,
  "Red (Taylor's Version)",              91L,               9.0,
  "Fearless (Taylor's Version)",         82L,               8.9,
  "evermore",                            85L,               8.9,
  "folklore",                            88L,               9.0,
  "Lover",                               79L,               8.4,
  "reputation",                          71L,               8.3,
  "1989",                                76L,               8.2,
  "Red",                                 77L,               8.5,
  "Speak Now",                           77L,               8.6,
  "Fearless",                            73L,               8.4,
  "Taylor Swift",                        67L,               8.5
)

# Old metacritic website ~ summer 2023
site <- read_html("https://www.metacritic.com/person/taylor-swift")
metacritic <- html_table(site) %>%
  pluck(2) %>%
  separate_wider_regex(
    `Title:`,
    patterns = c(
      metacritic_score = "[0-9|tbd]*",
      "\\n\\n[ ]*",
      album_name = ".*"
    )
  ) %>%
  mutate(
    metacritic_score = na_if(metacritic_score, "tbd"),
    metacritic_score = as.integer(metacritic_score),
    album_name = str_replace_all(
      album_name,
      fixed("[Taylor's Version]"),
      "(Taylor's Version)"
    )
  ) %>%
  select(album_name, metacritic_score, user_score = `User score:`)
