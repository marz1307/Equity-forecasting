library(testthat)

for (f in list.files(file.path("..", "..", "R"), pattern = "\\.R$", full.names = TRUE)) {
  source(f)
}

test_check("stocksTimeSeries")
