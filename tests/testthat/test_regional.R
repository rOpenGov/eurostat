context ("Regional code harmonization")


test_regional_codes <- data.frame (

  geo = c("FRB", "FRE", "UKN02", "IE022", "FR243", "FRB03"),
  time = c(rep(as.Date ("2014-01-01"), 5), as.Date("2015-01-01")), 
  values = c(1:6), 
  control = c("Changed from NUTS2 to NUTS1", 
              "New region NUTS2016 only", 
              "Discontinued region NUTS2013", 
              "Boundary shift NUTS2013", 
              "Recoded in NUTS2013", 
              "Recoded in NUTS2016"
  )) 


test_that("Recoding gives correct results",{

  skip_on_cran()
  skip_on_travis()

  test_harmonized <- harmonize_geo_code(test_regional_codes)

  try_recode_2013 <- recode_to_nuts_2013(test_harmonized)

  try_recode_2016 <- recode_to_nuts_2016(test_harmonized)

  lookup_code16 <- test_harmonized %>%
    filter ( geo  == "FR243") %>%
    select ( code16 ) %>% unlist() %>% as.character()

  lookup_code13 <- test_harmonized %>%
    filter ( geo  == "FRB03") %>%
    select ( code13 ) %>% unlist() %>% as.character()

  recode_frb <- try_recode_2013 %>%
    filter ( code16  == "FRB") %>%
    select ( geo ) %>% unlist() %>% as.character()

  recode_ukn02 <- try_recode_2016 %>%
    filter ( code13  == "UKN02") %>%
    select ( geo ) %>% unlist() %>% as.character()

  expect_equal( lookup_code16, 
    "FRB03"
  )
  expect_equal( lookup_code13, 
                "FR243"
  )
  expect_equal( lookup_code13, 
                "FR243"
  )
  expect_equal( recode_frb, 
                NA_character_
  )
  expect_equal( recode_ukn02, 
                NA_character_
  )
 
})
