% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/missingValuesFilter.R
\name{GetIndices_MetacellFiltering}
\alias{GetIndices_MetacellFiltering}
\title{Delete the lines in the matrix of intensities and the metadata table
given their indice.}
\usage{
GetIndices_MetacellFiltering(
  obj,
  level,
  pattern = NULL,
  type = NULL,
  percent,
  op,
  th
)
}
\arguments{
\item{obj}{An object of class \code{MSnSet} containing
quantitative data.}

\item{level}{A vector of integers which are the indices of lines to
delete.}

\item{pattern}{A string to be included in the \code{MSnSet}
object for log.}

\item{type}{xxx}

\item{percent}{xxx}

\item{op}{xxx}

\item{th}{xxx}
}
\value{
An instance of class \code{MSnSet} that have been filtered.
}
\description{
Delete the lines in the matrix of intensities and the metadata table
given their indice.
}
\examples{
data(Exp1_R25_pept, package="DAPARdata")
obj <- Exp1_R25_pept[seq_len(10)]
level <- GetTypeofData(obj)
pattern <- c("Missing", "Missing POV")
type <- "AtLeastOneCond"
percent <- FALSE
op <- ">="
th <- 1
indices <- GetIndices_MetacellFiltering(obj, level, pattern, type, percent, op, th)



pattern <- "Quantified"
type <- "AtLeastOneCond"
percent <- FALSE
op <- ">="
th <- 4
indices2.1 <- GetIndices_MetacellFiltering(obj, level, pattern, type, percent, op, th)

pattern <- "Quant. by direct id"
type <- "AtLeastOneCond"
percent <- FALSE
op <- ">="
th <- 3
indices2.2 <- GetIndices_MetacellFiltering(obj, level, pattern, type, percent, op, th)
}
\author{
Samuel Wieczorek
}
