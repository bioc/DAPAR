% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metacell.R
\name{Metacell_proline}
\alias{Metacell_proline}
\title{Sets the metacell dataframe for datasets which are from Proline software}
\usage{
Metacell_proline(qdata, conds, df, level = NULL)
}
\arguments{
\item{qdata}{An object of class \code{MSnSet}}

\item{conds}{xxx}

\item{df}{A list of integer xxxxxxx}

\item{level}{xxx}
}
\value{
xxxxx
}
\description{
In the quantitative columns, a missing value is identified by no value rather
than a value equal to 0.

In these datasets, the metacell info is computed from the 'PSM count' columns.

Conversion rules
Initial conversion rules for proline
|--------------|-----------------|-----|
| Quanti       |    PSM count    | Tag |
|--------------|-----------------|-----|
|  == 0 | N.A. |   whatever      | 2.0 |
|  > 0         |    > 0          | 1.1 |
|  > 0         |    == 0         | 1.2 |
|  > 0         |   unknown col   | 1.0 |
|--------------|-----------------|-----|
}
\examples{
file <- system.file("extdata", "Exp1_R25_pept.txt", package = "DAPARdata")
data <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
metadataFile <- system.file("extdata", "samples_Exp1_R25.txt", package = "DAPARdata")
metadata <- read.table(metadataFile, header = TRUE, sep = "\t", as.is = TRUE, stringsAsFactors = FALSE)
conds <- metadata$Condition
qdata <- data[seq_len(100), seq.int(from = 56, to = 61)]
df <- data[seq_len(100), seq.int(from = 43, to = 48)]
df <- Metacell_proline(qdata, conds, df, level = "peptide")


}
\author{
Samuel Wieczorek
}
