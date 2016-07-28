#' Disconnect database
#' 
#' Function \code{disconnect} removes connection with a PostgreSQL database.
#'
#' @usage disconnect(connection)
#'
#' @param connection connection to the database
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' disconnect(connection)}
#'
#' @author Kacper Roszczyna
#'
#' @export

disconnect <- function(connection){
  dbDisconnect(connection)
}