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

test_that("Get eurotime2date error message related to W99 values", {
  skip_on_cran()
  skip_if_offline()
  expect_warning(
    get_eurostat(
      "demo_r_mweek3",
      filters = list(
        sex = "F",
        age = "TOTAL",
        geo = "BG"
        )
      )
  )
})

test_that("cut_to_classes works", {
  skip_on_cran()
  skip_if_offline()
  dataset <- get_eurostat(
    "nama_10_lp_ulc", 
    filters = list(
      geo = c("AT", "DK", "BG"),
      unit = "EUR",
      na_item = "D1_SAL_HW"))
  dataset <- na.omit(dataset)
  
  expect_visible(cut_to_classes(dataset$values))
})