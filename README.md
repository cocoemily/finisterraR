
<!-- README.md is generated from README.Rmd. Please edit that file -->

# finisterraR

<!-- badges: start -->
<!-- badges: end -->

finisterraR is an R API interface to access the FINISTERRA project
excavation data stored at data.finisterra.icarehb.com.

## Functions

Function,Description,Key Arguments
finisterra_server_connect(),Authenticates with the API and returns a
connection object.,username get_site_data(),Returns a combined dataframe
of XYZ and Context records.,“con, site” get_site_contexts(),Fetches the
raw Context table for a specific site.,“con, site”
get_site_xyz(),Fetches the raw XYZ (coordinate) table for a specific
site.,“con, site” get_site_datums(),Retrieves the Datums table
(elevation/reference points).,“con, site” get_site_units(),Retrieves the
Units table (excavation units list).,“con, site”
search_by_square(),Filters joined data for a specific excavation
unit/square.,“con, site, unit_id”

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
