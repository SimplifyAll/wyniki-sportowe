#' Disconnect database
#' 
#' Function \code{disconnect} removes connection with a PostgreSQL database
#'
#' @usage disconnect(connection)
#'
#' @param connection connection to the database.
#'
#' @return ?????NULL????? TODO
#'
#' @example
#' \dontrun{
#' disconnect(connection)}
#'
#' @author XXXXXXXXX
#'
#' @export

disconnect <- function(connection){
  dbDisconnect(connection)
}