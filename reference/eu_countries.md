# Countries and Country Codes

Countries and country codes in EU, Euro area, EFTA and EU candidate
countries.

## Usage

``` r
eu_countries

ea_countries

efta_countries

eu_candidate_countries
```

## Format

A data_frame:

- **code**: Country code in the Eurostat database (two-letter ISO code
  (ISO 3166 alpha-2) except in the case of Greece where EL is used).

- **name**: Country name in English.

- **label**: Country name in the Eurostat database

- **name_fr**: Country name in French

- **name_de**: Country name in German

- **country_language**: Country name in national language(s).

An object of class `data.frame` with 20 rows and 6 columns.

An object of class `data.frame` with 4 rows and 6 columns.

An object of class `data.frame` with 9 rows and 6 columns.

## Source

<https://ec.europa.eu/eurostat/statistics-explained/index.php/Tutorial:Country_codes_and_protocol_order>,
<https://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Euro_area>

## Details

Country codes are two-letter ISO codes (ISO 3166 alpha-2) except in the
case of Greece where EL is used instead of the standard ISO code.

## See also

Other datasets:
[`eurostat_geodata_60_2024`](https://ropengov.github.io/eurostat/reference/eurostat_geodata_60_2024.md),
[`tgs00026`](https://ropengov.github.io/eurostat/reference/tgs00026.md)
