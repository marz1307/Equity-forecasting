<div align="center">

# stocksTimeSeries

### Time series forecasting for daily equity closing prices

![R](https://img.shields.io/badge/R-%3E=4.3-276DC3?logo=r&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)

</div>

## Overview

This project is an end-to-end R analysis package for univariate time series forecasting of daily equity closing prices. The committed working example uses 5,124 daily observations of Agilent Technologies (NYSE ticker `A`) from December 1999 to May 2023, with closing prices ranging from $7.76 to $113.70.

The pipeline tackles a familiar problem: build a defensible short-horizon point forecast from a noisy, non-stationary financial series, while keeping the modelling, diagnostics, and evaluation steps reproducible and testable.

Approach:

* Data load with schema validation
* EDA: distributional summary, quantiles, full-sample series plot
* Transformations: optional log, integer-order differencing
* Stationarity: ADF and KPSS, combined into a single decision rule
* Model candidates: ARIMA, seasonal ARIMA, ETS, naive baseline (drop-in via a `MODEL_REGISTRY`)
* Residual diagnostics: Ljung-Box, Shapiro-Wilk, summary moments
* Evaluation: RMSE, MAE, MAPE on a chronological 80/20 holdout
* Forecast: horizon-N projection with 80% and 95% prediction intervals

## What the pipeline produces

Running the full pipeline writes the following artifacts to `output/` and `models/`:

* `output/eda_summary.csv`, `output/eda_quantiles.csv`
* `output/figures/series.png`
* `output/model_comparison.csv` (RMSE, MAE, MAPE per candidate)
* `models/{arima,sarima,ets,naive}.rds` (serialised fitted models)
* `output/forecast_<model>.csv` and `output/figures/forecast_<model>.png` per candidate

To reproduce locally:

```bash
make install
make analyze
make forecast
```

## Architecture

```
data-raw/A.csv
      |
      v
load_share_prices -> validate_share_prices
      |
      v
to_ts (freq = 252) -> [optional] log_transform -> differences
      |
      v
adf_test + kpss_test -> is_stationary
      |
      v
MODEL_REGISTRY: { arima, sarima, ets, naive }
      |
      v
forecast_accuracy (RMSE, MAE, MAPE)
      |
      v
residual_diagnostics (Ljung-Box, Shapiro-Wilk)
      |
      v
horizon-N forecast + plot_forecast
```

## Project structure

```
stocks/
  DESCRIPTION, NAMESPACE, LICENSE, LICENSE.md
  Makefile, .lintr, .Rbuildignore, .gitignore
  .github/workflows/R-CMD-check.yml
  data-raw/
    A.csv
    companies.csv
  R/
    config.R, utils.R
    data.R, eda.R, transform.R, stationarity.R
    models.R, diagnostics.R, evaluate.R, plots.R
    pipeline.R
  analysis/
    01_eda.R, 02_modeling.R, 03_forecast.R
  tests/
    testthat.R
    testthat/
      test_data.R, test_transform.R, test_stationarity.R,
      test_models.R, test_evaluate.R, test_diagnostics.R
  man/
```

## Methodology

* **Target.** The closing price is the canonical end-of-session consensus value and is treated as the response.
* **Frequency.** A trading-year frequency of 252 is used in `ts()`, which aligns the seasonal index with calendar years.
* **Stationarity.** ADF and KPSS are applied jointly. A series is reported stationary only when ADF rejects the unit root at `alpha` and KPSS fails to reject stationarity at `alpha`. For the committed example, both tests indicate non-stationarity at level, motivating first-order differencing.
* **Candidates.** Auto-ARIMA (non-seasonal and seasonal), ETS with automatic component selection, and a naive (random-walk) baseline are fit on the same training window. Adding a candidate is one entry in `MODEL_REGISTRY`.
* **Evaluation.** Chronological 80/20 split, point forecasts evaluated by RMSE, MAE, and MAPE on the holdout.
* **Diagnostics.** Ljung-Box on residuals (lag 20) and Shapiro-Wilk for normality, with auto down-sampling for the latter.

## Reproducibility

* R version 4.3 or later
* Random seed pinned via `set.seed(42)` at the top of every driver script and inside `run_full_analysis()`
* Deterministic split (chronological 80/20) and deterministic forecast horizon (60 trading days)
* Model artifacts serialised via `saveRDS` for re-use without refitting

```bash
make install   # install package + dev dependencies
make lint      # lintr over R/, analysis/, tests/
make test      # testthat suite
make analyze   # 01_eda + 02_modeling
make forecast  # 03_forecast
```

## Limitations

The candidate models are linear and univariate. They tend to underperform when the underlying process is non-linear, regime-switching, or driven by exogenous shocks (earnings, macro releases, sector rotation). Residuals on long financial series typically retain measurable autocorrelation and exhibit fat tails, which means prediction intervals from these models should be treated as indicative rather than calibrated.

For production use, this pipeline is best framed as a baseline. Natural extensions include exogenous regressors (`xreg`), multivariate state-space or VAR specifications, gradient-boosted residual models, and rolling-origin re-estimation to track parameter drift.

## License

MIT. See [LICENSE.md](LICENSE.md).

## Author

Marvis Osazuwa, Analytics Engineer / Data Scientist with seven years across banking, healthcare, and marketing analytics.

* Portfolio: https://marz1307.github.io
* LinkedIn: https://www.linkedin.com/in/marvisosazuwa
