context("json")

test_that("Get json data",{
  skip_on_cran()
  skip_on_travis()    
  expect_named(get_eurostat_json("nama_10_gdp", filters = list(geo = "FI",
                                                               na_item = "B1GQ",
                                                               unit = "CLV_I10")),
               c("geo", "unit", "na_item", "time", "values"), 
               ignore.order = TRUE)
})

test_that("Handle numbers in filter name",{
  skip_on_cran()
  skip_on_travis()  
  expect_named(get_eurostat(id = "sts_inpr_a", filters = list(geo = "AT",
                                                              nace_r2 = "B",
                                                              s_adj = "CA",
                                                              indic_bt = "PROD",
                                                              unit = "I10")),
               c("geo", "nace_r2", "s_adj", "indic_bt", "unit", "time", "values"), 
               ignore.order = TRUE)
})
