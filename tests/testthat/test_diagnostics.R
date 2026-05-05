test_that("ljung_box and shapiro_test produce htest objects", {
  skip_if_not_installed("forecast")
  set.seed(7)
  train <- stats::ts(stats::rnorm(100), frequency = 4)
  fit <- fit_arima(train)
  expect_s3_class(ljung_box(fit, lag = 5), "htest")
  expect_s3_class(shapiro_test(stats::rnorm(50)), "htest")
})

test_that("residual_diagnostics returns the expected structure", {
  skip_if_not_installed("forecast")
  set.seed(8)
  train <- stats::ts(stats::rnorm(100), frequency = 4)
  fit <- fit_arima(train)
  d <- residual_diagnostics(fit, lag = 5)
  expect_named(d, c("ljung_box", "shapiro", "mean", "sd", "n"))
})

test_that("ensure_dir creates a directory when absent", {
  tmp <- file.path(tempdir(), paste0("ensure_dir_", as.integer(Sys.time())))
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
  ensure_dir(tmp)
  expect_true(dir.exists(tmp))
})
