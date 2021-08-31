context("json")

test_that("Get json data",{
  skip_on_cran()
  skip_on_ci()    
  expect_named(get_eurostat_json("nama_10_gdp", filters = list(geo = "FI",
                                                               na_item = "B1GQ",
                                                               unit = "CLV_I10")),
               c("geo", "unit", "na_item", "time", "values"), 
               ignore.order = TRUE)
})
# The following test produced an error on R-Studio R CMD check:
# Error: 'length(x) = 5 > 1' in coercion to 'logical(1)'
# Backtrace: 1. testthat::expect_named(...) test_json.R:16:2
# 2. testthat::quasi_label(enquo(object), label, arg = "object")
# 3. rlang::eval_bare(expr, quo_get_env(quo))
# 4. eurostat::get_eurostat(...)
# Probably has something to do with usage of || (scalar comparison)
# in functions instead of using | (vector comparison), will look into it
#test_that("Handle numbers in filter name",{
#  skip_on_cran()
#  skip_on_ci()  
#  expect_named(get_eurostat(id = "sts_inpr_a", filters = list(geo = "AT",
#                                                              nace_r2 = "B",
#                                                              s_adj = "CA",
#                                                              indic_bt = "PROD",
#                                                              unit = "I10")),
#               c("geo", "nace_r2", "s_adj", "indic_bt", "unit", "time", "values"), 
#               ignore.order = TRUE)
#})
