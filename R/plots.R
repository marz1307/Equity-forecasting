#' Plot a daily price series
#'
#' @param df A data frame with `Date` and `Close` columns.
#' @param title Plot title.
#' @return A ggplot object.
#' @examples
#' \dontrun{
#'   plot_series(df)
#' }
#' @export
plot_series <- function(df, title = "Daily closing price") {
  validate_share_prices(df)
  ggplot2::ggplot(df, ggplot2::aes(x = .data$Date, y = .data$Close)) +
    ggplot2::geom_line(colour = "steelblue", linewidth = 0.6) +
    ggplot2::labs(title = title, x = "Date", y = "Closing price (USD)") +
    ggplot2::theme_minimal(base_size = 11)
}

#' Side-by-side ACF and PACF plots
#'
#' @param x A numeric vector or `ts`.
#' @param lag_max Maximum lag.
#' @return A list with two ggplot objects (acf, pacf). Plotted via `forecast::ggAcf`.
#' @export
plot_acf_pacf <- function(x, lag_max = 40L) {
  list(
    acf = forecast::ggAcf(x, lag.max = lag_max) +
      ggplot2::labs(title = "ACF") +
      ggplot2::theme_minimal(base_size = 11),
    pacf = forecast::ggPacf(x, lag.max = lag_max) +
      ggplot2::labs(title = "PACF") +
      ggplot2::theme_minimal(base_size = 11)
  )
}

#' Residual diagnostics plot
#'
#' @param model A fitted model with a `residuals` method.
#' @return A ggplot object showing residuals over time.
#' @export
plot_residuals <- function(model) {
  res <- as.numeric(stats::residuals(model))
  df <- data.frame(idx = seq_along(res), residual = res)
  ggplot2::ggplot(df, ggplot2::aes(x = .data$idx, y = .data$residual)) +
    ggplot2::geom_line(colour = "grey40") +
    ggplot2::geom_hline(yintercept = 0, colour = "red", linetype = "dashed") +
    ggplot2::labs(title = "Residuals over time", x = "Index", y = "Residual") +
    ggplot2::theme_minimal(base_size = 11)
}

#' Forecast plot from a forecast object
#'
#' @param fc A `forecast` object.
#' @param title Plot title.
#' @return A ggplot object.
#' @export
plot_forecast <- function(fc, title = "Forecast") {
  forecast::autoplot(fc) +
    ggplot2::labs(title = title, x = "Time", y = "Closing price (USD)") +
    ggplot2::theme_minimal(base_size = 11)
}
