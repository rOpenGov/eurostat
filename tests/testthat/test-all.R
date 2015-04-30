
context("Get")

test_that("get_eurostat includes time and value",{
  skip_on_cran()
  expect_true(all(c("time", "values") %in% 
                    names(get_eurostat("namq_aux_lp"))))
})

test_that("get_eurostat works with multi-frequency",{
  skip_on_cran()
  expect_error(get_eurostat("avia_gonc", cache = FALSE))
  matches("-01-01", unique(get_eurostat("avia_gonc", select_time = "Y" , cache = FALSE)$time))
})

test_that("get_eurostat return right classes",{
  skip_on_cran()
  expect_true(all(c("factor", "numeric") %in% 
                    sapply(get_eurostat("namq_aux_lp"), class)))
  expect_true(all(c("character", "numeric") %in% 
                    sapply(get_eurostat("namq_aux_lp", stringsAsFactors = FALSE), 
                           class)))
})

context("cache")

test_that("Cache give error if cache dir does not exist", {
  skip_on_cran()
  expect_error(
    get_eurostat("nama_10_lp_ulc", cache_dir = file.path(tempdir(), "r_cache")))
})

test_that("Cache works", {
  skip_on_cran()
  expect_is({
    t_dir <- file.path(tempdir(), "reurostat")
    dir.create(t_dir)
    k <- get_eurostat("nama_10_lp_ulc", cache_dir = t_dir)
    },
    "data.frame")
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
  expect_true(any(grepl("_code", 
                        names(label_eurostat(
                          get_eurostat("namq_aux_lp"), code = "geo")))))
})

