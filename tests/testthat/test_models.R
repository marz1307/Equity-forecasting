test_that("fit_arima returns a forecast::Arima object on a small ts", {
  skip_if_not_installed("forecast")
  set.seed(4)
  x <- stats::ts(stats::rnorm(120), frequency = 12)
  fit <- fit_arima(x)
  expect_true(inherits(fit, "Arima") || inherits(fit, "forecast_ARIMA"))
})

test_that("fit_ets returns an ets object", {
  skip_if_not_installed("forecast")
  set.seed(5)
  x <- stats::ts(stats::rnorm(120), frequency = 12)
  fit <- fit_ets(x)
  expect_s3_class(fit, "ets")
})

test_that("MODEL_REGISTRY exposes the expected factories", {
  expect_setequal(names(MODEL_REGISTRY), c("arima", "sarima", "ets", "naive"))
  expect_true(all(vapply(MODEL_REGISTRY, is.function, logical(1))))
})
