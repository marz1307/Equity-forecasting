#' Augmented Dickey-Fuller test
#'
#' Thin wrapper around `tseries::adf.test` that returns the full htest object.
#'
#' @param x A numeric vector or `ts`.
#' @param alternative Character: "stationary" or "explosive".
#' @return An object of class `htest`.
#' @examples
#' \dontrun{
#'   adf_test(ts_close)
#' }
#' @export
adf_test <- function(x, alternative = "stationary") {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  tseries::adf.test(x, alternative = alternative)
}

#' KPSS test
#'
#' @param x A numeric vector or `ts`.
#' @param null Character: "Level" or "Trend".
#' @return An object of class `htest`.
#' @examples
#' \dontrun{
#'   kpss_test(ts_close)
#' }
#' @export
kpss_test <- function(x, null = "Level") {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  tseries::kpss.test(x, null = null)
}

#' Determine whether a series is stationary
#'
#' Uses ADF and KPSS jointly. A series is reported stationary only when ADF
#' rejects the null of a unit root and KPSS fails to reject the null of
#' stationarity, both at level `alpha`.
#'
#' @param x A numeric vector or `ts`.
#' @param alpha Significance level (default 0.05).
#' @return A logical scalar.
#' @examples
#' \dontrun{
#'   is_stationary(ts_close)
#' }
#' @export
is_stationary <- function(x, alpha = 0.05) {
  adf <- suppressWarnings(adf_test(x))
  kpss <- suppressWarnings(kpss_test(x))
  adf_rejects_unit_root <- adf$p.value < alpha
  kpss_keeps_stationary <- kpss$p.value > alpha
  isTRUE(adf_rejects_unit_root) && isTRUE(kpss_keeps_stationary)
}
