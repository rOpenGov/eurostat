# eurostat 1.1.9000

* Development version
* New `select_time` argument for `get_eurostat()` to select a time frequency 
  in case of multi-frequency datasets. Now the `get_eurostat()` also gives an
  error if you try to get multi-frequency with other time formats
  than `time_format = "raw"`. (#30) 
* `get_eurostat()` cache filenames includes now all relevant arguments. (#28)
* For `search_eurostat()` a new type option `type = "all"` to search all types.
* For `label_eurostat()` a new argument `code` to retain also codes 
  for spesified colums. 

# eurostat 1.0.16

* Fixed vignette error

# eurostat 1.0.14 (2015-03-19)

* Package largely rewritten
* Vignette added
* Changed the value column to values in the get_eurostat output

# eurostat 0.9.1 (2014-04-24)

* Package collected from statfi and smarterpoland
