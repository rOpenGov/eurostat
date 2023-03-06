
# flag_dat <- get_eurostat("t2020_rk310", type = "label", keepFlags=T, cache = FALSE)
# flag_dat <- get_eurostat("tsdtr210", type = "label", keepFlags=T, cache = FALSE)

test_that("get_eurostat includes flags", {
  skip_on_cran()
  skip_if_offline()
  expect_true(all(c("flags") %in%
    names(get_eurostat("road_eqr_trams", keepFlags = TRUE))))
})

test_that("keepFlags + label as in #61", {
  skip_on_cran()
  skip_if_offline()
  flag_dat <- get_eurostat("road_pa_buscoa", type = "label", keepFlags = TRUE, cache = FALSE)

  expect_true(all(c("flags") %in%
    names(flag_dat)))
})

test_that("flag content", {
  skip_on_cran()
  skip_if_offline()
  flag_dat <- get_eurostat("road_pa_buscoa", type = "label", keepFlags = TRUE, cache = FALSE)

  expect_true(all(c("b", "e") %in%
    unique(flag_dat$flags)))
})

test_that("flag content2", {
  skip_on_cran()
  skip_if_offline()
  flag_dat <- get_eurostat("road_pa_buscoa", 
                           type = "label", 
                           keepFlags = TRUE, 
                           cache = FALSE,
                           legacy_bulk_download = FALSE)
  
  expect_true(all(c("b", "e") %in%
                    unique(flag_dat$flags)))
  
  # sleep for a while to let the API rest
  Sys.sleep(5)
})
