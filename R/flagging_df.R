#' EMA Careless Response Cutoff Determination Dataframe
#'
#' \code{flagging_df} returns dataframe of Time to Complete per assessment, Time per Item per assessment, Standard Deviation of item response per assessment, and Longstring.
#'
#' This function creates the dataframe of Time to Complete, Time Per Item, Item Score Standard Deviation, and Longstring. See function \code{flagging_plots} for the histograms that are compiled from this dataframe.
#'
#' @param data dataframe to be analyzed.
#' @param ttc.colnames vector of column names of "Start Time" and "End Time" to calculate time to complete, also can be "Completion Time" if already calculated.
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.
#' @return  The item \code{"ttc.colnames"} must be the names of columns, corresponding to Start Time and End Time, ordered \code{ttc.colnames = c("StartTime", "EndTime")} start time first, follwed by end time. If the data includes assessment duration, then list the column name that corresponds with assessment completion: \code{ttc.colnames = "SurveyDuration"}.
#' @return The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for Item Score Standard Deviation. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seen below.
#' @seealso \code{\link{flagging_plots}} for the histograms that were created from this dataframe.
#' @seealso \code{\link{longstringr}} provides a dataframe of all the longstring values.
#' @seealso The following functions once cutoff values have been determined: \code{\link{TPI_cutoff}}, \code{\link{SD_cutoff}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Identification of careless responding in ecological momentary assessment: from post-hoc analyses to real-time data monitoring.}
#'
#' @export

flagging_df <- function(data, ttc.colnames, item.colnames){
  if (missing(ttc.colnames)){
    ttc.colnames <- stop("ttc.colnames missing.\nSpecify Start-Date & End-Date / Completion Time with ttc.colnames\n")
  }


  if (missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify column names of items with item.colnames\n")
  }

  #comparison DF for plots
  calc.df <- data.frame(matrix(NA, nrow = nrow(data), ncol = 4))
  data <- as.data.frame(data)
  for (idx in 1:nrow(data)){

    #calculate TTC and place in calc.df

    if (length(ttc.colnames[!is.na(ttc.colnames)]) > 1){
      starttime <- lubridate::ymd_hms(data[idx, which(colnames(data) %in% ttc.colnames[1])])
      endtime <- lubridate::ymd_hms(data[idx, which(colnames(data) %in% ttc.colnames[2])])
      calc.df[idx,1] <- as.numeric(endtime-starttime, units="secs")
    } else if (length(ttc.colnames[!is.na(ttc.colnames)]) == 1){
      calc.df[idx,1] <- (ttc.colnames[!is.na(ttc.colnames)])
    } else {
      calc.df[idx,1] <- NA
    }

    #calculate TPI and place in calc.df
    item_length <- length(which(!is.na(data[idx, item.colnames])))
    calc.df[idx,2] <- (calc.df[idx,1] / item_length)

    #calculate SD and place in calc.df
    if (length(item.colnames[!is.na(item.colnames)]) == 0){
      calc.df[idx,3] <- NA
    } else {
      calc.df[idx,3] <- round(sd(data[idx, which(colnames(data) %in% item.colnames[!is.na(item.colnames)])], na.rm = TRUE),2)
    }

    #calculate mode and place in calc.df
    MODE1 = as.vector(lsr::modeOf(as.numeric(data[idx, which(colnames(data) %in% item.colnames[!is.na(item.colnames)])]), na.rm = TRUE))
    if (length(MODE1) == 1){
      calc.df[idx,4] = MODE1
    } else if (length(MODE1) == length(item.colnames[!is.na(item.colnames)])){
      calc.df[idx,4] = NA
    } else{
      calc.df[idx,4] = paste(MODE1, collapse=",")
    }

  }

  calc.df <- as.data.frame(calc.df)
  colnames(calc.df)[1:4] <- c("TTC", "TPI", "SD", "Longstring")
  calc.df
}
