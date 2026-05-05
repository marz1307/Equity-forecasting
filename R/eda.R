#' Summarise a price data frame
#'
#' Computes minimum, median, mean, maximum, standard deviation, missing-value
#' count, and date range for the closing price column.
#'
#' @param df A data frame with `Date` and `Close` columns.
#' @return A one-row data frame of summary statistics.
#' @examples
#' \dontrun{
#'   summarize_prices(df)
#' }
#' @export
summarize_prices <- function(df) {
  validate_share_prices(df)
  data.frame(
    n = nrow(df),
    min = min(df$Close, na.rm = TRUE),
    median = stats::median(df$Close, na.rm = TRUE),
    mean = mean(df$Close, na.rm = TRUE),
    max = max(df$Close, na.rm = TRUE),
    sd = stats::sd(df$Close, na.rm = TRUE),
    n_missing = sum(is.na(df$Close)),
    date_min = min(df$Date, na.rm = TRUE),
    date_max = max(df$Date, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}

#' Quantile distribution of closing prices
#'
#' @param df A data frame with a numeric `Close` column.
#' @param probs Numeric vector of probabilities for `stats::quantile`.
#' @return A named numeric vector of quantiles.
#' @examples
#' \dontrun{
#'   price_distribution(df)
#' }
#' @export
price_distribution <- function(df, probs = c(0.05, 0.25, 0.5, 0.75, 0.95)) {
  validate_share_prices(df)
  stats::quantile(df$Close, probs = probs, na.rm = TRUE)
}

#' Summary of trading volume
#'
#' @param df A data frame with a `Volume` column. Returns NULL with a
#'   message if the column is absent.
#' @return A named numeric vector or NULL.
#' @examples
#' \dontrun{
#'   volume_summary(df)
#' }
#' @export
volume_summary <- function(df) {
  if (!"Volume" %in% colnames(df)) {
    message("No `Volume` column present; nothing to summarise.")
    return(invisible(NULL))
  }
  c(
    min = min(df$Volume, na.rm = TRUE),
    median = stats::median(df$Volume, na.rm = TRUE),
    mean = mean(df$Volume, na.rm = TRUE),
    max = max(df$Volume, na.rm = TRUE)
  )
}
