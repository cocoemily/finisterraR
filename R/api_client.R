
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
#' @param db The database name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with joined Context and XYZ tables from database
#' @export
get_site_data <- function(con, db) {
  xyz_path <- paste0(con$base_url, "/", db, "/xyz/list/")
  context_path <- paste0(con$base_url, "/", db, "/context/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_xyz     <- fetch_data(xyz_path)
  df_context <- fetch_data(context_path)

  combined_data = dplyr::left_join(df_xyz, df_context, by = c("squid", "unit", "idno"))

  return(combined_data)
}

#' Get Site Datums
#'
#' @param con Connection object from finisterra_server_connect()
#' @param db The database name ('esc', 'cari', 'gdc')
#'
#' @returns Dataframe with Datums table from the database
#' @export
get_site_datums <- function(con, db) {
  datums_path <- paste0(con$base_url, "/", db, "/datums/list/")

  fetch_data <- function(url) {
    httr2::request(url) |>
      httr2::req_headers(Authorization = paste("Token", con$token)) |>
      httr2::req_perform() |>
      httr2::resp_body_json(simplifyVector = TRUE)
  }

  df_datums    <- fetch_data(datums_path)

  return(df_datums)
}
