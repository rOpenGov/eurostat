test_that("get_eurostat_geospatial errors", {
  skip_if_not_installed(pkg = "giscoR")
  skip_if_not_installed(pkg = "sf")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")

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
  expect_error(get_eurostat_geospatial(cache = as.logical(NA), year = 2021))
  expect_error(get_eurostat_geospatial(cache = c(TRUE, FALSE), year = 2021))

  # Testing argument CRS
  expect_error(get_eurostat_geospatial(crs = "north polar stereographic"))
  expect_error(get_eurostat_geospatial(crs = c(4326, 3035)))

  # Invalid combinations
  expect_error(get_eurostat_geospatial(resolution = 60, year = 2003))
})

test_that("get_eurostat_geospatial messages", {
  skip_if_not_installed(pkg = "giscoR")
  skip_if_not_installed(pkg = "sf")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")


  # Deprecations
  expect_message(
    get_eurostat_geospatial(make_valid = TRUE),
    "'make_valid' argument has been deprecated"
  )

  expect_message(
    spdf <- get_eurostat_geospatial(output_class = "spdf"),
    "'spdf' output deprecated. Switching to sf output"
  )
  expect_s3_class(spdf, "sf")

  # Info about source of data
  expect_message(get_eurostat_geospatial(), "from eurostat")
  expect_message(get_eurostat_geospatial(nuts_id = "BE"), "giscoR package")
})


test_that("get_eurostat_geospatial nuts levels", {
  skip_if_not_installed(pkg = "sf")
  # From internal data with default args
  expect_message(all <- get_eurostat_geospatial(nuts_level = "all"), "eurostat")
  expect_message(n0 <- get_eurostat_geospatial(nuts_level = "0"), "eurostat")
  expect_message(n1 <- get_eurostat_geospatial(nuts_level = "1"), "eurostat")
  expect_message(n2 <- get_eurostat_geospatial(nuts_level = "2"), "eurostat")
  expect_message(n3 <- get_eurostat_geospatial(nuts_level = "3"), "eurostat")

  expect_gt(nrow(all), nrow(n3))
  expect_gt(nrow(n3), nrow(n2))
  expect_gt(nrow(n2), nrow(n1))
  expect_gt(nrow(n1), nrow(n0))

  expect_s3_class(all, "sf")
  expect_s3_class(n3, "sf")
  expect_s3_class(n2, "sf")
  expect_s3_class(n1, "sf")

  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")


  # From internal data with default args
  expect_message(gall <- get_eurostat_geospatial(
    nuts_level = "all",
    crs = 3035
  ), "giscoR")
  expect_message(gn0 <- get_eurostat_geospatial(
    nuts_level = "0",
    crs = 3035
  ), "giscoR")
  expect_message(gn1 <- get_eurostat_geospatial(
    nuts_level = "1",
    crs = 3035
  ), "giscoR")
  expect_message(gn2 <- get_eurostat_geospatial(
    nuts_level = "2",
    crs = 3035
  ), "giscoR")
  expect_message(gn3 <- get_eurostat_geospatial(
    nuts_level = "3",
    crs = 3035
  ), "giscoR")

  expect_gt(nrow(gall), nrow(gn3))
  expect_gt(nrow(gn3), nrow(gn2))
  expect_gt(nrow(gn2), nrow(gn1))
  expect_gt(nrow(gn1), nrow(gn0))
  expect_true("geo" %in% names(gall))

  expect_s3_class(gall, "sf")
  expect_s3_class(gn3, "sf")
  expect_s3_class(gn2, "sf")
  expect_s3_class(gn1, "sf")
})

test_that("get_eurostat_geospatial df", {
  skip_if_not_installed(pkg = "sf")
  # From internal data with default args
  expect_message(
    all <- get_eurostat_geospatial(
      nuts_level = "all",
      output_class = "df"
    ),
    "eurostat"
  )
  expect_message(n0 <- get_eurostat_geospatial(
    nuts_level = "0",
    output_class = "df"
  ), "eurostat")
  expect_message(n1 <- get_eurostat_geospatial(
    nuts_level = "1",
    output_class = "df"
  ), "eurostat")
  expect_message(n2 <- get_eurostat_geospatial(
    nuts_level = "2",
    output_class = "df"
  ), "eurostat")
  expect_message(n3 <- get_eurostat_geospatial(
    nuts_level = "3",
    output_class = "df"
  ), "eurostat")

  expect_gt(nrow(all), nrow(n3))
  expect_gt(nrow(n3), nrow(n2))
  expect_gt(nrow(n2), nrow(n1))
  expect_gt(nrow(n1), nrow(n0))

  expect_s3_class(all, "data.frame")
  expect_s3_class(n3, "data.frame")
  expect_s3_class(n2, "data.frame")
  expect_s3_class(n1, "data.frame")

  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")


  # From giscoR data
  expect_message(gall <- get_eurostat_geospatial(
    nuts_level = "all",
    output_class = "df",
    verbose = TRUE
  ), "giscoR")
  expect_message(gn0 <- get_eurostat_geospatial(
    nuts_level = "0",
    crs = 3035,
    verbose = TRUE
  ), "giscoR")
  expect_message(gn1 <- get_eurostat_geospatial(
    nuts_level = "1",
    crs = 3035,
    verbose = TRUE
  ), "giscoR")
  expect_message(gn2 <- get_eurostat_geospatial(
    nuts_level = "2",
    crs = 3035,
    verbose = TRUE
  ), "giscoR")
  expect_message(gn3 <- get_eurostat_geospatial(
    nuts_level = "3",
    crs = 3035,
    verbose = TRUE
  ), "giscoR")

  expect_gt(nrow(gall), nrow(gn3))
  expect_gt(nrow(gn3), nrow(gn2))
  expect_gt(nrow(gn2), nrow(gn1))
  expect_gt(nrow(gn1), nrow(gn0))
  expect_true("geo" %in% names(gall))

  expect_s3_class(gall, "data.frame")
  expect_s3_class(gn3, "data.frame")
  expect_s3_class(gn2, "data.frame")
  expect_s3_class(gn1, "data.frame")
})


test_that("get_eurostat_geospatial cache_dir", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")

  # Get initial cache dir
  init_cache <- eur_helper_detect_cache_dir()

  # Now mocking as if the user set a specific cache dir
  test_cache_dir <- file.path(tempdir(), "eurostat_set_by_user")
  suppressMessages(set_eurostat_cache_dir(test_cache_dir))

  # Check change
  new_cache <- eur_helper_detect_cache_dir()
  expect_false(identical(init_cache, new_cache))

  # Check now the messages with snapshot testing
  # This would show nothing regarding cache
  expect_snapshot(a <- get_eurostat_geospatial(
    nuts_id = "LU",
    nuts_level = 0
  ))

  # If set by the user no messages on caching
  another_temp <- tempdir()
  expect_snapshot(a <- get_eurostat_geospatial(
    nuts_id = "LU",
    nuts_level = 0,
    cache_dir = another_temp
  ))

  # But if using the default unset cache dir from eurostat, expect a message
  # stating that giscoR is managing it

  # Now mocking as if the user set a specific cache dir
  default_temp <- file.path(tempdir(), "eurostat")
  suppressMessages(set_eurostat_cache_dir(default_temp))

  # Check change
  new_cache <- eur_helper_detect_cache_dir()
  expect_false(identical(init_cache, new_cache))
  expect_true(identical(default_temp, new_cache))

  expect_snapshot(a <- get_eurostat_geospatial(
    nuts_id = "LU",
    nuts_level = 0
  ))


  # Finally, restore cache dir set by the user (if any)
  suppressMessages(set_eurostat_cache_dir(init_cache))
  expect_identical(init_cache, eur_helper_detect_cache_dir())
})


test_that("giscoR returns NULL", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")
  skip_if(packageVersion("giscoR") < "0.3.5", "Use latest giscoR release")

  options(giscoR_test_offline = TRUE)
  expect_message(
    n <- get_eurostat_geospatial(
      country = "AT", nuts_level = "0",
      update_cache = TRUE
    ),
    "not reachable"
  )
  expect_null(n)
  options(giscoR_test_offline = FALSE)
})


test_that("Check column names", {
  skip_if_not_installed(pkg = "sf")

  # See https://github.com/rOpenGov/eurostat/issues/240
  col_order <- c(
    "id", "LEVL_CODE", "NUTS_ID", "CNTR_CODE", "NAME_LATN",
    "NUTS_NAME", "MOUNT_TYPE", "URBN_TYPE", "COAST_TYPE",
    "FID", "geo", "geometry"
  )


  cached <- get_eurostat_geospatial()
  expect_s3_class(cached, "sf")
  expect_identical(names(cached), col_order)

  # df
  cached_df <- get_eurostat_geospatial(output_class = "df")
  expect_s3_class(cached_df, "data.frame")
  expect_identical(names(cached_df), col_order[-length(col_order)])
})


test_that("Check column names POLYGONS from GISCO", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")
  skip_if(packageVersion("giscoR") < "0.3.5", "Use latest giscoR release")

  col_order <- c(
    "id", "LEVL_CODE", "NUTS_ID", "CNTR_CODE", "NAME_LATN",
    "NUTS_NAME", "MOUNT_TYPE", "URBN_TYPE", "COAST_TYPE",
    "FID", "geo", "geometry"
  )

  # Polygons 2003
  poly <- get_eurostat_geospatial(nuts_level = 0, resolution = 20, year = 2003)
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 20, year = 2003
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Polygons 2006
  poly <- get_eurostat_geospatial(nuts_level = 0, resolution = 60, year = 2006)
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2006
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])


  # Polygons 2010
  poly <- get_eurostat_geospatial(nuts_level = 0, resolution = 60, year = 2010)
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2010
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Polygons 2013
  poly <- get_eurostat_geospatial(nuts_level = 0, resolution = 60, year = 2013)
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2013
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Polygons 2016
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2016,
    update_cache = TRUE
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2016,
    update_cache = TRUE
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Polygons 2021
  poly <- get_eurostat_geospatial(nuts_level = 0, resolution = 60, year = 2021)
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2021
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])
})

test_that("Check column names LABELS from GISCO", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")
  skip_if(packageVersion("giscoR") < "0.3.5", "Use latest giscoR release")

  col_order <- c(
    "id", "LEVL_CODE", "NUTS_ID", "CNTR_CODE", "NAME_LATN",
    "NUTS_NAME", "MOUNT_TYPE", "URBN_TYPE", "COAST_TYPE",
    "FID", "geo", "geometry"
  )

  # Labels 2003
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 20, year = 2003,
    spatialtype = "LB"
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 20, year = 2003,
    spatialtype = "LB"
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Labels 2006
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2006,
    spatialtype = "LB"
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2006,
    spatialtype = "LB"
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])


  # Labels 2010
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2010,
    spatialtype = "LB"
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2010,
    spatialtype = "LB"
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Labels 2013
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2013,
    spatialtype = "LB"
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2013,
    spatialtype = "LB"
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Labels 2016
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2016,
    update_cache = TRUE, spatialtype = "LB"
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2016,
    update_cache = TRUE,
    spatialtype = "LB"
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])

  # Labels 2021
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2021,
    spatialtype = "LB"
  )
  expect_s3_class(poly, "sf")
  expect_identical(names(poly), col_order)

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2021,
    spatialtype = "LB"
  )

  expect_s3_class(poly_df, "data.frame")
  expect_identical(names(poly_df), col_order[-length(col_order)])
})


test_that("Check column names BORDERS from GISCO", {
  skip_if_not_installed(pkg = "sf")
  skip_if_not_installed(pkg = "giscoR")
  skip_on_cran()
  skip_if_offline()
  skip_if(!giscoR::gisco_check_access(), "No access to GISCO")
  skip_if(packageVersion("giscoR") < "0.3.5", "Use latest giscoR release")

  # BORDERS 2003
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 20, year = 2003,
    spatialtype = "BN"
  )
  expect_s3_class(poly, "sf")

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 20, year = 2003,
    spatialtype = "BN"
  )

  expect_s3_class(poly_df, "data.frame")

  # BORDERS 2006
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2006,
    spatialtype = "BN"
  )
  expect_s3_class(poly, "sf")

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2006,
    spatialtype = "BN"
  )

  expect_s3_class(poly_df, "data.frame")


  # BORDERS 2010
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2010,
    spatialtype = "BN"
  )
  expect_s3_class(poly, "sf")

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2010,
    spatialtype = "BN"
  )

  expect_s3_class(poly_df, "data.frame")

  # BORDERS 2013
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2013,
    spatialtype = "BN"
  )
  expect_s3_class(poly, "sf")

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2013,
    spatialtype = "BN"
  )

  expect_s3_class(poly_df, "data.frame")

  # BORDERS 2016
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2016,
    update_cache = TRUE, spatialtype = "BN"
  )
  expect_s3_class(poly, "sf")

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2016,
    update_cache = TRUE,
    spatialtype = "BN"
  )

  expect_s3_class(poly_df, "data.frame")

  # BORDERS 2021
  poly <- get_eurostat_geospatial(
    nuts_level = 0, resolution = 60, year = 2021,
    spatialtype = "BN"
  )
  expect_s3_class(poly, "sf")

  # df
  poly_df <- get_eurostat_geospatial(
    output_class = "df", nuts_level = 0,
    resolution = 60, year = 2021,
    spatialtype = "BN"
  )

  expect_s3_class(poly_df, "data.frame")
})
