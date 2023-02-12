test_that("Get json data", {
  skip_on_cran()
  skip_if_offline()
  expect_named(
    get_eurostat_json("nama_10_gdp", 
                      filters = list(
                        geo = "FI",
                        na_item = "B1GQ",
                        unit = "CLV_I10")),
    c("geo", "unit", "na_item", "time", "values", "freq"),
    ignore.order = TRUE
  )
  
  # sleep for a while to let the API rest
  Sys.sleep(5)
})
