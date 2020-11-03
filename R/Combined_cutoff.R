#' Identification of Careless Response Using Standard Deviation and Time per Item
#'
#' \code{Combined_cutoff} returns dataframe of assessment flagged by any of these three cutoff values: Standard Deviation per assessment, Time per Item.
#'
#' This function creates the dataframe that includes the ID and index of assessments that met the cutoff criteria for \emph{Standard Deviation per assessment}, \emph{Time per Item}, and \emph{Percent of Items at Mode }.
#' If an assessment has a Standard Deviation \strong{less than or equal to} the cutoff value, a Time per Item \strong{less than or equal to} the cutoff value, or the Percent of Items scores at the Mode is \strong{greater than or equal to} the cutoff value, it will be flagged and placed in the dataframe.
#' This function uses the Boolean logic \emph{"OR"} in order to identify assessments that meet any of the listed criteria.
#' This function allows users to customize cutoff conditions for each separate cutoff to \strong{"<", ">", "<=", ">="}. The default values for the cutoff conditions will be set as described before.
#' This function allows users to customize the Boolean logic to \strong{"AND", "OR"}. The default values for the Boolean logic will be set as \emph{"OR"} between all three criteria.
#'
#' @param data dataframe to be analyzed.
#' @param SD.cutoff numeric cutoff value for Standard Deviation, 'default' value set to 5.
#' @param SD.condition character string of condition that is desired for comparison of data to SD cutoff value, i.e <, >=, etc. 'Default' logic set to "<=".
#' @param TPI.cutoff numeric cutoff value for Time per Item, 'default' value set to 1.
#' @param TPI.condition character string of condition that is desired for comparison of data to TPI cutoff value, i.e <, >=, etc. 'Default' logic set to "<=".
#' @param Perc.Mode.cutoff  numeric cutoff value for the Percent of Item scores at Mode, 'default' value set to 0.7.
#' @param Perc.Mode.condition character string of condition that is desired for comparison of data to Percent of Items at Mode cutoff value, i.e <, >=, etc. 'Default' logic set to ">=".
#' @param Combined.logic character string of logic that is desired for classifying the use of the  SD, TPI, and  Percent of Items at Mode cutoff values, 'default' logic set to 'OR'.
#' @param ttc.colnames vector of column names of "Start Time" and "End Time" to calculate time to complete, also can be "Completion Time" if already calculated.
#' @param number.items integer, number of items per assessment.
#' @param mandatory.response logical value based on whether response to items in each assessment were mandatory to complete.
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation responses.
#' @param ID.colname character string of column name for ID of assessment.
#' @return The item \code{"ttc.colnames"} must be the names of columns, corresponding to Start Time and End Time, ordered \code{ttc.colnames = c("StartTime", "EndTime")} start time first, followed by end time. If the data includes assessment duration, then list the column name that corresponds with assessment completion: \code{ttc.colnames = "SurveyDuration"}
#' @return The item \code{"mandatory.response"} should be \strong{\code{TRUE}} if participants were required to complete all items per assessment. This item should be \strong{\code{FALSE}} if not all items were required to be completed per assessment.
#' @return If there is variability in the items that are asked, mark the item \code{"mandatory.response"} as \strong{\code{FALSE}} and ensure that \code{"item.colnames"} includes all items.
#' @seealso \code{\link{Combined_cutoff_percent}} for a similar function, presenting only ID and the percent of assessments that were flagged by the criteria.
#' @seealso See the following functions for more information on Careless Response Identification in EMA: \code{\link{flagging_df}}, \code{\link{flagging_plots}}, \code{\link{longstringr}}, \code{\link{SD_cutoff}}, \code{\link{TPI_cutoff}}, and \code{\link{Perc_Mode_cutoff}}.
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Identification of careless responding in ecological momentary assessment: from post-hoc analyses to real-time data monitoring.}
#'
#' @export


Combined_cutoff <- function(data, SD.cutoff, SD.condition, TPI.cutoff, TPI.condition, Perc.Mode.cutoff, Perc.Mode.condition, Combined.logic, ttc.colnames, number.items, mandatory.response, item.colnames, ID.colname){
  if (missing(TPI.cutoff)){
    warning("TPI.cutoff missing.\nTPI cutoff value automatically set to 1 second. Specify TPI cutoff value to change from 1 second with variable 'TPI.cutoff =...' \n")
    TPI.cutoff <- 1
  }
  if (missing(SD.cutoff)){
    warning("SD.cutoff missing.\nSD cutoff value automatically set to 5. Specify SD cutoff value to change from 5 with variable 'SD.cutoff =...' \n")
    SD.cutoff <- 5
  }
  if (missing(Perc.Mode.cutoff)){
    warning("Perc.Mode.cutoff missing.\nPercent of Item scores at Mode cutoff value automatically set to 0.7. Specify Percent of Item scores at Mode cutoff value to change from 0.7 with variable 'Perc.Mode.cutoff =...' \n")
    Perc.Mode.cutoff <- 0.7
  }
  if (missing(SD.condition)){
    warning("SD.condition missing.\nSD condition (<, >, <=, >=) automatically set to '<='. Specify SD condition to change from '<=' with variable 'SD.condition =...' \n")
    SD.condition <- "<="
  }
  if (SD.condition == "="){
    warning("SD.condition cannot be set to '='.\nSD condition (<, >, <=, >=)  automatically set to '<='. Specify SD condition to change from '<=' with variable 'SD.condition =...' \n")
    SD.condition <- "<="
  }
  if (missing(TPI.condition)){
    warning("TPI.condition missing.\nTPI condition (<, >, <=, >=)  automatically set to '<='. Specify TPI condition to change from '<=' with variable 'TPI.condition =...' \n")
    TPI.condition <- "<="
  }
  if (TPI.condition == "="){
    warning("TPI.condition cannot be set to '='.\nTPI condition (<, >, <=, >=)  automatically set to '<='. Specify TPI condition to change from '<=' with variable 'TPI.condition =...' \n")
    TPI.condition <- "<="
  }
  if (missing(Perc.Mode.condition)){
    warning("Perc.Mode.condition missing.\n Percent of Items at Mode condition (<, >, <=, >=)  automatically set to '>='. Specify  Percent of Items at Mode condition to change from '>=' with variable 'Perc.Mode.condition =...' \n")
    Perc.Mode.condition <- ">="
  }
  if (Perc.Mode.condition == "="){
    warning("Perc.Mode.condition cannot be set to '='.\n Percent of Items at Mode condition (<, >, <=, >=)  automatically set to '>='. Specify  Percent of Items at Mode condition to change from '>=' with variable 'Perc.Mode.condition =...' \n")
    Perc.Mode.condition <- ">="
  }
  if (missing(Combined.logic)){
    warning("Combined.logic missing.\nThe logic for combining SD, TPI, and  Percent of Items at Mode cutoffs has automatically been set to 'or'. Specify the logic to change from 'or' with variable 'Combined.logic =...' \n")
    Combined.logic <- "or"
  }

  if (missing(ttc.colnames)){
    ttc.colnames <- stop("ttc.colnames missing. Specify Start-Date & End-Date / Completion Time with ttc.colnames\n")
  }
  if (isTRUE(mandatory.response) & missing(number.items)){
    number.items <- stop("number.items missing. Specify number of items with the variable 'number.items =...'\n")
  }

  if (missing(mandatory.response)){
    mandatory.response <- stop("mandatory.response missing.\nSpecify if response to all items was mandatory, resulting in with no NAs for item responses.
                               \nIf responses are mandatory, mandatory.response = TRUE \nIf responses are NOT mandatory, mandatory.response = FALSE")
  }
  if (isFALSE(mandatory.response) & missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify column names of items with the variable 'item.colnames =...'\n")
  }

  if (missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify number of items with the variable 'item.colnames =...'\n")
  }

  if (missing(ID.colname)){
    ID.colname <- stop("ID.colname missing.\nSpecify column name for the identifying information (Participant ID) with the variable 'ID.colname =...'\n")
  }



  newDF <- c()

  for(idx in 1:nrow(data)){
    # number of items if response to items not mandatory
    if(isFALSE(mandatory.response)){
      item_length <- length(which(!is.na(data[idx, item.colnames])))
    } else {
      item_length <- number.items
    }


    # calc TTC for the assessment
    data_TTC <- c()

    if (length(ttc.colnames[!is.na(ttc.colnames)]) > 1){
      starttime <- lubridate::ymd_hms(data[idx, which(colnames(data) %in% ttc.colnames[1])])
      endtime <- lubridate::ymd_hms(data[idx, which(colnames(data) %in% ttc.colnames[2])])
      data_TTC <- as.numeric(endtime-starttime, units = "secs")
    } else if (length(ttc.colnames[!is.na(ttc.colnames)]) == 1){
      data_TTC <- (ttc.colnames[!is.na(ttc.colnames)])
    } else {
      data_TTC <- NA
    }

    # TPI
    data_TPI <- (as.numeric(data_TTC) / as.numeric(item_length))

    # SD
    data_SD <- c()
    if (length(item.colnames[!is.na(item.colnames)]) == 0){
      data_SD <- NA
    } else {
      data_SD <- suppressWarnings(sd(as.numeric(data[idx,item.colnames]), na.rm = TRUE))
    }

    # % items at MODE
    data_mode <- c()
    if (length(item.colnames[!is.na(item.colnames)]) == 0){
      data_mode <- NA
    } else {
      mode <- suppressWarnings(as.vector(apply(data[idx, which(colnames(data) %in% item.colnames[!is.na(item.colnames)])], 1, DescTools::Mode, na.rm = TRUE)))
      Number_items <- length(item.colnames[!is.na(item.colnames)])
      Number_items_Mode <- length(which(item.colnames[!is.na(item.colnames)] == mode[1]))
      Mode_Frequency_Percent <- Number_items_Mode/Number_items
      data_mode <- Mode_Frequency_Percent
    }

    # check to see if TPI is <= cutoff and paste into dataframe if so
    data_point <- c()
    flag_point <- c()

    #pipe in conditionals specified
    Combined.logic <- tolower(Combined.logic)
    SD_TPI_Mode_cond <- paste("SD:", SD.condition, " TPI:", TPI.condition, " Perc.Mode:", Perc.Mode.condition, sep = "")
    switch(Combined.logic,
           "and" = switch(SD_TPI_Mode_cond,
                          # Different comb with SD TPI when Perc. Mode <=
                          "SD:<= TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          } else {next},

                          # Different comb iwth SD TPI when Perc. Mode >=

                          "SD:<= TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          } else {next},

                          # Different comb with SD TPI when Perc. Mode <

                          "SD:<= TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          } else {next},

                          # Different comb with SD TPI when Perc. Mode >


                          "SD:<= TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},


                          "SD:<= TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD <= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:>= TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD >= SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:< TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD < SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          }else {next},
                          "SD:> TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) & (!is.na(data_SD) & data_SD > SD.cutoff) & (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                            data_point <- idx
                            ID <- data[idx,ID.colname]
                            flag_point <- cbind(ID, data_point)
                          } else {next}
           ),
           "or" = switch(SD_TPI_Mode_cond,
                         # comb SD and TPI with Perc Mode <=
                         "SD:<= TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:<= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:>= Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:< Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:> Perc.Mode:<=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode <= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         } else {next},

                         # comb SD and TPI with Perc Mode >=

                         "SD:<= TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:<= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:>= Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:< Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:> Perc.Mode:>=" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode >= Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         } else {next},

                         # comb SD and TPI with Perc Mode <

                         "SD:<= TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:<= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:>= Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:< Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:> Perc.Mode:<" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode < Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         } else {next},

                         # comb SD and TPI with Perc Mode >

                         "SD:<= TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:<= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI <= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:>= Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI >= TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:< Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI < TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},


                         "SD:<= TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD <= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:>= TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD >= SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:< TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD < SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         }else {next},
                         "SD:> TPI:> Perc.Mode:>" =     if((!is.na(data_TPI) & data_TPI > TPI.cutoff) | (!is.na(data_SD) & data_SD > SD.cutoff) | (!is.na(data_mode) & data_mode > Perc.Mode.cutoff)){
                           data_point <- idx
                           ID <- data[idx,ID.colname]
                           flag_point <- cbind(ID, data_point)
                         } else {next}
           )

    )


    newDF <- rbind(newDF, flag_point)
  }
  newDF <- as.data.frame(newDF)

  if(length(colnames(newDF)) > 0){
    colnames(newDF)[1:2] <- c("ID", "Index_of_Flagged_Assessment")
    newDF
  } else {
    print("There were no assessments flagged by the criteria listed.")
  }


  }
