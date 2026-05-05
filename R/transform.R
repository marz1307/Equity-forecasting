#' Convert a price data frame into a `ts` object
#'
#' @param df A data frame containing a numeric `Close` column.
#' @param freq Integer: number of observations per seasonal period
#'   (default 252, the typical count of trading days per year).
#' @return A `ts` object of closing prices.
#' @examples
#' \dontrun{
#'   to_ts(df, freq = 252)
#' }
#' @export
to_ts <- function(df, freq = 252L) {
  validate_share_prices(df)
  if (!is.numeric(freq) || length(freq) != 1L || freq < 1L) {
    stop("`freq` must be a single positive integer.")
  }
  stats::ts(df$Close, frequency = as.integer(freq))
}

#' Apply a natural log transform to a `ts`
#'
#' @param x A numeric vector or `ts`. Must be strictly positive.
#' @return The element-wise natural logarithm, preserving `ts` attributes.
#' @examples
#' \dontrun{
#'   log_transform(ts_close)
#' }
#' @export
log_transform <- function(x) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  if (any(x <= 0, na.rm = TRUE)) {
    stop("`x` must be strictly positive for a log transform.")
  }
  log(x)
}

#' Apply differencing to a series
#'
#' @param x A numeric vector or `ts`.
#' @param d Integer order of differencing (default 1).
#' @return The differenced series.
#' @examples
#' \dontrun{
#'   differences(ts_close, d = 1)
#' }
#' @export
differences <- function(x, d = 1L) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  if (!is.numeric(d) || length(d) != 1L || d < 0L) {
    stop("`d` must be a non-negative integer scalar.")
  }
  diff(x, differences = as.integer(d))
}
