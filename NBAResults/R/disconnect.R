#' Disconnect database
#'
#' Function \code{disconnect_database} removes connection with a PostgreSQL database.
#'
#' @usage disconnect_database(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' disconnect_database(connection)
#' }
#'
#' @author Kacper Roszczyna
#'
#' @export

disconnect_database <- function(connection){
  dbDisconnect(connection)
}
