# Makefile for stocksTimeSeries
# Targets: install, lint, test, analyze, forecast, clean

R ?= Rscript

.PHONY: install lint test analyze forecast clean all

install:
	$(R) -e 'pkgs <- c("dplyr","lubridate","forecast","tseries","ggplot2","gridExtra","lmtest","readr","tibble","testthat","lintr"); to_install <- setdiff(pkgs, rownames(installed.packages())); if (length(to_install)) install.packages(to_install, repos = "https://cloud.r-project.org")'

lint:
	$(R) -e 'lintr::lint_dir("R"); lintr::lint_dir("analysis"); lintr::lint_dir("tests")'

test:
	$(R) -e 'testthat::test_dir("tests/testthat", reporter = "summary")'

analyze:
	$(R) analysis/01_eda.R
	$(R) analysis/02_modeling.R

forecast:
	$(R) analysis/03_forecast.R

all: install lint test analyze forecast

clean:
	rm -rf output models figures
