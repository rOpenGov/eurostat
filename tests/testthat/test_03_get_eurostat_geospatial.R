test_that("get_eurostat_geospatial wrong input arguments for output_format = \"sf\"", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "sp")
  library(sf)
  skip_on_cran()
  skip_if_offline()
  # Testing argument 'output_class'
  expect_error(get_eurostat_geospatial(output_class = 0))
  expect_error(get_eurostat_geospatial(output_class = "foo"))
  expect_error(get_eurostat_geospatial(output_class = "sf", "df"))

  # Testing argument 'resolution'
  expect_error(get_eurostat_geospatial(resolution = 12345))
  expect_error(get_eurostat_geospatial(resolution = 1:2))

  # Testing argument nuts_level
  expect_error(get_eurostat_geospatial(nuts_level = 12345))
  expect_error(get_eurostat_geospatial(nuts_level = 1:2))

  # Testing argument year
  expect_error(get_eurostat_geospatial(year = 1900))
  expect_error(get_eurostat_geospatial(year = c(2003, 2006)))

  # Testing argment cache
  expect_error(get_eurostat_geospatial(cache = as.logical(NA)))
  expect_error(get_eurostat_geospatial(cache = "TRUE"))
  expect_error(get_eurostat_geospatial(cache = c(TRUE, FALSE)))

  # Testing argment update_cache
  expect_error(get_eurostat_geospatial(update_cache = as.logical(NA)))
  expect_error(get_eurostat_geospatial(update_cache = "TRUE"))
  expect_error(get_eurostat_geospatial(update_cache = c(TRUE, FALSE)))

  # Testing argment cache_dir
  expect_error(get_eurostat_geospatial(cache_dir = 1234))
  expect_error(get_eurostat_geospatial(cache_dir = c("here", "and/there")))

  # Testing argument CRS
  expect_error(get_eurostat_geospatial(crs = "north polar stereographic"))
  expect_error(get_eurostat_geospatial(crs = c(4326, 3035)))

  # Testing argument make_valid
  expect_error(get_eurostat_geospatial(make_valid = as.logical(NA)))
  expect_error(get_eurostat_geospatial(make_valid = "TRUE"))
  expect_error(get_eurostat_geospatial(make_valid = c(TRUE, FALSE)))

  # Invalid combinations
  expect_error(get_eurostat_geospatial(resolution = 60, year = 2003))
})


# Tests explicitly for output_class = "sf"; first unnamed argument
test_that("get_eurostat_geospatial warnings for output_format = \"sf\"", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "sp")
  skip_on_cran()
  skip_if_offline()
  # skip_on_ci()

  # Custom function expecting that:
  # we have a warning, then a message, and the final object is of class "sf"
  expect_ismw <- function(x, cls = "sf") {
    expect_message(expect_warning(x))

    x2 <- suppressMessages(
      suppressWarnings(x)
    )

    expect_s3_class(
      x,
      cls
    )
  }

  # Testing nuts_level first, such that we can stick to one nuts_level later on ...
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 0.0))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 0L))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = "0.0"))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = "1"))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = "2"))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = "3"))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = "all"))

  # Testing year second, same reason, stick with one year for later tests
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, year = 2013.0))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, year = 2013L))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, year = "2013"))

  # Testing resolution
  expect_ismw(get_eurostat_geospatial("sf", resolution = 1, nuts_level = 3, year = 2013))
  expect_ismw(get_eurostat_geospatial("sf", resolution = "01", nuts_level = 3, year = 2013))
  expect_ismw(get_eurostat_geospatial("sf", resolution = "1", nuts_level = 3, year = 2013))

  # Testing cache
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, cache = TRUE))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, cache = FALSE))

  # Testing update_cache
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, cache = TRUE, update_cache = TRUE))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, cache = TRUE, update_cache = FALSE))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, cache = FALSE, update_cache = TRUE))
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, cache = FALSE, update_cache = FALSE))

  # Testing crs
  require("sf")
  expect_ismw(x <- get_eurostat_geospatial("sf", nuts_level = 1, crs = 4326))
  expect_identical(format(st_crs(x)), format(st_crs(4326)))
  expect_ismw(x <- get_eurostat_geospatial("sf", nuts_level = 1, crs = 3035))
  expect_identical(format(st_crs(x)), format(st_crs(3035)))
  expect_ismw(x <- get_eurostat_geospatial("sf", nuts_level = 1, crs = 3857))
  expect_identical(format(st_crs(x)), format(st_crs(3857)))

  # Testing make_valid which should be depricated somewhen sooner or later
  # Unfortunately testthat does not get rid of 'hidden' warning messages when
  # options(warn) is set to < 0.
  expect_ismw(get_eurostat_geospatial("sf", nuts_level = 1, make_valid = FALSE))
  expect_s3_class(get_eurostat_geospatial("sf", nuts_level = 1, make_valid = TRUE), "sf")
})

# Tests explicitly for output_class = "sf"; first unnamed argument
test_that("get_eurostat_geospatial tests to cover internals", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "sp")
  skip_on_cran()
  skip_if_offline()

  # Custom function expecting that:
  # we have a warning, then a message, and the final object is of class "sf"
  expect_ismw <- function(x, cls = "sf") {
    expect_message(expect_warning(x))

    x1 <- suppressMessages(
      suppressWarnings(x)
    )
    if (typeof(x1) == "S3") expect_s3_class(x1, cls)
    if (typeof(x1) == "S4") expect_s4_class(x1, cls)
  }
  # Special case where resolution == 60 && year == 2016 && crs == 4326.
  # Testing for correct return object class.
  expect_s3_class(get_eurostat_geospatial("sf", resolution = 60, year = 2016, crs = 4326, make_valid = TRUE), "sf")
  expect_ismw(get_eurostat_geospatial("df", resolution = 60, year = 2016, crs = 4326, make_valid = TRUE), cls = "data.frame")
  expect_ismw(get_eurostat_geospatial("spdf", resolution = 60, year = 2016, crs = 4326, make_valid = TRUE), cls = "SpatialPolygonsDataFrame")

  # General case (not resolution == 60 && year == 2016 && crs == 4326.
  # Testing for correct return object class.
  expect_s3_class(get_eurostat_geospatial("sf", resolution = 20, year = 2013, make_valid = TRUE), "sf")
  expect_ismw(get_eurostat_geospatial("df", resolution = 20, year = 2013, make_valid = TRUE), cls = "data.frame")
  expect_ismw(get_eurostat_geospatial("spdf", resolution = 20, year = 2013, make_valid = TRUE), cls = "SpatialPolygonsDataFrame")

  # Setting cache to false; everything else default
  expect_ismw(get_eurostat_geospatial("sf", cache = FALSE))
  expect_s3_class(get_eurostat_geospatial("sf", resolution = 20, year = 2013, make_valid = TRUE, update_cache = TRUE), "sf")
  expect_ismw(get_eurostat_geospatial("df", resolution = 20, year = 2013, make_valid = TRUE, update_cache = TRUE), cls = "data.frame")
  expect_ismw(get_eurostat_geospatial("spdf", resolution = 20, year = 2013, make_valid = TRUE, update_cache = TRUE), cls = "SpatialPolygonsDataFrame")
})
