test_that("rmse, mae, mape compute correct values on a small example", {
  actual <- c(10, 20, 30, 40)
  pred <- c(11, 19, 32, 38)
  expect_equal(rmse(actual, pred), sqrt(mean(c(1, 1, 4, 4))))
  expect_equal(mae(actual, pred), mean(c(1, 1, 2, 2)))
  expect_equal(mape(actual, pred),
               mean(c(1 / 10, 1 / 20, 2 / 30, 2 / 40)) * 100)
})

test_that("error metrics validate inputs", {
  expect_error(rmse(1:3, 1:4), "equal length")
  expect_error(mae("a", "b"), "must be numeric")
})

test_that("mape returns NA when actual contains zero", {
  expect_true(is.na(mape(c(1, 0, 3), c(1, 1, 3))))
})

test_that("forecast_accuracy returns the expected schema", {
  skip_if_not_installed("forecast")
  set.seed(6)
  train <- stats::ts(stats::rnorm(80), frequency = 4)
  fit <- fit_arima(train)
  test_vals <- stats::rnorm(10)
  out <- forecast_accuracy(fit, test_vals)
  expect_named(out, c("rmse", "mae", "mape"))
  expect_equal(nrow(out), 1L)
})
