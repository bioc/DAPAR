% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots_pca.R
\name{plotPCA_Eigen_hc}
\alias{plotPCA_Eigen_hc}
\title{Plots the eigen values of PCA with the highcharts library}
\usage{
plotPCA_Eigen_hc(res.pca)
}
\arguments{
\item{res.pca}{xxx}
}
\value{
A histogram
}
\description{
Plots the eigen values of PCA with the highcharts library
}
\examples{
data(Exp1_R25_pept, package='DAPARdata')
res.pca <- wrapper.pca(Exp1_R25_pept, ncp = 6)
plotPCA_Eigen_hc(res.pca)

}
\author{
Samuel Wieczorek
}
