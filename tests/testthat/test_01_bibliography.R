test_that("Bibentry gives correct results", {
  skip_on_cran()
  skip_if_offline()
  expect_equal(
    class(get_bibentry(
      code = c("sts_inpr_a", "nama_10_gdp"),
      keywords = list(
        c("production", "industry"),
        c("GDP")
      ),
      format = "Biblatex"
    )),
    "Bibtex"
  )
  
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
  
  # None of the codes not found
  expect_warning(
    get_bibentry(
      code = "sts_inpr_b"
    )
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
