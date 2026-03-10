
<!-- README.md is generated from README.Rmd. Please edit that file -->

# finisterraR

<!-- badges: start -->
<!-- badges: end -->

finisterraR is an R API interface to access the FINISTERRA project
excavation data stored at data.finisterra.icarehb.com.

## Installation

You can install the development version of finisterraR like so:

``` r
devtools::install_github("cocoemily/finisterraR")
```

## Example

``` r
library(finisterraR)

con <- finisterra_server_connect()
#enter username and password as prompted

esc <- get_site_data(con, "esc") 
gdc <- get_site_data(con, "gdc")

esc_datums <- get_site_datums(con, "esc")
gdc_datums <- get_site_datums(con, "gdc")
```
