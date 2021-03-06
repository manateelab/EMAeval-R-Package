% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Perc_Mode_cutoff.R
\name{Perc_Mode_cutoff}
\alias{Perc_Mode_cutoff}
\title{Identification of Careless Response Using the Percent of Items at Mode}
\usage{
Perc_Mode_cutoff(data, cutoff, condition, item.colnames, ID.colname)
}
\arguments{
\item{data}{dataframe to be analyzed.}

\item{cutoff}{numeric cutoff value for the Percent of Items at Mode, 'default' value set to 0.7.}

\item{condition}{character string of condition that is desired for comparison of data to Percent of Items at Mode cutoff value, i.e <, >=, etc. 'Default' logic set to ">=".}

\item{item.colnames}{vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.}

\item{ID.colname}{character string of column name for ID of assessment.}
}
\value{
The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for the Percent of Items at Mode. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seen below.
}
\description{
\code{Perc_Mode_cutoff} returns dataframe of assessment flagged by the Percent of Items at Mode per assessment cutoff value.
}
\details{
This function creates the dataframe that includes the ID and index of assessments that met the cutoff criterion for Percent of Items at Mode per assessment. If an assessment has a  Percent of Items at Mode \strong{greater than or equal to} the cutoff value, it will be flagged and placed in the dataframe.
}
\references{
Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Identification of careless responding in ecological momentary assessment: from post-hoc analyses to real-time data monitoring.}
}
\seealso{
\code{\link{TPI_cutoff}} for a similar function, using Time per Item rather than Percent of Items at Mode.

\code{\link{SD_cutoff}} for a similar function, using Standard Deviation rather than Percent of Items at Mode.

See the following functions for more information on Careless Response Identification in EMA: \code{\link{flagging_df}}, \code{\link{flagging_plots}}, \code{\link{longstringr}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}
}
