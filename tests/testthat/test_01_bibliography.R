test_that("Bibentry gives correct results", {
  skip_on_cran()
  skip_if_offline()

  expect_equal(
    class(
      suppressWarnings(
        get_bibentry(
        code = c("sts_inpr_a"),
        lang = "fr",
        format = "Bibtex"
      ))),
    "Bibtex"
  )

  expect_error(
    get_bibentry(code = 123456)
  )

  expect_error(
    get_bibentry(
      code = c("sts_inpr_a"),
      lang = "fr",
      keywords = "production"
    )
  )

  # First cache to get rid of possible vroom problem
  cache <- suppressWarnings(get_bibentry(
    code = "sts_inpr_b"
  ))

  # None of the codes not found
  expect_warning(
    get_bibentry(
      code = "sts_inpr_b"
    ), "None of the codes were found in the Eurostat table of contents"
  )

  # Some of the codes not found
  expect_warning(
    get_bibentry(
      code = c("sts_inpr_b", "sts_inpr_a")
    )
  )

  expect_warning(
    get_bibentry(
      code = c("sts_inpr_a", "nama_10_gdp"),
      keywords = list(
        c("production", "industry"),
        c("GDP")
      ),
      format = "character"
    )
  )


})
