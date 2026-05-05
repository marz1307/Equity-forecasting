test_that("to_ts produces a ts of correct frequency and length", {
  df <- data.frame(Date = as.Date("2020-01-01") + 0:9, Close = seq(10, 19))
  out <- to_ts(df, freq = 5L)
  expect_s3_class(out, "ts")
  expect_equal(length(out), 10L)
  expect_equal(stats::frequency(out), 5)
})

test_that("log_transform requires positive values", {
  expect_equal(log_transform(c(1, exp(1))), c(0, 1))
  expect_error(log_transform(c(1, 0)), "strictly positive")
})

test_that("differences performs first differencing by default", {
  expect_equal(as.numeric(differences(c(1, 3, 6, 10))), c(2, 3, 4))
  expect_equal(length(differences(1:5, d = 2L)), 3L)
})
