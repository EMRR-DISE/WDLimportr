
<!-- README.md is generated from README.Rmd. Please edit that file -->

\*\*NOTE: This package is still in beta.

# WDLimportr

<!-- badges: start -->
<!-- badges: end -->

The goal of WDLimportr is to easily import and format continuous and
discrete water data stored in Water Data Library (WDL) with easy to use
functions.

Though WDL does not have a publicly available API, WDL data is regularly
pushed to the California Natural Resources Agency (CNRA) Open Data
portal, which does have a publicly available API. This package uses HTTP
requests to the CNRA API to pull and format the WDL data that is stored
there, which ultimately saves time for frequent WDL data users.

### Relevant Links:

- CNRA Water Quality Data:
  <https://data.cnra.ca.gov/dataset/water-quality-data>
- CNRA DWR Continuous Data Download Links:
  <https://data.cnra.ca.gov/dataset/dwr-continuous-data-download-links>
- Water Data Library (WDL) Station Map:
  <https://wdl.water.ca.gov/waterdatalibrary/>

## Installation

You can install the development version of WDLimportr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EMRR-DISE/WDLimportr")
```

## Usage

### Function Summary Table

| Code                                                     | Purpose                                       |
|:---------------------------------------------------------|:----------------------------------------------|
| `ImportDiscreteLab(stationNumber)`                       | Import discrete lab data from WDL             |
| `ImportDiscreteField(stationNumber)`                     | Import discrete field data from WDL           |
| `ImportContinuousRaw(stationNumber, parameters = NULL)`  | Import continuous raw data from WDL           |
| `ImportContinuousMean(stationNumber, parameters = NULL)` | Import continuous daily average data from WDL |
| `ImportContinuousCSV(csv_link)`                          | Helper function                               |

### Discrete Data

There are two functions to import discrete water data from WDL.

1.  `ImportDiscreteLab()`

``` r
discrete_lab_station_number <- "B9D82851352" # FLIMS* station number

head(WDLimportr::ImportDiscreteLab(stationNumber = discrete_lab_station_number))
```

`ImportDiscreteLab()` will take a FLIMS\* station number as an input and
return a data frame which has that station’s WDL lab data, formatted in
the way that it is presented in CNRA.

2.  `ImportDiscreteField()`

``` r
discrete_field_station_number <- "B9D82851352" # FLIMS* station number

head(WDLimportr::ImportDiscreteField(stationNumber = discrete_field_station_number))
```

`ImportDiscreteField()` will take a FLIMS\* station number as an input
and return a data frame which has that station’s WDL field data,
formatted in the way that it is presented in CNRA.

### Continuous Data

There are two functions to import continuous water data from WDL

1.  `ImportContinuousRaw()`

``` r
continuous_station <- "B9156000"

test_parameters <- c("Water Temperature",
                     "Electrical Conductivity at 25C",
                     "Dissolved Oxygen")

head(WDLimportr::ImportContinuousRaw(stationNumber = continuous_station, parameters = NULL))

head(WDLimportr::ImportContinuousRaw(stationNumber = continuous_station, parameters = test_parameters))
```

`ImportContinuousRaw()` will take a station number as an input and
return a data frame with all or some (user’s choice) of the parameters
that are collected from that station. As the name implies, this function
pulls all of the raw data that is stored in CNRA.

\*\*NOTE: Due to the volume of data being pulled from the API, sometimes
this function will take a more than a few seconds.

2.  `ImportContinuousMean()`

``` r
continuous_station <- "B9156000"

test_parameters <- c("Water Temperature",
                     "Electrical Conductivity at 25C",
                     "Dissolved Oxygen")

head(WDLimportr::ImportContinuousMean(stationNumber = continuous_station, parameters = NULL))

head(WDLimportr::ImportContinuousMean(stationNumber = continuous_station, parameters = test_parameters))
```

`ImportContinuousMean()` will take a station number as an input and
return a data frame with all or some (user’s choice) of the parameters
that are collected from that station. As the name implies, this function
pulls all of the daily average data that is stored in CNRA.

### Helper Function

There is one helper function that can be used by the user, but is
intended to be used by the functions `ImportContinuousRaw()` and
`ImportContinuousMean()`.

1.  `ImportContinuousCSV(csv_link)`

``` r
CNRA_CSV_link <- "https://wdlstorageaccount.blob.core.windows.net/continuous/01N04E36Q001M/por/01N04E36Q001M_Groundwater_Level_Below_Ground_Surface_Raw.csv"

head(WDLimportr::ImportContinuousCSV(csv_link = CNRA_CSV_link))
```

`ImportContinuousCSV()` will take a CSV link from the Station-Trace
links to time-series downloads table
(<https://data.cnra.ca.gov/dataset/dwr-continuous-data-download-links/resource/cdb5dd35-c344-4969-8ab2-d0e2d6c00821>)
and return a data frame with only the dates and values from that table.
Users will notice that the the value column is named `Point` or `Inst`.
This is because this function does not rename the columns, that action
is performed within `ImportContinuousRaw()`/`ImportContinuousMean()`.

\*\*NOTE: Though this function is available to users, it is recommended
to use `ImportContinuousRaw()`/`ImportContinuousMean()` with a single
parameter selected instead.
