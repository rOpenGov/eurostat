
context("Get")

test_that("get_eurostat includes time and value",{
  skip_on_cran()
  expect_true(all(c("time", "values") %in% 
                    names(get_eurostat("namq_aux_lp", cache = FALSE))))
})

test_that("get_eurostat works with multi-frequency",{
  skip_on_cran()
  expect_error(get_eurostat("avia_gonc", cache = FALSE))
  matches("-01-01", unique(get_eurostat("avia_gonc", select_time = "Y" , cache = FALSE)$time))
})

context("Search")

test_that("search_eurostat finds",{
  skip_on_cran()
  expect_equal(search_eurostat(
    "Dwellings by type of housing, building and NUTS 3", type = "dataset")$code[1],
    "cens_01rdhh"
  )
})


context("Label")

test_that("Variable names are labeled",{
  skip_on_cran()
  expect_equal(label_eurostat_vars("geo"), "Geopolitical entity (reporting)")
})

