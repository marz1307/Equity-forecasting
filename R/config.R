## Configuration constants for stocksTimeSeries
## All defaults are exposed as function arguments; this file groups them in
## one place for easy auditing.

#' Default trading days per year (used as ts() frequency).
DEFAULT_FREQUENCY <- 252L

#' Default train/test split ratio (training fraction).
DEFAULT_TRAIN_RATIO <- 0.8

#' Default forecast horizon (in trading days) for out-of-sample projection.
DEFAULT_HORIZON <- 60L

#' Default Ljung-Box lag.
DEFAULT_LB_LAG <- 20L

#' Default significance level for hypothesis tests.
DEFAULT_ALPHA <- 0.05

#' Default random seed for reproducibility.
DEFAULT_SEED <- 42L

#' Expected columns in the share-price CSV.
EXPECTED_PRICE_COLUMNS <- c("Date", "Open", "High", "Low", "Close", "Adj Close", "Volume")
