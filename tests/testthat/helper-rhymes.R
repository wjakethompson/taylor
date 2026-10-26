# eSpeak isn't available on CRAN, but it is installed on CI (see the
# workflows in .github/), so a missing installation on CI is an error rather
# than a reason to skip
skip_if_no_espeak <- function(path) {
  testthat::skip_on_cran()
  if (nzchar(path)) {
    return(invisible(TRUE))
  }
  if (nzchar(Sys.getenv("CI"))) {
    stop("eSpeak should be installed on CI, but it could not be found.")
  }
  testthat::skip("eSpeak is not installed")
}

# Create a fake executable (a shell script) named `name` in `dir`
write_fake_program <- function(dir, name, script) {
  path <- file.path(dir, name)
  writeLines(c("#!/bin/sh", script), path)
  Sys.chmod(path, "0755")
  path
}
