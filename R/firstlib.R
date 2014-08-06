.SmarterPolandEnv <- new.env()

.onAttach <- function(lib, pkg)
{

  # This may help with encodings in Mac/Linux
  # Sys.setlocale(locale = "UTF-8")
  # Sys.setlocale(locale = "WINDOWS-1252")

  packageStartupMessage("Eurostat R tools. Copyright (C) 2014 Leo Lahti, Przemyslaw Biecek, Janne Huovari and Markus Kainu. This is free software from rOpenGov http://ropengov.github.io")

}
