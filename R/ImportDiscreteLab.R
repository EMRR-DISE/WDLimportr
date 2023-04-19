#' Generate a data frame with a station's discrete lab data.
#'
#' @param stationNumber a station's FLIMS* station number.
#'
#' @return A data frame with all of the discrete lab data records for a station.
#' @export
#'
#' @examples
#' test_discrete_lab <- "B9D82851352"
#' ImportDiscreteLab(stationNumber = test_discrete_lab)
ImportDiscreteLab <- function(stationNumber) {

  # lab_column_names ----
  lab_column_names <- c("_id", "station_id", "station_name",
                        "full_station_name", "station_number", "station_type",
                        "latitude", "longitude", "status",
                        "county_name", "sample_code", "sample_date",
                        "sample_depth", "sample_depth_units", "parameter",
                        "result", "reporting_limit", "units", "method_name")

  # format stationNumber ----
  stationNumber <- gsub(" ", "+", stationNumber, fixed = TRUE)

  # Generating HTTP request URL ----
  searchURL <- paste0("https://data.cnra.ca.gov/api/3/action/datastore_search?resource_id=a9e7ef50-54c3-4031-8e44-aa46f3c660fe&q=", stationNumber)

  ## Retrieving record total
  max_records <- searchURL %>%
    jsonlite::read_json() %>%
    purrr::pluck("result", "total")

  ## Updating HTTP request URL with record total stationNumber
  searchURL_max <- paste0(searchURL, "&limit=", max_records)

  # Call API, transform JSON data into formatted data frame  ----
  df_station_information_lab <- searchURL_max %>%
    jsonlite::read_json() %>%
    purrr::pluck("result", "records") %>%
    tidyr::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::select(all_of(lab_column_names)) %>%
    dplyr::mutate(sample_date = stringr::str_replace(sample_date, "T", " ")) %>%
    dplyr::mutate(sample_date = as.POSIXct(sample_date, format = "%Y-%m-%d %H:%M:%S")) # needs to be PST

  # Return final generated data frame ----
  return(df_station_information_lab)

}
