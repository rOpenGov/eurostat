test_that("Dic downloading works", {
  skip_on_cran()
  skip_if_offline()
  expect_warning(get_eurostat_dic("na_item"), NA)
})

test_that("Factors are retained in data.frame", {
  skip_on_cran()
  skip_if_offline()
  y <- label_eurostat(data.frame(unit = factor("EUR")))
  expect_s3_class(y$unit, "factor")
})

test_that("Duplicated gives an error", {
  skip_on_cran()
  skip_if_offline()
  expect_error(label_eurostat(x = factor(c("P5G", "P5")), dic = "na_item"))
})

test_that("Duplicated with fix_duplicated does not give an error", {
  skip_on_cran()
  skip_if_offline()
  expect_match(as.character(
    label_eurostat(
      x = factor(c("P5G", "P5")), dic = "na_item",
      fix_duplicated = TRUE
    )
  ), "P5", all = TRUE)
})
