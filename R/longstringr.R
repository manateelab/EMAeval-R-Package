#' EMA Careless Response Longstring Vector
#' 
#' \code{longstringr} returns a vector of all Longstring values.
#' 
#' This function creates a vector of all Longstring values for the data. 
#'
#' @param data dataframe to be analyzed.
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.
#' @return The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for Item Score Standard Deviation. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seeen below.
#' @seealso \code{\link{flagging_df}} for dataframe that includes Time to Complete per assessment, Time per Item per assessment, Standard Deviation per assessment, and Longstring per assessment.
#' @seealso \code{\link{flagging_plots}} for histograms of Time to Complete, Time per Item, Standard Deviation, and Longstring that were created from  \code{\link{flagging_df}}.
#' @seealso The following functions once cutoff values have been determined: \code{\link{TPI_cutoff}}, \code{\link{SD_cutoff}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}.
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Methods to automatically identify careless responding in ecological momentary assessment research: from post-hoc analyses to real-time data monitoring.}
#'  
#' @export

longstringr <- function(data, item.colnames) {

  #Mode
  Mode_List <- NULL

  for (jdx in 1:nrow(data)){
    new_mode = as.vector(apply(data[jdx, which(colnames(data) %in% item.colnames[!is.na(item.colnames)])], 1, DescTools::Mode))
    Mode_List <- c(Mode_List, new_mode)
  }

  Mode_List
}
