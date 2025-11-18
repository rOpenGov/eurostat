# Get all datasets in a folder

Loops over all files in a Eurostat database folder, downloads the data
and assigns the datasets to environment.

## Usage

``` r
get_eurostat_folder(code, env = .EurostatEnv)
```

## Arguments

- code:

  Folder code from Eurostat Table of Contents.

- env:

  Name of the environment where downloaded datasets are assigned.
  Default is .EurostatEnv. If NULL, datasets are returned as a list
  object.

## Details

The datasets are assigned into .EurostatEnv by default, using dataset
codes as object names. The datasets are downloaded from SDMX API as TSV
files, meaning that they are returned without filtering. No filters can
be provided using this function.

Please do not attempt to download too many datasets or the whole
database at once. The number of datasets that can be downloaded at once
is hardcoded to 20. The function also asks the user for confirmation if
the number of datasets in a folder is more than 10. This is by design to
discourage straining Eurostat API.

## Data source: Eurostat Table of Contents

The Eurostat Table of Contents (TOC) is downloaded from
<https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=en>
(default) or from French or German language variants:
<https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=fr>
<https://ec.europa.eu/eurostat/api/dissemination/catalogue/toc/txt?lang=de>

See Eurostat documentation on TOC items:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+-+Detailed+guidelines+-+Catalogue+API+-+TOC>

## Data source: Eurostat SDMX 2.1 Dissemination API

Data is downloaded from Eurostat SDMX 2.1 API endpoint as compressed TSV
files that are transformed into tabular format. See Eurostat
documentation for more information:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/API+SDMX+2.1+-+data+query>

The new dissemination API replaces the old bulk download facility that
was used by Eurostat before October 2023 and by the eurostat R package
versions before 4.0.0. See Eurostat documentation about the transition
from Bulk Download to API for more information about the differences
between the old bulk download facility and the data provided by the new
API connection:
<https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API>

See especially the document Migrating_to_API_TSV.pdf that describes the
changes in TSV file format in new applications.

For more information about SDMX 2.1, see SDMX standards: Section 7:
Guidelines for the use of web services, Version 2.1:
<https://sdmx.org/wp-content/uploads/SDMX_2-1_SECTION_7_WebServicesGuidelines.pdf>

## See also

[`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md)
[`toc_count_children()`](https://ropengov.github.io/eurostat/reference/toc_count_children.md)
[`toc_determine_hierarchy()`](https://ropengov.github.io/eurostat/reference/toc_determine_hierarchy.md)
[`toc_list_children()`](https://ropengov.github.io/eurostat/reference/toc_list_children.md)
[`toc_count_whitespace()`](https://ropengov.github.io/eurostat/reference/toc_count_whitespace.md)

## Author

Pyry Kantanen
