#' Load a daily share-price CSV
#'
#' Reads a CSV containing daily OHLCV share prices, coerces the Date column
#' to `Date`, and returns rows sorted ascending by date.
#'
#' @param path File path to the CSV. Must exist and be readable.
#' @return A `tibble` with at least the columns Date, Open, High, Low, Close,
#'   Adj Close, Volume.
#' @examples
#' \dontrun{
#'   df <- load_share_prices("data-raw/A.csv")
#' }
#' @export
load_share_prices <- function(path) {
  if (!is.character(path) || length(path) != 1L) {
    stop("`path` must be a single character string.")
  }
  if (!file.exists(path)) {
    stop(sprintf("File not found: %s", path))
  }
  df <- readr::read_csv(path, show_col_types = FALSE)
  df <- validate_share_prices(df)
  df$Date <- as.Date(df$Date)
  df <- df[order(df$Date), , drop = FALSE]
  df
}

#' Validate a share-price data frame
#'
#' Confirms that the required columns are present and that the Close column
#' is numeric and non-empty. Returns the input unchanged on success; otherwise
#' raises an error.
#'
#' @param df A data frame or tibble.
#' @return The input `df` (unchanged).
#' @examples
#' \dontrun{
#'   validate_share_prices(df)
#' }
#' @export
validate_share_prices <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  required <- c("Date", "Close")
  missing_cols <- setdiff(required, colnames(df))
  if (length(missing_cols) > 0L) {
    stop(sprintf("Missing required column(s): %s", paste(missing_cols, collapse = ", ")))
  }
  if (nrow(df) == 0L) {
    stop("Input data frame has zero rows.")
  }
  if (!is.numeric(df$Close)) {
    stop("`Close` column must be numeric.")
  }
  df
}

#' Join a ticker-to-name lookup onto a price data frame
#'
#' @param df A data frame with at least one row.
#' @param lookup A data frame mapping ticker to company name. Must contain
#'   columns `Symbol` (or `Ticker`) and `Name`.
#' @param ticker Character scalar: the ticker symbol to attach.
#' @return The input `df` with an added `CompanyName` column.
#' @examples
#' \dontrun{
#'   join_company_names(df, lookup, ticker = "A")
#' }
#' @export
join_company_names <- function(df, lookup, ticker) {
  if (!is.data.frame(df) || !is.data.frame(lookup)) {
    stop("`df` and `lookup` must both be data frames.")
  }
  symbol_col <- intersect(c("Symbol", "Ticker"), colnames(lookup))
  if (length(symbol_col) == 0L || !"Name" %in% colnames(lookup)) {
    stop("`lookup` must contain a Symbol/Ticker column and a Name column.")
  }
  hit <- lookup[lookup[[symbol_col[1L]]] == ticker, "Name", drop = TRUE]
  df$CompanyName <- if (length(hit) >= 1L) hit[1L] else NA_character_
  df
}
