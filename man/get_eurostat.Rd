\name{get_eurostat}
\alias{get_eurostat}
\title{Get PC Axis data with custom preprocessing for PC Axis
files from Statistics Finland (Tilastokeskus) http://www.stat.fi/}
\usage{
get_eurostat(url, format = "px", verbose = TRUE)
}
\arguments{
  \item{url}{or local file name of the Eurostat file}

  \item{format}{One of the following: "px", "csv", "xml".
  Specifies the desired format of the source file.}

  \item{verbose}{verbose}
}
\value{
data.frame
}
\description{
Get PC Axis data with custom preprocessing for PC Axis
files from Statistics Finland (Tilastokeskus)
http://www.stat.fi/
}
\details{
If the reading of PX file fails, CSV is used instead.
}
\examples{
\dontrun{px <- get_eurostat(url)}
}
\author{
Leo Lahti \email{louhos@googlegroups.com}
}
\references{
See citation("eurostat")
}
\keyword{utilities}

