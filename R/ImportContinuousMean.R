#' Generate a data frame with a station's continuous daily average data.
#'
#' @description
#' Input a station number* to import a formatted data frame with its continuous daily average data from WDL.
#'
#'
#' @param stationNumber A station's station number.
#' @param parameters A character vector of the parameters you want to select.
#'
#' @return A data frame with all or some of the parameters for a station's daily average data.
#' @export
#'
#' @examples
#' test_station_1 <- "B9156000"
#' ImportContinuousMean(stationNumber = test_station_1)
#' test_parameters <- c("Water Temperature",
#'                      "Electrical Conductivity at 25C",
#'                      "Dissolved Oxygen")
#' ImportContinuousMean(stationNumber = test_station_1, parameters = test_parameters)
ImportContinuousMean <- function(stationNumber, parameters = NULL) { # this works with c() but not with list()

  # HTTP request URL ----
  searchURL <- paste0("https://data.cnra.ca.gov/api/3/action/datastore_search?resource_id=cdb5dd35-c344-4969-8ab2-d0e2d6c00821&q=", stationNumber)

  # Call API, transform JSON data into data frame ----
  df_station_link <- searchURL %>%
    jsonlite::read_json() %>%
    purrr::pluck("result", "records") %>%
    tidyr::tibble() %>%
    tidyr::unnest_wider(1)

  # Filter data frame for "Daily Mean", and make sure user requested a valid station number ----
  if (is.null(parameters)) {
    filtered_df_station_link <- df_station_link %>%
      dplyr::filter(station_number == stationNumber,
                    output_interval == "Daily Mean")
  } else {
    filtered_df_station_link <- df_station_link %>%
      dplyr::filter(station_number == stationNumber,
                    output_interval == "Daily Mean",
                    parameter %in% parameters)
  }

  # Read in CSV links from data frame, format and join resultant data frames ----
  df_mean <- filtered_df_station_link$download_link %>%
    lapply(. %>% ImportContinuousCSV) %>%
    purrr::reduce(dplyr::left_join, by = 'Date') %>%
    dplyr::mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
    dplyr::rename_with(~ c("date", filtered_df_station_link$parameter)) %>%
    janitor::clean_names()

  # Return final generated data frame ----
  return(df_mean)

}
