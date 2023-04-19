#' Import CSV links from Station Trace Links data frame.
#'
#' @param csv_link A CSV link sourced from the CNRA Station-Trace links to time-series downloads.
#'
#' @return A formatted data frame which excludes quality code column and other extraneous information.
#' @export
#'
#' @examples
#' CNRA_CSV_link <- "https://wdlstorageaccount.blob.core.windows.net/continuous/01N04E36Q001M/por/01N04E36Q001M_Groundwater_Level_Below_Ground_Surface_Raw.csv"
#' ImportContinuousCSV(csv_link = CNRA_CSV_link)
ImportContinuousCSV <- function(csv_link){

  # Read CSV link and format
  df_wdl <- utils::read.csv(csv_link, skip = 2) %>%
    dplyr::select(!c("Qual", "X"))

  # Return formatted data frame
  return(df_wdl)

}
