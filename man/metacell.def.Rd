% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metacell.R
\name{metacell.def}
\alias{metacell.def}
\title{Metadata vocabulary for entities}
\usage{
metacell.def(level)
}
\arguments{
\item{level}{A string designing the type of entity/pipeline.
Available values are: `peptide`, `protein`}
}
\value{
xxx
}
\description{
This function gives the vocabulary used for the metadata of each entity in
each condition.

Peptide-level vocabulary

|-- 'Any'
|    |
|    |-- 1.0 'Quantified'
|    |    |
|    |    |-- 1.1 "Quant. by direct id" (color 4, white)
|    |    |
|    |    |-- 1.2 "Quant. by recovery" (color 3, lightgrey)
|    |
|    |-- 2.0 "Missing" (no color)
|    |    |
|    |    |-- 2.1 "Missing POV" (color 1)
|    |    |
|    |    |-- 2.2 'Missing MEC' (color 2)
|    |
|    |-- 3.0 'Imputed'
|    |    |
|    |    |-- 3.1 'Imputed POV' (color 1)
|    |    |
|    |    |-- 3.2 'Imputed MEC' (color 2)



Protein-level vocabulary:
|-- 'Any'
|    |
|    |-- 1.0 'Quantified'
|    |    |
|    |    |-- 1.1 "Quant. by direct id" (color 4, white)
|    |    |
|    |    |-- 1.2 "Quant. by recovery" (color 3, lightgrey)
|    |
|    |-- 2.0 "Missing"
|    |    |
|    |    |-- 2.1 "Missing POV" (color 1)
|    |    |
|    |    |-- 2.2 'Missing MEC' (color 2)
|    |
|    |-- 3.0 'Imputed'
|    |    |
|    |    |-- 3.1 'Imputed POV' (color 1)
|    |    |
|    |    |-- 3.2 'Imputed MEC' (color 2)
|    |
|    |-- 4.0 'Combined tags' (color 3bis, lightgrey)
}
\examples{
metacell.def('protein')
metacell.def('peptide')


}
\author{
Thomas Burger, Samuel Wieczorek
}
