#' Fit an ARIMA model
#'
#' Wraps `forecast::auto.arima` with sensible defaults. Set `seasonal = TRUE`
#' to allow seasonal terms.
#'
#' @param x A numeric vector or `ts`.
#' @param seasonal Logical: include seasonal components (default FALSE).
#' @param stepwise Logical: use the stepwise search heuristic (default TRUE).
#' @param approximation Logical: enable model approximation (default TRUE).
#' @param ... Additional arguments passed to `forecast::auto.arima`.
#' @return A fitted model of class `forecast::Arima`.
#' @examples
#' \dontrun{
#'   fit_arima(train_ts)
#' }
#' @export
fit_arima <- function(x, seasonal = FALSE, stepwise = TRUE, approximation = TRUE, ...) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  forecast::auto.arima(
    x,
    seasonal = seasonal,
    stepwise = stepwise,
    approximation = approximation,
    ...
  )
}

#' Fit an ETS exponential-smoothing model
#'
#' @param x A numeric vector or `ts`.
#' @param model Character ETS specification (default "ZZZ" for automatic).
#' @param ... Additional arguments passed to `forecast::ets`.
#' @return A fitted model of class `ets`.
#' @examples
#' \dontrun{
#'   fit_ets(train_ts)
#' }
#' @export
fit_ets <- function(x, model = "ZZZ", ...) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  forecast::ets(x, model = model, ...)
}

#' Fit a naive (random-walk) baseline
#'
#' @param x A numeric vector or `ts`.
#' @param h Integer forecast horizon used to construct the baseline forecast.
#' @return A `forecast` object from `forecast::naive`.
#' @examples
#' \dontrun{
#'   fit_naive(train_ts, h = 30)
#' }
#' @export
fit_naive <- function(x, h = 1L) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.")
  }
  forecast::naive(x, h = as.integer(h))
}

#' Registry of available model factories
#'
#' Named list keyed by model identifier, each entry a factory function with
#' signature `function(x, ...)` returning a model object compatible with
#' `forecast::forecast`.
#'
#' @export
MODEL_REGISTRY <- list(
  arima = function(x, ...) fit_arima(x, seasonal = FALSE, ...),
  sarima = function(x, ...) fit_arima(x, seasonal = TRUE, ...),
  ets = function(x, ...) fit_ets(x, ...),
  naive = function(x, ...) fit_naive(x, ...)
)
