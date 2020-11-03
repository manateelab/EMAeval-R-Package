#' Example data set for the EMAeval Package
#'
#' This is a fictitious data set that has 4 "participants" who were sampled once every day, for 50 straight days. There are responses to 8 different items (Q1, Q2, Q3, etc.).
#' This data can be used to help users understand the use of the EMAeval R Package.
#'
#' @docType data
#'
#' @usage data(EMAeval_Data)
#'
#' @keywords datasets
#'
#' @format A dataframe with 200 rows and 11 variables:
#' \describe {
#'     \item{ID}{identification number given to all 4 participants.}
#'     \item{StartDate}{date time when the assessment began.}
#'     \item{EndDate}{date time when the assessment ended.}
#'     \item{Q#}{individual items asked of participants for each assessment, numbered 1-8.}
#' }
#'
#' @source This data set is fictitious data only to demonstrate the uses of the R package EMAeval. Developed by Noah Kraus.


"EMAeval_Data"
