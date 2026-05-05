test_that("adf_test and kpss_test return htest objects", {
  skip_if_not_installed("tseries")
  set.seed(1)
  x <- stats::rnorm(200)
  expect_s3_class(suppressWarnings(adf_test(x)), "htest")
  expect_s3_class(suppressWarnings(kpss_test(x)), "htest")
})

test_that("is_stationary identifies a white-noise series as stationary", {
  skip_if_not_installed("tseries")
  set.seed(2)
  x <- stats::rnorm(500)
  expect_true(suppressWarnings(is_stationary(x)))
})

test_that("is_stationary flags a random walk as non-stationary", {
  skip_if_not_installed("tseries")
  set.seed(3)
  x <- cumsum(stats::rnorm(500))
  expect_false(suppressWarnings(is_stationary(x)))
})
