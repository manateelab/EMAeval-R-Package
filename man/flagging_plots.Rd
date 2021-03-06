% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flagging_plots.R
\name{flagging_plots}
\alias{flagging_plots}
\title{EMA Careless Response Cutoff Determination Plots}
\usage{
flagging_plots(
  data,
  ttc.colnames,
  number.items,
  item.colnames,
  ttc.plotx.max,
  sd.plotx.max,
  longstring.plotx.max
)
}
\arguments{
\item{data}{dataframe to be analyzed.}

\item{ttc.colnames}{vector of column names of "Start Time" and "End Time" to calculate time to complete, also can be "Completion Time" if already calculated.}

\item{number.items}{numeric of item responses per assessment}

\item{item.colnames}{vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.}

\item{ttc.plotx.max}{numeric that will set the upper limit of the x-axis of Time to Complete histogram, default is 100.}

\item{sd.plotx.max}{numeric that will set the upper limit of the x-axis of Standard Deviation histogram, default is 50.}

\item{longstring.plotx.max}{numeric that will set the upper limit of the x-axis of Time to Complete histogram, default is 100.}
}
\value{
The item \code{"ttc.colnames"} must be the names of columns, corresponding to Start Time and End Time, ordered \code{ttc.colnames = c("StartTime", "EndTime")} start time first, followed by end time. If the data includes assessment duration, then list the column name that corresponds with assessment completion: \code{ttc.colnames = "SurveyDuration"}

The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for Item Score Standard Deviation. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seen below.
}
\description{
\code{flagging_plots} returns grouping of histograms of Time to Complete per assessment, Time per Item per assessment, Standard Deviation of item response per assessment, and Longstring.
}
\details{
This function creates plots of Time to Complete, Time Per Item, Item Score Standard Deviation, and Longstring.
The histograms can be used to determine cutoff values for Time to Complete, Time Per Item, or Item Score Standard Deviation.
This also can help visualize the most reported scores.
}
\references{
Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Identification of careless responding in ecological momentary assessment: from post-hoc analyses to real-time data monitoring.}
}
\seealso{
\code{\link{flagging_df}} for the dataframe that was used for these histograms. \code{\link{longstringr}} provides a dataframe of all the longstring values

The following functions once cutoff values have been determined: \code{\link{TPI_cutoff}}, \code{\link{SD_cutoff}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}
}
