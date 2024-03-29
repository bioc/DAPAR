% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/missingValuesFilter.R
\name{NumericalFiltering}
\alias{NumericalFiltering}
\title{Removes lines in the dataset based on numerical conditions.}
\usage{
NumericalFiltering(obj, name = NULL, value = NULL, operator = NULL)
}
\arguments{
\item{obj}{An object of class \code{MSnSet}.}

\item{name}{The name of the column that correspond to the line to filter}

\item{value}{A number}

\item{operator}{A string}
}
\value{
An list of 2 items :
* obj : an object of class \code{MSnSet} in which the lines have been 
deleted,
* deleted : an object of class \code{MSnSet} which contains the deleted lines
}
\description{
This function removes lines in the dataset based on numerical conditions.
}
\examples{
data(Exp1_R25_pept, package="DAPARdata")
NumericalFiltering(Exp1_R25_pept[seq_len(100)], "A_Count", "6", "==")

}
\author{
Samuel Wieczorek
}
