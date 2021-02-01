

devtools::load_all("../../")
test_that("get_eurostat_geospatial wrong input arguments for output_format = \"sf\"", {
  expect_error(get_eurostat_geospatial("sf", resolution = 12345))
  expect_error(get_eurostat_geospatial("sf", nuts_level = 12345))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "0"), "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = 0.0), "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level =  0L), "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "2"), "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "3"), "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "1"), "sf"))
})


test_that("get_eurostat_geospatial warnings = \"sf\"", {
  skip_on_cran()
  skip_on_ci()    
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "0"),   "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "1"),   "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "2"),   "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "3"),   "sf"))
  expect_true(inherits(get_eurostat_geospatial("sf", nuts_level = "all"), "sf"))
})

