% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metacell_Plots.R
\name{wrapper.mvImage}
\alias{wrapper.mvImage}
\title{Heatmap of missing values from a \code{MSnSet} object}
\usage{
wrapper.mvImage(obj, pattern = "Missing MEC")
}
\arguments{
\item{obj}{An object of class \code{MSnSet}.}

\item{pattern}{xxx}
}
\value{
A heatmap
}
\description{
#' Plots a heatmap of the quantitative data. Each column represent one of
the conditions in the object of class \code{MSnSet} and
the color is proportional to the mean of intensity for each line of
the dataset.
The lines have been sorted in order to vizualize easily the different
number of missing values. A white square is plotted for missing values.
}
\examples{
data(Exp1_R25_prot, package="DAPARdata")
obj <- Exp1_R25_prot[seq_len(1000)]
level <- 'protein'
metacell.mask <- match.metacell(GetMetacell(obj), c("Missing POV", "Missing MEC"), level)
indices <- GetIndices_WholeMatrix(metacell.mask, op = ">=", th = 1)
obj <- MetaCellFiltering(obj, indices, cmd = "delete")
wrapper.mvImage(obj$new)

}
\author{
Alexia Dorffer
}
