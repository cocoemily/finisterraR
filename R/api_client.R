
#' Connect to FINISTERRA Database
#'
#' @param username Your database username
#'
#' @returns A connection object
#' @export
finisterra_server_connect <- function(username = NULL) {
  base_url = "https://data.finisterra.icarehb.com/api"

  if(is.null(username)) username <- readline("Username: ")
  password <- askpass::askpass("Password: ")

  resp <- httr2::request(paste0(base_url, "/get-token/")) |>
    httr2::req_body_form(username = username, password = password) |>
    httr2::req_perform()

  token <- httr2::resp_body_json(resp)$token

  structure(
    list(token = token, base_url = base_url),
    class = "finisterra_con"
  )
}


#' Get Site Data
#'
#' @param con Connection object from finisterra_server_connect()
#' @param site The abbreviated site name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with joined Context and XYZ tables from database
#' @export
get_site_data <- function(con, site) {
  xyz_path <- paste0(con$base_url, "/", site, "/xyz/list/")
  context_path <- paste0(con$base_url, "/", site, "/context/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_xyz <- fetch_data(xyz_path)
  df_context <- fetch_data(context_path)

  combined_data = dplyr::left_join(df_xyz, df_context, by = c("squid", "unit", "idno"))

  return(combined_data)
}

#' Get Site Contexts
#'
#' @param con Connection object from finisterra_server_connect()
#' @param site The abbreviated site name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with Context table from database
#' @export
get_site_contexts <- function(con, site) {
  context_path <- paste0(con$base_url, "/", site, "/context/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_context <- fetch_data(context_path)

  return(df_context)
}

#' Get Site XYZ
#'
#' @param con Connection object from finisterra_server_connect()
#' @param site The abbreviated site name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with Context table from database
#' @export
get_site_xyz <- function(con, site) {
  xyz_path <- paste0(con$base_url, "/", site, "/xyz/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_xyz <- fetch_data(xyz_path)

  return(df_xyz)
}

#' Get Site Datums
#'
#' @param con Connection object from finisterra_server_connect()
#' @param site The abbreviated site name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with Datums table from the database
#' @export
get_site_datums <- function(con, site) {
  datums_path <- paste0(con$base_url, "/", site, "/datums/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_datums <- fetch_data(datums_path)

  return(df_datums)
}

#' Get Site Units
#'
#' @param con Connection object from finisterra_server_connect()
#' @param site The abbreviated site name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with Units table from the database
#' @export
get_site_datums <- function(con, site) {
  units_path <- paste0(con$base_url, "/", site, "/units/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_units <- fetch_data(units_path)

  return(df_units)
}

#' Search by square
#' Search for all XYZ records from a specific excavation unit
#'
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @param con Connection object from finisterra_server_connect()
#' @param site The abbreviated site name ('esc', 'cari', 'gdc')
#' @param unit_id The name of the unit of interest
#'
#' @returns Dataframe with joined Context and XYZ tables from specific unit
#' @export
search_by_square <- function(con, site, unit_id) {
  xyz_path <- paste0(con$base_url, "/", site, "/xyz/list/")
  context_path <- paste0(con$base_url, "/", site, "/context/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_xyz <- fetch_data(xyz_path)
  df_context <- fetch_data(context_path)

  combined_data = dplyr::left_join(df_xyz, df_context, by = c("squid", "unit", "idno")) %>%
    dplyr::filter(.data$unit == unit_id)

  return(combined_data)
}

