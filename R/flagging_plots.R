#' EMA Careless Response Cutoff Determination Plots
#'
#' \code{flagging_plots} returns grouping of histograms of Time to Complete per assessment, Time per Item per assessment, Standard Deviation of item response per assessment, and Longstring.
#'
#' This function creates plots of Time to Complete, Time Per Item, Item Score Standard Deviation, and Longstring.
#' The histograms can be used to determine cutoff values for Time to Complete, Time Per Item, or Item Score Standard Deviation.
#' This also can help visualize the most reported scores.
#'
#' @param data dataframe to be analyzed.
#' @param ttc.colnames vector of column names of "Start Time" and "End Time" to calculate time to complete, also can be "Completion Time" if already calculated.
#' @param number.items numeric of item responses per assessment
#' @param item.colnames vector of column names of all items/questions to be used to calculate item score Standard Deviation and Longstring responses.
#' @param ttc.plotx.max numeric that will set the upper limit of the x-axis of Time to Complete histogram, default is 100.
#' @param sd.plotx.max numeric that will set the upper limit of the x-axis of Standard Deviation histogram, default is 50.
#' @param longstring.plotx.max numeric that will set the upper limit of the x-axis of Time to Complete histogram, default is 100.
#' @return The item \code{"ttc.colnames"} must be the names of columns, corresponding to Start Time and End Time, ordered \code{ttc.colnames = c("StartTime", "EndTime")} start time first, follwed by end time. If the data includes assessment duration, then list the column name that corresponds with assessment completion: \code{ttc.colnames = "SurveyDuration"}
#' @return The item \code{"item.colnames"} must be the column names of all items to be included in the calculations for Item Score Standard Deviation. The base function \code{colnames} can be utilized if user prefers. If columns \code{x} through \code{y} are to be used for this calculation, the following syntax must be followed: \code{item.colnames = colnames(data[,x:y])} Example of use with column names can bee seeen below.
#' @seealso \code{\link{flagging_df}} for the dataframe that was used for these histograms. \code{\link{longstringr}} provides a dataframe of all the longstring values
#' @seealso The following functions once cutoff values have been determined: \code{\link{TPI_cutoff}}, \code{\link{SD_cutoff}}, \code{\link{Combined_cutoff}}, and \code{\link{Combined_cutoff_percent}}
#' @references Jaso, B.A., Kraus, N.I., Heller, A.S. (2020) \emph{Methods to automatically identify careless responding in ecological momentary assessment research: from post-hoc analyses to real-time data monitoring.}
#'
#' @export

flagging_plots <- function(data, ttc.colnames, number.items, item.colnames, ttc.plotx.max, sd.plotx.max, longstring.plotx.max){
  if (missing(ttc.colnames)){
    ttc.colnames <- stop("ttc.colnames missing.\nSpecify Start-Date & End-Date / Completion Time with ttc.colnames\n")
  }

  if (missing(number.items)){
    number.items <- stop("number.items missing.\nSpecify number of items with number.items\n")
  }

  if (missing(item.colnames)){
    item.colnames <- stop("item.colnames missing.\nSpecify column names of items with item.colnames\n")
  }
  if (missing(ttc.plotx.max)){
    ttc.plotx.max <- 100
  }

  if (missing(sd.plotx.max)){
    sd.plotx.max <- 50
  }

  if (missing(longstring.plotx.max)){
    longstring.plotx.max <- 100
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

  #Mode for plots
  Mode_List <- NULL

  for (jdx in 1:nrow(data)){
    new_mode = as.vector(apply(data[jdx, which(colnames(data) %in% item.colnames[!is.na(item.colnames)])], 1, DescTools::Mode))
    Mode_List <- c(Mode_List, new_mode)
  }


  calc.df <- as.data.frame(calc.df)
  colnames(calc.df)[1:4] <- c("TTC", "TPI", "SD", "Longstring")

  Mode_List <- as.data.frame(Mode_List)



  #Plots:


  pTTC <- ggplot(data = calc.df, aes(TTC)) +
    geom_histogram(breaks= seq(0,ttc.plotx.max, by = 1),
                   col="blue",
                   fill="dark blue",
                   alpha = 0.3) +
    labs(subtitle = "Time to Complete Per Assessment") +
    labs(x="Time To Complete (seconds)", y="Count", tag = "A") +
    theme_classic()+
    scale_x_continuous(breaks = seq(0,ttc.plotx.max,10))+
    #scale_y_continuous(breaks = seq(0,800,100))+
    theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title.x = element_text(face = "bold"), axis.title.y =  element_text(face = "bold"))


  pTPI <- ggplot(data = calc.df, aes(TPI)) +
    geom_histogram(breaks= seq(0,(ttc.plotx.max/number.items), by = 0.5),
                   col="blue",
                   fill="dark blue",
                   alpha = 0.3) +
    labs(subtitle = "Time Per Item") +
    labs(x="Time Per Item(seconds)", y="Count", tag = "B") +
    theme_classic()+
    scale_x_continuous(breaks = seq(0,(ttc.plotx.max/number.items),2))+
    # scale_y_continuous(breaks = seq(0,30,1))+
    theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title.x = element_text(face = "bold"), axis.title.y =  element_text(face = "bold"))


  pSD <- ggplot(data = calc.df, aes(SD)) +
    geom_histogram(breaks= seq(0,sd.plotx.max, by = 1),
                   col="blue",
                   fill="dark blue",
                   alpha = 0.3) +
    labs(subtitle = "Standard Deviation Per Assessment") +
    labs(x="Standard Deviation", y="Count", tag = "C")+
    theme_classic()+
    scale_x_continuous(breaks = seq(0,sd.plotx.max,5))+
    #scale_y_continuous(breaks = seq(0,800,100))+
    theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title.x = element_text(face = "bold"), axis.title.y =  element_text(face = "bold"))


  pMODE <- ggplot(data = Mode_List, aes(Mode_List)) +
    geom_histogram(breaks= seq(0,longstring.plotx.max, by = 1),
                   col="blue",
                   fill="dark blue",
                   na.rm = TRUE,
                   alpha = 0.3) +
    labs(subtitle = "Longstring Score Per Assessment") +
    labs(x="Longstring", y="Count", tag = "D")+
    theme_classic()+
    scale_x_continuous(breaks = seq(0,longstring.plotx.max,10))+
    #scale_y_continuous(breaks = seq(0,3000,1000))+
    theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title.x = element_text(face = "bold"), axis.title.y =  element_text(face = "bold"))


  library(gridExtra)
  library(ggpubr)


  gridExtra::grid.arrange(grid.arrange(pTTC, pTPI, pSD, pMODE, nrow = 2, top = text_grob("Flagging Identification Plots", size = 20, just = "center")))

}


