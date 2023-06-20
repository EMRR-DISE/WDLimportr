
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

| Object                                                   | Type       | Purpose                                                |
|:---------------------------------------------------------|:-----------|:-------------------------------------------------------|
| `ImportDiscreteLab(stationNumber)`                       | Function   | Import discrete lab data from WDL                      |
| `ImportDiscreteField(stationNumber)`                     | Function   | Import discrete field data from WDL                    |
| `ImportContinuousRaw(stationNumber, parameters = NULL)`  | Function   | Import continuous raw data from WDL                    |
| `ImportContinuousMean(stationNumber, parameters = NULL)` | Function   | Import continuous daily average data from WDL          |
| `continuous_stations`                                    | Data Frame | Search for continuous station names and other metadata |
| `discrete_stations`                                      | Data Frame | Search for discrete station names and other metadata   |

### Discrete Data

#### There are two functions to import discrete water data from WDL.

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

#### `discrete_stations` data frame can be used to search for discrete stations and their relevant station numbers.

``` r
View(WDLimportr::discrete_stations)
```

Once you are viewing the data frame, you are able to filter out columns
and search the data frame using R Studio’s own search feature.

### Continuous Data

#### There are two functions to import continuous water data from WDL

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

#### `continuous_stations` data frame can be used to search for continuous stations and their relevant station numbers.

``` r
View(WDLimportr::discrete_stations)
```

Once you are viewing the data frame, you are able to filter out columns
and search the data frame using R Studio’s own search feature.
