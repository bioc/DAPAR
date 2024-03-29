% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metacell.R
\name{Metacell_maxquant}
\alias{Metacell_maxquant}
\title{Sets the metacell dataframe}
\usage{
Metacell_maxquant(qdata, conds, df, level = NULL)
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
Initial conversion rules for maxquant
|------------|-----------------------|--------|
| Quanti     |     Identification    |    Tag |
|------------|-----------------------|--------|
|  == 0      |       whatever        |    2.0 |
|  > 0       |       'By MS/MS'      |    1.1 |
|  > 0       |      'By matching'    |    1.2 |
|  > 0       |       unknown col     |    1.0 |
|------------|-----------------------|--------|
}
\examples{
file <- system.file("extdata", "Exp1_R25_pept.txt", package = "DAPARdata")
data <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
metadataFile <- system.file("extdata", "samples_Exp1_R25.txt",
    package = "DAPARdata"
)
metadata <- read.table(metadataFile,
    header = TRUE, sep = "\t", as.is = TRUE,
    stringsAsFactors = FALSE
)
conds <- metadata$Condition
qdata <- data[seq_len(10), seq.int(from = 56, to = 61)]
df <- data[seq_len(10), seq.int(from = 43, to = 48)]
df2 <- Metacell_maxquant(qdata, conds, df, level = "peptide")

}
\author{
Samuel Wieczorek
}
