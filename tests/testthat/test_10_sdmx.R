test_that("get_eurostat_sdmx works", {
  skip_on_cran()
  skip_if_offline()

  # Dimension order for DS-059328:
  # Reporter.partner.product.flow.period.indicators
  # although it seems that omitting period is no problem?

  prodcom <- get_eurostat_sdmx(id = "DS-059328", agency = "eurostat_comext",
                               filters =
                                 list(
                                   FREQ = c("A"), # Annual
                                   REPORTER = "FR", # France
                                   PARTNER = "US", # United States
                                   PRODUCT = c("122"), # 122-Food and beverages / Processed / Mainly for household consumption
                                   FLOW = "2", # 1-IMPORT, 2-EXPORT
                                   INDICATORS = "VALUE_EUR"), verbose = FALSE)

  expect_equal(unique(prodcom$freq), "A")

  prodcom2 <- get_eurostat_sdmx(id = "ds-059328", agency = "eurostat_comext",
                             filters =
                               list(
                                 FREQ = c("M"),
                                 REPORTER = "FR",
                                 PARTNER = "US",
                                 PRODUCT = c("310"), # 310-Fuels and lubricants / Primary
                                 FLOW = "1",
                                 INDICATORS = "VALUE_EUR"), verbose = FALSE, use.data.table = TRUE)

  expect_equal(unique(prodcom2$freq), "M")
})
