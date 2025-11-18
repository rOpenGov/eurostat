# Changelog

## eurostat 4.0.0

CRAN release: 2023-12-19

### Major updates

- Add data.table to package Imports and make using data.table functions
  optional with
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  `use.data.table` argument. This is especially useful with big datasets
  that would otherwise take a long time to go through the different data
  cleaning functions or crash R with their large memory footprint.
  (issue [\#277](https://github.com/rOpenGov/eurostat/issues/277), PR
  [\#278](https://github.com/rOpenGov/eurostat/issues/278))
- switch from `httr` package to `httr2` (issue
  [\#273](https://github.com/rOpenGov/eurostat/issues/273), PR
  [\#276](https://github.com/rOpenGov/eurostat/issues/276))
- Rewritten caching functionalities, making it possible to cache
  filtered queries and rely on local caches if the user attempt to
  filter a complete dataset that has already been cached. A list of
  queries and cached item hashes is stored in a cache_list.json file in
  cache folder. This can be viewed with a new function:
  [`list_eurostat_cache_items()`](https://ropengov.github.io/eurostat/reference/list_eurostat_cache_items.md).
  (Affects issues mentioned in
  [\#144](https://github.com/rOpenGov/eurostat/issues/144),
  [\#257](https://github.com/rOpenGov/eurostat/issues/257),
  [\#258](https://github.com/rOpenGov/eurostat/issues/258), fixed in PR
  [\#267](https://github.com/rOpenGov/eurostat/issues/267))
- Column names in `.eurostatTOC` object (returned by
  [`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md))
  now use dots instead of spaces in the style of
  [`base::make.names()`](https://rdrr.io/r/base/make.names.html),
  e.g. turning `last update of data` to `last.update.of.data` (PR
  [\#271](https://github.com/rOpenGov/eurostat/issues/271))
- `.eurostatTOC` object includes a new hierarchy column that represents
  the position of each folder, dataset and table in the folder
  structure.
- [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  includes the option to search Table of Content items by dataset codes
  in addition to titles. This makes it possible to make further queries
  from similar datasets (e.g. “nama_10_gdp”, “nama_10r_2gdp”,
  “nama_10r_3popgdp”) that might have different titles.
- [`label_eurostat_tables()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  has been rewritten to use the new SDMX API instead of `table_dic.dic`
  file in Eurostat Bulk Download Listing (PR
  [\#271](https://github.com/rOpenGov/eurostat/issues/271))
- Remove legacy code related to downloading data from old bulk download
  facilities and temporary functions added in package version 3.7.14.
- [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
  now leverages on
  [`giscoR::gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.html)
  for downloading geospatial data (PR
  [\#264](https://github.com/rOpenGov/eurostat/issues/264), thanks to
  [@dieghernan](https://github.com/dieghernan)):
  - `"spdf"` output class soft-deprecated, it would return a `sf` object
    with a message.
  - `make_valid` parameter soft-deprecated.
  - Added `...` to the function so additional parametes can be passed to
    [`giscoR::gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.html).
  - Dataset `eurostat_geodata_60_2016` updated.
- [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
  now requires sf package to work at all (PR
  [\#280](https://github.com/rOpenGov/eurostat/issues/280), thanks to
  [@dieghernan](https://github.com/dieghernan))

### Minor updates

- Added suppressWarnings() to some of the tests that use TOC’s directly
  or indirectly as the tests are not directly related to TOC files.
- Use more parameter inheritance in package function documentation to
  reduce discrepancies between different functions (DRY-principle) (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- Documentation more explicitly explains how to use filter parameters in
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  and
  [`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
  functions. The documentation now warns users about potential problems
  caused by `time` / `TIME_PERIOD` parameters when used to query
  datasets that contain quarterly data (issue
  [\#260](https://github.com/rOpenGov/eurostat/issues/260))
- As continuation of the update done in 3.7.14, started to use the new
  URL also for dictionary files in
  [`get_eurostat_dic()`](https://ropengov.github.io/eurostat/reference/get_eurostat_dic.md)
  and
  [`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  functions.
- [`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
  now outputs “Accessed YYYY-MM-DD” and “dataset last updated
  YYYY-MM-DD” in note field as otherwise it would be sporadically
  printed or not at all printed from `urldate` field.
- Print more informative API error messages. (issue
  [\#261](https://github.com/rOpenGov/eurostat/issues/261), PR
  [\#262](https://github.com/rOpenGov/eurostat/issues/262), thanks to
  [@ake123](https://github.com/ake123))
- Removed `sp`, `methods` and `broom` packages from dependencies.
- Added `giscoR` to Suggests. (PR
  [\#264](https://github.com/rOpenGov/eurostat/issues/264))

### New features

- Added new function:
  [`get_eurostat_interactive()`](https://ropengov.github.io/eurostat/reference/get_eurostat_interactive.md)
  for interactively searching and downloading data from Eurostat SDMX
  API. The function aims to make good data citation practices more
  prominently visible and also make it easier to explore what different
  arguments in
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  function do.
- There is also a new internal function `eurostat:::fixity_checksum()`
  to easily calculate a fixity checksum for datasets downloaded from
  Eurostat. The fixity checksum can, for example, be saved in research
  notes and reported in as part of data appendices. Printing the fixity
  checksum is encouraged by including an option to print it in every
  [`get_eurostat_interactive()`](https://ropengov.github.io/eurostat/reference/get_eurostat_interactive.md)
  query.
- Added a new internal function `clean_eurostat_toc()` for easy removal
  of TOC objects from .EurostatEnv environment. (PR
  [\#278](https://github.com/rOpenGov/eurostat/issues/278))
- New internal function `check_lang()` (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  function now explicity accepts a ‘lang’ argument, for passing onwards
  to
  [`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
  and
  [`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  (PR [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- New user facing function:
  [`get_eurostat_folder()`](https://ropengov.github.io/eurostat/reference/get_eurostat_folder.md)
  for downloading all datasets in a folder. The function is limited to
  downloading folders that contain at maximum 20 datasets. This function
  relies on new internal helper functions:
  [`toc_count_whitespace()`](https://ropengov.github.io/eurostat/reference/toc_count_whitespace.md),
  [`toc_determine_hierarchy()`](https://ropengov.github.io/eurostat/reference/toc_determine_hierarchy.md),
  [`toc_count_children()`](https://ropengov.github.io/eurostat/reference/toc_count_children.md)
  and
  [`toc_list_children()`](https://ropengov.github.io/eurostat/reference/toc_list_children.md).
  (PR [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- EXPERIMENTAL:
  [`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md)
  and
  [`set_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/set_eurostat_toc.md)
  now have experimental features that support downloading TOCs in French
  and German as well. This support, in turn, is leveraged in
  [`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
  which now has a language parameter: `lang` (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- Related to updates to
  [`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md),
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  now supports searching from French and German TOC-files as well (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))

### Deprecated and defunct

- [`grepEurostatTOC()`](https://ropengov.github.io/eurostat/reference/eurostat-defunct.md)
  is completely marked as defunct and is enroute to being removed from
  the package as
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  is now the only way to fetch Eurostat TOC items and search (grep) them
  (PR [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- During the development of the 4.0.0 version there was a temporary
  function called `label_eurostat_vars2` that has been removed in the
  final version, as promised earlier: “The old function will be
  completely removed after October 2023 when Eurostat Bulk Download
  Listing website is retired and `label_eurostat_vars2` will be renamed
  to
  [`label_eurostat_vars()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)”.
  The new
  [`label_eurostat_vars()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  function uses the new SDMX API to retrieve names for dataset columns.
  Function evolution is subject to ongoing Eurostat API developments.
  (PR [\#270](https://github.com/rOpenGov/eurostat/issues/270))

### Bug fixes

- Added a more informatic warning message in situations where TOC
  datasets downloaded from Eurostat might not have proper titles. For
  some reason this was isolated to German and French language versions
  of TOC while English language TOC had proper titles for all items. (PR
  [\#278](https://github.com/rOpenGov/eurostat/issues/278))
- [`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
  returns correct codes for titles and warns the user if some / all of
  the requested codes were not found in the TOC (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- [`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
  uses the date field with the internal BibEntry format that can be
  easily translated to other formats: bibtex, bibentry (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- [`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
  now outputs dataset codes in titles correctly so that `bibtex` and
  `biblatex` entries can be copypasted into bibliographies without
  adding escape characters manually (PR
  [\#270](https://github.com/rOpenGov/eurostat/issues/270))
- Fix issue related to downloading quarterly data (issue
  [\#260](https://github.com/rOpenGov/eurostat/issues/260), PR
  [\#271](https://github.com/rOpenGov/eurostat/issues/271))
- Reduce RAM usage in
  [`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md)
  when handling big datasets containing weekly data and tens of millions
  of rows (dataset used for testing mentioned in issue
  [\#200](https://github.com/rOpenGov/eurostat/issues/200)).

## eurostat 3.8.3 (2023-03-07)

### Bug fixes

- Fix date handling bug in the
  [`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
  and
  [`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md)
  functions (issue
  [\#251](https://github.com/rOpenGov/eurostat/issues/251), reported by
  [@lz1nwm](https://github.com/lz1nwm)). The
  [`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
  function uses the temporary
  [`eurotime2date()`](https://ropengov.github.io/eurostat/reference/eurotime2date.md)
  function for date handling until the old bulk download API is
  deprecated.

## eurostat 3.8.2 (2023-03-06)

CRAN release: 2023-03-06

### Minor updates

- use
  [`curl::curl_download`](https://jeroen.r-universe.dev/curl/reference/curl_download.html)
  on Windows platforms instead of
  [`utils::download.file`](https://rdrr.io/r/utils/download.file.html)
  as the latter causes the following error: “error reading from the
  connection \[…\] invalid or incomplete compressed data”. This affects
  only files downloaded from the new API.

## eurostat 3.7.14 (2023-02-22)

### Major updates

- Updated
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  and its assorted functions to download data from the new dissemination
  API (related to issues
  [\#251](https://github.com/rOpenGov/eurostat/issues/251),
  [\#243](https://github.com/rOpenGov/eurostat/issues/243)). See
  Eurostat web page Transition - from Eurostat Bulk Download to API for
  a list of differences between old and new data sources:
  <https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API>
- Added new temporary functions for downloading and handling data from
  the new dissemination API: `get_eurostat_raw2`, `tidy_eurostat2`,
  `convert_time_col2`, `eurotime2date2`, `eurotime2num2` and
  `label_eurostat2`. When the old bulk download facilities are
  decommissioned, these functions will replace the old functions with
  old naming schemes (without the 2s at the end).
- `tidy_eurostat2` function is now able to handle multiple time
  frequencies in one call: For example, you can download annual,
  quarterly, and monthly data simply by using a vector c(“A”, “Q”, “M”)
  in select_time instead of using these singular frequencies in separate
  calls. The function will also return multiple time series in one
  dataset if select_time is NULL (as it is by default). If the dataset
  contains multiple time series and these are explicitly downloaded / no
  select_time parameter is given, a message will be printed.
- `eurotime2num` can now handle monthly and weekly data as well.
- Added a new parameter to
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  function: legacy_bulk_download (default = TRUE). By setting this
  parameter to FALSE the user can download data from the new
  dissemination API. If you want to test the new API before it becomes
  the only way to download the data (and we very much encourage you to
  do so), set this parameter to FALSE.

### Minor updates

- Removed render-rmarkdown.yaml workflow used for rendering README.md
  file. README.md must be generated locally from now on.

## eurostat 3.7.13 (2023-02-01)

- Updated
  [`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md)
  to migrate from JSON web service to API Statistics (addressed in
  issues [\#243](https://github.com/rOpenGov/eurostat/issues/243),
  [\#251](https://github.com/rOpenGov/eurostat/issues/251)). Please note
  that the output from JSON API is now slightly different than before:
  the datasets now contain a freq column to indicate the frequency with
  which data has been collected, for example annually “A”, monthly “M”
  or quarterly “Q”. See Eurostat - Data browser online help website for
  more information:
  <https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+migrating+from+JSON+web+service+to+API+Statistics>
- Minor fixes in
  [`get_bibentry()`](https://ropengov.github.io/eurostat/reference/get_bibentry.md)
  and
  [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)

## eurostat 3.7.12 (2022-06-28)

- Updated included dataset `eurostat_geodata_60_2016` to fix the issue
  of old-style crs object
  ([\#237](https://github.com/rOpenGov/eurostat/issues/237))
- Added information about different variables in
  `eurostat_geodata_60_2016` so that the dataset is more understandable
  and usable for testing purposes. Added the same information to
  [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
  documentation as well.
- Added the GISCO copyright disclaimer to `eurostat_geodata_60_2016` and
  [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
  documentation.
- Get rid of unnecessary “No encoding supplied: defaulting to UTF-8.”
  messages in
  [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
  by setting content encoding to UTF-8 when
  [`httr::content()`](https://httr.r-lib.org/reference/content.html)
  function is called
- dplyr and tidyr namespaces are no longer imported completely, only
  selected few functions with importFrom

## eurostat 3.7.10 (2022-02-09)

CRAN release: 2022-02-09

- Fixed URL issues in tests and examples

## eurostat 3.7.9 (2020-10-01)

- Function documentation migrated from old `\code{}`, `\link{}` syntax
  to markdown (issue
  [\#230](https://github.com/rOpenGov/eurostat/issues/230), PR
  [\#231](https://github.com/rOpenGov/eurostat/issues/231) by
  [@dieghernan](https://github.com/dieghernan))

## eurostat 3.7.8 (2020-09-30)

- Package cache management updated:
  [`options()`](https://rdrr.io/r/base/options.html) command is no
  longer needed and the cache dir can be modified persistently with a
  custom function (issue
  [\#223](https://github.com/rOpenGov/eurostat/issues/223), PR
  [\#228](https://github.com/rOpenGov/eurostat/issues/228) by
  [@dieghernan](https://github.com/dieghernan))

## eurostat 3.7.7 (2020-06-24)

- Maps vignette fixed

## eurostat 3.7.6 (2021-05-20)

- Deprecated
  [`add_nuts_level()`](https://ropengov.github.io/eurostat/reference/add_nuts_level.md),
  [`harmonize_geo_code()`](https://ropengov.github.io/eurostat/reference/harmonize_geo_code.md),
  [`recode_to_nuts_2016()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2016.md)
  and
  [`recode_to_nuts_2013()`](https://ropengov.github.io/eurostat/reference/recode_to_nuts_2013.md);
  these functions were moved to the new package regions. The problem of
  sub-national geo codes is explained in the new vignette “Mapping
  Regional Data, Mapping Metadata Problems”, which replaces the
  “Regional data examples for the eurostat R package” vignette. This is
  a shared vignette, but the new regions package has more articles on
  how to work with sub-national data. (issues
  [\#218](https://github.com/rOpenGov/eurostat/issues/218) and
  [\#219](https://github.com/rOpenGov/eurostat/issues/219), PR
  [\#220](https://github.com/rOpenGov/eurostat/issues/220) by
  [@antaldaniel](https://github.com/antaldaniel))

## eurostat 3.7.5 (2020-05-12)

CRAN release: 2021-05-14

- Moved sf from Imports to Suggests and made
  [`get_eurostat_geospatial()`](https://ropengov.github.io/eurostat/reference/get_eurostat_geospatial.md)
  return a message if sf is not installed. This is to increase
  compatibility of eurostat-package on systems that have trouble
  installing sf (issue
  [\#213](https://github.com/rOpenGov/eurostat/issues/213))
- Wrapped some problem causing examples to `\dontrun{}` for a quick CRAN
  release

## eurostat 3.7.3

- Removed outdated dependencies (mapproj, plotrix, rsdmx)

## eurostat 3.7.2

- Non-intersecting sf-geometries in get_eurostat_geospatial (PR
  [\#202](https://github.com/rOpenGov/eurostat/issues/202) by
  [@retostauffer](https://github.com/retostauffer))

## eurostat 3.6.4 (2020-05-12)

- Fixed stringsAsFactors for R-4.0.0 and moved default to FALSE

## eurostat 3.6.3 (2020-04-21)

- Stabilized http requests (PR by [@annnvv](https://github.com/annnvv))

## eurostat 3.5.3

- get_eurostat switched to v2.1

## eurostat 3.5.2

CRAN release: 2020-01-25

- internet and proxy setting fixes
- bibentry fix

## eurostat 3.4.1

- Fixed vignette
- Added automated error messages to URL download failures

## eurostat 3.3.3

- Countries and Country Codes data.frames get label column for country
  names in the Eurostat database.
- Fixed vignette duplicate entry issue and smaller issues
- Added get_bibentry

## eurostat 3.3.1

CRAN release: 2018-11-24

- The
  [`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  has new countrycode and countrycode_nomatch arguments to label with
  countrycode package and custom_dic argument to add custom dictionary.
- Vignette updated

## eurostat 3.2.3

### Minor features

- dplyr moved from Dependencies to Imports
- curl removed from Imports
- solved geospatial map issues
- eurostat_url moved to options

## eurostat 3.2.1

CRAN release: 2018-05-20

### Major updates

- Improved support for sf in map visualization

### Minor features

- ./data/ generation script in ./data-raw/ updated to make all data
  reproducible

### Bug fixes

- Typo corrected from Cisco to Gisco

## eurostat 3.1.5

CRAN release: 2017-08-09

### Minor features

- Added new example data set to reduce repeated downloads from eurostat
  service
- Now
  [`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  gives always an error by default, if labelling introduces duplicated
  labels. A new `fix_duplicated` argument is add to fix duplicated
  labels automatically.
  ([\#79](https://github.com/rOpenGov/eurostat/issues/79),
  [\#90](https://github.com/rOpenGov/eurostat/issues/90))
- Shrinked the package tarball size

### Bug fixes

- Modified tutorial to accommodate the CRAN error
- Fixed cut_to_classes to generate unique breaks

## eurostat 3.1.1

CRAN release: 2017-03-16

### R Journal submission

- Release version associated with the R Journal manuscript 2017 final
  version
- Git release added with Zenodo DOI

### Minor features

- Changed maintainer email address from louhos to leo
- Added ./docs/ (automated package website generated with pkgdown)
- Expanded unit tests
- Gitter badge added to README
- Added ./revdep/ to check possible reverse dependencies automatically
- Cheat sheet added

### Bug fixes

- [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  accepts new argument `fixed`: if `TRUE` (default), `pattern` provided
  will used as is; if `FALSE`, `pattern` will be interpreted as a true
  regex pattern.
- Augmented the list of Suggested packages in the DESCRIPTION file,
  including the Cairo package
  ([\#70](https://github.com/rOpenGov/eurostat/issues/70))
- Updated the journal manuscript based on reviewer feedback

## eurostat 2.2.20001

- Development version opened

## eurostat 2.2.1

CRAN release: 2016-09-14

- Fixed canonical cran url in README

## eurostat 2.1.1

- The complete package now using tibbles
- Rare encoding issues circumvented
  ([\#55](https://github.com/rOpenGov/eurostat/issues/55))
- Improved functionality within firewall-protected systems
  ([\#63](https://github.com/rOpenGov/eurostat/issues/63))

## eurostat 2.0

- The
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  returns tibbles
  ([\#52](https://github.com/rOpenGov/eurostat/issues/52))
- The
  [`get_eurostat_dic()`](https://ropengov.github.io/eurostat/reference/get_eurostat_dic.md)
  and
  [`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md)
  return tibbles
- Now `read_tsv()` is used instead of
  [`read.csv()`](https://rdrr.io/r/utils/read.table.html)
  ([\#29](https://github.com/rOpenGov/eurostat/issues/29))

## eurostat 1.2.27

- Calls to extract_numeric are replaced by as.numeric
  ([\#60](https://github.com/rOpenGov/eurostat/issues/60))
- The column ‘flags’ is not being labelled even if type = “label”
  ([\#61](https://github.com/rOpenGov/eurostat/issues/61))

## eurostat 1.2.22

- The European Commission and the Eurostat generally uses ISO 3166-1
  alpha-2 codes with two exceptions: EL (not GR) is used to represent
  Greece, and UK (not GB) is used to represent the United Kingdom. This
  now can be handled with
  [`harmonize_country_code()`](https://ropengov.github.io/eurostat/reference/harmonize_country_code.md)
  which converts the raw data values from EL to GR and from UK to GB.
- Harmonized roxygen documentation to better follow CRAN conventions
- Changed Windows encoding to UTF for input files
- Improved memory usage

## eurostat 1.2.21

CRAN release: 2016-03-11

- The
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  can now get data also from the Eurostat JSON API via
  [`get_eurostat_json()`](https://ropengov.github.io/eurostat/reference/get_eurostat_json.md).
  It also have a new argument `type` to select labels for variable
  values instead of codes.
- Fix an error after update to `tidyr 0.4.0`
  ([\#47](https://github.com/rOpenGov/eurostat/issues/47)).

## eurostat 1.2.13

CRAN release: 2016-01-19

- New `select_time` argument for
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  to select a time frequency in case of multi-frequency datasets. Now
  the
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  also gives an error if you try to get multi-frequency with other time
  formats than `time_format = "raw"`.
  ([\#30](https://github.com/rOpenGov/eurostat/issues/30)) `time` column
  is also now in ascending order.
- [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  gets a new argument `compress_file` to control compression of the
  cache file. Also cache filenames includes now all relevant arguments.
  ([\#28](https://github.com/rOpenGov/eurostat/issues/28))
- For
  [`search_eurostat()`](https://ropengov.github.io/eurostat/reference/search_eurostat.md)
  a new type option `type = "all"` to search all types.
- For
  [`label_eurostat()`](https://ropengov.github.io/eurostat/reference/label_eurostat.md)
  new arguments. A `code` to retain also codes for specified columns. A
  `eu_order` to order factor levels in Eurostat order, which uses the
  new function
  [`dic_order()`](https://ropengov.github.io/eurostat/reference/dic_order.md).
- Now `label_eurostat_vars(x)` gives labels for names, if x is other
  than a character or a factor and `label_eurostat_tables(x)` does not
  accept other than a character or a factor.
- For
  [`get_eurostat()`](https://ropengov.github.io/eurostat/reference/get_eurostat.md)
  a new argument `stringsAsFactors` to control the factor conversion of
  variables.
- `eurotime2date` (and `get_eurostat`) convers now also daily data.

## eurostat 1.0.16

CRAN release: 2015-03-27

- Fixed vignette error

## eurostat 1.0.14 (2015-03-19)

- Package largely rewritten
- Vignette added
- Changed the value column to values in the get_eurostat output

## eurostat 0.9.1 (2014-04-24)

- Package collected from statfi and smarterpoland
