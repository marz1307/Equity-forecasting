#' Standard residual diagnostics for a fitted model
#'
#' Returns a list combining a Ljung-Box test, a Shapiro-Wilk normality test
#' (sub-sampled to 5000 points where necessary because Shapiro-Wilk is
#' undefined above that), and basic moments.
#'
#' @param model A fitted model with a `residuals` method.
#' @param lag Integer Ljung-Box lag (default 20).
#' @return A named list of diagnostic results.
#' @examples
#' \dontrun{
#'   residual_diagnostics(model_arima)
#' }
#' @export
residual_diagnostics <- function(model, lag = 20L) {
  res <- as.numeric(stats::residuals(model))
  res <- stats::na.omit(res)
  list(
    ljung_box = ljung_box(model, lag = lag),
    shapiro = shapiro_test(res),
    mean = mean(res),
    sd = stats::sd(res),
    n = length(res)
  )
}

#' Ljung-Box test on model residuals
#'
#' @param model A fitted model with a `residuals` method.
#' @param lag Integer lag at which to compute the statistic.
#' @return An object of class `htest`.
#' @export
ljung_box <- function(model, lag = 20L) {
  res <- as.numeric(stats::residuals(model))
  stats::Box.test(stats::na.omit(res), lag = lag, type = "Ljung-Box")
}

#' Shapiro-Wilk normality test on residuals
#'
#' Down-samples to 5000 observations when needed (Shapiro-Wilk requires
#' between 3 and 5000 observations).
#'
#' @param x Numeric vector of residuals (or any numeric sample).
#' @return An object of class `htest`.
#' @export
shapiro_test <- function(x) {
  x <- stats::na.omit(as.numeric(x))
  if (length(x) > 5000L) {
    x <- sample(x, 5000L)
  }
  stats::shapiro.test(x)
}
