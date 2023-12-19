#' @title R Tools for Eurostat open data
#' 
#' @description
#' Tools to download data from the Eurostat database
#' <https://ec.europa.eu/eurostat> together with search and manipulation
#' utilities.
#' 
#' @details
#'
#' |              |          |
#' | :---         | :--      |
#' | **Package**  | eurostat |
#' | **Type**     | Package  |
#' | **Version**  | `r packageVersion("eurostat")` |
#' | **Date**     | 2014-2023     |
#' | **License**  | `r as.character(utils::packageDescription("eurostat")["License"])`|
#' | **LazyLoad** | yes      |
#'
#' @name eurostat-package
#' @aliases eurostat
#' @docType package
#'
#' @author Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek
#' @references
#' See `citation("eurostat")`:
#'
#' ```{r, echo=FALSE, comment="" }
#' citation("eurostat")
#' ```
#' 
#' When citing data downloaded from Eurostat, see section "Citing Eurostat data"
#' in [get_eurostat()] documentation.
#'
#' @details 
#' # Eurostat
#' Eurostat website: \url{https://ec.europa.eu/eurostat}
#' Eurostat database: \url{https://ec.europa.eu/eurostat/web/main/data/database}
#' 
#' Information about the data update schedule from Eurostat:
#' "Eurostat datasets are updated twice a day at 11:00 and 23:00 CET, if newer
#' data is available or for structural changes, for example for the
#' dimensions in the dataset.
#' 
#' The Eurostat database always contains the latest version of the datasets,
#' meaning that there is no versioning or documentation of past versions of
#' the data."
#' 
#' # Data source: Eurostat SDMX 2.1 Dissemination API
#' 
#' Data is downloaded from Eurostat SDMX 2.1 API endpoint 
#' as compressed TSV files that are transformed into tabular format.
#' See Eurostat documentation for more information:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+SDMX+2.1+-+data+query}
#' 
#' The new dissemination API replaces the old bulk download facility that was 
#' used by Eurostat before October 2023 and by the eurostat R package versions 
#' before 4.0.0.
#' See Eurostat documentation about the transition from Bulk Download to API
#' for more information about the differences between the old bulk download 
#' facility and the data provided by the new API connection:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API}
#' 
#' See especially the document Migrating_to_API_TSV.pdf that describes the 
#' changes in TSV file format in new applications.
#' 
#' For more information about SDMX 2.1, see SDMX standards: Section 7: 
#' Guidelines for the use of web services, Version 2.1:
#' \url{https://sdmx.org/wp-content/uploads/SDMX_2-1_SECTION_7_WebServicesGuidelines.pdf}
#' 
#' # Disclaimer: Availability of filtering functionalities
#' 
#' Currently it only possible to download filtered data through API Statistics
#' (JSON API) when using `eurostat` package, although technically filtering
#' datasets downloaded through the SDMX Dissemination API is also supported by
#' Eurostat. We may support this feature in the future. In the meantime, if you
#' are interested in filtering Dissemination API data queries manually, please
#' consult the following Eurostat documentation:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+SDMX+2.1+-+data+filtering}
#' 
#' # Data source: Eurostat API Statistics (JSON API)
#' 
#' Data is downloaded from Eurostat API Statistics. See Eurostat documentation
#' for more information about data queries in API Statistics
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query}
#' 
#' This replaces the old JSON Web Services that was used by Eurostat before
#' February 2023 and by the eurostat R package versions before 3.7.13.
#' See Eurostat documentation about the migration from JSON web service to API
#' Statistics for more information about the differences between the old and
#' the new service:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+migrating+from+JSON+web+service+to+API+Statistics}
#' 
#' For easily viewing which filtering options are available -  in addition to
#' the default ones, time and language - Eurostat Web services Query builder 
#' tool may be useful:
#' \url{https://ec.europa.eu/eurostat/web/query-builder}
#' 
#' # Filtering datasets
#' 
#' When using Eurostat API Statistics (JSON API), datasets can be filtered
#' before they are downloaded and saved in local memory. The general format
#' for filter parameters is `<DIMENSION_CODE>=<VALUE>`. 
#' 
#' Filter parameters are optional but the used dimension codes must be present
#' in the data product that is being queried. Dimension codes can
#' vary between different data products so it may be useful to examine new 
#' datasets in Eurostat data browser beforehand. However, most if not all
#' Eurostat datasets concern European countries and contain information that
#' was gathered at some point in time, so `geo` and `time` dimension codes
#' can usually be used.
#' 
#' `<DIMENSION_CODE>` and `<VALUE>` are case-insensitive and they can be written
#' in lowercase or uppercase in the query.
#' 
#' Parameters are passed onto the `eurostat` package functions [get_eurostat()]
#' and [get_eurostat_json()] as a list item. If an individual item contains
#' multiple items, as it often can be in the case of `geo` parameters and
#' other optional items, they must be in the form of a vector: `c("FI", "SE")`.
#' For examples on how to use these parameters, see function examples below.
#' 
#' ## Time parameters
#' 
#' `time` and `time_period` address the same `TIME_PERIOD` dimension in the
#' dataset and can be used interchangeably. In the Eurostat documentation
#' it is stated that "Using more than one Time parameter in the same query
#' is not accepted", but practice has shown that actually Eurostat API allows
#' multiple `time` parameters in the same query. This makes it possible to
#' use R colon operator when writing queries, so `time = c(2015:2018)` 
#' translates to `&time=2015&time=2016&time=2017&time=2018`. 
#' 
#' The only exception
#' to this is when the queried dataset contains e.g. quarterly data and 
#' `TIME_PERIOD` is saved as `2015-Q1`, `2015-Q2` etc. Then it is possible
#' to use `time=2015-Q1&time=2015-Q2` style in the query URL, but this makes it
#' unfeasible to use the colon operator and requires a lot of manual typing.
#' 
#' Because of this, it is useful to know about other time parameters as well:
#' * `untilTimePeriod`: return dataset items from the oldest record up until the
#' set time, for example "all data until 2000": `untilTimePeriod = 2000`
#' * `sinceTimePeriod`: return dataset items starting from set time, for example
#' "all datastarting from 2008": `sinceTimePeriod = 2008`
#' * `lastTimePeriod`: starting from the most recent time period, how many
#' preceding time periods should be returned? For example 10 most 
#' recent observations: `lastTimePeriod = 10`
#' 
#' Using both `untilTimePeriod` and `sinceTimePeriod` parameters in the same
#' query is allowed, making the usage of the R colon operator unnecessary.
#' In the case of quarterly data, using `untilTimePeriod` and `sinceTimePeriod`
#' parameters also works, as opposed to the colon operator, so it is generally
#' safer to use them as well.
#' 
#' ## Other dimensions
#' 
#' In [get_eurostat_json()] examples `nama_10_gdp` dataset is filtered with
#' two additional filter parameters:
#' * `na_item = "B1GQ"`
#' * `unit = "CLV_I10"`
#' 
#' Filters like these are most likely unique to the `nama_10_gdp` dataset 
#' (or other datasets within the same domain) and should
#' not be used with others dataset without user discretion. 
#' By using [label_eurostat()] we know that `"B1GQ"` stands for 
#' "Gross domestic product at market prices" and
#' `"CLV_I10"` means "Chain linked volumes, index 2010=100".
#' 
#' Different dimension codes can be translated to a natural language by using
#' the [get_eurostat_dic()] function, which returns labels for individual 
#' dimension items such as `na_item` and `unit`, as opposed to 
#' [label_eurostat()] which does it for whole datasets. For example, the 
#' parameter `na_item` stands for "National accounts indicator (ESA 2010)" and
#' `unit` stands for "Unit of measure".
#' 
#' ## Language
#' 
#' All datasets have metadata available in English, French and German. If no
#' parameter is given, the labels are returned in English.
#' 
#' Example:
#' * `lang = "fr"`
#' 
#' ## More information 
#' 
#' For more information about data filtering see Eurostat documentation
#' on API Statistics:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+Statistics+-+data+query#APIStatisticsdataquery-TheparametersdefinedintheRESTrequest}
#' 
#' # Data source: Eurostat Table of Contents
#' 
#' The Eurostat Table of Contents (TOC) is downloaded from
#' \url{https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=en}
#' (default) or from French or German language variants:
#' \url{https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=fr}
#' \url{https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=de}
#' 
#' See Eurostat documentation on TOC items:
#' \url{https://wikis.ec.europa.eu/display/EUROSTATHELP/API+-+Detailed+guidelines+-+Catalogue+API+-+TOC}
#' 
#' # Data source: GISCO - General Copyright
#' 
#' "Eurostat's general copyright notice and licence policy is applicable and
#' can be consulted here:
#' <https://ec.europa.eu/eurostat/about-us/policies/copyright>
#' 
#' Please also be aware of the European Commission's general conditions:
#' <https://commission.europa.eu/legal-notice_en>
#' 
#' Moreover, there are specific provisions applicable to some of the following
#' datasets available for downloading. The download and usage of these data
#' is subject to their acceptance:
#' 
#' * Administrative Units / Statistical Units
#' * Population distribution / Demography
#' * Transport Networks
#' * Land Cover
#' * Elevation (DEM)"
#' 
#' Of the abovementioned datasets, Administrative Units / Statistical Units
#' is applicable if the user wants to draw maps with borders provided by
#' GISCO / EuroGeographics.
#' 
#' # Data source: GISCO - Administrative Units / Statistical Units
#' 
#' The following copyright notice is provided for end user convenience.
#' Please check up-to-date copyright information from the GISCO website:
#' [GISCO: Geographical information and maps - Administrative units/statistical units](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units)
#'
#' "In addition to the [general copyright and licence policy](https://ec.europa.eu/eurostat/web/main/about/policies/copyright) applicable to the whole Eurostat website, the following
#' specific provisions apply to the datasets you are downloading. The download
#' and usage of these data is subject to the acceptance of the following
#' clauses:
#'
#' 1. The Commission agrees to grant the non-exclusive and not transferable
#' right to use and process the Eurostat/GISCO geographical data downloaded
#' from this page (the "data").
#'
#' 1. The permission to use the data is granted on condition that:
#'    1. the data will not be used for commercial purposes;
#'    2. the source will be acknowledged. A copyright notice, as specified
#'    below, will have to be visible on any printed or electronic publication
#'    using the data downloaded from this page."
#'
#' ## Copyright notice
#'
#' When data downloaded from this page is used in any printed or electronic
#' publication, in addition to any other provisions applicable to the whole
#' Eurostat website, data source will have to be acknowledged in the legend of
#' the map and in the introductory page of the publication with the following
#' copyright notice:
#'
#' EN: © EuroGeographics for the administrative boundaries
#'
#' FR: © EuroGeographics pour les limites administratives
#'
#' DE: © EuroGeographics bezüglich der Verwaltungsgrenzen
#'
#' For publications in languages other than English, French or German, the
#' translation of the copyright notice in the language of the publication shall
#' be used.
#'
#' If you intend to use the data commercially, please contact EuroGeographics
#' for information regarding their licence agreements."
#' 
#' # Eurostat: Copyright notice and free re-use of data
#' 
#' The following copyright notice is provided for end user convenience.
#' Please check up-to-date copyright information from the eurostat website:
#' <https://ec.europa.eu/eurostat/about-us/policies/copyright>
#' 
#' "(c) European Union, 1995 - today
#' 
#' Eurostat has a policy of encouraging free re-use of its data, both for
#' non-commercial and commercial purposes. All statistical data, metadata,
#' content of web pages or other dissemination tools, official publications
#' and other documents published on its website, with the exceptions listed
#' below, can be reused without any payment or written licence provided that:
#' 
#' * the source is indicated as Eurostat;
#' * when re-use involves modifications to the data or text, this must be
#' stated clearly to the end user of the information."
#' 
#' For exceptions to the abovementioned principles see 
#' [Eurostat website](https://ec.europa.eu/eurostat/about-us/policies/copyright)
#' 
#' # Citing Eurostat data
#' 
#' For citing datasets, use [get_bibentry()] to build a bibliography that
#' is suitable for your reference manager of choice.
#' 
#' When using Eurostat data in other contexts than academic publications that
#' in-text citations or footnotes/endnotes, the following guidelines may be
#' helpful:
#' 
#' * The origin of the data should always be mentioned as "Source: Eurostat".
#'
#' * The online dataset codes(s) should also be provided in order to ensure
#' transparency and facilitate access to the Eurostat data and related
#' methodological information. For example:
#' "Source: Eurostat (online data code: namq_10_gdp)"
#'
#' * Online publications (e.g. web pages, PDF) should include a clickable
#' link to the dataset using the bookmark functionality available in the
#' Eurostat data browser.
#'
#' It should be avoided to associate different entities (e.g. Eurostat,
#' National Statistical Offices, other data providers) to the same dataset or
#' indicator without specifying the role of each of them in the treatment of
#' data.
#' 
#' See also section "Eurostat: Copyright notice and free re-use of data"
#' in [get_eurostat()] documentation.
#' 
#' # Strategies for handling large datasets more efficiently
#' 
#' Most Eurostat datasets are relatively manageable, at least on a machine
#' with 16 GB of RAM. The largest dataset in Eurostat database, at the time
#' of writing this, had 148362539 (148 million) values, which results in an
#' object with 148 million rows in tidy data (long) format. The test machine
#' with 16 GB of RAM was able to handle the second largest dataset in the
#' database with 91 million values (rows).
#' 
#' There are still some methods to make data fetching 
#' functions perform faster:
#' 
#' * turn caching off: `get_eurostat(cache = FALSE)`
#' * turn cache compression off (may result in rather large cache files!): 
#' `get_eurostat(compress_file = FALSE)`
#' * if you want faster caching with manageable file sizes, use stringsAsFactors: 
#' `get_eurostat(cache = TRUE, compress_file = TRUE, stringsAsFactors = TRUE)`
#' * Use faster data.table functions: `get_eurostat(use.data.table = TRUE)`
#' * Keep column processing to a minimum: 
#' `get_eurostat(time_format = "raw", type = "code")` etc.
#' * Read `get_eurostat()` function documentation carefully so you understand
#' what different arguments do
#' * Filter the dataset so that you fetch only the parts you need!
#' 
#' @examples library(eurostat)
#' @section regions functions:
#' For working with sub-national statistics the basic functions of the
#' regions package are imported <https://regions.dataobservatory.eu/>.
#' @keywords package
#' @seealso `help("regions")`, <https://regions.dataobservatory.eu/>
NULL
