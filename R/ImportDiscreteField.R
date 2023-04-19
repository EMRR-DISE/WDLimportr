#' Generate a data frame with a station's discrete field data.
#'
#' @param stationNumber A station's FLIMS* station number.
#'
#' @return A data frame with all of the discrete field data records for a station.
#' @export
#'
#' @examples
#' test_discrete_field <- "B9D82851352"
#' ImportDiscreteField(test_discrete_field)
ImportDiscreteField <- function(stationNumber) {

  # field_column_names ----
  field_column_names <- c("_id", "station_id", "station_number",
                          "full_station_name", "station_type", "latitude",
                          "longitude", "status", "county_name",
                          "sample_code", "sample_date", "sample_depth",
                          "sample_depth_units", "anl_data_type", "parameter",
                          "fdr_result", "fdr_text_result", "fdr_date_result",
                          "fdr_reporting_limit", "uns_name", "mth_name",
                          "fdr_footnote")

  # format stationNumber ----
  stationNumber <- gsub(" ", "+", stationNumber, fixed = TRUE)

  # Generating HTTP request URL ----
  searchURL <- paste0("https://data.cnra.ca.gov/api/3/action/datastore_search?resource_id=1911e554-37ab-44c0-89b0-8d7044dd891d&q=", stationNumber)

  ## Retrieving record total
  max_records <- searchURL %>%
    jsonlite::read_json() %>%
    purrr::pluck("result", "total")

  ## Updating HTTP request URL with record total stationNumber
  searchURL_max <- paste0(searchURL, "&limit=", max_records)

  # Call API, transform JSON data into formatted data frame  ----
  df_station_information_field <- searchURL_max %>%
    jsonlite::read_json() %>%
    purrr::pluck("result", "records") %>%
    tidyr::tibble() %>%
    tidyr::unnest_wider(1) %>%
    dplyr::select(all_of(field_column_names)) %>%
    dplyr::mutate(sample_date = stringr::str_replace(sample_date, "T", " "),
                  fdr_date_result = stringr::str_replace(fdr_date_result, "T", " ")) %>%
    dplyr::mutate(sample_date = as.POSIXct(sample_date, format = "%Y-%m-%d %H:%M:%S"),
                  fdr_date_result = as.POSIXct(fdr_date_result, format = "%Y-%m-%d %H:%M:%S")) # needs to be PST

  # Return final generated data frame ----
  return(df_station_information_field)

}
