% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalize.R
\name{MeanCentering}
\alias{MeanCentering}
\title{Normalisation MeanCentering}
\usage{
MeanCentering(
  qData,
  conds,
  type = "overall",
  subset.norm = NULL,
  scaling = FALSE
)
}
\arguments{
\item{qData}{xxx}

\item{conds}{xxx}

\item{type}{"overall" (shift all the sample distributions at once) or
"within conditions" (shift the sample distributions within each
condition at a time).}

\item{subset.norm}{A vector of index indicating rows to be used for
normalization}

\item{scaling}{A boolean that indicates if the variance of the data have to
be forced to unit (variance reduction) or not.}
}
\value{
A normalized numeric matrix
}
\description{
Normalisation MeanCentering
}
\examples{
data(Exp1_R25_pept, package="DAPARdata")
qData <- Biobase::exprs(Exp1_R25_pept)
conds <- Biobase::pData(Exp1_R25_pept)$Condition
normalized <- MeanCentering(qData, conds, type = "overall")

}
\author{
Samuel Wieczorek, Thomas Burger, Helene Borges, Anais Courtier,
Enora Fremy
}
