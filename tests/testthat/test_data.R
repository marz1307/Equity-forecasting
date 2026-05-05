test_that("validate_share_prices accepts a well-formed frame", {
  df <- data.frame(Date = as.Date("2020-01-01") + 0:4, Close = c(1, 2, 3, 4, 5))
  expect_identical(validate_share_prices(df), df)
})

test_that("validate_share_prices rejects missing columns", {
  df <- data.frame(Date = Sys.Date(), Open = 1)
  expect_error(validate_share_prices(df), "Missing required column")
})

test_that("validate_share_prices rejects empty frames", {
  df <- data.frame(Date = as.Date(character(0)), Close = numeric(0))
  expect_error(validate_share_prices(df), "zero rows")
})

test_that("validate_share_prices rejects non-numeric Close", {
  df <- data.frame(Date = Sys.Date(), Close = "high")
  expect_error(validate_share_prices(df), "must be numeric")
})

test_that("load_share_prices errors on missing files", {
  expect_error(load_share_prices("nonexistent_file.csv"), "File not found")
})

test_that("load_share_prices returns sorted dates from a temp file", {
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  utils::write.csv(
    data.frame(
      Date = c("2020-01-03", "2020-01-01", "2020-01-02"),
      Open = c(2, 1, 1.5), High = c(2.1, 1.1, 1.6), Low = c(1.9, 0.9, 1.4),
      Close = c(2, 1, 1.5), `Adj Close` = c(2, 1, 1.5), Volume = c(100, 200, 150),
      check.names = FALSE
    ),
    tmp, row.names = FALSE
  )
  out <- load_share_prices(tmp)
  expect_s3_class(out$Date, "Date")
  expect_equal(out$Date, sort(out$Date))
  expect_true(all(c("Date", "Close") %in% colnames(out)))
})
