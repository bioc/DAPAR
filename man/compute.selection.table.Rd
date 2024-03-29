% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anova_analysis.R
\name{compute.selection.table}
\alias{compute.selection.table}
\title{Applies an FDR threshold on a table of adjusted p-values and summarizes the results}
\usage{
compute.selection.table(x, fdr.threshold)
}
\arguments{
\item{x}{a table of adjusted p-values}

\item{fdr.threshold}{an FDR threshold}
}
\value{
a summary of the number of significantly differentially abundant proteins, overall and per contrast
}
\description{
Applies an FDR threshold on a table of adjusted p-values and summarizes the results
}
\examples{
data(Exp1_R25_prot, package='DAPARdata')
exdata <- Exp1_R25_prot[1:5,]
adjpvaltab <- globalAdjPval(testAnovaModels(applyAnovasOnProteins(exdata), "TukeyHSD")$P_Value)
seltab <- compute.selection.table(adjpvaltab, 0.2)
seltab

}
\author{
Thomas Burger
}
