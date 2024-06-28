# abort_bad_argument() is informative.

    Code
      abort_bad_argument("size", "be an integer", not = "character")
    Condition
      Error:
      ! `size` must be an integer; not character
    Code
      abort_bad_argument("size", must = "be an integer", not = "character", footer = c(
        i = "please"))
    Condition
      Error:
      ! `size` must be an integer; not character
      i please
    Code
      abort_bad_argument("size", must = "be an integer", not = "character", footer = "required",
        custom = "A new error")
    Condition
      Error:
      ! A new error

# abort_bad_argument() can add inline markup to footer

    Code
      a_local_variable <- "local var"
      footer <- cli::format_message(c(x = "Look at {.val {a_local_variable}}"))
      abort_bad_argument("size", "be an integer", footer = footer)
    Condition
      Error:
      ! `size` must be an integer
      x Look at "local var"

# check_palette() throws informative error.

    Code
      check_palette(2)
    Condition
      Error:
      ! `2` must be a character vector; not double
    Code
      check_palette(NA_character_)
    Condition
      Error:
      ! `NA_character_` must not contain missing values

---

    Code
      x <- c("#009fb7", "firetruck")
      check_palette(x)
    Condition
      Error:
      ! `x` must be valid hexadecimal values or from `colors()`.
      i Problematic value: "firetruck".

# check_pos_int() errors well

    Code
      check_pos_int("blue")
    Condition
      Error:
      ! `"blue"` must be numeric; not character
    Code
      check_pos_int(NA_integer_, "taylor")
    Condition
      Error:
      ! `taylor` must be non-missing
    Code
      check_pos_int(integer(0L))
    Condition
      Error:
      ! `integer(0L)` must have length of 1; not 0
    Code
      check_pos_int(2:3)
    Condition
      Error:
      ! `2:3` must have length of 1; not 2
    Code
      check_pos_int(-2)
    Condition
      Error:
      ! `-2L` must be greater than 0

# check_real_range() works

    Code
      check_real_range("a", 0, 1, "taylor")
    Condition
      Error:
      ! `taylor` must be numeric; not character
    Code
      check_real_range(NA_integer_, 1, 5)
    Condition
      Error:
      ! `NA_integer_` must be non-missing
    Code
      check_real_range(integer(0L), 1, 5)
    Condition
      Error:
      ! `integer(0L)` must have length of 1; not 0
    Code
      check_real_range(2:3, 0, 1)
    Condition
      Error:
      ! `2:3` must have length of 1; not 2
    Code
      check_real_range(2, 0, 1)
    Condition
      Error:
      ! `2` must be between 0 and 1
    Code
      check_real_range(-1, 0, 1)
    Condition
      Error:
      ! `-1` must be between 0 and 1

# check_exact_abs_int() errors well

    Code
      check_exact_abs_int("a", 1)
    Condition
      Error:
      ! `"a"` must be numeric; not character
    Code
      check_exact_abs_int(NA_integer_, 1)
    Condition
      Error:
      ! `NA_integer_` must be non-missing
    Code
      check_exact_abs_int(integer(0), 1)
    Condition
      Error:
      ! `integer(0)` must have length of 1; not 0
    Code
      check_exact_abs_int(2:3, 1)
    Condition
      Error:
      ! `2:3` must have length of 1; not 2
    Code
      check_exact_abs_int(3, 1)
    Condition
      Error:
      ! `3` must be 1 or -1
    Code
      check_exact_abs_int(3, 4)
    Condition
      Error:
      ! `3` must be 4 or -4

# check_character() errors well

    Code
      check_character(1, arg = "taylor")
    Condition
      Error:
      ! `taylor` must be character; not double
    Code
      check_character(NA_character_)
    Condition
      Error:
      ! `NA_character_` must be non-missing

