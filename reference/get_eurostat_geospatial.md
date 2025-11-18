# Download Geospatial Data from GISCO

Downloads either a simple features (sf) or a data_frame of NUTS regions.
This function is a wrapper of
[`giscoR::gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.html).
This function requires to have installed the packages
[sf](https://CRAN.R-project.org/package=sf) and
[giscoR](https://CRAN.R-project.org/package=giscoR).

## Usage

``` r
get_eurostat_geospatial(
  output_class = "sf",
  resolution = "60",
  nuts_level = "all",
  year = "2016",
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  crs = "4326",
  make_valid = "DEPRECATED",
  ...
)
```

## Source

Data source: Eurostat

© EuroGeographics for the administrative boundaries

Data downloaded using giscoR

## Arguments

- output_class:

  Class of object returned, either `sf` `simple features` or `df`
  (`data_frame`). `spdf` output has been soft-deprecated, the function
  would switch to `sf`.

- resolution:

  Resolution of the geospatial data. One of

  - "60" (1:60million),

  - "20" (1:20million)

  - "10" (1:10million)

  - "03" (1:3million) or

  - "01" (1:1million).

- nuts_level:

  Level of NUTS classification of the geospatial data. One of "0", "1",
  "2", "3" or "all" (mimics the original behaviour)

- year:

  NUTS release year. One of "2003", "2006", "2010", "2013", "2016" or
  "2021"

- cache:

  a logical whether to do caching. Default is `TRUE`.

- update_cache:

  a logical whether to update cache. Can be set also with
  `options(eurostat_update = TRUE)`

- cache_dir:

  a path to a cache directory. See
  [`set_eurostat_cache_dir()`](https://ropengov.github.io/eurostat/reference/set_eurostat_cache_dir.md).
  If `NULL` and the cache dir has not been set globally the file would
  be stored in the [`tempdir()`](https://rdrr.io/r/base/tempfile.html).

- crs:

  projection of the map: 4-digit [EPSG
  code](https://spatialreference.org/ref/epsg/). One of:

  - "4326" - WGS84

  - "3035" - ETRS89 / ETRS-LAEA

  - "3857" - Pseudo-Mercator

- make_valid:

  Deprecated

- ...:

  Arguments passed on to
  [`giscoR::gisco_get_nuts`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.html)

  `verbose`

  :   Logical, displays information. Useful for debugging, default is
      `FALSE`.

  `spatialtype`

  :   Type of geometry to be returned:

      - **"BN"**: Boundaries - `LINESTRING` object.

      - **"LB"**: Labels - `POINT` object.

      - **"RG"**: Regions - `MULTIPOLYGON/POLYGON` object.

  `country`

  :   Optional. A character vector of country codes. It could be either
      a vector of country names, a vector of ISO3 country codes or a
      vector of Eurostat country codes. Mixed types (as
      `c("Turkey","US","FRA")`) would not work. See also
      [`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/reference/countrycode.html).

  `nuts_id`

  :   Optional. A character vector of NUTS IDs.

## Value

a sf or data_frame

## Details

The objects downloaded from GISCO should contain all or some of the
following variable columns:

- **id**: JSON id code, the same as **NUTS_ID**. See **NUTS_ID** below
  for further clarification.

- **LEVL_CODE**: NUTS level code: 0 (national level), 1 (major
  socio-economic regions), 2 (basic regions for the application of
  regional policies) or 3 (small regions).

- **NUTS_ID**: NUTS ID code, consisting of country code and numbers (1
  for NUTS 1, 2 for NUTS 2 and 3 for NUTS 3)

- **CNTR_CODE**: Country code: two-letter ISO code (ISO 3166 alpha-2),
  except in the case of Greece (EL).

- **NAME_LATN**: NUTS name in local language, transliterated to Latin
  script

- **NUTS_NAME**: NUTS name in local language, in local script.

- **MOUNT_TYPE**: Mountain typology for NUTS 3 regions.

  - 1: "where more than 50 % of the surface is covered by topographic
    mountain areas"

  - 2: "in which more than 50 % of the regional population lives in
    topographic mountain areas"

  - 3: "where more than 50 % of the surface is covered by topographic
    mountain areas and where more than 50 % of the regional population
    lives in these mountain areas"

  - 4: non-mountain region / other region

  - 0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2
    and non-EU countries)

- **URBN_TYPE**: Urban-rural typology for NUTS 3 regions.

  - 1: predominantly urban region

  - 2: intermediate region

  - 3: predominantly rural region

  - 0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2
    regions)

- **COAST_TYPE**: Coastal typology for NUTS 3 regions.

  - 1: coastal (on coast)

  - 2: coastal (\>= 50% of population living within 50km of the
    coastline)

  - 3: non-coastal region

  - 0: no classification provided (e.g. in the case of NUTS 1 and NUTS 2
    regions)

- **FID**: Same as NUTS_ID.

- **geo**: Same as NUTS_ID, added for for easier joins with dplyr.
  Consider the status of this column "questioning" and use other columns
  for joins when possible.

- **geometry**: geospatial information.

## Eurostat: Copyright notice and free re-use of data

The following copyright notice is provided for end user convenience.
Please check up-to-date copyright information from the eurostat website:
<https://ec.europa.eu/eurostat/about-us/policies/copyright>

"(c) European Union, 1995 - today

Eurostat has a policy of encouraging free re-use of its data, both for
non-commercial and commercial purposes. All statistical data, metadata,
content of web pages or other dissemination tools, official publications
and other documents published on its website, with the exceptions listed
below, can be reused without any payment or written licence provided
that:

- the source is indicated as Eurostat;

- when re-use involves modifications to the data or text, this must be
  stated clearly to the end user of the information."

For exceptions to the abovementioned principles see [Eurostat
website](https://ec.europa.eu/eurostat/about-us/policies/copyright)

## Data source: GISCO - General Copyright

"Eurostat's general copyright notice and licence policy is applicable
and can be consulted here:
<https://ec.europa.eu/eurostat/about-us/policies/copyright>

Please also be aware of the European Commission's general conditions:
<https://commission.europa.eu/legal-notice_en>

Moreover, there are specific provisions applicable to some of the
following datasets available for downloading. The download and usage of
these data is subject to their acceptance:

- Administrative Units / Statistical Units

- Population distribution / Demography

- Transport Networks

- Land Cover

- Elevation (DEM)"

Of the abovementioned datasets, Administrative Units / Statistical Units
is applicable if the user wants to draw maps with borders provided by
GISCO / EuroGeographics.

## Data source: GISCO - Administrative Units / Statistical Units

The following copyright notice is provided for end user convenience.
Please check up-to-date copyright information from the GISCO website:
[GISCO: Geographical information and maps - Administrative
units/statistical
units](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units)

"In addition to the [general copyright and licence
policy](https://ec.europa.eu/eurostat/web/main/about/policies/copyright)
applicable to the whole Eurostat website, the following specific
provisions apply to the datasets you are downloading. The download and
usage of these data is subject to the acceptance of the following
clauses:

1.  The Commission agrees to grant the non-exclusive and not
    transferable right to use and process the Eurostat/GISCO
    geographical data downloaded from this page (the "data").

2.  The permission to use the data is granted on condition that:

    1.  the data will not be used for commercial purposes;

    2.  the source will be acknowledged. A copyright notice, as
        specified below, will have to be visible on any printed or
        electronic publication using the data downloaded from this
        page."

### Copyright notice

When data downloaded from this page is used in any printed or electronic
publication, in addition to any other provisions applicable to the whole
Eurostat website, data source will have to be acknowledged in the legend
of the map and in the introductory page of the publication with the
following copyright notice:

EN: © EuroGeographics for the administrative boundaries

FR: © EuroGeographics pour les limites administratives

DE: © EuroGeographics bezüglich der Verwaltungsgrenzen

For publications in languages other than English, French or German, the
translation of the copyright notice in the language of the publication
shall be used.

If you intend to use the data commercially, please contact
EuroGeographics for information regarding their licence agreements."

## See also

[`giscoR::gisco_get_nuts()`](https://ropengov.github.io/giscoR/reference/gisco_get_nuts.html)

Other geospatial:
[`eurostat_geodata_60_2016`](https://ropengov.github.io/eurostat/reference/eurostat_geodata_60_2016.md)

## Author

Markus Kainu <markuskainu@gmail.com>, Diego Hernangomez
<https://github.com/dieghernan/>

## Examples

``` r
# \donttest{
# Uses cached dataset
sf <- get_eurostat_geospatial(
  output_class = "sf",
  resolution = "60",
  nuts_level = "all"
)
#> Extracting data from eurostat::eurostat_geodata_60_2016
# Downloads dataset from server
sf2 <- get_eurostat_geospatial(
  output_class = "sf",
  resolution = "20",
  nuts_level = "all"
)
#> Extracting data using giscoR package, please report issues on https://github.com/rOpenGov/giscoR/issues
#> Cache management as per giscoR. see 'giscoR::gisco_get_nuts()'
df <- get_eurostat_geospatial(
  output_class = "df",
  nuts_level = "0"
)
#> Extracting data from eurostat::eurostat_geodata_60_2016
# }
```
