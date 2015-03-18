
context("Get")

test_that("search_eurostat finds",{
  skip_on_cran()
  expect_true(all(c("time", "values") %in% names(get_eurostat("namq_aux_lp", cache = FALSE))))
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

