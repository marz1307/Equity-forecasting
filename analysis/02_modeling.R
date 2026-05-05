## 02_modeling.R
## Driver script: chronological split, fit candidates, save fitted models.

set.seed(42)

for (f in list.files("R", pattern = "\\.R$", full.names = TRUE)) {
  source(f, local = FALSE)
}

ensure_dir("output")
ensure_dir("models")

df <- load_share_prices("data-raw/A.csv")
series <- to_ts(df, freq = 252L)

n <- length(series)
cut_idx <- floor(0.8 * n)
train <- stats::ts(series[seq_len(cut_idx)], frequency = 252L)
test <- as.numeric(series[(cut_idx + 1L):n])

message(sprintf("Train: %d, Test: %d", length(train), length(test)))

results <- list()
metrics_rows <- list()
for (name in names(MODEL_REGISTRY)) {
  message(sprintf("Fitting: %s", name))
  fit <- MODEL_REGISTRY[[name]](train)
  results[[name]] <- fit
  saveRDS(fit, file.path("models", sprintf("%s.rds", name)))
  acc <- forecast_accuracy(fit, test)
  metrics_rows[[name]] <- cbind(model = name, acc, stringsAsFactors = FALSE)
}

comparison <- do.call(rbind, metrics_rows)
utils::write.csv(comparison, "output/model_comparison.csv", row.names = FALSE)
message("Wrote output/model_comparison.csv")
print(comparison)
