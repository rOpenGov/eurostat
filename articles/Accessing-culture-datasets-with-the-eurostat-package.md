# Accessing culture datasets with the eurostat package

## Introduction

The eurostat package can be used to access datasets related to various
facets of life. Datasets belonging to the culture sector are scattered
across different database tables. Eurostat has collected datasets
related to the cultural sector, for example datasets that are related to
culture, music, and literature, in a special section in their website:
<https://ec.europa.eu/eurostat/web/culture/database/data-domain>.

Downloading these datasets manually is demonstrated in this article.

## Loading the eurostat R package

``` r
library(eurostat)
```

## Dataset examples

### EU Labour Force Survey (EU-LFS)

Download like this:

``` r
# J59: Motion picture, video and television programme production, 
# sound recording and music publishing activities
# R90: Creative, arts and entertainment activities
# R91: Libraries, archives, museums and other cultural activities

stats <- get_eurostat(
  "lfsq_egan22d",
  filters = 
    list(
      nace_r2 = c("R90", "R91", "J59")
      )
  )
#> Table lfsq_egan22d cached at /tmp/RtmpviRApf/eurostat/0ea3de3a5dc3085eb07abadf56568c89.rds
stats_label <- label_eurostat(stats, code = "nace_r2")
```

Quick glance at dataset:

``` r
head(stats)
#> # A tibble: 6 × 8
#>   freq  unit    age    sex   nace_r2 geo       time       values
#>   <chr> <chr>   <chr>  <chr> <chr>   <chr>     <date>      <dbl>
#> 1 Q     THS_PER Y15-24 T     J59     EU27_2020 2008-01-01   48.1
#> 2 Q     THS_PER Y15-24 T     J59     EU27_2020 2008-04-01   NA  
#> 3 Q     THS_PER Y15-24 T     J59     EU27_2020 2008-07-01   36.7
#> 4 Q     THS_PER Y15-24 T     J59     EU27_2020 2008-10-01   37  
#> 5 Q     THS_PER Y15-24 T     J59     EU27_2020 2009-01-01   50  
#> 6 Q     THS_PER Y15-24 T     J59     EU27_2020 2009-04-01   45.8
```

Quick glance at labeled dataset:

``` r
head(stats_label)
#> # A tibble: 6 × 9
#>   nace_r2_code freq      unit        age   sex   nace_r2 geo   time       values
#>   <chr>        <chr>     <chr>       <chr> <chr> <chr>   <chr> <date>      <dbl>
#> 1 J59          Quarterly Thousand p… From… Total Motion… Euro… 2008-01-01   48.1
#> 2 J59          Quarterly Thousand p… From… Total Motion… Euro… 2008-04-01   NA  
#> 3 J59          Quarterly Thousand p… From… Total Motion… Euro… 2008-07-01   36.7
#> 4 J59          Quarterly Thousand p… From… Total Motion… Euro… 2008-10-01   37  
#> 5 J59          Quarterly Thousand p… From… Total Motion… Euro… 2009-01-01   50  
#> 6 J59          Quarterly Thousand p… From… Total Motion… Euro… 2009-04-01   45.8
```

Variable names:

``` r
label_eurostat_vars(names(stats), id = "lfsq_egan22d")
#> [1] "Time frequency"                                                                           
#> [2] "Unit of measure"                                                                          
#> [3] "Age class"                                                                                
#> [4] "Sex"                                                                                      
#> [5] "Statistical classification of economic activities in the European Community (NACE Rev. 2)"
#> [6] "Geopolitical entity (reporting)"
```

### Structured business statistics (SBS)

First we must ask the question: What are music-related goods and
services in the vast sea of structured business statistics? From the
[Eurostat
website](https://ec.europa.eu/eurostat/web/culture/database/data-domain#Business%20statistics)
documentation:

> “No data collection specifically on music exists. The various EU
> harmonised surveys and data collections include only a few items of
> information on the topic.
>
> A difficulty with those is that statistical classifications and
> variables often do not differentiate music from other cultural
> activities in broader categories, such as live performances, or
> artistic creation.”

Two concrete examples are given: Sound recording and music publishing
activities (NACE code 59.2) and Manufacture of musical instruments (NACE
code 32.2).

#### Sound recording and music publishing activities (NACE code 59.2)

``` r
# J592: Sound recording and music publishing activities
music_business1 <- get_eurostat(
  id = "sbs_na_1a_se_r2",
  filters = 
    list(
      indic_sb = c("V11110", "V12110", "V12120", 
                   "V12150", "12170"), 
      nace_r2 = c("J592")
      )
  )
#> Table sbs_na_1a_se_r2 cached at /tmp/RtmpviRApf/eurostat/6ffac09dd81503e6fbc67e8d77e04e14.rds
head(music_business1)
#> # A tibble: 6 × 6
#>   freq  nace_r2 indic_sb geo       time       values
#>   <chr> <chr>   <chr>    <chr>     <date>      <dbl>
#> 1 A     J592    V11110   EU27_2020 2005-01-01     NA
#> 2 A     J592    V11110   EU27_2020 2006-01-01     NA
#> 3 A     J592    V11110   EU27_2020 2007-01-01     NA
#> 4 A     J592    V11110   EU27_2020 2008-01-01     NA
#> 5 A     J592    V11110   EU27_2020 2009-01-01     NA
#> 6 A     J592    V11110   EU27_2020 2010-01-01     NA
```

#### Manufacture of musical instruments (NACE code 32.2)

``` r
music_business2 <- get_eurostat(
  id = "sbs_na_ind_r2",
  filters = 
    list(
      indic_sb = c("V11110", "V12110", "V12120",
                   "V12130", "12150"), 
      nace_r2 = c("C322")
      )
  )
#> Table sbs_na_ind_r2 cached at /tmp/RtmpviRApf/eurostat/020fd07b3be54c0fc3de7e5faab89b93.rds
head(music_business2)
#> # A tibble: 6 × 6
#>   freq  nace_r2 indic_sb geo       time       values
#>   <chr> <chr>   <chr>    <chr>     <date>      <dbl>
#> 1 A     C322    V11110   EU27_2020 2005-01-01     NA
#> 2 A     C322    V11110   EU27_2020 2006-01-01     NA
#> 3 A     C322    V11110   EU27_2020 2007-01-01     NA
#> 4 A     C322    V11110   EU27_2020 2008-01-01     NA
#> 5 A     C322    V11110   EU27_2020 2009-01-01     NA
#> 6 A     C322    V11110   EU27_2020 2010-01-01     NA
# Or
# music_business2 <- get_eurostat(
#   id = "sbs_na_ind_r2",
#   filters = list(
#     indic_sb = c("V11110", "V12110", "V12120", 
#                  "V12130", "12150"), 
#     nace_r2 = c("C3220")
#     )
#   )
```

#### Music-related goods production

Also, database on the production of various goods contains information
about production of music-related goods, such as instruments and
recorded media.

The code to download the dataset:

``` r
stats <- get_eurostat("lfsq_egan22d", 
                      filters = 
                        list(nace_r2 = c("R90", "R91", "J59")))
#> Dataset query already saved in cache_list.json...
#> Reading cache file /tmp/RtmpviRApf/eurostat/0ea3de3a5dc3085eb07abadf56568c89.rds
#> Table  lfsq_egan22d  read from cache file:  /tmp/RtmpviRApf/eurostat/0ea3de3a5dc3085eb07abadf56568c89.rds
stats_label <- label_eurostat(stats, code = "nace_r2")
```

### International trade in goods statistics (ITGS) (OM_dataset_sec_eurostat_003)

What, then, are these specified music-related goods? From [Eurostat
website](https://ec.europa.eu/eurostat/web/culture/database/data-domain#International%20trade):

> “The domain of international trade in goods includes annual data on
> trade of musical instruments and parts of thereof.
>
> Since 2017, data on recorded media containing only music have not been
> collected as a separate category. In statistics on international trade
> in services, music items are included in the existing categories:
>
> - audio-visual services
> - artistic services
> - licences”

(Source:
<https://ec.europa.eu/eurostat/web/culture/database/data-domain#International%20trade>)

Download:

``` r
stats <- get_eurostat("ext_lt_intertrd")
#> Table ext_lt_intertrd cached at /tmp/RtmpviRApf/eurostat/90c956a4066eb21ec7b021b78434e0ad.rds
stats_label <- label_eurostat(stats, code = "sitc06")
```

``` r
# C322: Manufacture of musical instruments
stats <- get_eurostat("ext_tec09", filters = list(nace_r2 = "C322"))
#> Table ext_tec09 cached at /tmp/RtmpviRApf/eurostat/89f444e610fef6f1a883b484041bf9cc.rds
```

### Data by domain: Culture

#### Music

Original information can be found here:
<https://ec.europa.eu/eurostat/web/culture/database/data-domain>

#### Employment

There is an Excel file that contains the number of persons employed as
musicians, singers and composers (ISCO code 2652, main job) in years
2019-2021.

2 NACE codes could be used to collect data from EU labour force survey
(EU-LFS) statistics:

- sound recording and music publishing activities (59.2)
- manufacture of musical instruments (32.2)

### Business statistics

#### Sound recording and music publishing activities (NACE code 59.2)

``` r
music_business1 <- get_eurostat(
  id = "sbs_na_1a_se_r2", 
  filters = 
    list(
      indic_sb = c("V11110", "V12110", "V12120", 
                   "V12150", "12170"), 
      nace_r2 = c("J592")
      )
  )
#> Dataset query already saved in cache_list.json...
#> Reading cache file /tmp/RtmpviRApf/eurostat/6ffac09dd81503e6fbc67e8d77e04e14.rds
#> Table  sbs_na_1a_se_r2  read from cache file:  /tmp/RtmpviRApf/eurostat/6ffac09dd81503e6fbc67e8d77e04e14.rds
head(music_business1)
#> # A tibble: 6 × 6
#>   freq  nace_r2 indic_sb geo       time       values
#>   <chr> <chr>   <chr>    <chr>     <date>      <dbl>
#> 1 A     J592    V11110   EU27_2020 2005-01-01     NA
#> 2 A     J592    V11110   EU27_2020 2006-01-01     NA
#> 3 A     J592    V11110   EU27_2020 2007-01-01     NA
#> 4 A     J592    V11110   EU27_2020 2008-01-01     NA
#> 5 A     J592    V11110   EU27_2020 2009-01-01     NA
#> 6 A     J592    V11110   EU27_2020 2010-01-01     NA
```

#### Manufacture of musical instruments

``` r
music_business2 <- get_eurostat(
  id = "sbs_na_ind_r2", 
  filters = 
    list(
      indic_sb = c("V11110", "V12110", "V12120", 
                   "V12130", "12150"), 
      nace_r2 = c("C322")
      )
  )
#> Dataset query already saved in cache_list.json...
#> Reading cache file /tmp/RtmpviRApf/eurostat/020fd07b3be54c0fc3de7e5faab89b93.rds
#> Table  sbs_na_ind_r2  read from cache file:  /tmp/RtmpviRApf/eurostat/020fd07b3be54c0fc3de7e5faab89b93.rds
head(music_business2)
#> # A tibble: 6 × 6
#>   freq  nace_r2 indic_sb geo       time       values
#>   <chr> <chr>   <chr>    <chr>     <date>      <dbl>
#> 1 A     C322    V11110   EU27_2020 2005-01-01     NA
#> 2 A     C322    V11110   EU27_2020 2006-01-01     NA
#> 3 A     C322    V11110   EU27_2020 2007-01-01     NA
#> 4 A     C322    V11110   EU27_2020 2008-01-01     NA
#> 5 A     C322    V11110   EU27_2020 2009-01-01     NA
#> 6 A     C322    V11110   EU27_2020 2010-01-01     NA
# Or
# music_business2 <- get_eurostat(
#   id = "sbs_na_ind_r2",
#   filters = list(
#     indic_sb = c("V11110", "V12110", "V12120", 
#                  "V12130", "12150"),
#     nace_r2 = c("C3220")
#     )
#   )
```

#### Music-related goods production

Downloading PRODCOM data is is done via different route than the usual
datasets and the functionality is currently experimental. The logic of
the functions, however, is identical to the currently existing
functions. Here is a non-functional example of how the workflow should
look:

``` r
remotes::install_github("ropengov/eurostat", ref = "v4.1")
```

``` r
prodcom <- get_eurostat_sdmx(
  id = "DS-059359",
  compressed = FALSE, 
  agency = "eurostat_comext",
  filters = 
    list(
      FREQ = c("A"),
      product = c("18121920", "18201010", "18201030", 
                  "18201050", "18201070", "18202050", 
                  "18202070", "32201110", "32201130", 
                  "32201150", "32201200", "32201310", 
                  "32201340", "32201370", "32201400", 
                  "32201510", "32201530", "32201600", 
                  "32202000"),
      DECL = c("001", "003", "004", "005", "006", 
               "007", "008", "009", "010", "011", 
               "017", "018", "024", "028", "030", 
               "032", "038", "046", "052", "053", 
               "054", "055", "060", "061", "063", 
               "064", "066", "068", "091", "092", 
               "093", "096", "097", "098", "2027", 
               "600"),
      INDICATORS = c("PRODVAL"),
      PRCCODE = c("18121920", "18201010", "18201030", 
                  "18201050", "18201070", "18202050", 
                  "18202070", "32201110", "32201130", 
                  "32201150", "32201200", "32201310", 
                  "32201340", "32201370", "32201400", 
                  "32201510", "32201530", "32201600", 
                  "32202000")))

prodcom_labeled <- label_eurostat_sdmx(
  x,
  agency = "eurostat_comext",
  id = "DS-056120"
  )
```

The URL to this custom dataset:
<https://ec.europa.eu/eurostat/databrowser/view/DS-056120__custom_4088056/bookmark/table?lang=en&bookmarkId=a25712df-96d0-445a-95d6-4b807e83be43>

## Session info

``` r
sessionInfo()
#> R version 4.5.2 (2025-10-31)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] eurostat_4.0.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] xfun_0.56           bslib_0.10.0        httr2_1.2.2        
#>  [4] htmlwidgets_1.6.4   tzdb_0.5.0          vctrs_0.7.1        
#>  [7] tools_4.5.2         ISOweek_0.6-2       generics_0.1.4     
#> [10] curl_7.0.0          parallel_4.5.2      tibble_3.3.1       
#> [13] proxy_0.4-29        RefManageR_1.4.0    pkgconfig_2.0.3    
#> [16] KernSmooth_2.23-26  data.table_1.18.2.1 desc_1.4.3         
#> [19] readxl_1.4.5        assertthat_0.2.1    lifecycle_1.0.5    
#> [22] compiler_4.5.2      stringr_1.6.0       textshaping_1.0.5  
#> [25] htmltools_0.5.9     class_7.3-23        sass_0.4.10        
#> [28] yaml_2.3.12         pillar_1.11.1       pkgdown_2.2.0      
#> [31] crayon_1.5.3        jquerylib_0.1.4     tidyr_1.3.2        
#> [34] regions_0.1.8       classInt_0.4-11     cachem_1.1.0       
#> [37] countrycode_1.7.0   tidyselect_1.2.1    digest_0.6.39      
#> [40] stringi_1.8.7       dplyr_1.2.0         purrr_1.2.1        
#> [43] bibtex_0.5.2        rprojroot_2.1.1     fastmap_1.2.0      
#> [46] here_1.0.2          cli_3.6.5           magrittr_2.0.4     
#> [49] utf8_1.2.6          e1071_1.7-17        withr_3.0.2        
#> [52] readr_2.2.0         backports_1.5.0     rappdirs_0.3.4     
#> [55] bit64_4.6.0-1       lubridate_1.9.5     timechange_0.4.0   
#> [58] rmarkdown_2.30      httr_1.4.8          bit_4.6.0          
#> [61] otel_0.2.0          cellranger_1.1.0    ragg_1.5.1         
#> [64] hms_1.1.4           evaluate_1.0.5      knitr_1.51         
#> [67] rlang_1.1.7         Rcpp_1.1.1          glue_1.8.0         
#> [70] xml2_1.5.2          vroom_1.7.0         jsonlite_2.0.0     
#> [73] R6_2.6.1            plyr_1.8.9          systemfonts_1.3.2  
#> [76] fs_1.6.7
```
