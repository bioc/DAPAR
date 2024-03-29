% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalize.R
\name{QuantileCentering}
\alias{QuantileCentering}
\title{Normalisation QuantileCentering}
\usage{
QuantileCentering(
  qData,
  conds = NULL,
  type = "overall",
  subset.norm = NULL,
  quantile = 0.15
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

\item{quantile}{A float that corresponds to the quantile used to
align the data.}
}
\value{
A normalized numeric matrix
}
\description{
Normalisation QuantileCentering
}
\examples{
data(Exp1_R25_pept, package="DAPARdata")
obj <- Exp1_R25_pept
conds <- Biobase::pData(Exp1_R25_pept)$Condition
normalized <- QuantileCentering(Biobase::exprs(obj), conds,
type = "within conditions", subset.norm = seq_len(10)
)

}
\author{
Samuel Wieczorek, Thomas Burger, Helene Borges, Anais Courtier,
Enora Fremy
}
