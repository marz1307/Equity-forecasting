## 01_eda.R
## Driver script: load data, summarise, save EDA artifacts.

set.seed(42)

source_all <- function(dir) {
  for (f in list.files(dir, pattern = "\\.R$", full.names = TRUE)) {
    source(f, local = FALSE)
  }
}
source_all("R")

ensure_dir("output")
ensure_dir("output/figures")

df <- load_share_prices("data-raw/A.csv")
message(sprintf("Loaded %d rows from data-raw/A.csv", nrow(df)))

summary_tbl <- summarize_prices(df)
utils::write.csv(summary_tbl, "output/eda_summary.csv", row.names = FALSE)
message("Wrote output/eda_summary.csv")

quantiles <- price_distribution(df)
utils::write.csv(
  data.frame(quantile = names(quantiles), value = as.numeric(quantiles)),
  "output/eda_quantiles.csv",
  row.names = FALSE
)
message("Wrote output/eda_quantiles.csv")

p <- plot_series(df, title = "Daily closing price (full sample)")
ggplot2::ggsave("output/figures/series.png", p, width = 10, height = 5, dpi = 150)
message("Wrote output/figures/series.png")
