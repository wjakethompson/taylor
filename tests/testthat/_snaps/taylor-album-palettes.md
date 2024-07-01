# taylor_col() throws informative error.

    Code
      taylor_col(5, begin = -1)
    Condition
      Error in `taylor_col()`:
      ! `begin` must be between 0 and 1
    Code
      taylor_col(5, begin = 2)
    Condition
      Error in `taylor_col()`:
      ! `begin` must be between 0 and 1
    Code
      taylor_col(5, end = -1)
    Condition
      Error in `taylor_col()`:
      ! `end` must be between 0 and 1
    Code
      taylor_col(5, end = 2)
    Condition
      Error in `taylor_col()`:
      ! `end` must be between 0 and 1

---

    Code
      taylor_col(5, direction = 2)
    Condition
      Error in `taylor_col()`:
      ! `direction` must be 1 or -1
    Code
      taylor_col(5, direction = -3)
    Condition
      Error in `taylor_col()`:
      ! `direction` must be 1 or -1

