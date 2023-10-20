test_that("search_eurostat finds", {
  skip_on_cran()
  skip_if_offline()
  expect_equal(
    search_eurostat(
      "Dwellings by type of housing, building and NUTS 3",
      type = "dataset"
    )$code[1],
    "cens_01rdhh"
  )
  
  expect_equal(
    suppressWarnings(
      search_eurostat(
        "Volkswirtschaftliche Gesamtrechnungen",
        type = "folder",
        lang = "de"
      ))$code[1],
    "ei_qna"
  )
  
  expect_equal(
    suppressWarnings(
      search_eurostat(
        "sts_os_t",
        type = "folder",
        column = "code",
        lang = "fr"
      ))$title[1],
    "Chiffre d'affaires"
  )
})
