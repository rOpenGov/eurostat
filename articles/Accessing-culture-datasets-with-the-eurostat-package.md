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
#> Table lfsq_egan22d cached at /tmp/RtmpX6lvNn/eurostat/a7cc98a77ed9b8860c46c52ce27281a9.rds
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
#> Table sbs_na_1a_se_r2 cached at /tmp/RtmpX6lvNn/eurostat/6a36e2f2ab8fdf612aadf86c3e62805c.rds
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
#> Table sbs_na_ind_r2 cached at /tmp/RtmpX6lvNn/eurostat/064e207ea0ffa273582867d219103210.rds
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
#> Reading cache file /tmp/RtmpX6lvNn/eurostat/a7cc98a77ed9b8860c46c52ce27281a9.rds
#> Table  lfsq_egan22d  read from cache file:  /tmp/RtmpX6lvNn/eurostat/a7cc98a77ed9b8860c46c52ce27281a9.rds
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
#> Table ext_lt_intertrd cached at /tmp/RtmpX6lvNn/eurostat/c14dc38152ae6603d5242bf0aa0918a2.rds
stats_label <- label_eurostat(stats, code = "sitc06")
```

``` r

# C322: Manufacture of musical instruments
stats <- get_eurostat("ext_tec09", filters = list(nace_r2 = "C322"))
#> Table ext_tec09 cached at /tmp/RtmpX6lvNn/eurostat/22b1e376cdc32008cf56bc904c2fcc3a.rds
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
#> Reading cache file /tmp/RtmpX6lvNn/eurostat/6a36e2f2ab8fdf612aadf86c3e62805c.rds
#> Table  sbs_na_1a_se_r2  read from cache file:  /tmp/RtmpX6lvNn/eurostat/6a36e2f2ab8fdf612aadf86c3e62805c.rds
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
#> Reading cache file /tmp/RtmpX6lvNn/eurostat/064e207ea0ffa273582867d219103210.rds
#> Table  sbs_na_ind_r2  read from cache file:  /tmp/RtmpX6lvNn/eurostat/064e207ea0ffa273582867d219103210.rds
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
#> R version 4.6.1 (2026-06-24)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.5 LTS
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
#> [1] eurostat_4.1.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] xfun_0.60           bslib_0.12.0        httr2_1.3.0        
#>  [4] htmlwidgets_1.6.4   tzdb_0.5.0          vctrs_0.7.3        
#>  [7] tools_4.6.1         ISOweek_0.6-2       generics_0.1.4     
#> [10] curl_8.0.0          parallel_4.6.1      tibble_3.3.1       
#> [13] proxy_0.4-29        pkgconfig_2.0.3     R.oo_1.27.1        
#> [16] KernSmooth_2.23-26  data.table_1.18.6.1 desc_1.4.3         
#> [19] readxl_1.5.0        assertthat_0.2.1    lifecycle_1.0.5    
#> [22] compiler_4.6.1      stringr_1.6.0       textshaping_1.0.5  
#> [25] htmltools_0.5.9     class_7.3-23        sass_0.4.10        
#> [28] yaml_2.3.12         pillar_1.11.1       pkgdown_2.2.1      
#> [31] crayon_1.5.3        jquerylib_0.1.4     tidyr_1.3.2        
#> [34] regions_0.1.8       R.utils_2.13.0      classInt_0.4-11    
#> [37] cachem_1.1.0        countrycode_1.9.0   tidyselect_1.2.1   
#> [40] digest_0.6.39       stringi_1.8.9       dplyr_1.2.1        
#> [43] purrr_1.2.2         rprojroot_2.1.1     fastmap_1.2.0      
#> [46] here_1.0.2          cli_3.6.6           magrittr_2.0.5     
#> [49] utf8_1.2.6          e1071_1.7-17        withr_3.0.3        
#> [52] readr_2.2.0         bit64_4.8.6         lubridate_1.9.5    
#> [55] timechange_0.4.0    rmarkdown_2.32      bit_4.6.0          
#> [58] otel_0.2.0          cellranger_1.1.0    ragg_1.5.2         
#> [61] R.methodsS3_1.8.2   hms_1.1.4           evaluate_1.0.5     
#> [64] knitr_1.52          rlang_1.3.0         glue_1.8.1         
#> [67] xml2_1.6.0          vroom_1.7.1         jsonlite_2.0.0     
#> [70] R6_2.6.1            systemfonts_1.3.2   fs_2.1.0
```
