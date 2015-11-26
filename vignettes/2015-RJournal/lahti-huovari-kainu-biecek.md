---
title: "eurostat R package"
author: Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek
date: "2015-11-25"
bibliography: 
- references.bib
output: 
  md_document:
    variant: markdown_github
---
<!--
%\VignetteEngine{knitr::rmarkdown}
%\VignetteIndexEntry{eurostat Markdown Vignette}
%\usepackage[utf8]{inputenc}
-->



Installing the CRAN release version:



Installing the Github development version:




```
## Warning in file(file, "rt"): unable to resolve 'ec.europa.eu'
```

```
## Error in file(file, "rt"): cannot open the connection
```


```
## Warning in download.file(url, tfile): unable to resolve 'ec.europa.eu'
```

```
## Error in download.file(url, tfile): cannot open URL 'http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2Ftsdtr210.tsv.gz'
```


```
## % latex table generated in R 3.2.2 by xtable 1.8-0 package
## % Wed Nov 25 23:28:14 2015
## \begin{table}[ht]
## \centering
## \begin{tabular}{rll}
##   \hline
##  & NUTS\_ID & VarX \\ 
##   \hline
## 1 & AT11 &  \\ 
##   2 & AT12 &  \\ 
##   3 & AT13 &  \\ 
##   4 & AT21 &  \\ 
##   5 & AT22 &  \\ 
##   6 & AT31 &  \\ 
##    \hline
## \end{tabular}
## \caption{This is a table.} 
## \label{tab:getdatatable}
## \end{table}
```



```
## Warning in download.file(url, tfile): unable to resolve 'ec.europa.eu'
```

```
## Error in download.file(url, tfile): cannot open URL 'http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2Ftgs00026.tsv.gz'
```

```
## Error in df$time: object of type 'closure' is not subsettable
```

```
## Error in df$time: object of type 'closure' is not subsettable
```

```
## Error: Key column 'time' does not exist in input.
```

```
## Warning in download.file("http://ec.europa.eu/eurostat/cache/GISCO/
## geodatafiles/NUTS_2010_60M_SH.zip", : unable to resolve 'ec.europa.eu'
```

```
## Error in download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2010_60M_SH.zip", : cannot open URL 'http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2010_60M_SH.zip'
```

```
## Warning in unzip("NUTS_2010_60M_SH.zip"): error 1 in extracting from zip
## file
```

```
## Error in merge(dat, dw, by.x = "NUTS_ID", by.y = "geo", all.x = TRUE): error in evaluating the argument 'y' in selecting a method for function 'merge': Error: object 'dw' not found
```

```
## Error in eval(expr, envir, enclos): object 'dat2' not found
```

```
## Error in eval(expr, envir, enclos): object 'dat2' not found
```

```
## Error in dat2$NUTS_ID <- NULL: object 'dat2' not found
```

```
## Error in spCbind(map_nuts2, dat2): error in evaluating the argument 'x' in selecting a method for function 'spCbind': Error: object 'dat2' not found
```

```
## Error in rownames(shape@data): object 'shape' not found
```

```
## Error in fortify(shape, region = "id"): object 'shape' not found
```

```
## Error in merge(map.points, shape, by = "id"): error in evaluating the argument 'x' in selecting a method for function 'merge': Error: object 'map.points' not found
```

```
## Error in eval(expr, envir, enclos): object 'map.df' not found
```

```
## Error in setNames(as.list(seq_along(vars)), vars): object 'map.df' not found
```

```
## Error in stri_replace_all_regex(string, pattern, replacement, vectorize_all = vec, : object 'map.df.l' not found
```

```
## Error in factor(map.df.l$year): object 'map.df.l' not found
```

```
## Error in levels(map.df.l$year): object 'map.df.l' not found
```

```
## Error in unique(map.df.l$year): object 'map.df.l' not found
```

```
## Error in eval(expr, envir, enclos): object 'years' not found
```

```
## Error in print(p): object 'p' not found
```


```
## Warning in file(file, "rt"): unable to resolve 'ec.europa.eu'
```

```
## Error in file(file, "rt"): cannot open the connection
```

```
## Error in paste0(id, "_", time_format, "_", select_time, "_", stringsAsFactors, : cannot coerce type 'closure' to vector of type 'character'
```

```
## Error in time == 2012: comparison (1) is possible only for atomic and list types
```

```
## Error in na.omit(transports): object 'transports' not found
```


```
## % latex table generated in R 3.2.2 by xtable 1.8-0 package
## % Wed Nov 25 23:28:15 2015
## \begin{table}[ht]
## \centering
## \begin{tabular}{rll}
##   \hline
##  & code & name \\ 
##   \hline
## 1 & IS & Iceland \\ 
##   2 & LI & Liechtenstein \\ 
##   3 & NO & Norway \\ 
##   4 & CH & Switzerland \\ 
##    \hline
## \end{tabular}
## \end{table}
```


```
## Warning in download.file(url, tfile): unable to resolve 'ec.europa.eu'
```

```
## Error in download.file(url, tfile): cannot open URL 'http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2Ftsdtr420.tsv.gz'
```

```
## Error in eval(expr, envir, enclos): object 't1' not found
```

```
## Error in ggplot(t1, aes(x = time, y = values, color = Country, group = Country, : object 't1' not found
```



```
## Warning in download.file(url, tfile): unable to resolve 'ec.europa.eu'
```

```
## Error in download.file(url, tfile): cannot open URL 'http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&file=data%2Fhlth_ehis_de1.tsv.gz'
```

```
## Error in eval(expr, envir, enclos): object 'tmp1' not found
```

