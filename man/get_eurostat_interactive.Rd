% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_eurostat.R
\name{get_eurostat_interactive}
\alias{get_eurostat_interactive}
\title{Get Eurostat data interactive}
\usage{
get_eurostat_interactive(code = NULL)
}
\arguments{
\item{code}{A unique identifier / code for the dataset of interest. If code is not
known \code{\link[=search_eurostat]{search_eurostat()}} function can be used to search Eurostat table
of contents.}
}
\description{
A simple interactive helper function to go through the steps of downloading
and/or finding suitable eurostat datasets.
}
\details{
This function is intended to enable easy exploration of different eurostat
package functionalities and functions. In order to not drown the end user
in endless menus this function does not allow for setting
all possible \code{\link[=get_eurostat]{get_eurostat()}} function arguments. It is possible to set
\code{time_format}, \code{type}, \code{lang}, \code{stringsAsFactors}, \code{keepFlags}, and
\code{use.data.table} in the interactive menus.

In some datasets setting these parameters may result in a
"Error in label_eurostat" error, for example:
"labels for XXXXXX includes duplicated labels in the Eurostat dictionary".
In these cases, and with other more complex queries, please
use \code{\link[=get_eurostat]{get_eurostat()}} function directly.
}
\seealso{
\code{\link[=get_eurostat]{get_eurostat()}}
}
