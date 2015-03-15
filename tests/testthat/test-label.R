context("label")

test_that("Variable names are labeled",{
  expect_equal(label_eurostat_vars("geo"), "Geopolitical entity (reporting)")
})
