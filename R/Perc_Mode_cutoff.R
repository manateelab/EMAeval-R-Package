#' Identification of Careless Response Using the Percent of Items at Mode
#'
#' \code{Perc_Mode_cutoff} returns dataframe of assessment flagged by the Percent of Items at Mode per assessment cutoff value.
#'
#' This function creates the dataframe that includes the ID and index of assessments that met the cutoff criterion for Percent of Items at Mode per assessment. If an assessment has a  Percent of Items at Mode \strong{greater than or equal to} the cutoff value, it will be flagged and placed in the dataframe.
#'
#' @param data dataframe to be analyzed.
#' @param cutoff numeric cutoff value for the Percent of Items at Mode, 'default' value set to 0.7. 
#' @param condition character string of condition that is desired for comparison of data to Percent of Items at Mode cutoff value, i.e <, >=, etc. 'Default' logic set to ">=".
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.
#' @param ID.colname character string of column name for ID of assessment.
#' @return The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for the Percent of Items at Mode. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seen below.
#' @seealso \code{\link{TPI_cutoff}} for a similar function, using Time per Item rather than Percent of Items at Mode.
#' @seealso \code{\link{SD_cutoff}} for a similar function, using Standard Deviation rather than Percent of Items at Mode.
#' @seealso See the following functions for more information on Careless Response Identification in EMA: \code{\link{flagging_df}}, \code{\link{flagging_plots}}, \code{\link{longstringr}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Identification of careless responding in ecological momentary assessment: from post-hoc analyses to real-time data monitoring.}
#'
#' @export




Perc_Mode_cutoff <- function(data, cutoff, condition, item.colnames, ID.colname){
  
  if (missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify number of items with item.colnames\n")
  }
  
  if (missing(cutoff)){
    warning("cutoff missing.\nCutoff value automatically set to 0.7. Specify cutoff value to change from 0.7 with variable 'cutoff = ' \n")
    cutoff <- 0.7
  }
  if (missing(condition)){
    warning("condition missing.\nSD condition (<, >, <=, >=) automatically set to '>='. Specify SD condition to change from '>=' with variable 'condition =...' \n")
    condition <- ">="
  }
  if (condition == "="){
    warning("condition cannot be set to '='.\nSD condition (<, >, <=, >=)  automatically set to '>='. Specify SD condition to change from '>=' with variable 'condition =...' \n")
    condition <- ">="
  }
  if (missing(ID.colname)){
    ID.colname <- stop("ID.colname missing.\nSpecify column name for the identifying information (Participant ID) with the variable 'ID.colname =...'\n")
  }
  
  newDF <- c()
  # suppressWarnings(
    for(idx in 1:nrow(data)){
      
      # % items at MODE
      data_mode <- c()
      if (length(item.colnames[!is.na(item.colnames)]) == 0){
        data_mode <- NA
      } else {
        mode <- suppressWarnings(as.vector(apply(data[idx, which(colnames(data) %in% item.colnames[!is.na(item.colnames)])], 1, DescTools::Mode, na.rm = TRUE)))
        Number_items <- length(which(!is.na(data[idx, item.colnames])))
        Number_items_Mode <- length(which(data[idx,item.colnames[!is.na(item.colnames)]] == mode[1]))
        Mode_Frequency_Percent <- Number_items_Mode/Number_items
        data_mode <- Mode_Frequency_Percent
      }
      
      # check to see if Percent items at mode is >= (or other condition) cutoff and paste into dataframe if so
      data_point <- c()
      flag_point <- c()
      switch(condition,
             "<=" =     if(!is.na(data_mode) & data_mode <= cutoff){
               data_point <- idx
               ID <- data[idx,ID.colname]
               flag_point <- cbind(ID, data_point)
             },
             ">=" =     if(!is.na(data_mode)  & data_mode >= cutoff){
               data_point <- idx
               ID <- data[idx,ID.colname]
               flag_point <- cbind(ID, data_point)
             },
             "<" =     if(!is.na(data_mode) & data_mode < cutoff){
               data_point <- idx
               ID <- data[idx,ID.colname]
               flag_point <- cbind(ID, data_point)
             },
             ">" =     if( !is.na(data_mode) & data_mode > cutoff){
               data_point <- idx
               ID <- data[idx,ID.colname]
               flag_point <- cbind(ID, data_point)
             }
      )
      
      newDF <- rbind(newDF, flag_point)
    }
  # )
  newDF <- as.data.frame(newDF)
  if(length(colnames(newDF)) > 0){
    colnames(newDF)[2] <- "Index_of_Flagged_Assessment"
    newDF
  } else {
    print("There were no assessments flagged by the criteria listed.")
  }


  
}
