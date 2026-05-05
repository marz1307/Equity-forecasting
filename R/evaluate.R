#' Root mean squared error
#'
#' @param actual Numeric vector of observed values.
#' @param pred Numeric vector of predicted values (same length as actual).
#' @return Numeric scalar.
#' @examples
#' rmse(c(1, 2, 3), c(1.1, 1.9, 3.2))
#' @export
rmse <- function(actual, pred) {
  check_pair(actual, pred)
  sqrt(mean((actual - pred)^2, na.rm = TRUE))
}

#' Mean absolute error
#'
#' @param actual Numeric vector of observed values.
#' @param pred Numeric vector of predicted values.
#' @return Numeric scalar.
#' @examples
#' mae(c(1, 2, 3), c(1.1, 1.9, 3.2))
#' @export
mae <- function(actual, pred) {
  check_pair(actual, pred)
  mean(abs(actual - pred), na.rm = TRUE)
}

#' Mean absolute percentage error (in percent)
#'
#' Returns NA when any actual value is zero, as MAPE is undefined.
#'
#' @param actual Numeric vector of observed values.
#' @param pred Numeric vector of predicted values.
#' @return Numeric scalar (percent).
#' @examples
#' mape(c(10, 20, 30), c(11, 19, 32))
#' @export
mape <- function(actual, pred) {
  check_pair(actual, pred)
  if (any(actual == 0, na.rm = TRUE)) {
    return(NA_real_)
  }
  mean(abs((actual - pred) / actual), na.rm = TRUE) * 100
}

#' Forecast accuracy on a holdout
#'
#' Generates an h-step forecast from `model` and reports RMSE, MAE, MAPE
#' against the supplied holdout vector.
#'
#' @param model A fitted model accepted by `forecast::forecast`.
#' @param holdout Numeric vector of holdout actuals.
#' @return A one-row data frame of metrics.
#' @examples
#' \dontrun{
#'   forecast_accuracy(model_arima, test_ts)
#' }
#' @export
forecast_accuracy <- function(model, holdout) {
  if (!is.numeric(holdout)) {
    stop("`holdout` must be numeric.")
  }
  fc <- forecast::forecast(model, h = length(holdout))
  pred <- as.numeric(fc$mean)
  data.frame(
    rmse = rmse(holdout, pred),
    mae = mae(holdout, pred),
    mape = mape(holdout, pred),
    stringsAsFactors = FALSE
  )
}

## Internal helper, not exported.
check_pair <- function(actual, pred) {
  if (!is.numeric(actual) || !is.numeric(pred)) {
    stop("`actual` and `pred` must be numeric vectors.")
  }
  if (length(actual) != length(pred)) {
    stop("`actual` and `pred` must have equal length.")
  }
  invisible(TRUE)
}
