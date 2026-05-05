## 03_forecast.R
## Driver script: load fitted models, generate horizon-N forecast, write CSV + plot.

set.seed(42)

for (f in list.files("R", pattern = "\\.R$", full.names = TRUE)) {
  source(f, local = FALSE)
}

ensure_dir("output")
ensure_dir("output/figures")

horizon <- 60L

model_files <- list.files("models", pattern = "\\.rds$", full.names = TRUE)
if (length(model_files) == 0L) {
  stop("No fitted models in models/. Run analysis/02_modeling.R first.")
}

for (f in model_files) {
  name <- tools::file_path_sans_ext(basename(f))
  fit <- readRDS(f)
  fc <- forecast::forecast(fit, h = horizon)
  out <- data.frame(
    step = seq_along(fc$mean),
    point = as.numeric(fc$mean),
    lo80 = as.numeric(fc$lower[, 1]),
    hi80 = as.numeric(fc$upper[, 1]),
    lo95 = as.numeric(fc$lower[, 2]),
    hi95 = as.numeric(fc$upper[, 2])
  )
  utils::write.csv(out,
                   file.path("output", sprintf("forecast_%s.csv", name)),
                   row.names = FALSE)

  p <- plot_forecast(fc, title = sprintf("%s: %d-day forecast", toupper(name), horizon))
  ggplot2::ggsave(file.path("output/figures", sprintf("forecast_%s.png", name)),
                  p, width = 10, height = 5, dpi = 150)
  message(sprintf("Wrote forecast artifacts for %s", name))
}
