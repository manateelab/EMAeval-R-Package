#' Identification of Careless Response Using Standard Deviation
#'
#' \code{SD_cutoff} returns dataframe of assessment flagged by Standard Deviation per assessment cutoff value.
#'
#' This function creates the dataframe that includes the ID and index of assessments that met the cutoff criterion for Standard Deviation per assessment. If an assessment has a Standard Deviation \strong{less than or equal to} the cutoff value, it will be flagged and placed in the dataframe.
#'
#' @param data dataframe to be analyzed.
#' @param cutoff numeric cutoff value for Standard Deviation, 'default' value set to 5.
#' @param condition character string of condition that is desired for comparison of data to SD cutoff value, i.e <, >=, etc. 'Default' logic set to "<=".
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.
#' @param ID.colname character string of column name for ID of assessment.
#' @return The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for Item Score Standard Deviation. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seen below.
#' @seealso \code{\link{TPI_cutoff}} for a similar function, using Time per Item rather than Standard Deviation.
#' @seealso \code{\link{Perc_Mode_cutoff}} for a similar function, using Percent of Items at Mode rather than Standard Deviation.
#' @seealso See the following functions for more information on Careless Response Identification in EMA: \code{\link{flagging_df}}, \code{\link{flagging_plots}}, \code{\link{longstringr}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Identification of careless responding in ecological momentary assessment: from post-hoc analyses to real-time data monitoring.}
#'
#' @export


SD_cutoff <- function(data, cutoff, condition, item.colnames, ID.colname){

  if (missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify number of items with item.colnames\n")
  }

  if (missing(cutoff)){
    warning("cutoff missing.\nCutoff value automatically set to 5. Specify cutoff value to change from 5 with variable 'cutoff = ' \n")
    cutoff <- 5
  }
  if (missing(condition)){
    warning("condition missing.\nSD condition (<, >, <=, >=) automatically set to '<='. Specify SD condition to change from '<=' with variable 'condition =...' \n")
    condition <- "<="
  }
  if (condition == "="){
    warning("condition cannot be set to '='.\nSD condition (<, >, <=, >=)  automatically set to '<='. Specify SD condition to change from '<=' with variable 'condition =...' \n")
    condition <- "<="
  }
  if (missing(ID.colname)){
    ID.colname <- stop("ID.colname missing.\nSpecify column name for the identifying information (Participant ID) with the variable 'ID.colname =...'\n")
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


      # check to see if SD is <= (or other condition) cutoff and paste into dataframe if so
      data_point <- c()
      flag_point <- c()
 switch(condition,
    "<=" =     if(!is.na(data_SD) & data_SD <= cutoff){
      data_point <- idx
      ID <- data[idx,ID.colname]
      flag_point <- cbind(ID, data_point)
    },
    ">=" =     if(!is.na(data_SD)  & data_SD >= cutoff){
      data_point <- idx
      ID <- data[idx,ID.colname]
      flag_point <- cbind(ID, data_point)
    },
    "<" =     if(!is.na(data_SD) & data_SD < cutoff){
      data_point <- idx
      ID <- data[idx,ID.colname]
      flag_point <- cbind(ID, data_point)
    },
    ">" =     if( !is.na(data_SD) & data_SD > cutoff){
      data_point <- idx
      ID <- data[idx,ID.colname]
      flag_point <- cbind(ID, data_point)
    }
    )

      newDF <- rbind(newDF, flag_point)
    }
  )
  newDF <- as.data.frame(newDF)
  if(length(colnames(newDF)) > 0){
    colnames(newDF)[2] <- "Index_of_Flagged_Assessment"
    newDF
  } else {
    print("There were no assessments flagged by the criteria listed.")
  }


}
