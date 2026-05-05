#' Ensure a directory exists
#'
#' Creates a directory recursively if it does not already exist. Safe to call
#' repeatedly; emits no warnings when the directory is already present.
#'
#' @param path Character scalar: the directory path to create.
#' @return Invisibly returns the (normalized) path.
#' @examples
#' \dontrun{
#'   ensure_dir("output/figures")
#' }
#' @export
ensure_dir <- function(path) {
  if (!is.character(path) || length(path) != 1L || is.na(path) || nchar(path) == 0L) {
    stop("`path` must be a non-empty character scalar.")
  }
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  invisible(path)
}
