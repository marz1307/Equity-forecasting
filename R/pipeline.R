#' Run the full forecasting pipeline end to end
#'
#' Loads the share-price CSV, performs an 80/20 chronological split, fits the
#' candidates registered in [MODEL_REGISTRY], evaluates them on the holdout,
#' and writes a model-comparison table plus per-model forecast CSVs to
#' `output_dir`.
#'
#' @param input_path Path to the OHLCV CSV.
#' @param output_dir Output directory (created if it does not exist).
#' @param freq Seasonal frequency for the `ts` (default 252).
#' @param train_ratio Training fraction (default 0.8).
#' @param horizon Forecast horizon for the production projection (default 60).
#' @param seed Random seed (default 42).
#' @return Invisibly, a list with the model-comparison data frame and the
#'   fitted model objects.
#' @examples
#' \dontrun{
#'   run_full_analysis("data-raw/A.csv", "output")
#' }
#' @export
run_full_analysis <- function(input_path,
                              output_dir = "output",
                              freq = 252L,
                              train_ratio = 0.8,
                              horizon = 60L,
                              seed = 42L) {
  set.seed(seed)
  ensure_dir(output_dir)

  df <- load_share_prices(input_path)
  series <- to_ts(df, freq = freq)
  n <- length(series)
  cut_idx <- floor(train_ratio * n)
  train <- series[seq_len(cut_idx)]
  test <- series[(cut_idx + 1L):n]
  train_ts <- stats::ts(train, frequency = freq)

  message(sprintf("Loaded %d observations; training on %d, holding out %d.",
                  n, length(train), length(test)))

  fits <- list()
  comparison <- data.frame(
    model = character(0),
    rmse = numeric(0),
    mae = numeric(0),
    mape = numeric(0),
    stringsAsFactors = FALSE
  )

  for (name in names(MODEL_REGISTRY)) {
    message(sprintf("Fitting model: %s", name))
    fit <- tryCatch(MODEL_REGISTRY[[name]](train_ts), error = function(e) e)
    if (inherits(fit, "error")) {
      warning(sprintf("Model %s failed: %s", name, conditionMessage(fit)))
      next
    }
    fits[[name]] <- fit
    metrics <- forecast_accuracy(fit, test)
    comparison <- rbind(comparison, cbind(model = name, metrics, stringsAsFactors = FALSE))
  }

  utils::write.csv(comparison,
                   file.path(output_dir, "model_comparison.csv"),
                   row.names = FALSE)

  for (name in names(fits)) {
    fc <- forecast::forecast(fits[[name]], h = horizon)
    out <- data.frame(
      step = seq_along(fc$mean),
      point = as.numeric(fc$mean)
    )
    utils::write.csv(out,
                     file.path(output_dir, sprintf("forecast_%s.csv", name)),
                     row.names = FALSE)
  }

  invisible(list(comparison = comparison, fits = fits))
}
