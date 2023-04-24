#' Generate a data frame with a station's continuous raw data.
#'
#' @description
#' Input a station number* to import a formatted data frame with its continuous raw data from WDL.
#'
#' @param stationNumber A station's station number.
#' @param parameters A character vector of the parameters you want to select.
#'
#' @return A data frame with all or some of the parameters for a station's raw data.
#' @export
#'
#' @examples
#' test_station_1 <- "B9156000"
#' ImportContinuousRaw(stationNumber = test_station_1)
#' test_parameters <- c("Water Temperature",
#'                      "Electrical Conductivity at 25C",
#'                      "Dissolved Oxygen")
#' ImportContinuousRaw(stationNumber = test_station_1, parameters = test_parameters)
ImportContinuousRaw <- function(stationNumber, parameters = NULL) {

  # HTTP request URL ----
  searchURL <- paste0("https://data.cnra.ca.gov/api/3/action/datastore_search?resource_id=cdb5dd35-c344-4969-8ab2-d0e2d6c00821&q=", stationNumber)

  # Call on the API, transform JSON data into data frame ----
  df_station_link <- searchURL %>%
    jsonlite::read_json() %>%
    purrr::pluck("result", "records") %>%
    tidyr::tibble() %>%
    tidyr::unnest_wider(1)

  # Filter data frame for "Daily Mean", and make sure user requested a valid station number ----
  if (is.null(parameters)) {
    filtered_df_station_link <- df_station_link %>%
      dplyr::filter(station_number == stationNumber,
                    output_interval == "Raw")
  } else {
    filtered_df_station_link <- df_station_link %>%
      dplyr::filter(station_number == stationNumber,
                    output_interval == "Raw",
                    parameter %in% parameters)
  }

  # Read in CSV links from data frame, format and join resultant data frames ----
  df_raw <- filtered_df_station_link$download_link %>%
    lapply(. %>% ImportContinuousCSV) %>%
    purrr::reduce(dplyr::full_join, by = 'Date') %>%
    dplyr::mutate(Date = stringr::str_replace(Date, "T", " "))
    dplyr::mutate(Date = as.POSIXct(Date, format = "%m/%d/%Y %H:%M:%S")) %>%
    dplyr::rename_with(~ c("date", filtered_df_station_link$parameter)) %>%
    janitor::clean_names()

  # Return final generated data frame ----
  return(df_raw)

}
