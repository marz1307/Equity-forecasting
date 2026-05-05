## Source package R files so testthat::test_dir() works without full pkg install.
candidates <- c(
  file.path(getwd(), "..", "..", "R"),
  file.path(getwd(), "..", "R"),
  file.path(getwd(), "R")
)
pkg_r <- NULL
for (c_path in candidates) {
  if (dir.exists(c_path)) {
    pkg_r <- normalizePath(c_path, winslash = "/", mustWork = FALSE)
    break
  }
}
if (!is.null(pkg_r)) {
  for (f in list.files(pkg_r, pattern = "\\.R$", full.names = TRUE)) {
    source(f, local = FALSE)
  }
}
