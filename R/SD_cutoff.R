#' Identification of Careless Reponse Using Standard Deviation
#' 
#' \code{SD_cutoff} returns dataframe of assessment flagged by Standard Deviation per assessment cutoff value. 
#' 
#' This function creates the dataframe that includes the ID and index of assessments that met the cutoff criterion for Standard Deviation per assessment. If an assessment has a Standard Deviation \strong{less than or equal to} the cutoff value, it will be flagged and placed in the dataframe.
#'
#' @param data dataframe to be analyzed.
#' @param cutoff numeric cutoff value for Standard Deviation. 
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.
#' @param ID.colname character string of column name for ID of assessment.
#' @return The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for Item Score Standard Deviation. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seeen below.
#' @seealso \code{\link{TPI_cutoff}} for a similar fuction, using Time per Item rather than Standard Deviation.
#' @seealso See the following functions for more information on Careless Response Identification in EMA: \code{\link{flagging_df}}, \code{\link{flagging_plots}}, \code{\link{longstringr}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}} 
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Methods to automatically identify careless responding in ecological momentary assessment research: from post-hoc analyses to real-time data monitoring.}
#'  
#' @export


SD_cutoff <- function(data, cutoff, item.colnames, ID.colname){

  if (missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify number of items with item.colnames\n")
  }


  if (missing(ID.colname)){
    ID.colname <- stop("ID.colname missing.\nSpecify column name of ID with ID.colname\n")
  }

  if (missing(cutoff)){
    warning("cutoff missing.\nCutoff value automatically set to 5. Specify cutoff value to change from 5 with variable 'cutoff = ' \n")
    cutoff <- 5
  }


  newDF <- c()
  suppressWarnings(
    for(idx in 1:nrow(data)){

      # calculate SD
      data_SD <- c()
      if (length(item.colnames[!is.na(item.colnames)]) == 0){
        data_SD <- NA
      } else {
        data_SD <- suppressWarnings(sd(data[idx,item.colnames], na.rm = TRUE))
      }


      # check to see if TPI is <= cutoff and paste into dataframe if so
      data_point <- c()
      flag_point <- c()
      if(data_SD <= cutoff){
        data_point <- idx
        ID <- data[idx,ID.colname]
        flag_point <- cbind(ID, data_point)
      }else{
        next
      }
      newDF <- rbind(newDF, flag_point)
    }
  )
  newDF <- as.data.frame(newDF)
  colnames(newDF)[2] <- "Index_of_Flagged_Assessment"
  newDF

}
