# Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek
# <ropengov.github.com>. All rights reserved.

.SmarterPolandEnv <- new.env()

.onAttach <- function(lib, pkg)
{

  # This may help with encodings in Mac/Linux
  # Sys.setlocale(locale = "UTF-8")
  # Sys.setlocale(locale = "WINDOWS-1252")

  packageStartupMessage("Eurostat R tools. Copyright (C) 2014 Leo Lahti and Przemyslaw Biecek. This is free software and part of rOpenGov http://ropengov.github.io")

}
