# Count white space at the start of the title

Counts the number of white space characters at the start of the string.

## Usage

``` r
toc_count_whitespace(input_string)
```

## Arguments

- input_string:

  A string containing Eurostat TOC titles

## Value

Numeric (number of white space characters)

## Details

Used in toc_determine_hierarchy function to determine hierarchy.
Hierarchy is defined in Eurostat .txt format TOC files by the number of
white space characters at intervals of four. For example, " Foo" (4
white space characters) is one level higher than " Bar" (8 white space
characters). "Database by themes" (0 white space characters before the
first alphanumeric character) is highest in the hierarchy.

The function will return a warning if the input has white space in
anything else than as increments of 4. 0, 4, 8... are acceptable but 3,
6, 10... are not.

## See also

[`get_eurostat_toc()`](https://ropengov.github.io/eurostat/reference/get_eurostat_toc.md)
[`toc_count_children()`](https://ropengov.github.io/eurostat/reference/toc_count_children.md)
[`toc_determine_hierarchy()`](https://ropengov.github.io/eurostat/reference/toc_determine_hierarchy.md)
[`toc_list_children()`](https://ropengov.github.io/eurostat/reference/toc_list_children.md)
`toc_count_whitespace()`

## Author

Pyry Kantanen

## Examples

``` r
strings <- c("    abc", "  cdf", "no_spaces")
for (string in strings) {
 whitespace_count <- eurostat:::toc_count_whitespace(string)
 cat("String:", string, "\tWhitespace Count:", whitespace_count, "\n")
}
#> String:     abc  Whitespace Count: 4 
#> String:   cdf    Whitespace Count: 2 
#> String: no_spaces    Whitespace Count: 0 
```
