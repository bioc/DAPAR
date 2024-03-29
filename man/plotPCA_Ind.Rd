% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots_pca.R
\name{plotPCA_Ind}
\alias{plotPCA_Ind}
\title{Plots individuals of PCA}
\usage{
plotPCA_Ind(res.pca, chosen.axes = c(1, 2))
}
\arguments{
\item{res.pca}{xxx}

\item{chosen.axes}{The dimensions to plot}
}
\value{
A plot
}
\description{
Plots individuals of PCA
}
\examples{
data(Exp1_R25_pept, package="DAPARdata")
res.pca <- wrapper.pca(Exp1_R25_pept)
plotPCA_Ind(res.pca)

}
\author{
Samuel Wieczorek
}
